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

(defvar c2e nil)
(defvar e2c nil)
(defvar components nil)
(defvar entities nil)
(defvar generals nil)
(defvar components-def nil)
(defvar systems-def nil)

;; A vector that automatically grows
(defun gvec-new (&optional length grow)
  (let ((vector (make-vector (or length 64) nil))
        (grow (or grow 0.8))
        (length (or length 64))
        (index 0))
    (lambda(action &rest cargs)
      (cond
       ((equal action 'insert)
        (let ((arg-value (car cargs)))
          (when (> index (* grow length) )
            (setq vector (vconcat vector (make-vector length nil)))
            (setq length (* 2 length)))
          (aset vector index arg-value)
          (setq index (+ index 1))
          (- index 1)))
       ((equal action 'get )
        (let ((arg-index (car cargs)))
          (when (> index arg-index)
            (aref vector arg-index))))
       ((equal action 'set )
        (let ((arg-index (car cargs))
              (arg-value (cadr cargs)))
          (when (> index arg-index)
            (aset vector arg-index arg-value))))
       ((equal action 'vector) vector)
       ((equal action 'index) index)))))

(defun gvec-insert (value gvec)
  (funcall gvec 'insert value))

(defun gvec-get (index gvec)
  (funcall gvec 'get index))

(defun gvec-set (index value gvec)
  (funcall gvec 'set index value))

(defun gvec-rem (index gvec)
  (funcall gvec 'set index nil))

(defun gvec-to-vector ( gvec)
  (funcall gvec 'vector))

(defun gvec-index (gvec)
  (funcall gvec 'index))

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

(defun init-globs ()
  (setq c2e (make-hash-table))
  (setq e2c (make-hash-table))
  (setq generals (make-hash-table))
  (setq components-def (make-hash-table))
  (setq systems-def (make-hash-table))
  (setq components (gvec-new))
  (setq entities (gvec-new)))

(defun initialized (init-systems init-components setup)
  (let (c2e e2c components entities generals components-def systems-def)
    (init-globs)
    (funcall init-systems)
    (funcall init-components)
    (funcall setup)
    (list :c2e c2e :e2c e2c :components components :entities entities
          :generals generals :components-def components-def :systems-def systems-def)))

(defun insert-component-into-components (value)
  (gvec-insert value components))

(defun remove-component-from-components (key)
  (gvec-rem key components))

(defun insert-entity-into-entities (value)
  (gvec-insert value entities))

(defun remove-entity-from-entities (key)
  (gvec-rem key entities))

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
          (when (equal component (car(gvec-get x components)))
            (gvec-rem x components)
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


(defun components-f (comp-list)
  (mapcar (lambda (index) (gvec-get index components)) comp-list))

(defun entities-f (ent-list)
  (mapcar (lambda (index) (gvec-get index entities)) ent-list))

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
                            (mapcar (lambda (x) `(,x (generals ',x))) gens))
                ,@body))
            systems-def))

(defun call-system (system)
  (funcall (gethash system systems-def)))

(defun gen-component (comp &rest cargs)
  (apply (gethash comp components-def) cargs))

(defun join (&rest sets)
  (mapcar (lambda (ent) (cons ent (components-f (e2c-f ent))))
          (set-to-list (apply 'set-intersect sets))))

;; (defun tick (state callback)
;;   (let ((c2e (plist-get state :c2e))
;;         (e2c (plist-get state :e2c))
;;         (components (plist-get state :components))
;;         (entities (plist-get state :entities))
;;         (generals (plist-get state :generals))
;;         (components-def (plist-get state :components-def))
;;         (systems-def (plist-get state :systems-def)))
;;     (funcall callback)
;;     (list :c2e c2e :e2c e2c :components components :entities entities
;;           :generals generals :components-def components-def :systems-def systems-def)))

(defun tick (state callback)
  (let ((c2e (plist-get state :c2e))
        (e2c (plist-get state :e2c))
        (components (plist-get state :components))
        (entities (plist-get state :entities))
        (generals (plist-get state :generals))
        (components-def (plist-get state :components-def))
        (systems-def (plist-get state :systems-def)))
    (funcall callback)))

(provide 'ces)
;;; ces.el ends here
