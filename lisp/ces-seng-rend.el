;;; -*- lexical-binding: t -*-

(defvar ces-seng-rend-test-message-list
  `((:body "hello world" :rname "@deer@1" :dname "Deer" :when "now")
    (:body "hello world" :rname "@deer@1" :dname "Deer" :when "now")
    (:body ,(propertize "hello world" 'face 'default)
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

(insert (ces-seng-create-message (car ces-seng-test-message-alist)))

(ces-seng-rend-render-message (elt ces-seng-rend-test-message-list 2) "*temp*")

