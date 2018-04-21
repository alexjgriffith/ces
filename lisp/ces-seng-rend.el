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


(defvar ces-seng-rend-test-message-list
  `((:body "hello world" :rname "@deer@1" :dname "Deer" :when "now")
    (:body "A deer has entered the dell." :rname "@deer@1.loc1" :dname "Deer" :when "now")
    (:body "A deer makes a deer sound."
           :entity-id 10
           :rname  "@deer@1.loc1" 
           :link-info '(details :rname "@deer@1.loc1" :dname "Deer"
                                :description "A furry deer friend. Both loveable and delicous; the best combination."
                                :likes ("Grass" "Forests" "Blue Shirts"  "Long Walks on the Beach")
                                :dislikes ("Wolves" "Red Shirts" "You"))
           :dname "Deer" :when "now")))

(defun ces-seng-render (state))

;; 'font-lock-builtin-face
;; 'font-lock-keyword-face
;; 'font-lock-function-name-face
;; 'font-lock-string-face

(defun ces-seng-rend-create-display (link-info)
  (let ((dname (plist-get link-info :dname))
        (rname (plist-get link-info :rname))
        (description (plist-get link-info :description))
        (likes (plist-get link-info :likes))
        (dislikes (plist-get link-info :dislikes)))
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
   (when (and (member 'link-info props) (member 'message-buffer props))
     (with-current-buffer (get-buffer-create
                           (concat (plist-get props 'message-buffer)
                                   (plist-get  (cdr (plist-get props 'link-info)) :rname)))
       (delete-region (point-min) (point-max))
       (insert (ces-seng-rend-create-display (cdr (plist-get props 'link-info))))
       (display-buffer (current-buffer))))))



(defun ces-seng-rend-create-message (message)
  (let ((body (plist-get message :body))
        (rname (plist-get message :rname))
        (dname (plist-get message :dname))
        (when (plist-get message :when)))
    (concat body"\n" "| " (propertize (concat  dname) 'face 'warning) " (" rname") "  when"\n\n" )))

(defun ces-seng-rend-render-message(message message-buffer)
  (with-current-buffer (get-buffer-create message-buffer)
    (save-excursion
      (goto-char (point-min))
      (insert (propertize (ces-seng-rend-create-message message)
                          'message-buffer message-buffer)))))

;; (insert (ces-seng-create-message (car ces-seng-test-message-alist)))

;; (ces-seng-rend-render-message (elt ces-seng-rend-test-message-list 1) "*temp*")

;; (ces-seng-rend-render-message (elt ces-seng-rend-test-message-list 2) "*temp*")

(provide 'ces-seng-reng)
;;; ces-seng-reng.el ends here
