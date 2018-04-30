;;; ces.el --- Emacs Game Engine -*- lexical-binding: t -*-

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

(require 'subr-x)

(defvar c2e nil)
(defvar e2c nil)
(defvar generals nil)
(defvar components-def nil)
(defvar systems-def nil)
(defvar components nil)
(defvar c-insert nil)
(defvar e-insert nil)
(defvar entities nil)
(defvar message-queue nil)

(defun ces-make-set (&optional test)
  (make-hash-table :test (or test 'eql)))

(defun ces-set-set (element set)
  (puthash element t set))

(defun ces-set-get (element set)
  (gethash element set nil))

(defun ces-set-rem (element set)
  (remhash element set))

(defun ces-set-to-list (set)
  (hash-table-keys set))

(defun ces-copy-set (set)
  (copy-hash-table set))

(defun ces-set-from-list (list &optional test)
  (let ((set (ces-make-set test)))
    (mapc (lambda(x) (ces-set-set x set)) list)
    set))

(defun ces-set-intersect-2 (seta setb)
  (let* ((keys (hash-table-keys seta))
         (setc (ces-copy-set seta)))
    (mapc (lambda(key) (unless (ces-set-get key setb)
                         (ces-set-rem key setc)))
                keys)
    setc))

(defun ces-set-union-2 (seta setb)
  (let* ((setc (ces-copy-set seta)))
    (maphash (lambda(key value)            
              (puthash key value setc))
          setb)
    setc))

(defun ces-set-intersect (&rest sets)
  (cond ((equal (length sets) 0) (ces-make-set))
         ((equal (length sets) 1) (car sets))
         ((equal (length sets) 2) (ces-set-intersect-2 (car sets) (cadr sets)))
         (t (ces-fold 'ces-set-intersect-2  (car sets) (cadr sets) (cddr sets)))))

(defun ces-set-union (&rest sets)
  (cond ((equal (length sets) 0) (ces-make-set))
         ((equal (length sets) 1) (car sets))
         ((equal (length sets) 2) (ces-set-union-2 (car sets) (cadr sets)))
         (t (ces-fold 'ces-set-union-2  (car sets) (cadr sets) (cddr sets)))))

(defun ces-fold (fun initial arg1 args)
  (while arg1
    (setq initial (funcall fun arg1 initial))
    (setq arg1 (pop args)))
  initial)

(defun ces-zip2 (lista listb)
  (let ((elema (pop lista))
        (elemb (pop listb))
        ret)
    (while (and elema elemb)
      (push (list elema elemb ) ret)
      (setq elema (pop lista))
      (setq elemb (pop listb)))
    (reverse ret)))

(defun ces-zip2-cons (lista listb)
  (let ((elema (pop lista))
        (elemb (pop listb))
        ret)
    (while (and elema elemb)
      (push (cons elema elemb ) ret)
      (setq elema (pop lista))
      (setq elemb (pop listb)))
    (reverse ret)))

(defun ces-insert-into-hash-set (index value hash)
  (let ((selection (gethash index hash)))
    (unless selection
      (setq selection (ces-make-set)))
    (ces-set-set value selection)
    (puthash index selection hash)))

(defun ces-remove-from-hash-set (index value hash)
  (let* ((selection (gethash index hash)))
    (ces-set-rem  value selection)
    (puthash index  selection hash)))

(defun ces-insert-into-hash-list (index value hash)
  (puthash index (append (gethash index hash) (list value)) hash))

(defun ces-remove-from-hash-list (index value hash)
  (let* ((sub-hash (gethash index hash)))
    (puthash index (remove  value sub-hash) hash)))

(defun ces-new-entity (moniker &rest components)
  (let ((id (ces-insert-entity-into-entities moniker)))
    (when components (add-components id components))
    id))

(defun ces-insert-component-bld (start-key)
  (let ((key start-key))
    (lambda (value)
      (puthash key value components)
      (setq key (+ key 1))
      (- key 1))))

(defun ces-insert-entity-bld (start-key)
  (let ((key start-key))
    (lambda (value)
      (puthash key value entities)
      (setq key (+ key 1))
      (- key 1))))

(defun ces-init-globs ()
  (setq c2e (make-hash-table))
  (setq e2c (make-hash-table))
  (setq generals (make-hash-table))
  (setq components-def (make-hash-table))
  (setq systems-def (make-hash-table))
  (setq components (make-hash-table))
  (setq c-insert (ces-insert-component-bld 0))
  (setq e-insert (ces-insert-entity-bld 0))
  (setq entities (make-hash-table))
  (setq message-queue '()))

(defun ces-initialized (init-systems init-components setup)
  (let (c2e e2c components entities generals components-def systems-def
            c-insert e-insert message-queue)
    (ces-init-globs)
    (mapc 'funcall init-systems)
    (mapc 'funcall init-components)
    (funcall setup)
    (list :c2e c2e :e2c e2c :components components :entities entities
          :generals generals :components-def components-def :systems-def systems-def)))

(defun ces-insert-component-into-components (value)
  (funcall c-insert value))

(defun ces-remove-component-from-components (key)
  (remhash key components))

(defun ces-insert-entity-into-entities (value)
  (funcall e-insert value))

(defun ces-get-entity-from-entities (key)
  (gethash key entities))

(defun ces-remove-entity-from-entities (key)
  (remhash key entities))

(defun ces-insert-component-into-e2c (e-id which)
  (ces-insert-into-hash-list e-id which e2c))

(defun ces-remove-component-from-e2c (e-id c-id)
  (ces-remove-from-hash-list e-id  c-id  e2c))

(defun ces-remove-entity-from-e2c (e-id)
  (remhash e-id e2c))

(defun ces-insert-entity-into-c2e (e-id c-id)
  (ces-insert-into-hash-set c-id e-id c2e))

(defun ces-remove-entity-from-c2e (e-id c-id)
  (ces-remove-from-hash-set c-id  e-id  c2e))

(defun ces-insert-general-into-generals (key value)
  (puthash key value generals))

(defun ces-remove-general-from-generals (key)
  (remhash key generals))


(defun ces-add-component (id component)
  (let* ((component-name (car component))
         (component-value (cdr component))
         (which (insert-component-into-components component)))
    (ces-insert-component-into-e2c id which)
    (ces-insert-entity-into-c2e id component-name)))

(defun ces-add-components (player-id &rest components)
  (when components
    (mapc (lambda(comp) (ces-add-component player-id comp)) components))
  player-id)

(defun ces-remove-component-from-entity (entity-id component)
  (mapc (lambda(x )
          (when (equal component (car(gethash x components)))
            (remhash x components)
            (ces-remove-component-from-e2c entity-id x)
            (ces-remove-entity-from-c2e entity-id component)))
        (gethash entity-id e2c)))

(defun ces-remove-entity (entity-id)
  (let ((comp-ids (e2c-f entity-id)))
    (ces-remove-entity-from-entities entity-id)
    (mapc (lambda (comp) (ces-remove-entity-from-c2e entity-id (car  comp)))
          (components-f comp-ids))
    (mapc (lambda (comp-id) (ces-remove-component-from-components comp-id))
          comp-ids) 
    (ces-remove-entity-from-e2c entity-id)))

(defun ces-entity-keys()
  (hash-table-keys entities))

(defun ces-components-f (comp-list)
  (mapcar (lambda (index) (gethash index components)) comp-list))

(defun ces-entities-f (ent-list)
  (mapcar (lambda (index) (gethash index entities)) ent-list))

(defun ces-generals-f (name)
  (gethash name generals))

(defun ces-e2c-f (entity)
  (gethash entity e2c))

(defun ces-c2e-f (component)
  (gethash component c2e))

(defmacro ces-new-component! (name &rest elements)
  `(puthash ',name (lambda(,@elements)
                     (apply 'append '(,name) (ces-zip2 (quote ,elements)
                                                   (list ,@elements) )))
            components-def))

(defmacro ces-new-system! (name comps gens &rest body)
  `(puthash ',name
            (lambda ()
              (let ,(append (mapcar (lambda (x) `(,x (ces-c2e-f ',x))) comps)
                            (mapcar (lambda (x) `(,x (ces-generals-f ',x))) gens))
                ,@body))
            systems-def))

(defun ces-call-system (system)
  (funcall (gethash system systems-def)))

(defun ces-gen-component (comp &rest cargs)
  (apply (gethash comp components-def) cargs))

(defun ces-join (&rest sets)
  (mapcar (lambda (ent) (cons ent (ces-components-f (ces-e2c-f ent))))
          (ces-set-to-list (apply 'ces-set-intersect sets))))

(defun ces-tick (state callback)
  (let ((c2e (plist-get state :c2e))
        (e2c (plist-get state :e2c))
        (components (plist-get state :components))
        (entities (plist-get state :entities))
        (generals (plist-get state :generals))
        (components-def (plist-get state :components-def))
        (systems-def (plist-get state :systems-def)))
    (funcall callback)))


;; Serialization and Deserialization tools
(defun ces-serialize-human-callback ()
  (mapcar
       (lambda (ent-id)
         (let ((comp-ids (ces-e2c-f ent-id)))
           `(,ent-id
             ,(ces-get-entity-from-entities ent-id)
             ,(ces-components-f comp-ids))))
       (ces-entity-keys) ))

(defun ces-serialize-human (world buffer)
  (with-current-buffer (get-buffer-create buffer)
    (let ((str (ces-tick world 'ces-serialize-human-callback)))
      (goto-char (point-min))
      (delete-region (point-min) (point-max))
      (let ((print-level nil)
            (print-length nil))
        (insert (pp str))))))

(defun ces-deserialize-human (buffer)
  (with-current-buffer (get-buffer buffer)
    (goto-char (point-min))
    (let ((data (read (current-buffer))))
      (mapcar
       (lambda (entity)
         (let ((ent-id (car entity))
               (moniker (cadr entity))
               (c-ids (mapcar 'ces-insert-component-struct-into-components
                                   (caddr entity))))
           (ces-new-entity-with-instantiated-components
            ent-id moniker c-ids (mapcar 'car (ces-components-f c-ids)))))
       data))))

(defun ces-set-c&e-insert ()
  (setq e-insert (ces-insert-entity-bld 2048
                  ;;(+ 1 (apply 'max 0 (hash-table-keys entities)))
                  ))
  (setq c-insert (ces-insert-component-bld 2048
                  ;;(+ 1 (apply 'max 0 (hash-table-keys components)))
                  )))

(defun ces-insert-component-struct-into-components (cstruct)
  (let ((c-id (car cstruct))
        (component (cdr cstruct)))
    (puthash c-id component components)
    c-id))

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

(defun ces-initialize-from-human-seraialized (init-systems init-components buffer)
  (let (c2e e2c components entities generals components-def systems-def
            c-insert e-insert)
    (ces-init-globs)
    (apply 'funcall init-systems)
    (apply 'fncall funcall init-components)
    (ces-deserialize-human buffer)
    (ces-set-c&e-insert)
    (list :c2e c2e :e2c e2c :components components :entities entities
          :generals generals :components-def components-def :systems-def systems-def)))

(defun ces-call-function (state fun)
  (ces-tick state (lambda () (funcall fun))))

(defun ces-event-send-message (state type &rest cargs)
  (ces-tick state (lambda()
                (push (list 'player (float-time) type cargs)
                      message-queue))))

(defun ces-event-poll (state)
  (ces-tick state
        (lambda ()
          (let* ((mq2 (reverse message-queue))
                 (message (pop mq2)))
            (while message
              (let ((uid (car message))
                    (time-sent (cadr message))
                    (type (cadr (cdr message)))
                    (args (cddr (cdr message))))
                (when (equal uid 'player)
                  (ces-insert-general-into-generals type `(:time ,time-sent
                                                             :args ,@args))))
                (setq message (pop mq2))))
            (setq message-queue nil))))

(defun ces-system-dispatch (state &rest systems)
  (ces-tick state
        (lambda () (mapc 'ces-call-system systems))))

(defun ces-check-general (state general)
  (ces-tick state (lambda () (ces-generals-f general))))

(provide 'ces)
;;; ces.el ends here
