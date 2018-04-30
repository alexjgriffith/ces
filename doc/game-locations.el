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
  (1 "location cave.0"
    (named :sname "nil" :rname "cave.0" :dname "Cave" :pronoun "It")
    (description :text "A dank damp cave with a semblance of designated places for things. You likely aren’t the First to live here.")
    (move :modifier 2)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  (0 t 67 t 68 t)))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               ("east:" 2 "south:" 14))))
 (2 "location field.of.sheep"
    (named :sname "nil" :rname "field.of.sheep" :dname "Field of Sheep" :pronoun "It")
    (description :text ": A field with short yellow grass and a few old sheep. The air smells fresh and free.")
    (move :modifier 1)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               ("east:" 3 "south:" 15 "west:" 1))))
 (3 "location turnip.patch"
    (named :sname "nil" :rname "turnip.patch" :dname "Turnip Patch" :pronoun "It")
    (description :text "A small area of tilled dirt with a knee high fence around it. No gate but the patch does seem to be abundant with turnips.")
    (move :modifier 1)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               ("east:" 4 "south:" 16 "west:" 2))))
 (4 "location town.north"
    (named :sname "nil" :rname "town.north" :dname "North side of Town" :pronoun "It")
    (description :text "A large square designated by fine cobblestone with a well at the center. On the north west corner is the Grocer, the North East Corner is the Blacksmith, the South west is the Tavern, the South east corner is the Tailor.")
    (move :modifier 1)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               ("south:" 17 "west:" 3 "tavern:" 5 "blacksmith-smithy:" 12 "grocery-store:" 10 "tailor-shop:" 8))))
 (5 "location tavern.0"
    (named :sname "nil" :rname "tavern.0" :dname "Tavern" :pronoun "It")
    (description :text "A low lit tavern filled with the smell of old dried beer. The bar top is old and scratched and the floor has obvious warps but it inviting enough.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               ("upstairs" nil "hatch" nil "front" nil))))
 (6 "location tavern.basement"
    (named :sname "nil" :rname "tavern.basement" :dname "Tavern Basement" :pronoun "It")
    (description :text "One small candle on the wall lights the room. Large casks of ale drip intermittently. several rats scurry about.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               ("ceiling" nil))))
 (7 "location tavern.bedroom"
    (named :sname "nil" :rname "tavern.bedroom" :dname "Tavern Bedroom" :pronoun "It")
    (description :text "A small bedroom in what was likely intended to be a large storage closet. A small single bed sits in one corner with a small bedside table. At the foot of the bed a large chest.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               ("door:" 5))))
 (8 "location tailor.0"
    (named :sname "nil" :rname "tailor.0" :dname "Tailor Shop" :pronoun "It")
    (description :text "The store is full of mannequins almost all naked. Behind a large desk empty fabric spools can be seen. There is the faint smell of alcohol but not a bottle in sight.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               ("back" nil "front" nil))))
 (9 "location tailor.bedroom"
    (named :sname "nil" :rname "tailor.bedroom" :dname "Tailor Bedroom" :pronoun "It")
    (description :text "A plain bedroom with a double bed in the center and a dresser in the corner. Clothes are sprawled all over.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               ("door:" 8))))
 (10 "location grocer.0"
     (named :sname "nil" :rname "grocer.0" :dname "Grocery Store" :pronoun "It")
     (description :text "Every surface of the room is pristine. Each barrel and stand made of quality wood and solid construction. The apples and turnips shine in the light as if each one was hand washed before put out for sale.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("back" nil "front" nil))))
 (11 "location grocer.bedroom"
     (named :sname "nil" :rname "grocer.bedroom" :dname "Grocer Bedroom" :pronoun "It")
     (description :text "A very neat and tidy bedroom. Everything has its place. The bed is made and the dresser is topped with brushes and other such tools and accessories.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("door:" 10))))
 (12 "location blacksmith.0"
     (named :sname "nil" :rname "blacksmith.0" :dname "Blacksmith Smithy" :pronoun "It")
     (description :text "A dark room covered in soot with orange light pouring from large furnace. A large anvil sits in the center of the room.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("back" nil "front" nil))))
 (13 "location blacksmith.bedroom"
     (named :sname "nil" :rname "blacksmith.bedroom" :dname "Blacksmith Bedroom" :pronoun "It")
     (description :text "A rickety old bed sits in the small room. A chest sits at the foot of the bed, clothes hanging out. Just peeking out from under the bed is an old pot.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("door:" 12))))
 (14 "location mine.0"
     (named :sname "nil" :rname "mine.0" :dname "Mine" :pronoun "It")
     (description :text "More of a cave than a mine but the walls do seem to be abundant with ore veins thought the kind is unclear.")
     (move :modifier 2)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("north:" 1 "east:" 15))))
 (15 "location orchard.0"
     (named :sname "nil" :rname "orchard.0" :dname "Orchard" :pronoun "It")
     (description :text "A small orchard, only few rows of trees. All apple trees.")
     (move :modifier 1)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("north:" 2 "west:" 14 "east:" 16))))
 (16 "location graveyard.0"
     (named :sname "nil" :rname "graveyard.0" :dname "Graveyard" :pronoun "It")
     (description :text "Rows of tombstones dating back centuries. They seem well taken care of. Many have flowers against them.")
     (move :modifier 1)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("north:" 3 "west:" 15 "east:" 17))))
 (17 "location town.south"
     (named :sname "nil" :rname "town.south" :dname "South side of Town" :pronoun "It")
     (description :text ": A haphazard use of space. The cobblestone is old and in need of resetting. There is a small clock that seems to be broken and an empty flower bed at its base. in the North west there is the Temple, in North east the Jail, in the west Jacob’s Hovel, in the east Fredrick’s hut, in the South west the Apothecary, in the South east the Library.")
     (move :modifier 0)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("north:" 4 "west:" 16 "temple:" 18 "apothecary-shop:" 21 "jail:" 19 "library:" 23 "hovel:" 25 "hut:" 24))))
 (18 "location temple.0"
     (named :sname "nil" :rname "temple.0" :dname "Temple" :pronoun "It")
     (description :text "A large high ceiling room with 6 alters spread eavenly around the edge of the room. One for each of the spirit.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("Door:" 17))))
 (19 "location jail.0"
     (named :sname "nil" :rname "jail.0" :dname "Jail" :pronoun "It")
     (description :text "An open room with one desk for the law keeper to sit at.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("Front" nil "Iron" nil))))
 (20 "location jail.cell"
     (named :sname "nil" :rname "jail.cell" :dname "Jail Cell" :pronoun "It")
     (description :text "A small room with blanket piled in the corner and on large iron door ominously waiting to be opened for freedom or death.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("Iron" nil))))
 (21 "location apothecary.0"
     (named :sname "nil" :rname "apothecary.0" :dname "Apothecary Shop" :pronoun "It")
     (description :text "A small shop front. The room is stuffed with flowers and clipping and and the smell is overwhelming.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("Front" nil "back" nil))))
 (22 "location apothecary.bedroom"
     (named :sname "nil" :rname "apothecary.bedroom" :dname "Apothecary Bedroom" :pronoun "It")
     (description :text "Strangely sparse. There is a small bed and Statue of the Spirit of Vengeance.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("door:" 21))))
 (23 "location library.0"
     (named :sname "nil" :rname "library.0" :dname "Library" :pronoun "It")
     (description :text "A very large room full of book shelves. The front desk seems to be surrounded by a musky odur.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("door:" 23))))
 (24 "location fredricks.hut"
     (named :sname "nil" :rname "fredricks.hut" :dname "Hut" :pronoun "It")
     (description :text "A small hut with all the amenities, a wood stove, a dresser, a bed.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("Door:" 17))))
 (25 "location jacobs.hovel"
     (named :sname "nil" :rname "jacobs.hovel" :dname "Hovel" :pronoun "It")
     (description :text "Barely describable as a structure one wall looks like it might fall in at any moment. Said wall seem to gain most of its support from a small bed. Some clothes hang from the ceiling.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                ("Curtain:" 17)))))
