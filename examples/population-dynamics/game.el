;; -*- lexical-binding: t -*-

;; Sample application

(require 'ces)

(defun game-loop (step)
   (call-system 'grow)
   (call-system 'reproduce)
   (call-system 'graze)
   (call-system 'move)
  (with-current-buffer (get-buffer-create "*game-log*")
    (goto-char (point-max))
    (insert (format "step = %s creatrures = %s\n" step (call-system 'viz))))
  ;;(c2e-f 'plant)
  ;;(pp (components-f (e2c 3)))
  ;;(message (format "ents %s" (length (hash-table-keys (c2e-f 'plant)))))
  )

(mapcar 'load-file '("system.el" "components.el" "setup.el"))

(defvar game-state  (game))

(with-current-buffer (get-buffer-create "*game-log*" ) (delete-region (point-min)
                                                                      (point-max)))

(let ((x 0))
  (while (< x 1000) (setq x (+ x 1))
         (message (format "%s" x))
         (tick game-state (lambda() (game-loop x)))))


(tick game-state (lambda() (game-loop  0)))



(tick game-state (lambda()
                   (render 0)
                   (let (( print-level nil)
                         (print-length nil))
                     (format "%s" (gvec-to-vector entities)))
                   ;;(move-direction 0 13 "east")
                   (move-direction-random 13)
                   (move-direction-random 13)
                   (move-direction-random 13)
                   (components-f (e2c-f 13))
                   ;;(comp-get-value (components-f (e2c-f 1)) 'contains :hash)
                   ;;(gethash "east" (comp-get-value (components-f (e2c-f 0)) 'exits :hash))
                   ))


(defun trial-run ()
  (interactive)
  (let ((game-state (game)))
    (with-current-buffer (get-buffer-create "*game-log*" ) (delete-region (point-min)
                                                                          (point-max)))
    (let ((x 0))
      (while (< x 3000) (setq x (+ x 1))
             (tick game-state (lambda() (game-loop x)))))))
