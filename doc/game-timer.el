`((0 "player"
     (player)
     (named :pronoun "He" :dname "Glen" :sname "glen" :rname "glen@player.0")
     (description :text "You, but with a love for turnips and slightly more ponchy.")
     (equipment :head nil :shirt ,(story-game-new nil 'shirt)
                :pants ,(story-game-new nil 'pants) :shoes nil :ring nil :hand nil)
     (moveable :time 1 :start-text "begin to move towards"
               :abort-text "stop moving towards"
               :end-text "have moved to")
     (attributes :hash ,(story-game-l2s '("cat"
                                          "has killed bill")))
     (where :location 1))
  ;; location codes generated at the start of the game range from 1-256
  (1 "location forest-glen-0"
     (location :floor-size 20 :obj-soft-limit 10)
     (named :pronoun "It" :dname "Forest" :sname "forest" :rname "forest@location.1")
     (description :text "It looks a little scary.")
     (move :modifier 0.7)
     (contains :hash ,(story-game-l2s '(0 2 67 68)))
     (exits :hash ,(story-game-al2h '((:north . 3) (:cottage . 2)))))
  (2 "location cottage-0"
     (location :floor-size 5 :obj-soft-limit 5)
     (named :pronoun "It" :dname "Cottage" :sname "cottage" :rname "cottage@location.2") 
     (description :text "It looks a little run down but the timber frame still stands strong.")
     (move :modifier 1.0)
     (contains :hash #s(hash-table))
     (exits :hash #s(hash-table data (:door 1))))
  (3 "location forest-glen-2"
     (location :floor-size 20 :obj-soft-limit 10)
     (named :pronoun "It" :dname "Forest" :sname "forest" :rname "forest@location.2")
     (description :text "It looks a little scary.")
     (move :modifier 0.7)
     (contains :hash ,(story-game-l2s '()))
     (exits :hash ,(story-game-al2h '((:south . 1)))))
  (65 ,@(story-game-new-insert 65 2 'rat))
  (66 ,@(story-game-new-insert 66 2 'rat))
  (67 "micheal"
     (npc)
     (named :pronoun "He" :dname "Micheal" :sname "micheal" :rname "micheal@player.1")
     (description :text "A pretty cool cat, for a human.")
     (doing :text "Hunting bill." :keywords ,(story-game-al2h '(("bill" 6))))
     (favour :level 0 :description-hash ,(story-game-al2h '((20 . "Dislike")
                                                            (50 . "Mistrust")
                                                            (75 . "Amicable")
                                                            (95 . "Adore"))))
     (preferences :hash ,(story-game-al2h '(("blue pants" . 10)
                                            ("has killed bill" . 20)
                                            ("cat" . 30)
                                            ("human" . -5)
                                            ("doesn't know micheal" . -20))))
     (where :location 1))
  (68 "bill"
     (npc)
     (named :pronoun "He" :dname "Bill" :sname "bill" :rname "bill@npc.2")
     (description :text "A pretty cool cat, for a human.")
     (doing :text "Minding his own business." :keywords nil)
     (favour :level 0 :description-hash ,(story-game-al2h '((20 . "Dislike")
                                                            (50 . "Mistrust")
                                                            (75 . "Amicable")
                                                            (95 . "Adore"))))     
     (preferences :hash ,(story-game-al2h '(("cool" . 10)
                                            ("human" . 20)
                                            ("t-shirt" . -10))))
     (where :location 1))
  (69 "timer"      
      (timers :hash
              ,(story-game-al2h
                `(((,(float-time (time-add (current-time) (seconds-to-time 1))) move  0) .
                   (:task move
                    :args (0 2)
                    :start-text "The player begins moving towards the door."
                    :abort-text "The player cancled their move to the door."
                    :end-text "The player leaves the building."
                    :start ,(current-time)
                    :end ,(time-add (current-time) (seconds-to-time 15))
                    :durration 15))))))
  )
