`((0 "player"
     (name :obj-name player :diplay-name "Glen" :short-name "glen")
     (description :text "You, but with a love for turnips and slightly more ponchy.")
     (fitness :likes #s(hash-table data (turnips t emacs t))
              :dislikes #s(hash-table data (vim t)))
     (contains :hash #s(hash-table data ()))
     (equipment :legs ,(story-game-new 'jeans
                                       :where 0
                                       :attributes '(blue acid-wash))
                :hat nil
                :shirt ,(story-game-new 'cotton-shirt :where 0 :attributes '(blue))
                :shoes ,(story-game-new 'adidas :where 0 :attributes '(white))
                :gloves nill
                :lhand nill :rhand nil :ring nil)
     (attributes :hash ,(ces-set-from-list '(player human)))
     (move-description :into-end "you enter"
                       :exit-end "you've left"
                       :into-start "you move towards"
                       :exit-start "you move towards")
     (look-description :around "you look arround"
                       :self "you pull out a mirror and look at yourself"
                       :at "you look at")
     (stats :hp 100 :en 100 :str 7 :con 7 :dex 7 :weight 80))
  ;; location codes generated at the start of the game range from 1-256
  (1 "location forest-glen-0"
     (name :obj-name forest-glen-0 :display-name "The forest glen" :short-name "forest")
     (attributes :hash ,(ces-set-from-list  '(outdoors forest dark)))
     (description :text "It looks a little scary.")
     (move :modifier 0.7 )
     (contains :hash #s(hash-table data (0 t 2 t)))
     (exits :hash #s(hash-table data (:north 3 :cottage 2)))
     (location :timer #s(hash-table)))
  (2 "location cottage-0"
     (name :obj-name forest-glen-0 :display-name "Cottage" :short-name "cottage")
     (attributes :hash ,(ces-set-from-list '(indoors cottage poor-repair)))
     (description :text "It looks a little run down but the timber frame still stands strong.")
     (move :modifier 1.0 )
     (contains :hash #s(hash-table data (257 t))) ;; rats
     (exits :hash #s(hash-table data (:door 1)))
     (location :timer #s(hash-table)))
  (3 "location field-0"
     (name :obj-name feild-0 :display-name "A farm feild" :short-name "feild")
     (attributes :hash  ,(ces-set-from-list '(outdoors field overgrown)))
     (description :text "It looks abandoned.")
     (move :modifier 1.0 )
     (contains :hash #s(hash-table data (259 t
                                             ,(story-game-new 'tomato-plant
                                                              :where 3 :stage 3)
                                             t
                                             ,(story-game-new 'tomato-plant
                                                              :where 3 :stage 2)
                                             t
                                             ,(story-game-new 'weed :where 3) t
                                             ,(story-game-new 'weed :where 3) t
                                             ,(story-game-new 'weed :where 3) t
                                             ,(story-game-new 'weed :where 3) t
                                             ,(story-game-new 'weed :where 3) t
                                             ,(story-game-new 'weed :where 3) t
                                             ,(story-game-new 'weed :where 3) t
                                             ,(story-game-new 'weed :where 3) t
                                         )))
     (exits :hash #s(hash-table data (:south 1)))
     (location :timer #s(hash-table data (,@(ces-seng-timer-gen 'produce 259)
                                          ,@(ces-seng-timer-gen 'stage 259)))))
  ;; Object codes, other than player start at 257 and end by 2049, this is an arbitrary end point
  (256 "rat"
       (name :obj-name rat :display-name "Rat" :short-name "Rat")
       (description :text "A furry little rodent that will eat you if you're not careful.")
       (attributes :hash  ,(ces-set-from-list '(rat furry rodent)))
       (stage :step 1 :next (100 200) :stages ((20 30) (200 400)))
       (dies :at 2)
       (produce :at 1 :time nil :what 'rat-meat :tonly t)
       (contains :hash #s(hash-table data (2050 . t)))
       (where :location 2)
       (fitness :likes ,(story-game-add-global 'rat-likes)
                :dislikes ,(story-game-add-global 'rat-dislikes))
       (move-description :into-end "the rat scurries into"
                         :exit-start "the rat scurries towards"
                         :exit-start "the rat has left the"
                         :into-start "the rat scurries towards"))
  (257 ,(story-game-new-insert 'rat 2 :contains 'rat-meat))
  (258 ,(story-game-new-insert 'rat 2 :contains 'rat-meat))
  (259 "tomato plant"
       (name :obj-name tomato-plant :display-name "Tomato plant" :short-name "tomato-p")
       (description :text "A tomato plant. Has 3 growth stages. Once harvested it will contiue to produce tomatoes untill the end of the season")
       (attributes :hash ,(ces-set-from-list '(plant tomato red)))
       (stage :step 1 :next (100 200) :stages ((20 30) (100 200) (200 400)))
       (dies :at 3)
       (produce :at 2 :time (80 120) :what 'tomato :tonly nil)
       (fitness :likes ,(ces-set-from-list '(field bright water))
                :dislikes ,(ces-set-from-list '(forest mountain village dark weed)))
       (contains :hash #s(hash-table data (2051 t
                                           (story-game-new 'tomato :where 259) t))))
  ;; 2050 + are held objects or likes (These objects do not contain others)
  (2050 "rat meat"
        (name :obj-name rat-meat :display-name "Rat meat" :short-name "meat")
        (effects :stat :en :by 10)
        (description "Looks grose, tastes grose and may make you sick, but at least its food.")
        (attributes :hash ,(ces-set-from-list '(food meat grose rat))))
  (2050 "tomato"
        (name :obj-name tomato :display-name "Tomato" :short-name "tomato")
        (effects :stat :en :by 10)
        (description "A bright red tomato, very tasty.")
        (attributes :hash ,(ces-set-from-list '(food fruit tomato red))))
  )

