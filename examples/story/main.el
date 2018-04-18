(require 'subr-x)

(mapcar 'load-file '("../../lisp/ces.el" "../../lisp/event.el"
                     "../../lisp/ces-seng-components.el"
                     "../../lisp/ces-seng-rend.el"
                    "untils.el" "system.el" "components.el" "setup.el"))

(defvar game-state  (game))
(defvar game-step 0)

(defun game-loop (game-state)
  (game-debug ":: tick %s\n" game-step)
  (ces-event-poll game-state)
  (ces-system-dispatch game-state 'grow 'reproduce 'graze 'move 'viz)
  (setq game-step (+ game-step 1))
  (let ((quit (car (plist-get (ces-check-general game-state 'quit) :args))))
    (if quit
        (game-debug "Game quit!")
      (run-at-time (time-add (current-time) (seconds-to-time 0.333333))
                    nil ;; don't repeat
                    #'game-loop
                    game-state))
      nil))
