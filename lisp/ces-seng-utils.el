(defun ces-seng-utils-move (ent-id loc0 loc1)
  ;; 1 update where in ent-id to loc1
  ;; remove ent-id from loc0
  ;; add ent-id to loc1
  (ces-utils-comp-get-plist (ces-components-f (ces-e2c-f ent-id)) 'where)
  )

(defun ces-seng-utils-hail (ent-id)
  ;; Attempt to change the ent-id state from default to hailed
  nil)
