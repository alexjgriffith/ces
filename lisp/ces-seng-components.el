;; -*- lexical-binding: t -*-

(defun ces-seng-action-components ()
  (move :scaling-stats :state-of-mind :outcomes)
  (eat :scaling-likes  :outcomes)
  (pick :scaling-skills :outcomes)
  
  ;; rendering
(defun ces-seng-option-components ()  
  (where :current-location :headed :previous-location)
  (location :floor-size :obj-soft-limit :move-speed)
  (named :sname :rname :dname :description :pronoun :att)
  (likes :hash :current-happiness)
  (stats :speed :def :att :char)
  )
