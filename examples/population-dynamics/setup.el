;; -*- lexical-binding: t -*-


;; Functions that would go in the game code
(defun new-plant (location)
  (put-in-location
   location
   (add-components (new-entity "plant" )
                   (gen-component 'render "P")
                   (gen-component 'floor)
                   (gen-component 'autotroph)
                   (gen-component 'plant 1 5)
                   (gen-component 'size 10 100 1)
                   (gen-component 'reproduction 'dormant 0
                                  '((dormant 10) (flowering 2) (reproductive 1))
                                  30 'reproductive)
                   (gen-component 'where location)
                   )))


(defun new-deer (location)
  (put-in-location
   location
   (add-components (new-entity "deer")
                   (gen-component 'render "D")
                   (gen-component 'obj)
                   (gen-component 'herbivore)
                   (gen-component 'deer)
                   (gen-component 'where location)
                   (gen-component 'hunger 300 300 1)
                   (gen-component 'size 10 1000 1)
                   (gen-component 'reproduction 'dormant 0
                                  '((dormant 100) (pregnant 10) (reproductive 1))
                                  100 'reproductive))))


;; Functions that would go in the libary code
(defun put-in-location (loc-id ent-id)
  (puthash ent-id t (comp-get-value (components-f (e2c-f loc-id)) 'contains :hash))
  ent-id)

(defun remove-from-location (loc-id ent-id)
  (remhash ent-id (plist-get (cdr (assoc 'contains (components-f (e2c-f loc-id)))) :hash))
  loc-id)

(defun move-direction (loc-id1 ent-id direction)
  (let* ((ent-plist (comp-get-plist (components-f (e2c-f ent-id)) 'where))
         (loc-id2 (gethash direction
                          (comp-get-value (components-f (e2c-f loc-id1)) 'exits :hash))))
    (plist-put ent-plist :location loc-id2)
    (remove-from-location loc-id1 ent-id )
    (put-in-location loc-id2 ent-id))
  ent-id)

(defun move-direction-random (ent-id)
  (let* ((loc-id (comp-get-value (components-f (e2c-f ent-id)) 'where :location))
         (exits (get-exits loc-id))
         (dir (elt exits (random (length  exits )))))    
      (move-direction loc-id ent-id dir)))

(defun move-direction-random-internal (ent-id loc-id1 location)
  (let* ((ent-plist (comp-get-plist (components-f (e2c-f ent-id)) 'where))
         (loc1-hash (comp-get-value location 'exits :hash))
         (exits (hash-table-keys  loc1-hash))
         (dir (elt exits (random (length  exits ))))         
         (loc-id2 (gethash dir loc1-hash))
         (loc2-hash (comp-get-value (components-f (e2c-f loc-id2)) 'contains :hash)))
    (plist-put ent-plist :location loc-id2)
    (puthash ent-id t loc2-hash)
    (remhash ent-id loc1-hash)
    ent-id))


(defun get-exits (loc-id)
  (hash-table-keys  (comp-get-value (components-f (e2c-f loc-id)) 'exits :hash)))


(defun add-exit (loc-id key exit-id)
  (puthash key exit-id (plist-get (cdr (assoc 'exits (components-f (e2c-f loc-id)))) :hash))
  loc-id)

(defun new-location ()
  (add-components (new-entity "location")
                  (gen-component 'location 25 10 "")
                  (gen-component 'contains (make-hash-table))
                  (gen-component 'exits (make-hash-table :test 'equal))))

(defun location-add-description (loc-id description)
  (plist-put (cdr (assoc 'location (components-f (e2c-f loc-id)))) :description description)
  loc-id)

;; (defun list-exits)

(defun init-setup ()
  (let ((location-1 (new-location ""))
        (location-2 (new-location))
        (location-3 (new-location))
        (location-4 (new-location))
        (player-id (new-entity "player"))
        (mob-id-1 (new-entity "mob"))
        (mob-id-2 (new-entity "mob"))        
        (c1 (gen-component 'stats 7 7 7))
        (c2 (gen-component 'stats 7 7 7))
        (c3 (gen-component 'stats 7 7 7))
        (c4 (gen-component 'description  "This is the end. My only friend, the end.")))
    (add-exit (add-exit location-1 "south" location-3) "east" location-2)
    (add-exit (add-exit location-2 "south" location-4) "west" location-1)
    (add-exit (add-exit location-3 "north" location-1) "east" location-4)
    (add-exit (add-exit location-4 "north" location-2) "west" location-3)
    (add-components player-id c1 c4 c5 (gen-component 'where location-1))
    (add-components mob-id-1 c2)
    (add-components mob-id-2 c3)
    (location-add-description 0 "A wooded dell.")
    (location-add-description 1 "A gentle brook flows past.")
    (location-add-description 2 "A small hill, covered in grass.")
    (location-add-description 4 "A dense forest.")
    (new-plant location-1)
    (new-plant location-1)
    (new-plant location-1)
    (new-plant location-2)
    (new-plant location-3)
    (new-plant location-4)
    (new-deer location-1)
    ;; (remove-entity 4)
    (insert-general-into-generals 'player-location location-1)
    (insert-general-into-generals 'look nil)
    (insert-general-into-generals 'move nil)
    (insert-general-into-generals 'quit nil)
    (insert-general-into-generals 'render nil)
    (insert-general-into-generals 'exits (list-exits location-1))
    ;;(remove-component player-id 'description)
    ))


;; Generalize for the library
;; (defun ces-seng-new-game (setup systems components)
;;   (initialized `(ces-seng-systems ,@systems) `(ces-seng-components ,@components) setup))
;;
;;
(defun game ()
   (initialized
    'init-systems
    'init-components
    'init-setup))

