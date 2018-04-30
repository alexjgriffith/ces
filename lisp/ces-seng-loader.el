;; -*- lexical-binding: t -*-

(defvar ces-seng-loader-blank-state
  (ces-initialized '(ces-seng-systems) '(ces-seng-components) (lambda() nil)))

(defvar ces-seng-loader-schedule-headings
  (mapcar 'intern '("rname" "day" "location" "dependencies" "description" "entry-text" "exit-text")))

(defvar ces-seng-loader-npc-headings
  (mapcar 'intern '("dname" "rname" "pronoun" "starting-location" "description" "hat" "shirt" "pants" "shoes" "ring" "hand" "doing" "entry-text" "exit-text" "abort-move-text" "attributes" "preferences" "interactions" )))

(defvar ces-seng-loader-clothing-headings
  (mapcar 'intern '("dname" "rname" "description" "attributes" "slot")))

(defvar ces-seng-loader-location-headings
  (mapcar 'intern '("dname" "rname" "description" "move-modifier" "exits")))


(defun ces-seng-loader-parse-day (string)
  (let* ((date (rest (split-string-and-unquote (replace-regexp-in-string "," "" string) " ")))

         (day (string-to-number (car date)))
         (hours (string-to-number (car (split-string  (cadr date) ":"))))
         (minutes (string-to-number (cadr (split-string  (cadr date) ":"))))
         (offset (if (equal "AM" (elt date 2))
                     (progn
                       (when (equal hours 12) (setq hours 0))
                       0)
                   (* 60 12) ))
         )
    (+ (* (- day 1) 24 60) (* hours 60) minutes offset)
    ))

;; load in everything as alists
;; make hash tables for locations to ids
;; locations start at 0
;; entities start at 64
;; clothing starts at 256

