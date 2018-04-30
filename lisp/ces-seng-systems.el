;; -*- lexical-binding: t -*-

(defun ces-seng-systems-put-in-location (loc-id ent-id)
  (funcall ces-seng-debug (format "locid %s" loc-id))
  (puthash ent-id t (comp-get-value (ces-components-f (ces-e2c-f loc-id))
                                    'contains :hash))
  ent-id)

(defun ces-seng-systems-remove-from-location (loc-id ent-id)
  (remhash ent-id (plist-get (cdr (assoc 'contains (ces-components-f (e2c-f loc-id))))
                             :hash))
  loc-id)

(defun ces-seng-systems-move-direction (loc-id1 ent-id direction)
  (let* ((ent-plist (ces-utils-comp-get-plist (ces-components-f (ces-e2c-f ent-id)) 'where))
         (loc-id2 (gethash direction
                           (ces-utils-comp-get-value
                            (ces-components-f (ces-e2c-f loc-id1))
                                           'exits :hash))))
    (plist-put ent-plist :location loc-id2)
    (ces-seng-systems-remove-from-location loc-id1 ent-id )
    (ces-seng-systems-put-in-location loc-id2 ent-id))
  ent-id)

(defun ces-seng-systems-add-timer (ent task args duration
                                       start-text abort-text end-text
                                       &optional start-time)
  (let* ((hash (ces-components-f (ces-e2c-f (ces-generals-f 'timer-ent))))
         (start-time (or start-time (current-time)))
         (end-time (time-add start-time (seconds-to-time duration)))
         (key `(,(float-time end-time)
                ,task  ,ent))
         (value (ces-gen-component 'task 'move args
                    start-text abort-text end-text                    
                    start-time end-time duration)))
    (ces-seng-system-signal-message `(:body ,start-text
                                            :ent-id ,ent
                                            :when ,start-time))
   (ces-utils-comp-put-hash-value hash 'timers :hash key (cdr value))))

(defun ces-seng-systems ()
  (ces-new-system!
   player-move
   () (player-move)
   (when player-move
     (let ((time (plist-get player-move :time))
           (args (plist-get player-move :args)))
       ;;(story-game-debug "move: %s\n" args)       
       (apply 'ces-seng-systems-add-timer `(,@(car args) ,time))
       ;;(ces-serialize-human story-game-state "*temp*")
       (ces-remove-general-from-generals 'player-move)))
   )
  (ces-new-system!
   calculate-favour
   (npc) (player-location player-ent)
   (when (and player-location npc)     
     (let ((members (ces-utils-comp-get-value-e player-location
                                                'contains :hash))
           (player-attributes (ces-set-union-2
                               (ces-seng-utils-get-equipment-attributes-union player-ent)
                               (ces-utils-comp-get-value-e player-ent
                                                           'attributes :hash))))
       (mapc (lambda (n)
               (let* ((prefs (ces-utils-comp-get-value (cdr n)
                                                       'preferences :hash))
                      (values (hash-table-values
                               (ces-utils-set-filter prefs player-attributes)))
                      (favour (min 100 (max 0 (apply '+ values)))))
                 (ces-utils-comp-put-value (cdr n) 'favour :level favour)))
             ;; (message "favour %s: %s \n %s " (car n) values favour)))
           (ces-join npc members)))))
  (ces-new-system!
   check-timers
   () (timer-ent)
   (let* ((hash (ces-utils-comp-get-value-e timer-ent 'timers :hash))
          (t-time (current-time))
          (time (float-time t-time)))
     (maphash (lambda (complete value)
              (when (< (car complete) time)
                (let* ((value value)
                       (task (plist-get value :task))
                       (args (plist-get value :args))
                       (text (plist-get value :end-text))
                       (abort (plist-get value :abort-text))
                       (tfun (gethash task ces-seng-systems-tasks)))
                  ;; if tfun matches evaluate function with args and send a message
                  ;; if no match send a failure message
                  (if tfun
                      (progn
                        (apply tfun args)
                        (remhash complete hash)                        
                        (when text
                         (ces-seng-system-signal-message `(:body ,(concat "COMPLETE: " text)
                                                                :ent-id ,(elt complete 2)
                                                                :when ,t-time))))
                    (remhash complete hash)
                    (when abort
                      (ces-seng-system-signal-message `(:body ,(concat "ABORT: " abort)
                                                              :ent-id ,(elt complete 2)
                                                              :when ,t-time)))))))
              hash)
     )
   )
  )


(defun ces-seng-systems-move-aux (ent newloc)
  (let ((oldloc (ces-utils-comp-get-value-e ent 'where :location))
        (player (eql (ces-generals-f 'player-ent) ent)))
    (when player
      (ces-insert-general-into-generals 'player-location newloc))
    (ces-seng-utils-move ent oldloc newloc)))

(defvar ces-seng-systems-tasks #s(hash-table data (move ces-seng-systems-move-aux)))

(defun ces-seng-system-signal-message (message)
  (let ((message-buffer "*ces-seng-rend-test*"))
    (with-current-buffer (get-buffer-create message-buffer)
      (ces-seng-rend-mode)
      (ces-seng-rend-render-message message message-buffer))))
