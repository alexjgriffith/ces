;; -*- lexical-binding :t -*-

(defvar story-game-file-loc "~/Development/elisp/ces/")

;; (setq debug-on-error t)

(defconst story-game-timeline-buffer "*ces-seng-rend-test*"
  "Timeline buffer of story game.")

(defconst story-game-look-buffer "*ces-seng-look*"
  "Timeline buffer of story game.")


(defconst story-game-debug-buffer "*story-game-debug*"
  "Debug buffer of story game.")

(defconst story-game-repl-buffer "*ces-repl*"
  "Debug buffer of story game.")

(defvar story-game-state  nil)

(defvar story-game-step 0)

(defvar story-game-init-message (lambda()
                                  `(:body "Welcome to life Glen." :ent-id 0 :when ,(current-time))))

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

;; Start game,
;; Open create repl, create timeline

(defun story-game-start-repl ()
  "Start a new repl with some test functions."
  (let ((buffer (get-buffer-create story-game-repl-buffer))        
        (fun-alist `(("move" . ,(story-game-controls-wrap 'ces-seng-controls-mv))
                     ("look" . ,(story-game-controls-wrap 'ces-seng-controls-ls))
                     ("close" . ,(story-game-controls-wrap 'ces-seng-controls-close))
                     ("quit" . ,(story-game-controls-wrap 'ces-seng-controls-quit))
                     ("timeline" . ,(story-game-controls-wrap 'ces-seng-controls-timeline))
                     ("inspect" . ,(story-game-controls-wrap 'ces-seng-controls-cat))
                     ("talk" . ,(story-game-controls-wrap 'ces-seng-controls-talk))
                     ("show" . ,(story-game-controls-wrap 'ces-seng-controls-show))
                     ("stomp" . ,(story-game-controls-wrap 'ces-seng-controls-stomp))
                     ("grab" . ,(story-game-controls-wrap 'ces-seng-controls-grab))
                     ("drop" . ,(story-game-controls-wrap 'ces-seng-controls-drop))
                     ("commands" . (lambda (&rest _body)
                                     (mapconcat 'identity
                                                '("move" "look" "inspect" "talk"
                                                  "show" "timeline"
                                                  "stomp" "grab" "drop" "close" "quit")
                                                " "))))))
    (with-current-buffer  buffer
      (ces-repl buffer)
      (ces-repl-add-function-keywords fun-alist)
      (ces-repl-load-functions fun-alist)            
      (font-lock-add-keywords nil ces-repl-test-highlights)
      (switch-to-buffer-other-window buffer))))

(defun story-game-build-from-tab ()
  (with-current-buffer (get-buffer-create "*temp*")
    (delete-region (point-min) (point-max))
    (insert (let ((print-level nil)
                  (print-length nil))
              (concat "'"(pp (apply 'ces-seng-loader-import
                                    (mapcar (lambda(file)
                                              (concat story-game-file-loc file))
                                            '("/examples/ex1/locations.tab"
                                              "/examples/ex1/player.tab"
                                              "/examples/ex1/npc.tab"
                                              "/examples/ex1/clothing.tab"
                                              "/examples/ex1/sched.tab")))))))
    (current-buffer)))

(defun story-game-start ()
  (interactive)
  (mapc 'load-file (directory-files (concat story-game-file-loc  "lisp/") t ".el"))
  (setq story-game-state (story-game-load (story-game-build-from-tab)))
  (ces-tick story-game-state (lambda() (ces-seng-rend-start
                                        (funcall story-game-init-message))))
  (with-current-buffer (get-buffer-create story-game-debug-buffer)
    (delete-region (point-min) (point-max)))
  (story-game-start-repl)
  (story-game-loop story-game-state))

(defun story-game-quit ()
  (interactive)
  (setq ces-seng-rend-update-bool nil)
  (with-current-buffer (get-buffer-create story-game-timeline-buffer)
    (kill-this-buffer))
  (with-current-buffer (get-buffer-create story-game-repl-buffer)
    (kill-this-buffer))
  (when (get-buffer "*ces-seng-look*")
    (kill-buffer "*ces-seng-look*"))
  ;;(ces-seng-controls-quit story-game-state)
  )

(defun story-game-loop (game-state)
  (story-game-debug ":: tick %s\n" story-game-step)
  (ces-event-poll story-game-state)
  (ces-system-dispatch game-state 'player-move 'calculate-favour 'check-timers)
  (setq story-game-step (+ story-game-step 1))
  (let ((quit (car (plist-get (ces-check-general game-state 'quit) :args))))
    (if quit
        (story-game-debug "Game quit!")
      (run-at-time (time-add (current-time) (seconds-to-time 0.333333))
                    nil ;; don't repeat
                    #'story-game-loop
                    story-game-state))
    nil))

(defun story-game-debug (str &rest args)
    (with-current-buffer (get-buffer-create story-game-debug-buffer)
      (let ((print-level nil)
            (print-length nil))        
        (save-excursion
          (goto-char (point-max))
          (insert (apply 'format str args)))))
    nil)


(defun story-game-load (buffer)
   (ces-loader '(ces-seng-systems) '(ces-seng-components)
               'story-game-loader `(,buffer)
               story-game-generals-init))


(defun story-game-controls-wrap (fun)
  (lambda (&rest body)
    (ces-tick story-game-state (lambda () (apply fun story-game-state  body)))))

(defun story-game-restart ()
  (interactive)
  (story-game-quit)
  (story-game-start))