(defun ces-seng-loader-load-locations (filename)
  (let ((buffer (find-file-noselect filename)))
    (let ((strs (mapcar (lambda(str)
                           (ces-zip2-cons ces-seng-loader-location-headings
                                          (split-string str "\t" nil " ")))
                         (split-string (ces-loader-read-buffer buffer) "\n")))
          (int-hash (make-hash-table :test 'equal))
          (ent 1))
      (kill-buffer buffer)
      (mapc (lambda(alist)
              (puthash (cdr (assoc 'rname alist)) ent int-hash)
              (setq ent (+ ent 1)))
            strs)
      (setq ent 1)
      (mapcar (lambda(alist)
                (let ((ret (ces-seng-loader-make-location ent alist int-hash)))
                  (setq ent (+ ent 1))
                  ret))              
              strs))))

(defun ces-seng-loader-make-location (contains)
  (let ((contains contains))
   (lambda (ind alist rname-to-hash)
     (let* ((exit-alist (when
                            (cdr (assoc 'exits alist))
                            (mapcar (lambda (str)
                                 (let ((x (split-string str ":" nil " ")))
                                   (cons (intern (concat ":" (car x)))
                                          ;;(cadr x)))
                                         (gethash (cadr x) rname-to-hash))))
                                         (split-string (cdr (assoc 'exits alist)) "," nil " "))))
           (exits (make-hash-table))
           (rname (assoc 'rname alist))
           (contain (make-hash-table)))
       ;; (message "myexit:: %s" exit-alist)
       ;; (message "myexit:: %s" (gethash "town.south" rname-to-hash))
       ;; (message "myexit:: %s %s" (cdr (car exit-alist))
       ;;          (gethash (cdr (car exit-alist)) rname-to-hash))
      (maphash (lambda(key value) (when (eql value ind)
                                    (puthash key t contain)))
                 contains)
      (mapc (lambda (e)
              (let ((dir (car e))
                    (ent-id  (cdr e)))
                (puthash dir ent-id exits)))
            exit-alist)
      
      (list ind
            (concat "location " (cdr (assoc 'rname alist)))
            (ces-gen-component 'named "nil" (cdr (assoc 'rname alist))
                               (cdr (assoc 'dname alist)) "It")
            (ces-gen-component 'description (cdr (assoc 'description alist)))
            (ces-gen-component 'move (string-to-number
                                      (if (cdr (assoc 'move-modifier alist))
                                          (cdr (assoc 'move-modifier alist))
                                        "1")))
            `(contains :hash ,(or contain (make-hash-table)))
            '(location :floor-size 20 :obj-soft-limit 10)        
            (ces-gen-component 'exits  exits))))))

(defun ces-seng-loader-build (ent alists rname-to-hash fun &optional where?)
  (let* ((ent-to-loc (make-hash-table))
        (strs (mapcar (lambda(alist)
                        (let ((ret (funcall fun ent alist rname-to-hash)))
                          (when where?
                            (puthash ent (ces-utils-comp-get-value ret 'where :location)
                                     ent-to-loc))
                          (setq ent (+ ent 1))
                          ret
                          ))
                      alists)))
              (if where?
                  (list strs ent-to-loc)
                strs)))

(defun ces-seng-loader-string-check (string)
  (unless (equal string "")
    string))

(defun ces-seng-loader-get (key alist)
  (ces-seng-loader-string-check (cdr (assoc key alist))))

(defun ces-seng-loader-make-player (ind alist rname-to-hash)
  (let ( (loc-id (gethash (ces-seng-loader-get 'starting-location alist) rname-to-hash)))
    (list ind "player"
          '(player)
          (ces-gen-component 'named "nil" (cdr (assoc 'rname alist))
                             (cdr (assoc 'dname alist))
                             (cdr (assoc 'pronoun alist)))
          (ces-gen-component 'description (cdr (assoc 'description alist)))
          `(moveable :time 1
                     :start-text ,(ces-seng-loader-get 'entry-text alist) 
                     :abort-text ,(ces-seng-loader-get 'abort-move-text alist) 
                     :end-text ,(ces-seng-loader-get 'exit-text alist))
          `(equipment :hat ,(ces-seng-loader-get 'hat alist)
                      :shirt ,(gethash (ces-seng-loader-get 'shirts alist) rname-to-hash)
                      :pants ,(gethash (ces-seng-loader-get 'pants alist) rname-to-hash)
                      :shoes ,(gethash (ces-seng-loader-get 'shoes alist) rname-to-hash)
                      :ring ,(gethash (ces-seng-loader-get 'ring alist) rname-to-hash)
                      :hand ,(gethash (ces-seng-loader-get 'hand alist) rname-to-hash))
          `(doing :text ,(ces-seng-loader-get 'doing alist) :keywords nil)
          `(where :location ,loc-id)
          `(attributes :hash ,(story-game-l2s (split-string
                                               (ces-seng-loader-get 'attributes alist)
                                               "," nil " ")))               
          )))

(defun ces-seng-loader-make-clothing (ind alist rname-to-hash)
  (let ((attrs (split-string-and-unquote
                (cdr (assoc 'attributes alist)) ",")))
    (list ind (concat "clothing " (ces-seng-loader-get 'rname alist))
          (ces-gen-component 'named "nil" (cdr (assoc 'rname alist))
                             (cdr (assoc 'dname alist))
                             (cdr (assoc 'pronoun alist)))
          (ces-gen-component 'description (cdr (assoc 'description alist)))
          `(attributes :hash ,(if attrs (story-game-l2s attrs)
                                (make-hash-table :test 'equal))))
          ))


(defun ces-seng-loader-make-npc (ind alist rname-to-hash)
  (let ((prefs (make-hash-table :test 'equal))
        (loc-id (gethash (ces-seng-loader-get 'starting-location alist) rname-to-hash))
        (attrs (split-string-and-unquote
                (cdr (assoc 'attributes alist)) ",")))
    (mapcar (lambda (section)
              (let ((x (split-string section ":")))
               (puthash (car x) (cadr x) prefs)))
            (split-string  (cdr (assoc 'preferences alist)) ","))
    (list ind (concat "npc " 
                    (ces-seng-loader-get 'rname alist))
               '(npc)
               (ces-gen-component 'named "nil" (cdr (assoc 'rname alist))
                                  (cdr (assoc 'dname alist))
                                  (cdr (assoc 'pronoun alist)))
               (ces-gen-component 'description (cdr (assoc 'description alist)))
               `(equipment :hat ,(ces-seng-loader-get 'hat alist)
                           :shirt ,(gethash (ces-seng-loader-get 'shirts alist) rname-to-hash)
                           :pants ,(gethash (ces-seng-loader-get 'pants alist) rname-to-hash)
                           :shoes ,(gethash (ces-seng-loader-get 'shoes alist) rname-to-hash)
                      :ring ,(gethash (ces-seng-loader-get 'ring alist) rname-to-hash)
                      :hand ,(gethash (ces-seng-loader-get 'hand alist) rname-to-hash))
               
               `(moveable :time 1
                          :start-text ,(ces-seng-loader-get 'entry-text alist) 
                          :abort-text ,(ces-seng-loader-get 'abort-move-text alist) 
                          :end-text ,(ces-seng-loader-get 'exit-text alist))
               `(doing :text ,(ces-seng-loader-get 'doing alist) :keywords nil)
               `(where :location ,loc-id)
               `(attributes :hash ,(if attrs (story-game-l2s attrs)
                                     (make-hash-table :test 'equal)))
               `(favour :level 0 :description-hash ,(story-game-al2h '((20 . "Dislike")
                                                            (50 . "Mistrust")
                                                            (75 . "Amicable")
                                                            (95 . "Adore"))))
               `(preferences :hash , prefs)               
               )))

;; (let ((print-level nil)
;;                (print-length nil))
;;            (pp (car (ces-seng-loader-load ces-seng-loader-npc-headings "../examples/ex1/player.tab" 0))))

;; come back to this
(defun ces-seng-loader-load (headings filename ent-start)
  (let ((buffer (find-file-noselect filename)))
    (let ((strs (mapcar (lambda(str)
                          (ces-zip2-cons headings
                                         (split-string str "\t" nil " ")))
                        (split-string (ces-loader-read-buffer buffer) "\n")))
          (int-hash (make-hash-table :test 'equal))
          (ent ent-start))
      (kill-buffer buffer)
      (progn (mapc (lambda(alist)
                     (puthash (cdr (assoc 'rname alist)) ent int-hash)
                     (setq ent (+ ent 1)))
                   strs)
             (list strs int-hash)))))



;; (ces-seng-loader-load ces-seng-loader-clothing-headings "../examples/ex1/clothing.tab" 256)



;; (ces-seng-loader-load ces-seng-loader-location-headings "../examples/ex1/locations.tab" 1)

;; (ces-seng-loader-load ces-seng-loader-npc-headings "../examples/ex1/npc.tab" 70)

;; (ces-seng-loader-load ces-seng-loader-schedule-headings "../examples/ex1/sched.tab" 1024)

;;(ces-seng-loader-load ces-seng-loader-schedule-headings "../examples/ex1/player.tab" 1024)


(defun ces-seng-loader-import (loc-file player-file npc-file clothing-file sched-file)
  (ces-tick ces-seng-loader-blank-state
            (lambda()                        
              (let*
                  ((clothing
                    (ces-seng-loader-load ces-seng-loader-clothing-headings
                                          clothing-file 256))
                   (clothing-hash (cadr clothing))
                   (clothing-alist (car clothing))
                   (location (ces-seng-loader-load
                              ces-seng-loader-location-headings
                              loc-file 1))
                   (location-hash (cadr location))
                   (location-alist (car location))
                   (npc (ces-seng-loader-load ces-seng-loader-npc-headings
                                              npc-file 70))
                   (npc-hash (cadr npc))
                   (npc-alist (car npc))
                   (sched-alist (ces-seng-loader-load ces-seng-loader-schedule-headings
                                                      sched-file 1024))
                   (player (ces-seng-loader-load ces-seng-loader-npc-headings player-file 0))
                   (player-hash (cadr player))
                   (player-alist (car player))
                   (rname-to-hash (ces-set-union clothing-hash location-hash
                                                 npc-hash player-hash))
                   (player-str (ces-seng-loader-build 0 player-alist rname-to-hash 'ces-seng-loader-make-player t))
                   (player-comps (car player-str))
                   (player-locs (cadr player-str))
                   (npc-str (ces-seng-loader-build 70 npc-alist rname-to-hash 'ces-seng-loader-make-npc t))
                   (npc-comps (car npc-str))
                   (npc-locs (cadr npc-str))
                   (clothing-comps (ces-seng-loader-build 256 clothing-alist rname-to-hash 'ces-seng-loader-make-clothing))
                   (e2l (ces-set-union player-locs npc-locs)))
                (append
                 player-comps
                 (ces-seng-loader-build 1 location-alist rname-to-hash (ces-seng-loader-make-location e2l))
                 `((69 "timer" (timers :hash ,(make-hash-table))))
                 npc-comps
                 clothing-comps
                 )
                ))))
