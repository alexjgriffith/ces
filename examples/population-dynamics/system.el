;; -*- lexical-binding: t -*-

(defun init-systems ()
  (new-system!
   sample
   (stats pos) (input)
   (mapcar (lambda(x)
             (let* ((ent (car x))
                    (comps (cdr x))
                    (dex (plist-get (cdr (assoc 'stats comps)) :dex))
                    (p (cdr (assoc 'pos comps))))
               (when (> dex 6) 
                 (plist-put p :x (+ input (plist-get p :x)))
                 )))
           (join stats pos)))
  (new-system!
   grow
   (size where) ()
   (mapcar (lambda(x)
             (let* ((ent (car x))
                    (comps (cdr x))
                    (size-plist (cdr (assoc 'size comps)))
                    (current (plist-get size-plist :current))
                    (rate (plist-get size-plist :rate))
                    (max (plist-get size-plist :max)))
               (when (> max current)
                 (plist-put size-plist :current (+ rate  current )))
               (when (equal max current)
                 (remove-entity ent)                 
                 (remove-from-location
                  (plist-get (cdr (assoc 'where comps)) :location)
                  ent)
                 )))
           (join size where)))
  (new-system!
   viz
   () (my-location)
   (render my-location))
  (new-system!
   move
   (deer where location) ()
   (mapc
    (lambda(x)
      (let* ((loc-id (car x))
             (location (cdr x))
             (partners (comp-get-value location 'contains :hash)))
        (mapc (lambda(x)
                (when (< (random 10) 2)
                  (game-debug "random-move: %s\n" (car x))                  
                  ;;(move-direction-random-internal (car x) loc-id location)
                  (move-direction-random (car x) )
                  ))
              (join partners where deer))
        )
      )
    (join location))
   )
  (new-system!
   graze
   (location hunger where herbivore) ()
   (mapcar (lambda(x)
             (let* ((ent (car x))
                    (comps (cdr x))
                    (hunger-plist (comp-get-plist comps 'hunger))
                    (current (plist-get hunger-plist :current))
                    (rate (plist-get hunger-plist :rate))
                    (max (plist-get hunger-plist :max))
                    (loc-id (comp-get-value comps 'where :location)))
               ;; do you eat?
               (when (> (* (random-float-range 0.2 0.5) max) current)
                 ;; try to eat the first plant in the room
                 (let ((plant (find-first 'plant loc-id)))
                   (if plant
                       (progn
                         (game-debug "debug-eating %s\n" plant)
                         (remove-entity plant)
                         (remove-from-location loc-id plant)
                         (plist-put hunger-plist :current (min max (+ 30  current )))
                         (game-debug "hunger %s\n" hunger-plist))
                     (game-debug "can't find plant\n")
                     )
                   ))
               ;; have you starved to death?
               (when (> 0 current)
                 (remove-entity ent)                 
                 (remove-from-location
                  loc-id
                  ent))
               (plist-put hunger-plist :current (-  (plist-get hunger-plist :current) rate))))
           (join hunger where herbivore)))
    (new-system!
     reproduce
     (location size reproduce) ()
     (mapc (lambda(x)
             (let* ((loc-id (car x))
                    (location (cdr x))
                    (partners (comp-get-value location 'contains :hash))
                    (floor-size (comp-get-value location 'location  :floor-size))
                    (obj-limit (comp-get-value location 'location  :obj-limit))
                    (comp-names (component-names loc-id))
                    (floor-count (count-component-names comp-names 'floor))
                    (obj-count (count-component-names comp-names 'obj)))
               (mapc (lambda(x)
                       (let* ((ent (car x))
                             (comps (cdr x))
                             (rep-plist (comp-get-plist comps 'reproduction))
                             (current (comp-get-value comps 'size :current))
                             (state (plist-get rep-plist :state))
                             (step (plist-get rep-plist :step))                    
                             (stages (plist-get rep-plist :stages))
                             (max-step (cadr (assoc state stages)))
                             (min (plist-get rep-plist :min-size))
                             (rep-stage (plist-get rep-plist :reproduce-on)))
                         (when (> current min)
                           (if (< step (- max-step 1))
                               (plist-put rep-plist :step (+ step 1))
                             (plist-put rep-plist :step 0)
                             (plist-put rep-plist :state
                                        (or (cadr(member state (mapcar 'car stages)))
                                            (caar stages)))
                             )
                           (when (equal state rep-stage)                   
                             (cond  ((and (member 'plant (mapcar 'car comps))
                                          (< floor-count floor-size))
                                     (new-plant loc-id)
                                     (setq floor-count (+ floor-count 1)))
                                    ((and (member 'deer (mapcar 'car comps))
                                          (< obj-count obj-limit))
                                     (new-deer loc-id)
                                     (setq obj-count (+ obj-count 1))
                             ))
                         
                         ))))
                       (join partners size reproduce))))
               (join location)))

  
  (new-system!
   sample-2
   (stats pos) nil
   (join stats pos)))
