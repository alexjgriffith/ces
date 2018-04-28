;; -*- lexical-binding: t -*-

(defun ces-seng-components ()
  (ces-new-component! task-timer :task :args :start :end :duration)
  (ces-new-component! task :start-text :completion-text :abort-text
                      :hours :function)
  (ces-new-component! location)
  (ces-new-component! player)
  (ces-new-component! where :location)
  (ces-new-component! location :floor-size :obj-soft-limit)
  (ces-new-component! move :modifier)
  (ces-new-component! named :sname :rname :dname :pronoun)
  (ces-new-component! likes :hash :current-happiness)
  (ces-new-component! exits :hash)
  (ces-new-component! timers :hash)
  (ces-new-component! description :text)
  (ces-new-component! contains :hash))
