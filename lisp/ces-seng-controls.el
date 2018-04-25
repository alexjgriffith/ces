;; These functions are only used by the user player.
;; THe npcs can interact directly with the ECS.

;; to define
;; ces-seng-utils-location-valid-dir
;; ces-seng-utils-location-description
;; ces-seng-utils-entity-handle-to-id
;; ces-seng-utils-entity-description

(defun ces-seng-controls-mv (state &rest body)
  ""
  (let ((dir (car body)))
    (if dir
        (progn
          (ces-event-send-message state 'move dir)
          (if (ces-seng-utils-location-valid-dir state dir)
              (format "Moving towards the %s." dir)
            (format "%s is not a valid destination." dir)))
      (format "mv requires a destination."))))

(defun ces-seng-controls-ls (state &rest body)
  ""
  (let ((dir (car body)))
    (ces-seng-utils-location-description state dir)))

(defun ces-seng-controls-pwd (state &rest _body)
  ""  
  (ces-seng-utils-location-description state nil))


(defun ces-seng-controls-cat (state &rest body)
  ""
  (let* ((entity-handle (car body))
         (entity-id (ces-seng-utils-entity-handle-to-id entity-handle)))
    (ces-seng-utils-entity-description state entity-id)))

;; this is similar to ces-seng-new-insert but can happen while playing
;;; (defun ces-seng-controls-make
