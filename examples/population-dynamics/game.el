 ;; -*- lexical-binding: t -*-

;; Sample application

;; (require 'ces)

(require 'subr-x)

(mapcar 'load-file '("../../lisp/ces.el" "../../lisp/event.el"
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


(defun game-render (game-state)  
  (ces-check-general game-state 'render))

(defun game-quit (game-state)
  (ces-event-send-message game-state 'quit t))

(defun game-list-exits (game-state)  
  (ces-check-general game-state 'exits))

(defun game-move (game-state dir)
  (ces-event-send-message game-state 'move dir))

(game-render game-state)

(game-move game-state "south")

(game-list-exits game-state)


(ces-call-function game-state 'init-systems)

(game-loop game-state)








(defun trial-run ()
  (interactive)
  (let ((game-state (game)))
    (with-current-buffer (get-buffer-create "*game-log*" ) (delete-region (point-min)
                                                                          (point-max)))
    (let ((x 0))
      (while (< x 3000) (setq x (+ x 1))
             (tick game-state (lambda() (game-loop x)))))))
