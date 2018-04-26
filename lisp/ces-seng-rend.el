;;; ces-seng-reng.el --- Emacs Story Engine -*- lexical-binding: t -*-

;; Copyright (C) 2018 Alexander Griffith
;; Author: Alexander Griffith <griffitaj@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "25.1"))
;; Homepage: https://github.com/alexjgriffith/ces.el

;; This file is not part of GNU Emacs.

;; This file is part of ces.el.

;; ces.el is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; ces.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with ces.el.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:


;; -*- lexical-binding: t -*-


(autoload 'special-mode "simple")

;;(require 'special-mode)

(defvar ces-seng-rend-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-n") #'ces-seng-render-move-to-next-message)
    (define-key map (kbd "M-p") #'ces-seng-render-move-to-previous-message)
    (define-key map (kbd "RET") #'ces-seng-render-eval-at-point)
    (define-key map (kbd "c") #'ces-seng-render-eval-at-point)
    (define-key map (kbd "g") #'undefined)
    map))

(define-derived-mode ces-seng-render-mode special-mode "Seng"
  "Major mode for seng timeline style rendering."
  (read-only-mode 't)
  ;;(setq font-lock-defaults '(ces-seng-render-mode-highlights))
  )

;; From ces-seng-render

(defvar ces-seng-rend-test-entities-alist
  '((10 ((deer)
         (likes :hash #s(hash-table test equal data ("Grass" 1 "Forests" 1 "Blue Shirts" 1 "Long walks on the Beach" 1 "Wolves" -1 "Red Shirts" -1 "You" -1))
                :current-happiness 100)
         (named :sname "Deer" :rname "@deer@1.loc1" :dname "Deer"
                :description "A furry deer friend. Both lovable and delicions; the best combination."
                :pronoun "it"
                :att #s(hash-table test equal data ("fury" t "deer" t "woodland" t))))))
  "Should match the output of (ces-components-f (ces-e2c-f enti-id))")

(defvar ces-seng-rend-test-message-list
  `((:body "hello world" :ent-id 10  :when ,(current-time))
    (:body "A deer has entered the dell." :ent-id 10 :when ,(current-time))
    (:body "A deer makes a deer sound." :ent-id 10 :when ,(current-time))))

(defun ces-seng-rend-test ()
  (let ((message-buffer "*ces-seng-rend-test*"))
   (with-current-buffer (get-buffer-create message-buffer)
    (ces-seng-render-mode)   
    (ces-seng-rend-render-message (elt ces-seng-rend-test-message-list 0) message-buffer)
    (ces-seng-rend-render-message (elt ces-seng-rend-test-message-list 1) message-buffer)
    (ces-seng-rend-render-message (elt ces-seng-rend-test-message-list 2) message-buffer)
    (switch-to-buffer-other-window (current-buffer)))))

;; 'font-lock-builtin-face
;; 'font-lock-keyword-face
;; 'font-lock-function-name-face
;; 'font-lock-string-face

;; (cdr (assoc ent-id ces-seng-rend-test-entities-alist))

;; this function and below has to be cleaned up to handle the ces
(defun ces-seng-rend-entity (ent-id &optional components)
  (let* ((components (or components (ces-components-f (ces-e2c-f ent-id))))
         (named (ces-utils-comp-get-plist components 'named))
         (dname (plist-get named :dname))
         (rname (plist-get named :rname))
         (description (plist-get named :description))
         (hash (ces-utils-comp-get-value components 'likes :hash))
         likes dislikes)
    (maphash (lambda(key value) (if (> value 0) (push key likes) (push key dislikes)))
             hash)
    ;;(nreverse likes)
    ;;(nreverse dislikes)
    (message "likes: %s" likes)
    (concat (propertize dname 'face 'warning)
            " ("
            (propertize rname 'face 'font-lock-string-face) ")\n"
            (propertize description 'face font-lock-builtin-face)
            "\n\n"
            (propertize rname 'face 'font-lock-string-face)
            " likes "
            (mapconcat (lambda (str) (propertize str 'face font-lock-keyword-face))
                       (cdr likes) ", ")
            " & "
            (propertize (car likes) 'face  font-lock-keyword-face)
            ".\nThey dislike "
            (mapconcat (lambda (str) (propertize str 'face font-lock-keyword-face))
                       (cdr dislikes) ", ")
            " & "
            (propertize (car dislikes) 'face font-lock-keyword-face))))

(defun ces-seng-rend-display-details ()
  (interactive)
  (let ((props (text-properties-at (point))))
   (when (and (member 'buf-name props) (member 'entity props))
     (with-current-buffer (get-buffer-create (plist-get props 'buf-name))
       (delete-region (point-min) (point-max))
       (insert (ces-seng-rend-entity (plist-get props 'entity)
                                     (plist-get props 'components)))
       (display-buffer (current-buffer))))))

;; need to add an 'entity, components and buf-name property to the byline

(defun ces-seng-rend-byline (dname rname when entity &optional components)
  (propertize
   (concat "| " (propertize (concat  dname) 'face 'warning) " (" rname") "
           (propertize (concat when "\n") 'timeline-time t 'time-length (length when)))
   'entity entity
   'components components
   'rname rname))

(defun ces-seng-rend-create-message (message)
  (let* ((body (plist-get message :body))
         (ent-id (plist-get message :ent-id))
         (components (cadr (assoc ent-id ces-seng-rend-test-entities-alist)))
         (dname (ces-utils-comp-get-value components 'named :dname))
         (rname (ces-utils-comp-get-value components 'named :rname))
         (relative-when  (ces-seng-rend-timestamp-relative (plist-get message :when)))
         (byline (ces-seng-rend-byline dname rname relative-when
                                       ent-id components)))
    (concat body"\n" byline)))

(defun ces-seng-rend-render-message(message message-buffer)
  (with-current-buffer (get-buffer-create message-buffer)
    (save-excursion
      (goto-char (point-min))
      (let ((inhibit-read-only t)
            (when  (plist-get message :when))
            (str (ces-seng-rend-create-message message)))
        (insert
         (propertize str
                     'when when
                     'length (length str)
                     'buf-name
                     (concat message-buffer
                             "-"
                             (get-text-property (length str) 'rname str)))
         (propertize "\n" 'inbetween t))))))

(defun ces-seng-rend-unpause-message-time (&optional point)
  (let* ((point (or point (point)))
         (reg (ces-seng-rend-message-region point))
         (start (car reg))
         (end (cdr reg))
         (when (plist-get (text-properties-at point) 'when))
         (current (current-time)))
    (add-text-properties start end 'when
                         (time-subtract current (time-subtract current when)))))

(defun ces-seng-rend-update-message-time (&optional point)
  (let* ((point (or point (point)))
         (region (ces-seng-rend-when-region))
         (start (car region))
         (end (cdr region))         
         (when (get-text-property point 'when))
         (relative-when (ces-seng-rend-timestamp-relative when))
         (str (propertize (concat relative-when "\n")
                          'timeline-time t 'time-length (length relative-when)))
         (new-time-len (length str))
         (message-len (get-text-property end 'length))
         (old-time-len (get-text-property end 'time-length))
         (new-message-len (+ message-len (- new-time-len old-time-len)))
         (inhibit-read-only t))
      (ces-seng-rend-set-property-for-message point 'length new-message-len)
      (goto-char end)
      (delete-region start (+ end 1))
      (insert str)))

(defun ces-seng-rend-set-property-for-message (point property value)
  (let* ((region (ces-seng-rend-message-region point))
         (start (car region))
         (end (cdr region)))
    (add-text-properties start end (list property value))))

(defun ces-seng-rend-when-region (&optional point)
  (let* ((point (or point (point)))
        (next-prop (next-single-property-change point 'inbetween)))
    (when (not (plist-get (text-properties-at next-prop) 'inbetween))
      (setq next-prop  (next-single-property-change next-prop 'inbetween)))
    (let ((length (plist-get (text-properties-at (- next-prop 1)) 'time-length)))      
      (cons (- next-prop length 1)  (- next-prop 1) ))))


(defun ces-seng-rend-message-region (&optional point)
  (let* ((point (or point (point)))
        (next-prop (next-single-property-change point 'inbetween)))
    (when (not (plist-get (text-properties-at next-prop) 'inbetween))
      (setq next-prop  (next-single-property-change next-prop 'inbetween)))
    (let ((length (plist-get (text-properties-at (- next-prop 1)) 'length)))
      (cons (- next-prop length)  (- next-prop 1) ))))

(defmacro ces-seng-rend-timestamp-make-to-string-alist (seconds-per-hour)
  `(defun ces-seng-rend-timestamp-to-string-alist (diff)
    ,(append `(cond)
        (mapcar (lambda (x)
          (let ((time (car x))
                (stamp (cdr x)))
            `((>= diff ,time) ,stamp)))
                (reverse
                 `((0 . "now")
                   (7 . "30 min ago")
                   ,@(mapcar (lambda(hours) (cons (* hours seconds-per-hour)
                                                  (format "%s hours ago" hours)))
                             '(1 2 3 4 5 6 7 8 9 10 11 12 13
                                 14 15 16 17 18 19 20 21 22 23))
                   ,@(mapcar (lambda(days) (cons (* days seconds-per-hour 24)
                                                 (format "%s days ago" days)))
                             '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
                                 21 22 23 24 25 26 27 28 29))
                   ,@(mapcar (lambda(days) (cons (* days seconds-per-hour 24 30)
                                                 (format "%s months ago" days)))
                             '(1 2 3 4 5 6 7 8 9 10 11))
                   ,@(mapcar (lambda(days) (cons (* days seconds-per-hour 24 30 12)
                                                 (format "%s years ago" days)))
                             '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
                                 21 22 23 24 25 26 27 28 29))
                   ))))))

(defun ces-seng-rend-timestamp-relative (timestamp &optional current-time)
 (unless (functionp 'ces-seng-timestamp-to-string-alist)
   (ces-seng-timestamp-make-to-string-alist 15))
 (let* ((now (or current-time (current-time)))
        (time-diff (float-time (time-subtract now timestamp))))
   (ces-seng-timestamp-to-string-alist time-diff)))

(provide 'ces-seng-reng)
;;; ces-seng-reng.el ends here
