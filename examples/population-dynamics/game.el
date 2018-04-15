;; -*- lexical-binding: t -*-

;; Sample application

(require 'ces)

(mapcar 'load-file '("system.el" "components.el" "setup.el"))

(defvar game-state  (game))

(with-current-buffer (get-buffer-create "*game-log*" ) (delete-region (point-min)
                                                                      (point-max)))

(let ((x 0))
  (while (< x 1000) (setq x (+ x 1))
         (tick game-state (lambda() (game-loop x)))))


(tick game-state (lambda() (game-loop  0)))



(tick game-state (lambda()
                   (render 0)))
