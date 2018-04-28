;;; ces-utils.el --- Emacs Game Engine Utilities -*- lexical-binding: t -*-

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
(defun ces-utils-comp-get-value (comps component-name key)
  (plist-get (cdr (assoc component-name comps)) key))

(defun ces-utils-comp-get-plist (components component-name)
  (cdr (assoc component-name components)) )

(defun ces-utils-find-first (component loc-id)
  (let ((hash (comp-get-value (components-f (e2c-f loc-id)) 'contains :hash)))
    (if (hash-table-p hash)
      (progn (cadr
       (assoc 't (mapcar
              (lambda(x) `(,(not (not (member component
                                              (mapcar 'car (components-f (e2c-f x))))))
                           ,x))
              (hash-table-keys hash)))))
      (game-debug "Contains in location is not a hash\n"))))

(defun ces-utils-component-names (loc-id)
  (let ((hash (plist-get (cdr (assoc 'contains (components-f (e2c-f loc-id)))) :hash)))
   (mapcar
    (lambda(x)  (mapcar 'car (components-f (e2c-f x))))
    (hash-table-keys hash))))

(defun ces-utils-count-component-names (name-list name)
  (let ((count 0))
    (mapc (lambda(x) (when (member name x)
                       (setq count (+ count 1))))
          name-list)
  count))

(defun ces-utils-stack (list)
  (let ((key (pop list))
        ret-plist
        keys)
    (while key
      (if (assoc key ret-plist)
          (push  (list key (+ (cadr (assoc key ret-plist)) 1)) ret-plist)
        (push (list key 1)  ret-plist)
        (push key keys))
      (setq key (pop list)))
    (mapcar (lambda(x) (assoc x ret-plist)) (reverse keys))))


(defun ces-utils-random-float ()
  (/ (random 1000000) (float 1000000)))

(defun ces-utils-random-float-range (lower upper)
  (+ (* (random-float)  (- upper lower)) lower))


(defun ces-utils-roll-d6 ()
  (random 6))

(defun ces-utils-roll-d10 ()
  (random 10))

(defun ces-utils-roll-d20 ()
  (random 20))

(defun ces-utils-hash-from-alist (alist)
  (let ((hash (makehash equal)))
    (mapc (lambda(x) (puthash (car x) (cdr x) hash)) alist)
    hash))

(provide 'ces-utils)
;;; ces-utils.el ends here
