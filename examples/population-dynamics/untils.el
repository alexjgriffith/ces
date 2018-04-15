;; -*- lexical-binding: t -*-

;; Utilities

;; Some of these need to be put in a library

(defun comp-get-value (comps component-name key)
  (plist-get (cdr (assoc component-name comps)) key))

(defun comp-get-plist (components component-name)
  (cdr (assoc component-name components)) )

(defun find-first (component loc-id)
  (let ((hash (comp-get-value (components-f (e2c-f loc-id)) 'contains :hash)))
    (if (hash-table-p hash)
      (progn (cadr
       (assoc 't (mapcar
              (lambda(x) `(,(not (not (member component
                                              (mapcar 'car (components-f (e2c-f x))))))
                           ,x))
              (hash-table-keys hash)))))
      (game-debug "Contains in location is not a hash\n"))))

(defun component-names (loc-id)
  (let ((hash (plist-get (cdr (assoc 'contains (components-f (e2c-f loc-id)))) :hash)))
   (mapcar
    (lambda(x)  (mapcar 'car (components-f (e2c-f x))))
    (hash-table-keys hash))))

(defun count-component-names (name-list name)
  (let ((count 0))
    (mapc (lambda(x) (when (member name x)
                       (setq count (+ count 1))))
          name-list)
  count))

(defun stack (list)
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

;; (insert (json-encode (stack '("a" "a" "b" "c" "d" "d" "d"))))

(defun render (location)
  (let ((hash (comp-get-value (components-f (e2c-f location)) 'contains :hash)))
    (when (hash-table-p hash)
      (stack (mapcar
              (lambda(x)  (comp-get-value (components-f (e2c-f x)) 'render :char))
              (hash-table-keys hash))))))

(defun random-float ()
  (/ (random 1000000) (float 1000000)))

(defun random-float-range (lower upper)
  (+ (* (random-float)  (- upper lower)) lower))


(defun roll-d6 ()
  (random 6))

(defun roll-d10 ()
  (random 10))

(defun roll-d20 ()
  (random 20))

(defun game-debug (str &rest args)
    (with-current-buffer (get-buffer-create "*game-log*")
      (goto-char (point-max))
      (insert (apply 'format str args)))
    nil)
