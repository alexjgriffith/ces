;; -*- lexical-binding: t -*-

(defun ces-seng-components ()
  (ces-new-component! attributes :hash)
  (ces-new-component! task :task :args :start-text :abort-text :end-text
                      :start :end :duration)
  (ces-new-component! timer :hash)
  (ces-new-component! location)
  (ces-new-component! player)
  (ces-new-component! where :location)
  (ces-new-component! location :floor-size :obj-soft-limit)
  (ces-new-component! move :modifier)
  (ces-new-component! moveable :time :start-text :abort-text :end-text)
  (ces-new-component! named :sname :rname :dname :pronoun)
  (ces-new-component! likes :hash :current-happiness)
  (ces-new-component! exits :hash)
  (ces-new-component! timers :hash)
  (ces-new-component! description :text)
  (ces-new-component! doing :text :keywords)
  (ces-new-component! contains :hash)
  (ces-new-component! preferences :hash)
  (ces-new-component! favour :level :description-hash)
  (ces-new-component! equipment :head :shirt :pants :shoes :ring :hand)
  (ces-new-component! interactions :hash))
