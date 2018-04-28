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
    (define-key map (kbd "M-n") #'ces-seng-rend-move-to-next-message)
    (define-key map (kbd "k") #'ces-seng-rend-move-to-next-message)
    (define-key map (kbd "M-p") #'ces-seng-rend-move-to-previous-message)
    (define-key map (kbd "j") #'ces-seng-rend-move-to-previous-message)
    (define-key map (kbd "RET") #'ces-seng-rend-eval-at-point)
    (define-key map (kbd "g") #'undefined)
    map))

(defvar ces-seng-rend-display-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "q") #'kill-this-buffer)
    map))

(defun ces-seng-rend-move-to-next-message ()
  (interactive)
  (ces-seng-rend-goto-next-byline (point)))

(defun ces-seng-rend-move-to-previous-message ()
  (interactive)
  (ces-seng-rend-goto-previous-byline (point)))

(defun ces-seng-rend-eval-at-point ()
  (interactive)
  (ces-seng-rend-display-details (point)))

(define-derived-mode ces-seng-rend-mode special-mode "SengTL"
  "Major mode for seng timeline style rendering."
  (read-only-mode 't))

(define-derived-mode ces-seng-rend-display-mode special-mode "SengD"
  "Major mode for seng timeline style rendering."
  (read-only-mode 't))

;; From ces-seng-render

(defvar ces-seng-rend-test-entities-alist
  '((10 ((deer)
         (interactions :hash #s(hash-table test equal data ("Pet Deer" 11 "Chase Deer" 12)))
         (likes :hash #s(hash-table test equal data ("People who pet deer" t "Grass" 1 "Forests" 1 "Blue Shirts" 1 "Long walks on the Beach" 1 "Wolves" -1 "Red Shirts" -1 "You" -1))
                :current-happiness 100)
         (named :sname "Deer" :rname "@deer@1.loc1" :dname "Deer"
                :description "A furry deer friend. Both lovable and delicions; the best combination."
                :pronoun "It"
                :att #s(hash-table test equal data ("fury" t "deer" t "woodland" t)))))
    (11 ((interaction :name "Pet Deer" :effect 'attributes
                      :hash #s(hash-table test equal date ("People who pet deer" 1
                                                           "People who chase deer" -1)))))
    (12 ((interaction :name "Chase Deer" :effect 'attributes
                      :hash #s(hash-table test equal date ("People who pet deer" -1
                                                           "People who chase deer" 1)))         
         )))
  "Should match the output of (ces-components-f (ces-e2c-f enti-id))")

(defvar ces-seng-rend-test-message-list
  `((:body "hello world" :ent-id 10  :when ,(current-time))
    (:body "A deer has entered the dell." :ent-id 10 :when ,(current-time))
    (:body "A deer makes a deer sound." :ent-id 10 :when ,(current-time))))

(defun ces-seng-rend-test ()
  (let ((message-buffer "*ces-seng-rend-test*"))
   (with-current-buffer (get-buffer-create message-buffer)
    (ces-seng-rend-mode)   
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
         (pronoun (plist-get named :pronoun))
         (description (plist-get named :description))
         (hash (ces-utils-comp-get-value components 'likes :hash))
         likes dislikes)
    (maphash (lambda(key value) (if (> value 0) (push key likes) (push key dislikes)))
             hash)
    ;;(nreverse likes)
    ;;(nreverse dislikes)
    (message "likes: %s" likes)
    (propertize
     (concat (propertize dname 'face 'warning)
             " ("
             (propertize rname 'face 'font-lock-string-face)
             ")\n============\n\n"
             (propertize description 'face font-lock-builtin-face)
             (format "\n%s likes " pronoun)
             (mapconcat (lambda (str) (propertize str 'face font-lock-keyword-face))
                        (cdr likes) ", ")
             " & "
             (propertize (car likes) 'face  font-lock-keyword-face)
             "."
             (format "\n%s dislikes " pronoun)
             (mapconcat (lambda (str) (propertize str 'face font-lock-keyword-face))
                        (cdr dislikes) ", ")
             " & "
             (propertize (car dislikes) 'face font-lock-keyword-face)
             ".\n\n"
             (propertize "Interactions" 'face font-lock-builtin-face)
             "\n============\n"
             )
     'header-section t)))

(defun ces-seng-rend-display-details (point)
  (let ((props (text-properties-at point))
        (inhibit-read-only t))
   (when (and (member 'buf-name props) (member 'entity props))
     (with-current-buffer (get-buffer-create (plist-get props 'buf-name))
       (delete-region (point-min) (point-max))
       (insert (ces-seng-rend-entity (plist-get props 'entity)
                                     (plist-get props 'components)))
       (ces-seng-rend-display-mode)
       (switch-to-buffer (current-buffer))))))

;; need to add an 'entity, components and buf-name property to the byline

(defun ces-seng-rend-create-message (message-buffer message)
  (let* ((body (plist-get message :body))
         (ent-id (plist-get message :ent-id))
         (components (cadr (assoc ent-id ces-seng-rend-test-entities-alist)))
         (dname (ces-utils-comp-get-value components 'named :dname))
         (rname (ces-utils-comp-get-value components 'named :rname))
         (when  (plist-get message :when))         
         (relative-when  (ces-seng-rend-timestamp-relative (plist-get message :when)))
         (str (concat (propertize (concat body "\n") 'body-section t)
                      (propertize "| " 'byline-start t)

                      (propertize
                       (concat (propertize (concat  dname) 'face 'warning)
                               " (" rname") ")
                       'byline-section t)
                      (propertize relative-when 'time-section t)
                      "\n"
                      (propertize "\n" 'end-section t))))
    (propertize
     str
     'entity ent-id
     'components components
     'rname rname
     'when when
     'length (length str)
     'buf-name (concat message-buffer "-" rname))))

(defun ces-seng-rend-render-message(message message-buffer)
  (with-current-buffer (get-buffer-create message-buffer)
    (save-excursion
      (goto-char (point-min))
      (let ((inhibit-read-only t)            
            (str (ces-seng-rend-create-message message-buffer message)))
        (insert str)))))

(defmacro ces-seng-rend-timestamp-make-to-string-alist (seconds-per-hour)
  `(defun ces-seng-rend-timestamp-to-string-alist (diff)
    ,(append `(cond)
        (mapcar (lambda (x)
          (let ((time (car x))
                (stamp (cdr x)))
            `((>= diff ,time) ,stamp)))
                (reverse
                 `((0 . "now")
                   (,(floor (/ seconds-per-hour 2) ) . "30 min ago")
                   (,seconds-per-hour . "1 hour ago")
                   ,@(mapcar (lambda(hours) (cons (* hours seconds-per-hour)
                                                  (format "%s hours ago" hours)))
                             '(2 3 4 5 6 7 8 9 10 11 12 13
                                 14 15 16 17 18 19 20 21 22 23))
                   (,(* 24 seconds-per-hour) . "1 day ago")
                   ,@(mapcar (lambda(days) (cons (* days seconds-per-hour 24)
                                                 (format "%s days ago" days)))
                             '(2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
                                 21 22 23 24 25 26 27 28 29))
                   (,(* 24 30 seconds-per-hour) . "1 months ago")
                   ,@(mapcar (lambda(days) (cons (* days seconds-per-hour 24 30)
                                                 (format "%s months ago" days)))
                             '(2 3 4 5 6 7 8 9 10 11))
                   (,(* 24 30 12 seconds-per-hour) . "1 months ago")
                   ,@(mapcar (lambda(days) (cons (* days seconds-per-hour 24 30 12)
                                                 (format "%s years ago" days)))
                             '(2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
                                 21 22 23 24 25 26 27 28 29))
                   ))))))

(defun ces-seng-rend-timestamp-relative (timestamp &optional current-time)
 (unless (functionp 'ces-seng-rend-timestamp-to-string-alist)
   (ces-seng-rend-timestamp-make-to-string-alist 15))
 (let* ((now (or current-time (current-time)))
        (time-diff (float-time (time-subtract now timestamp))))
   (ces-seng-rend-timestamp-to-string-alist time-diff)))

(defun ces-seng-rend-iter-over-times (fun)
  (let ((next-loc (ces-seng-rend-next-prop-t 1 'byline-start))
        (counter 0))
    (while next-loc                     
      (funcall fun next-loc)
      (setq counter (+ counter 1))
      (setq next-loc  (ces-seng-rend-next-prop-t next-loc 'byline-start)))
    counter))

(defun ces-seng-rend-update-all-times (&optional buffer override)
  (with-current-buffer (get-buffer-create (or buffer (current-buffer)))
    (let ((current (current-time)))
      (ces-seng-rend-iter-over-times
       (lambda (point)
         (ces-seng-rend-replace-timer-region 
          point
          (or
           override
           (ces-seng-rend-timestamp-relative (get-text-property point 'when)))))))))

(defun ces-seng-rend-pause-all-times (&optional buffer)
  (with-current-buffer  (get-buffer-create  (or buffer (current-buffer)))
    (let ((current (current-time)))
      (ces-seng-rend-iter-over-times
       (lambda (point)
         (ces-seng-rend-replace-message-properties point `(paused ,current)))))))

