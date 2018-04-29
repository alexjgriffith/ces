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

(defun ces-seng-utils-move (ent-id loc0 loc1)
  ;; 1 update where in ent-id to loc1
  (ces-utils-comp-put-value (ces-components-f (ces-e2c-f ent-id)) 'where :location loc1)
  ;; remove ent-id from loc0  
  (ces-utils-comp-rem-hash-value (ces-components-f (ces-e2c-f loc0))
                                 'contains :hash ent-id)
  ;; add ent-id to loc1
  (ces-utils-comp-put-hash-value (ces-components-f (ces-e2c-f loc1))
                                 'contains :hash ent-id t))

(defun ces-seng-utils-hail (ent-id)
  ;; Attempt to change the ent-id state from default to hailed
  nil)

(defun ces-seng-utils-get-equipment-attributes-union (ent-id)
  (let ((keys '(:head :shirt :pants :shoes :ring :hand))
        (equipment (ces-utils-comp-get-plist-e ent-id 'equipment))
        sets)
    (mapc (lambda(key)
            (let ((set (ces-utils-comp-get-value-e (plist-get equipment key)
                                                   'attributes :hash)))
              (when set
                (push set sets))))
          keys)
    (message  "%s"  sets)
    (apply 'ces-set-union sets)))
