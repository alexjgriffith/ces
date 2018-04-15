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
   graze
   (hunger where herbivore) ()
   (mapcar (lambda(x)
             (let* ((ent (car x))
                    (comps (cdr x))
                    (hunger-plist (comp-get-plist comps 'hunger))
                    (current (plist-get hunger-plist :current))
                    (rate (plist-get hunger-plist :rate))
                    (max (plist-get hunger-plist :max))
                    (loc-id (comp-get-value comps 'where :location))
                    (location (components-f (e2c-f loc-id))))
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
   (size reproduction where) ()
   (mapcar (lambda(x)
             (let* ((ent (car x))
                    (comps (cdr x))
                    (current (plist-get (cdr (assoc 'size comps)) :current))
                    (loc-id (plist-get  (cdr (assoc 'where comps)) :location))
                    (location (components-f (e2c-f loc-id)))
                    (floor-size (plist-get (cdr (assoc 'location location)) :floor-size))
                    (obj-limit (plist-get (cdr (assoc 'location location)) :obj-limit))
                    (comp-names (component-names loc-id))
                    (floor-count (count-component-names comp-names 'floor))
                    (obj-count (count-component-names comp-names 'obj))
                    (rep-plist (cdr (assoc 'reproduction comps )))
                    (state (plist-get rep-plist :state))
                    (step (plist-get rep-plist :step))                    
                    (stages (plist-get rep-plist :stages))
                    (next-stage (or (cadr(member state (mapcar 'car stages)))
                                   (caar stages)))
                    (max-step (cadr (assoc state stages)))
                    (min (plist-get rep-plist :min-size))
                    (rep-stage (plist-get rep-plist :reproduce-on)))
               (when (comp-get-plist comps 'hunger)
                 (game-debug "rep %s\n" (comp-get-plist comps 'reproduction))
                 (game-debug "size %s\n" (comp-get-plist comps 'size))
                 )
               (when (> current min)
                 (if (< step (- max-step 1))
                     (plist-put rep-plist :step (+ step 1))
                   (plist-put rep-plist :step 0)
                   (plist-put rep-plist :state next-stage)                   
                   )
                 (when (equal state rep-stage)                   
                   (when (and (member 'plant (mapcar 'car comps))
                              (< floor-count floor-size))
                     (new-plant loc-id))
                   (when (and (member 'deer (mapcar 'car comps))
                              (< obj-count obj-limit))
                     (new-deer loc-id))
                 ))))
           (join size reproduction where)))
  (new-system!
   sample-2
   (stats pos) nil
   (join stats pos)))
