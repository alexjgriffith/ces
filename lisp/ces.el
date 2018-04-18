;;; ces.el --- Emacs Game Engine  -*- lexical-binding: t -*-

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

(defun make-set ()
  (make-hash-table))

(defun set-set (element set)
  (puthash element t set))

(defun set-get (element set)
  (gethash element set nil))

(defun set-rem (element set)
  (remhash element set))

(defun set-to-list (set)
  (hash-table-keys set))

(defun copy-set (set)
  (copy-hash-table set))

(defun set-from-list (list)
  (let ((set (make-set)))
    (mapc (lambda(x) (set-set x set)) list)
    set))

(defun set-intersect-2 (seta setb)
  (let* ((keys (hash-table-keys seta))
         (setc (copy-set seta)))
    (mapc (lambda(key) (unless (set-get key setb)
                         (set-rem key setc)))
                keys)
    setc))

(defun set-intersect (&rest sets)
  (cond ((equal (length sets) 0) (make-set))
         ((equal (length sets) 1) (car sets))
         ((equal (length sets) 2) (set-intersect-2 (car sets) (cadr sets)))
         (t (fold 'set-intersect-2  (car sets) (cadr sets) (cddr sets)))))

(defun fold (fun initial arg1 args)
  (while arg1
    (setq initial (funcall fun arg1 initial))
    (setq arg1 (pop args)))
  initial)

(defun zip2 (lista listb)
  (let ((elema (pop lista))
        (elemb (pop listb))
        ret)
    (while (and elema elemb)
      (push (list elema elemb ) ret)
      (setq elema (pop lista))
      (setq elemb (pop listb)))
    (reverse ret)))

(defun zip2-cons (lista listb)
  (let ((elema (pop lista))
        (elemb (pop listb))
        ret)
    (while (and elema elemb)
      (push (cons elema elemb ) ret)
      (setq elema (pop lista))
      (setq elemb (pop listb)))
    (reverse ret)))

(defun insert-into-hash-set (index value hash)
  (let ((selection (gethash index hash)))
    (unless selection
      (setq selection (make-set)))
    (set-set value selection)
    (puthash index selection hash)))

(defun remove-from-hash-set (index value hash)
  (let* ((selection (gethash index hash)))
    (set-rem  value selection)
    (puthash index  selection hash)))

(defun insert-into-hash-list (index value hash)
  (puthash index (append (gethash index hash) (list value)) hash))

(defun remove-from-hash-list (index value hash)
  (let* ((sub-hash (gethash index hash)))
    (puthash index (remove  value sub-hash) hash)))

(defun new-entity (moniker &rest components)
  (let ((id (insert-entity-into-entities moniker)))
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

(defun init-globs ()
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

(defun initialized (init-systems init-components setup)
  (let (c2e e2c components entities generals components-def systems-def
            c-insert e-insert message-queue)
    (init-globs)
    (mapc 'funcall init-systems)
    (mapc 'funcall init-components)
    (funcall setup)
    (list :c2e c2e :e2c e2c :components components :entities entities
          :generals generals :components-def components-def :systems-def systems-def)))

(defun insert-component-into-components (value)
  (funcall c-insert value))

(defun remove-component-from-components (key)
  (remhash key components))

(defun insert-entity-into-entities (value)
  (funcall e-insert value))

(defun get-entity-from-entities (key)
  (gethash key entities))

(defun remove-entity-from-entities (key)
  (remhash key entities))

(defun insert-component-into-e2c (e-id which)
  (insert-into-hash-list e-id which e2c))

(defun remove-component-from-e2c (e-id c-id)
  (remove-from-hash-list e-id  c-id  e2c))

(defun remove-entity-from-e2c (e-id)
  (remhash e-id e2c))

(defun insert-entity-into-c2e (e-id c-id)
  (insert-into-hash-set c-id e-id c2e))

(defun remove-entity-from-c2e (e-id c-id)
  (remove-from-hash-set c-id  e-id  c2e))

(defun insert-general-into-generals (key value)
  (puthash key value generals))

(defun remove-general-from-generals (key)
  (remhash key generals))


(defun add-component (id component)
  (let* ((component-name (car component))
         (component-value (cdr component))
         (which (insert-component-into-components component)))
    (insert-component-into-e2c id which)
    (insert-entity-into-c2e id component-name)))

(defun add-components (player-id &rest components)
  (when components
    (mapc (lambda(comp) (add-component player-id comp)) components))
  player-id)

(defun remove-component-from-entity (entity-id component)
  (mapc (lambda(x )
          (when (equal component (car(gethash x components)))
            (remhash x components)
            (remove-component-from-e2c entity-id x)
            (remove-entity-from-c2e entity-id component)))
        (gethash entity-id e2c)))

(defun remove-entity (entity-id)
  (let ((comp-ids (e2c-f entity-id)))
    (remove-entity-from-entities entity-id)
    (mapc (lambda (comp) (remove-entity-from-c2e entity-id (car  comp)))
          (components-f comp-ids))
    (mapc (lambda (comp-id) (remove-component-from-components comp-id))
          comp-ids) 
    (remove-entity-from-e2c entity-id)))

(defun entity-keys()
  (hash-table-keys entities))

(defun components-f (comp-list)
  (mapcar (lambda (index) (gethash index components)) comp-list))

(defun entities-f (ent-list)
  (mapcar (lambda (index) (gethash index entities)) ent-list))

(defun generals-f (name)
  (gethash name generals))

(defun e2c-f (entity)
  (gethash entity e2c))

(defun c2e-f (component)
  (gethash component c2e))

(defmacro new-component! (name &rest elements)
  `(puthash ',name (lambda(,@elements)
                     (apply 'append '(,name) (zip2 (quote ,elements)
                                                   (list ,@elements) )))
            components-def))

(defmacro new-system! (name comps gens &rest body)
  `(puthash ',name
            (lambda ()
              (let ,(append (mapcar (lambda (x) `(,x (c2e-f ',x))) comps)
                            (mapcar (lambda (x) `(,x (generals-f ',x))) gens))
                ,@body))
            systems-def))

(defun call-system (system)
  (funcall (gethash system systems-def)))

(defun gen-component (comp &rest cargs)
  (apply (gethash comp components-def) cargs))

(defun join (&rest sets)
  (mapcar (lambda (ent) (cons ent (components-f (e2c-f ent))))
          (set-to-list (apply 'set-intersect sets))))

(defun tick (state callback)
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
         (let ((comp-ids (e2c-f ent-id)))
           `(,ent-id
             ,(get-entity-from-entities ent-id)
             ,(zip2-cons comp-ids (components-f comp-ids)))))
       (entity-keys) ))

(defun ces-serialize-human (world buffer)
  (with-current-buffer (get-buffer-create buffer)
    (let ((str (tick world 'ces-serialize-human-callback)))
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
               (c-ids (mapcar 'insert-component-struct-into-components
                                   (caddr entity))))
           (new-entity-with-instantiated-components
            ent-id moniker c-ids (mapcar 'car (components-f c-ids)))))
       data))))

(defun ces-set-c&e-insert ()
  (setq e-insert (ces-insert-entity-bld
                  (+ 1 (apply 'max (hash-table-keys entities)))))
  (setq c-insert (ces-insert-component-bld
                  (+ 1 (apply 'max (hash-table-keys components))))))

(defun insert-component-struct-into-components (cstruct)
  (let ((c-id (car cstruct))
        (component (cdr cstruct)))
    (puthash c-id component components)
    c-id))

(defun new-entity-with-instantiated-components (ent-id moniker c-ids cnames)
  (puthash ent-id moniker entities)
  (mapc (lambda(c-id)
          (insert-component-into-e2c ent-id c-id))
        c-ids)
  (mapc (lambda (cname)
          (insert-entity-into-c2e ent-id cname))
        cnames)        
  ent-id)

(defun initialize-from-human-seraialized (init-systems init-components buffer)
  (let (c2e e2c components entities generals components-def systems-def
            c-insert e-insert)
    (init-globs)
    (funcall init-systems)
    (funcall init-components)
    (ces-deserialize-human buffer)
    (ces-set-c&e-insert)
    (list :c2e c2e :e2c e2c :components components :entities entities
          :generals generals :components-def components-def :systems-def systems-def)))

(defun ces-call-function (state fun)
  (tick state (lambda () (funcall fun))))

(provide 'ces)
;;; ces.el ends here
