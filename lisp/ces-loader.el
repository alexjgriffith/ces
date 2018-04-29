;;; ces-loader.el --- Loader for Emacs CES -*- lexical-binding: t -*-

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

(defun ces-loader-insert-components (comps)
  (mapcar (lambda (component)
            (ces-insert-component-into-components component))
          comps))

(defun ces-loader-read-buffer (buffer)
  (with-current-buffer (get-buffer buffer)
    (goto-char (point-min))
    (read (current-buffer))))

(defun ces-loader-load (buffer)
  (let ((data (eval (ces-loader-read-buffer buffer))))
    (mapcar
     (lambda (entity)
       (let ((ent-id (car entity))
             (moniker (cadr entity))
             (c-ids (ces-loader-insert-components
                            (cddr  entity))))
         (ces-new-entity-with-instantiated-components
           ent-id moniker c-ids (mapcar 'car (ces-components-f c-ids)))))
     data)))

(defun ces-loader (init-systems init-components game-loader buffers gen)
  (let (c2e e2c components entities generals components-def systems-def
            c-insert e-insert)
    (ces-init-globs)
    (apply 'funcall init-systems)
    (apply 'funcall init-components)
    (ces-set-c&e-insert)    
    (apply game-loader buffers)
    (mapc (lambda(x)
            (ces-insert-general-into-generals (car x) (cdr x)))
          gen)
    (list :c2e c2e :e2c e2c :components components :entities entities
     :generals generals :components-def components-def :systems-def systems-def)))

(provide 'ces--loader)
;;; ces--loader.el ends here
