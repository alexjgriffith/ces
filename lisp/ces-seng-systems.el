;; -*- lexical-binding: t -*-

(defun ces-seng-systems-put-in-location (loc-id ent-id)
  (message (format "locid %s" loc-id))
  (puthash ent-id t (comp-get-value (ces-components-f (ces-e2c-f loc-id))
                                    'contains :hash))
  ent-id)

(defun ces-seng-systems-remove-from-location (loc-id ent-id)
  (remhash ent-id (plist-get (cdr (assoc 'contains (ces-components-f (e2c-f loc-id))))
                             :hash))
  loc-id)

(defun ces-seng-systems-move-direction (loc-id1 ent-id direction)
  (let* ((ent-plist (ces-utils-comp-get-plist (ces-components-f (ces-e2c-f ent-id)) 'where))
         (loc-id2 (gethash direction
                           (ces-utils-comp-get-value
                            (ces-components-f (ces-e2c-f loc-id1))
                                           'exits :hash))))
    (plist-put ent-plist :location loc-id2)
    (ces-seng-systems-remove-from-location loc-id1 ent-id )
    (ces-seng-systems-put-in-location loc-id2 ent-id))
  ent-id)

(defun ces-seng-systems-add-location-timer (loc-id ends callback)
  (let* ((location (ces-components-f (ces-e2c-f loc-id)))
        ;; look into hash less than comparison for timers?
        (timer (ces-utils-comp-get-value location 'timers :hash)))
    (puthash ends callback timer)))

(defun ces-seng-systems ()
  (ces-new-system!
   move-player
   (player location)(player-direction)   
   (let* ((player (car (ces-join player)))
          (player-comps (cdr player))
          (player-id (car player))
          (current-loc-id (ces-utils-comp-get-value player-comps 'where :current-location))
          (direction (car (plist-get player-direction :args)))
          (time (car (plist-get player-direction :time))))
     (story-game-debug "creating timer!\n")
     (ces-seng-systems-add-location-timer
      current-loc-id (float-time (time-add time 1.0))      
      (lambda()
        (story-game-debug "moving character!\n")
        (ces-seng-systems-move-direction current-loc-id player-id player-direction))))
   )
  (ces-new-system!
   check-location-timers
   (location) ()
   (let ((meas (float-time)))
     (mapc (lambda(loc)
             (message (format "message: %s" (ces-utils-comp-get-value (cdr loc) 'timers :hash)))
             (maphash (lambda(time callback)
                        (when (< meas time)
                          (funcall callback)))
                    (ces-utils-comp-get-value (cdr loc) 'timers :hash)))
           (join location))))
  )
