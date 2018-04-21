(defvar story-setup-locations
  '((forest-glen-0 :x 0 :y 0 :parent nil :move-speed 0.7
                   :exits ((:north . southern-field-0) (:cottage . cottage-0))
                   :description "A small wooded glen with a small cottage.")
    (cottage-0 :x 0 :y 0 :parent forest-glen-0 :move-speed 1.0
               :exits ((:front-door . forest-glen-0))
               :description "This cottage looks a little run down.")
    (southern-field-0 :x 0 :y 1 :parent nil :move-speed 1.0
                      :exits ((:north . forest-glen-0))
                      :description "These fields don't look so fertile.")
    ))


(defvar story-setup-game-floor-size 20)
(defvar story-setup-game-obj-soft-limit 10)

(defun story-setup-player (location)
  (ces-seng-systems-put-in-location
   location
   (ces-add-components
    (new-entity "player")
    (gen-component 'player)
    (gen-component 'where location nil nil)
    (gen-component 'stats 7 7 7 80))))

(defun story-setup-get-exits (loc-id)
  (hash-table-keys  (ces-utils-comp-get-value (ces-components-f (ces-e2c-f loc-id)) 'exits :hash)))

(defun story-setup-add-exit (loc-id key exit-id)
  (puthash key exit-id (plist-get (cdr (assoc 'exits (ces-components-f (ces-e2c-f loc-id)))) :hash))
  loc-id)

(defun story-setup-create-location (location)
  (let ((floor-size story-setup-game-floor-size)
        (obj-soft-limit story-setup-game-obj-soft-limit)
        (move-speed (plist-get (cdr location) :move-speed))
        (description (plist-get (cdr location) :description))
        (location-handle (car location)))
    (ces-add-components
     (ces-new-entity (concat "location " (format "%s" location-handle)))
     (ces-gen-component 'move '((dex 1.2)(con 1.2)(weight 0.95)))
     (ces-gen-component 'location floor-size obj-soft-limit move-speed)
     (ces-gen-component 'contains (make-hash-table))
     (gen-component 'timers (make-hash-table))
     (ces-gen-component 'description description)
     (ces-gen-component 'exits (make-hash-table :test 'equal)))))

(defun story-setup-locations ()
  (let* ((locs (mapcar 'story-setup-create-location
                                     story-setup-locations))
        (ents (ces-zip2-cons (mapcar 'car story-setup-locations)
                             locs)))
    (mapc (lambda (loc)
            (let ((loc-id (car loc))
                  (loc (cddr loc)))
             (mapc (lambda(exit)
                    (let* ((room-name (cdr exit))
                           (direction (car exit))
                           (ent-id (cdr (assoc room-name ents))))
                      (story-setup-add-exit loc-id direction ent-id) ;; here
                      ))
                  (plist-get loc :exits))))
          (ces-zip2-cons (mapcar 'cdr ents) story-setup-locations))
    (mapcar 'cdr ents)))

(defun story-setup ()
  (let ((locations (story-setup-locations)))
    (ces-components-f (ces-e2c-f (story-setup-player 0)))))

(let ((game (story-game)))
  (let ((print-level nil)
        (print-length nil))
    (ces-event-send-message game 'move-player :north)
    (ces-system-dispatch game 'move-player)
    (ces-system-dispatch game 'check-location-timers)
    (ces-event-poll game)
    (ces-check-general game 'move-player)
    ))


