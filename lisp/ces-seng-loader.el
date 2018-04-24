;;; ces-seng-loader.el --- Loader for Emacs Story Engine -*- lexical-binding: t -*-

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

(defun ces-seng-loader-init (systems components setup-file new-objs globals)
  "load the setup file.

SYSTEMS and COMPONENTS are list of functinos to be used in the game. 
SETUP-FILE contains the initialization information for generating a new world.
NEW-OBJS is an alist linking object handels such as `tomato' with functions such
as `game-story-name-gen-new-tomato'. These functions take a list of keyword arguments
that can be used to customize the initialization.
GLOBALS is an alist of variables that can be used when writing the setup-file. For 
example if characteristics are shared between several locations they can be generalized
in a global.

`ces-seng-loader-init' returns a game object that can be passed to any function that
relies on `ces-tick'.

1. loader-new calls will be put directly into new world, any entites that 
need to be put into locations will append their request to `entity-locations'. 
Any entities that require timers in their requisite locations will append those
timers to `timers'.

2. All loader-new-insert calls will insert entites directly into the load-in list.
The location of the entity has to be handled when writing the setup file. However so
long as the location is defined in the call the timers will be handled by the 
loader-new-insert call

3. The setup-file has been converted to a list, all insert calls have been executed.
The input list is parsed and inserted into the `new-world'"
  (let* ((temp-world (lambda () (ces-initialized systems components  'identity)))
         (new-world (temp-world))
         timers entity-locations)
    ;; see ces-deserialize-human
    ))

(defun ces-seng-loader-new-insert (obj-type &rest keyword-args)
  "Insert a readable version of OBJ-TYPE generated with KEYWORD-ARGS"
  (let* ((world (temp-world))
         (ent-id (apply (assoc obj-type new-objs) world keyword-arguments)))
    (ces-seng-loader-human-readable world ent-id)))

(defun ces-seng-loader-new (obj-type &rest keyword-args)
  "Insert a new OBJ-TYPE directly into the new-world. 
KEYWORD-ARGUMENTS must be handled by the function assosiated with OBJ-TYPE."
  (apply (assoc obj-type new-objs) new-world keyword-arguments))

(defun ces-seng-loader-add-global (key)
  (gethash globals key))


(provide 'ces-seng-loader)
;;; ces-seng-loader.el ends here