(defun ces-seng-rend-unpause-all-times (&optional buffer)
  (with-current-buffer (get-buffer-create (or buffer (current-buffer)))
    (let ((current (current-time)))
      (ces-seng-rend-iter-over-times
       (lambda (point)
         (let* ((when (get-text-property point 'when))
                (paused (get-text-property point 'paused))
                (new-when (time-add  when (time-subtract current paused))))
           (when paused
             (ces-seng-rend-replace-message-properties
              point `(paused nil when ,new-when)))))))))

(defun ces-seng-rend-replace-message-properties (point properties)  
  (let* ((region (ces-seng-rend-message-region point))
         (start (car region))
         (end (cdr region))
         (inhibit-read-only t))
    (add-text-properties start end properties)))


(defun ces-seng-rend-replace-timer-properties (point properties)  
  (let* ((region (ces-seng-rend-next-time-region point))
         (start (car region))
         (end (cdr region))
         (inhibit-read-only t))
    (set-text-properties start end properties)))

(defun ces-seng-rend-replace-timer-region (point message)  
  (let* ((region (ces-seng-rend-next-time-region point))
         (start (car region))
         (end (cdr region))
         (props (text-properties-at start))
         (inhibit-read-only t))    
      (goto-char start)
      (delete-region start end)
      (insert  message)
      (set-text-properties start (+ start (length message)) props)))

(defun ces-seng-rend-next-message (point)  
  (let ((message-end (ces-seng-rend-end-of-message point)))
    (ces-seng-rend-end-of-message message-end)))
     
(defun ces-seng-rend-previous-message (point)  
  (let ((message-end (ces-seng-rend-end-of-message point)))
     (ces-seng-rend-previous-prop-t message-end 'end-section)))

(defun ces-seng-rend-next-time-region (point)  
  (let* ((start (ces-seng-rend-next-prop-t point 'time-section))
         (end (next-single-property-change start 'time-section)))
    (cons start end)))

(defun ces-seng-rend-message-region (point)
  (let* ((end (ces-seng-rend-end-of-message point))
         (start (or (previous-single-property-change end 'end-section) 1)))
    (cons start end)))

(defun ces-seng-rend-goto-next-byline (point)  
  (let ((byline (ces-seng-rend-next-prop-t point 'byline-start)))
    (when byline
      (goto-char byline))))

(defun ces-seng-rend-goto-previous-byline (point)  
  (let ((byline (ces-seng-rend-previous-prop-t point 'byline-start)))
    (when byline
      (goto-char byline))))

(defun ces-seng-rend-end-of-message (point)  
  (ces-seng-rend-next-prop-t point 'end-section))

(defun ces-seng-rend-next-prop-t (point prop)  
  (let ((next-point (next-single-property-change point prop)))
    (cond  ((not next-point) nil)           
           ((not (get-text-property next-point prop))
            (setq next-point (next-single-property-change next-point prop)))
           (t next-point))))

(defun ces-seng-rend-previous-prop-t (point prop)  
  (let ((next-point (previous-single-property-change point prop)))
    (cond  ((not next-point) nil)           
           ((not (get-text-property next-point prop))
            (setq next-point (previous-single-property-change next-point prop)))
           (t next-point))))

(provide 'ces-seng-reng)
;;; ces-seng-reng.el ends here
