`((0 "player"
     (player)
     (named :pronoun "He" :dname "Glen" :sname "glen" :rname "glen@player.0")
     (description :text "You, but with a love for turnips and slightly more ponchy.")
     (where :location 1))
  ;; location codes generated at the start of the game range from 1-256
  (1 "location forest-glen-0"
     (location :floor-size 20 :obj-soft-limit 10)
     (named :pronoun "It" :dname "Forest" :sname "forest" :rname "forest@location.1")
     (description :text "It looks a little scary.")
     (move :modifier 0.7)
     (contains :hash #s(hash-table data (0 t 2 t)))
     (exits :hash #s(hash-table data (:north 3 :cottage 2))))
  (2 "location cottage-0"
     (location :floor-size 5 :obj-soft-limit 5)
     (named :pronoun "It" :dname "Cottage" :sname "cottage" :rname "cottage@location.2") 
     (description :text "It looks a little run down but the timber frame still stands strong.")
     (move :modifier 1.0)
     (contains :hash #s(hash-table data ((story-game-new 2 'rat) t)))
     (exits :hash #s(hash-table data (:door 1))))
  (3 ,@(story-game-new-insert 3 2 'rat)))
