;; -*- lexical-binding: t -*-

(setq lexical-binding t)

(defun ces-event-send-message (state type &rest cargs)
  (tick state (lambda() (push (list 'player (float-time) type cargs)
                              message-queue))))

(defun ces-event-poll (state)
  (tick state
        (lambda ()
          (let* ((mq2 (reverse message-queue))
                 (message (pop mq2)))
            (while message
              (let ((uid (car message))
                    (time-sent (cadr message))
                    (type (caddr message))
                    (args (cadddr message)))
                (when (equal uid 'player)
                  (insert-general-into-generals type (cons time-sent args)))
                (setq message (pop mq2))))
            (setq message-queue nil)))))

(defun ces-system-dispatch (state &rest systems)
  (tick state
        (lambda () (mapc 'call-system systems))))
