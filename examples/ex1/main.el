;; -*- lexical-binding :t -*-
;;(mapc 'load-file (directory-files "~/Development/elisp/ces/lisp/" t ".el"))

(mapc 'load-file (directory-files "~/Development/elisp/ces/lisp/" t ".el"))


;;(setq lexical-binding t)

(setq debug-on-error t)

;; this is getting very compicated
(defvar story-game-ids #s(hash-table test equal data ("animals" 1024
                                                      "locations" 1024
                                                      "npcs" 1024)))

(defvar story-game-loader-location-alist nil)

(defvar story-game-standard-init #s(hash-table data (rat story-game-init-rat)))

(defvar story-game-state
  (ces-loader '(ces-seng-systems) '(ces-seng-components)
              'story-game-loader '("game-mid.el")))


(defun story-game-loader (buffer)
                   (let  ((story-game-loader-location-alist nil))
                     (ces-loader-load buffer)
                     (mapc (lambda (ent-loc)
                             (let ((ent (car ent-loc))
                                   (loc (cdr ent-loc)))
                               (ces-seng-utils-add-ent-to-location ent loc)))
                           story-game-loader-location-alist)))

(defun story-game-next-id (key)
  (let ((value (gethash key story-game-ids)))
    (puthash key (+ value 1) story-game-ids)
    value))

;; must be called from within tick
(defun story-game-init-rat (location)
  (let ((id (format "%s"(story-game-next-id "animals"))))
    (remove 'nil
          (cons (concat "rat animals-" id)
           (list `(named :pronoun "It" :dname "Rat"
                        :sname "rat" :rname ,(concat "rat@animals."
                                                     id))
                `(description :text ,"A furry little rat buddy. Great for cuddling.")
                `(where :location ,location))))))

(defun story-game-new-insert (e-id loc type &rest parameters)
  (let* ((fun (gethash type story-game-standard-init))
         (ret (funcall fun loc))
         (name (car ret))
         (components (cdr ret))
         c-ids)
    ;; update components with parameters    
    (setq components (ces-utils-replace-component-info components parameters))    
    (push (cons e-id loc) story-game-loader-location-alist)
    (append (list name) components)))

(defun story-game-new (loc type &rest parameters)
  (let* ((fun (gethash type story-game-standard-init))
         (components (funcall fun loc))
         c-ids
         e-id)
    ;; update components with parameters    
    (setq components (ces-utils-replace-component-info components parameters))
    ;; insert components into components
    (setq c-ids (ces-loader-insert-components components))
    ;; add entity with inserted component ids
    (setq e-id (ces-new-entity-with-instantiated-components-no-id
                (format "%s" type) c-ids (mapcar 'car (ces-components-f c-ids))))
    ;; insert ent id into location contains    
    e-id))

;; Utils
(defun ces-seng-utils-add-ent-to-location (ent-id loc-id)
  (ces-utils-comp-put-hash-value (ces-components-f(ces-e2c-f loc-id))
                                 'contains :hash ent-id t))

(defun ces-utils-replace-component-info (components details)
  (let ((components (copy-alist components))
        (detail (pop details)))
    (while detail
      (let* ((to-update (car detail))
             (plist (cdr detail))
             (comp (ces-utils-comp-get-plist components to-update)))
        (if comp
            (let ((key (pop plist))
                  (value (pop plist)))
              (while (and key value)
                (plist-put comp key value)
                (setq key (pop plist))
                (setq value (pop plist))))
          (push components detail)))
      (setq detail (pop details)))
    components))


;; Loader


;; CES
(defun ces-new-entity-with-instantiated-components (ent-id moniker c-ids cnames)
  (puthash ent-id moniker entities)
  (mapc (lambda(c-id)
          (ces-insert-component-into-e2c ent-id c-id))
        c-ids)
  (mapc (lambda (cname)
          (ces-insert-entity-into-c2e ent-id cname))
        cnames)        
  ent-id)

(defun ces-new-entity-with-instantiated-components-no-id (moniker c-ids cnames)
  (let ((ent-id (ces-new-entity moniker)))
    (mapc (lambda(c-id)
            (ces-insert-component-into-e2c ent-id c-id))
          c-ids)
    (mapc (lambda (cname)
            (ces-insert-entity-into-c2e ent-id cname))
          cnames)        
    ent-id))
