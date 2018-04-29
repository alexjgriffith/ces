;; These functions are only used by the user player.
;; THe npcs can interact directly with the ECS.

;; to define
;; ces-seng-utils-location-valid-dir
;; ces-seng-utils-location-description
;; ces-seng-utils-entity-handle-to-id
;; ces-seng-utils-entity-description


(defun ces-seng-controls-quit (state &rest _body)
  (ces-event-send-message story-game-state 'quit 't)
  )

(defun ces-seng-utils-current-location ()
  (let* ((loc0 (ces-utils-comp-get-value-e 0 'where :location)))
    (when loc0
      (cons loc0 (ces-components-f (ces-e2c-f loc0))))))

(defun ces-seng-utils-direction-to-location (loc-id dir)
  (let* ((hash (ces-utils-comp-get-value-e loc-id 'exits :hash)))
    (gethash dir hash)))

(defun ces-seng-controls-mv (state &rest body)
  ""
  (ces-tick
   state
   (lambda()
     (let* ((dir (intern-soft (car body)))            
            (loc-details (ces-seng-utils-current-location))
            (loc-id (car loc-details))
            (exits (hash-table-keys (ces-utils-comp-get-value-e loc-id 'exits :hash)))
            (loc-components (cdr loc-details))
            (loc-name (ces-utils-comp-get-value-e loc-id 'named :dname))
            (loc2 (ces-seng-utils-direction-to-location loc-id dir))
            (moveable (ces-utils-comp-get-plist-e 0 'moveable))
            (player-start-move (plist-get moveable :start-text))
            (player-abort-move (plist-get moveable :abort-text))
            (player-time (plist-get moveable :time))
            (player-end-move (plist-get moveable :end-text))
            (dur (* player-time (ces-utils-comp-get-value-e loc-id 'move :modifier)))
            (start-text (format "%s %s the %s." "You" player-start-move
                                dir))
            (abort-text (format "%s %s the %s." "You" player-abort-move
                                dir))
            (end-text (format "%s %s the %s." "You" player-end-move
                              dir)))
       (if dir
           (progn          
             (if loc2
                 (progn                                      
                   (ces-event-send-message story-game-state
                                        'player-move `(0 move (0 ,loc2) ,dur
                                                         ,start-text
                                                         ,abort-text
                                                         ,end-text
                                                         ))
                   (format "You started moving towards the %s." dir)
                   )
               (format "%s is not a valid destination."                              
                       dir)))
         
         (if exits
             (format "Posible exits: %s." exits)
           (format "A viable location is required.")))))))


(ces-tick story-game-state (lambda() (gethash :door (ces-utils-comp-get-value-e 2 'exits :hash))))

;; (defun ces-seng-controls-ls (state &rest body)
;;   ""
;;   (let ((dir (car body))
;;         (player-ent 0)
;;         (loc-id (ces-utils-comp-get-value-e player-ent 'where :location))
;;         (loc-comps (ces-components-f (ces-e2c-f loc-id))))
;;     (ces-seng-rend-display-details-e loc-id loc-comps "*ces-seng-look")
;;     (ces-seng-utils-location-description state dir)))

(defun ces-seng-controls-ls (state &rest body)
  ""
  (cond ((eql 0 (length body ))
         (let* ((player-ent 0)
               (loc-id (ces-utils-comp-get-value-e player-ent 'where :location))
               (loc-comps (ces-components-f (ces-e2c-f loc-id))))
           (ces-seng-rend-display-details-e loc-id loc-comps "*ces-seng-look*")
           (format "%s" "You look around.")))
        ((eql 1 (length body))
         (let* ((rname (car body))
                (ent (ces-seng-utils-rname-to-ent rname))
                (comps (ces-components-f (ces-e2c-f rname)))
                (loc-id (ces-utils-comp-get-value-e player-ent 'where :location))
                (hash (ces-utils-comp-get-value-e loc-id 'contains :hash)))
           (if (gethash ent hash)
               (progn(ces-seng-rend-display-details-e ent comps "*ces-seng-look*")
                     (format "%s %s." "You look at" rname))
             (format "%s is not in your location."))
           ))
        (t "Look failed, too many args or object not in this location!")))


(defun ces-seng-utils-rname-to-ent (rname)
  (car
   (remove 'nil (mapcar
                 (lambda(key)
                   (when (equal rname
                                (ces-utils-comp-get-value-e key 'named :rname))
                     key))
                 (ces-set-to-list (ces-c2e-f 'named))))))


(defun ces-seng-controls-close (state &rest body)
  (kill-buffer "*ces-seng-look*"))

(defun ces-seng-controls-pwd (state &rest _body)
  ""  
  (ces-seng-utils-location-description state nil))


(defun ces-seng-controls-cat (state &rest body)
  ""
  (let* ((entity-handle (car body))
         (entity-id (ces-seng-utils-entity-handle-to-id entity-handle)))
    (ces-seng-utils-entity-description state entity-id)))

(defun ces-seng-controls-talk (stat &rest body)
  (format "Not implemented!"))

(defun ces-seng-controls-show (stat &rest body)
  (format "Not implemented!"))

(defun ces-seng-controls-stomp (stat &rest body)
  (format "Not implemented!"))

(defun ces-seng-controls-grab (stat &rest body)
  (format "Not implemented!"))

(defun ces-seng-controls-drop (stat &rest body)
  (format "Not implemented!"))

;; this is similar to ces-seng-new-insert but can happen while playing
;;; (defun ces-seng-controls-make
