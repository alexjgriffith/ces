(mapcar 'load-file '("../../lisp/ces.el"
                     "../../lisp/ces-utils.el" 
                     "../../lisp/ces-seng-components.el"
                     "../../lisp/ces-seng-rend.el"
                    ))

(defvar story-game-state  nil)

(defvar stroy-game-step 0)

(defcustom story-game-debug-buffer "*story-game-debug*"
  "Debug buffer of story game.")
(defcustom story-game-timeline-buffer "*story-game-debug-buffer*"
  "Timeline buffer of story game.")

(defun story-game-start ()
  (setq story-game-state (story-game))
  (story-game-loop story-game-state))

(defun story-systems ())

(defun story-components ()
  )

(defun story-setup ())

(defun story-game ()
   (ces-initialized
    '(ces-seng-systems story-systems)
    ;;'(story-systems)
    '(ces-seng-components story-components)
    'story-setup))

(defun story-game-loop (game-state)
  (story-game-debug ":: tick %s\n" story-game-step)
  (ces-event-poll story-game-state)
  (ces-system-dispatch game-state 'grow 'reproduce 'graze 'move 'viz)
  (setq game-step (+ game-step 1))
  (let ((quit (car (plist-get (ces-check-general game-state 'quit) :args))))
    (if quit
        (story-game-debug "Game quit!")
      (run-at-time (time-add (current-time) (seconds-to-time 0.333333))
                    nil ;; don't repeat
                    #'stroy-game-loop
                    stroy-game-state))
    nil))

(defun story-game-debug (str &rest args)
    (with-current-buffer (get-buffer-create story-game-debug-buffer)
      (let ((print-level nil)
            (print-length nil))        
        (save-excursion
          (goto-char (point-max))
          (insert (apply 'format str args)))))
    nil)

(setq ces-seng-debug 'story-game-debug)
