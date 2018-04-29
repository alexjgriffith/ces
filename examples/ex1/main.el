;; -*- lexical-binding :t -*-
(mapc 'load-file (directory-files "~/Development/elisp/ces/lisp/" t ".el"))
(setq debug-on-error t)


(defvar story-game-ids #s(hash-table test equal data ("animals" 1024
                                                      "locations" 1024
                                                      "npcs" 1024
                                                      "clothing" 1024)))

(defvar story-game-generals-init '((player-location . 1)
                                   (player-ent . 0)
                                   (timer-ent . 69)))

(defvar story-game-loader-location-alist nil)

(defvar story-game-standard-init #s(hash-table data (rat story-game-init-rat
                                                         shirt story-game-init-shirt
                                                         pants story-game-init-pants)))

(defvar story-game-state nil)

(defun story-game-al2h (alist)
  (ces-utils-hash-from-alist alist))

(defun story-game-l2s (list)
  (ces-set-from-list list 'equal))

(defun story-game-loader (buffer)
  (let  ((story-game-loader-location-alist nil))
    (ces-loader-load buffer)
    (mapc (lambda (ent-loc)
            (let ((ent (car ent-loc))
                  (loc (cdr ent-loc)))
              (ces-seng-utils-add-ent-to-location ent loc)))
          story-game-loader-location-alist)))

(defun story-game-next-id (key)
  (let ((value (gethash key story-game-ids)))
    (puthash key (+ value 1) story-game-ids)
    value))

(defun story-game-init-rat (&optional location)
  (let ((id (format "%s"(story-game-next-id "animals"))))
    (remove 'nil
            (cons (concat "rat animals-" id)
                  (list `(named :pronoun "It" :dname "Rat"
                                :sname "rat" :rname ,(concat "rat@animals."
                                                             id))
                        `(description :text ,"A furry little rat buddy. Great for cuddling.")
                        (when location
                          `(where :location ,location)))))))

(defun story-game-init-shirt (&optional location)
  (let ((id (format "%s"(story-game-next-id "clothing"))))
    (remove 'nil
            (cons (concat "shirt clothing-" id)
                  (list `(named :pronoun "It" :dname "White Shirt"
                                :sname "white-shirt" :rname ,(concat "white-shirt@clothing."
                                                             id))
                        `(description :text ,"A plain white t.")
                        `(attributes :hash ,(story-game-l2s '("white shirt" "white" "t-shirt" "cool")))
                        (when location
                          `(where :location ,location)))))))

(defun story-game-init-pants (&optional location)
  (let ((id (format "%s" (story-game-next-id "clothing"))))
    (remove 'nil
            (cons (concat "pants clothing-" id)
                  (list `(named :pronoun "It" :dname "Worn Jeans"
                                :sname "worn-jeans" :rname ,(concat "worn-jeans@clothing."
                                                             id))
                        `(description :text ,"Just some worn jeans.")
                        `(attributes :hash ,(story-game-l2s '("blue pants" "blue" "jeans" "worn" "cool")))
                        (when location
                          `(where :location ,location)))))))

(defun story-game-init-npc (location)
  (let ((id (format "%s" (story-game-next-id "npc"))))
    (remove 'nil
          (cons (concat "npc-" id)
           (list `(named :pronoun "It" :dname "NPC"
                         :sname "npc" :rname ,(concat "npc@npc." id))
                 `(description :text ,"A very generic npc. It walks arround.")
                 `(where :location ,location))))))

(defun story-game-new-insert (e-id loc type &rest parameters)
  (let* ((fun (gethash type story-game-standard-init))
         (ret (funcall fun loc))
         (name (car ret))
         (comps (cdr ret))
         c-ids)
    ;; update components with parameters    
    (setq comps (ces-utils-replace-component-info comps parameters))    
    (push (cons e-id loc) story-game-loader-location-alist)
    (append (list name) comps)))

;; the issue is i can't seam to evaluate in the hash, this will work programatically
;; though
(defun story-game-new (loc type &rest parameters)
  (let* ((fun (gethash type story-game-standard-init))
         (comps (funcall fun loc))
         c-ids
         e-id)
    ;; update components with parameters    
    (setq comps (ces-utils-replace-component-info comps parameters))
    ;; insert components into components
    (setq c-ids (ces-loader-insert-components (cdr comps)))
    ;; add entity with inserted component ids
    (setq e-id (ces-new-entity-with-instantiated-components-no-id
                (format "%s" type) c-ids (mapcar 'car (ces-components-f c-ids))))
    ;; insert ent id into location contains    
    e-id))




;; Timers global entity

;; new task, move npc from one room to another
;; (ces-seng-utils-move )
;; the player requires a timer
;; 1. check if provided direction is valid
;; 2. set timer to move in that direction
;; 3. return message that you are moving towards that direction

;; schedule format parser



(setq story-game-state (ces-loader '(ces-seng-systems) '(ces-seng-components)
                                   'story-game-loader '("game-timer.el")
                                   story-game-generals-init))

(ces-tick story-game-state (lambda()
                             ;; (ces-utils-comp-get-plist-e 0 'equipment)))
                             ;; (ces-components-f (ces-e2c-f 2049))))
                             (hash-table-keys (ces-seng-utils-get-equipment-attributes-union 0))))

(ces-check-general story-game-state 'player-location)

(ces-system-dispatch story-game-state 'calculate-favour)

;; call to check timers is not working mapcar ces-components-f, the issue is
;; in the rendering pipeline
(ces-system-dispatch story-game-state 'check-timers)

(ces-serialize-human story-game-state "*test*")

(ces-event-send-message story-game-state 'player-move `(0 move (0 1) 1
                                                          "You begin to move back."
                                                          "You failed to move"
                                                          "You've moved back"))
(ces-event-poll story-game-state)

(ces-system-dispatch story-game-state 'player-move)





;; (message "%s" #s(hash-table test les data (1 "hello" 2 "world")))
