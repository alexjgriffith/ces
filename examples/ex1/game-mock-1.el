'((0 "player"
    (player)
    (named :sname "nil" :rname "glen.0" :dname "Glen" :pronoun "He")
    (description :text "looks like you in the mirror, but something just a little off, or maybe a lot off.")
    (equipment :hat nil :shirt nil :pants 268 :shoes nil :ring 270 :hand nil)
    (where :location 1)
    (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                    ("funny looking" t "he really likes hats" t "blue eyes" t "black hair" t))))
 (1 "location cave.0"
    (named :sname "nil" :rname "cave.0" :dname "Cave" :pronoun "It")
    (description :text "A dank damp cave with a semblance of designated places for things. You likely aren’t the First to live here.")
    (move :modifier 2)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               (:east nil :south nil))))
 (2 "location field.of.sheep"
    (named :sname "nil" :rname "field.of.sheep" :dname "Field of Sheep" :pronoun "It")
    (description :text ": A field with short yellow grass and a few old sheep. The air smells fresh and free.")
    (move :modifier 1)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               (:east nil :south nil :west nil))))
 (3 "location turnip.patch"
    (named :sname "nil" :rname "turnip.patch" :dname "Turnip Patch" :pronoun "It")
    (description :text "A small area of tilled dirt with a knee high fence around it. No gate but the patch does seem to be abundant with turnips.")
    (move :modifier 1)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               (:east nil :south nil :\ west nil))))
 (4 "location town.north"
    (named :sname "nil" :rname "town.north" :dname "North side of Town" :pronoun "It")
    (description :text "A large square designated by fine cobblestone with a well at the center.")
    (move :modifier 1)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               (:south nil :\ west nil :tavern nil :blacksmith-smithy nil :grocery-store nil :tailor-shop nil))))
 (5 "location tavern.0"
    (named :sname "nil" :rname "tavern.0" :dname "Tavern" :pronoun "It")
    (description :text "A low lit tavern filled with the smell of old dried beer. The bar top is old and scratched and the floor has obvious warps but it inviting enough.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               (:upstairs-door nil :hatch-behind-the-bar nil :front-door nil))))
 (6 "location tavern.basement"
    (named :sname "nil" :rname "tavern.basement" :dname "Tavern Basement" :pronoun "It")
    (description :text "One small candle on the wall lights the room. Large casks of ale drip intermittently. several rats scurry about.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               (:ceiling-hatch nil))))
 (7 "location tavern.bedroom"
    (named :sname "nil" :rname "tavern.bedroom" :dname "Tavern Bedroom" :pronoun "It")
    (description :text "A small bedroom in what was likely intended to be a large storage closet. A small single bed sits in one corner with a small bedside table. At the foot of the bed a large chest.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               (:door nil))))
 (8 "location tailor.0"
    (named :sname "nil" :rname "tailor.0" :dname "Tailor Shop" :pronoun "It")
    (description :text "The store is full of mannequins almost all naked. Behind a large desk empty fabric spools can be seen. There is the faint smell of alcohol but not a bottle in sight.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               (:back-door nil :front-door nil))))
 (9 "location tailor.bedroom"
    (named :sname "nil" :rname "tailor.bedroom" :dname "Tailor Bedroom" :pronoun "It")
    (description :text "A plain bedroom with a double bed in the center and a dresser in the corner. Clothes are sprawled all over.")
    (move :modifier 0.5)
    (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                  ()))
    (location :floor-size 20 :obj-soft-limit 10)
    (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                               (:door nil))))
 (10 "location grocer.0"
     (named :sname "nil" :rname "grocer.0" :dname "Grocery Store" :pronoun "It")
     (description :text "Every surface of the room is pristine. Each barrel and stand made of quality wood and solid construction. The apples and turnips shine in the light as if each one was hand washed before put out for sale.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:back-door nil :front-door nil))))
 (11 "location grocer.bedroom"
     (named :sname "nil" :rname "grocer.bedroom" :dname "Grocer Bedroom" :pronoun "It")
     (description :text "A very neat and tidy bedroom. Everything has its place. The bed is made and the dresser is topped with brushes and other such tools and accessories.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:door nil))))
 (12 "location blacksmith.0"
     (named :sname "nil" :rname "blacksmith.0" :dname "Blacksmith Smithy" :pronoun "It")
     (description :text "A dark room covered in soot with orange light pouring from large furnace. A large anvil sits in the center of the room.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:back-door nil :\ front-door nil))))
 (13 "location blacksmith.bedroom"
     (named :sname "nil" :rname "blacksmith.bedroom" :dname "Blacksmith Bedroom" :pronoun "It")
     (description :text "A rickety old bed sits in the small room. A chest sits at the foot of the bed, clothes hanging out. Just peeking out from under the bed is an old pot.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:door nil))))
 (14 "location mine.0"
     (named :sname "nil" :rname "mine.0" :dname "Mine" :pronoun "It")
     (description :text "More of a cave than a mine but the walls do seem to be abundant with ore veins thought the kind is unclear.")
     (move :modifier 2)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:north nil :east nil))))
 (15 "location orchard.0"
     (named :sname "nil" :rname "orchard.0" :dname "Orchard" :pronoun "It")
     (description :text "A small orchard, only few rows of trees. All apple trees.")
     (move :modifier 1)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:north nil :west nil :east nil))))
 (16 "location graveyard.0"
     (named :sname "nil" :rname "graveyard.0" :dname "Graveyard" :pronoun "It")
     (description :text "Rows of tombstones dating back centuries. They seem well taken care of. Many have flowers against them.")
     (move :modifier 1)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:north nil :west nil :east nil))))
 (17 "location town.south"
     (named :sname "nil" :rname "town.south" :dname "South side of Town" :pronoun "It")
     (description :text ": A haphazard use of space. The cobblestone is old and in need of resetting. There is a small clock that seems to be broken and an empty flower bed at its base.")
     (move :modifier 0)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:north nil :west nil :temple nil :apothecary-shop nil :jail nil :library nil :hovel nil :hut nil))))
 (18 "location temple.0"
     (named :sname "nil" :rname "temple.0" :dname "Temple" :pronoun "It")
     (description :text "A large high ceiling room with 6 alters spread eavenly around the edge of the room. One for each of the spirit.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:Door nil))))
 (19 "location jail.0"
     (named :sname "nil" :rname "jail.0" :dname "Jail" :pronoun "It")
     (description :text "An open room with one desk for the law keeper to sit at.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:Front-door nil :Iron-door nil))))
 (20 "location jail.cell"
     (named :sname "nil" :rname "jail.cell" :dname "Jail Cell" :pronoun "It")
     (description :text "A small room with blanket piled in the corner and on large iron door ominously waiting to be opened for freedom or death.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:Iron-door nil))))
 (21 "location apothecary.0"
     (named :sname "nil" :rname "apothecary.0" :dname "Apothecary Shop" :pronoun "It")
     (description :text "A small shop front. The room is stuffed with flowers and clipping and and the smell is overwhelming.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:Front-door nil :back-door nil))))
 (22 "location apothecary.bedroom"
     (named :sname "nil" :rname "apothecary.bedroom" :dname "Apothecary Bedroom" :pronoun "It")
     (description :text "Strangely sparse. There is a small bed and Statue of the Spirit of Vengeance.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:Door nil))))
 (23 "location library.0"
     (named :sname "nil" :rname "library.0" :dname "Library" :pronoun "It")
     (description :text "A very large room full of book shelves. The front desk seems to be surrounded by a musky odur.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:Door nil))))
 (24 "location fredricks.hut"
     (named :sname "nil" :rname "fredricks.hut" :dname "Hut" :pronoun "It")
     (description :text "A small hut with all the amenities, a wood stove, a dresser, a bed.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:Door nil))))
 (25 "location jacobs.hovel"
     (named :sname "nil" :rname "jacobs.hovel" :dname "Hovel" :pronoun "It")
     (description :text "Barely describable as a structure one wall looks like it might fall in at any moment. Said wall seem to gain most of its support from a small bed. Some clothes hang from the ceiling.")
     (move :modifier 0.5)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (:Curtain nil))))
 (26 "location cloud.birth"
     (named :sname "nil" :rname "cloud.birth" :dname "Cloud Birth" :pronoun "It")
     (description :text "An indescribable space. Its unclear what is up or down, bright or dark. Your senses fail you , but you are surrounded by the Spirits.")
     (move :modifier 0)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (nil nil))))
 (27 "location forest.0"
     (named :sname "nil" :rname "forest.0" :dname "lost forest" :pronoun "It")
     (description :text "where ideas start.")
     (move :modifier 0)
     (contains :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                   ()))
     (location :floor-size 20 :obj-soft-limit 10)
     (exits :hash #s(hash-table size 65 test eql rehash-size 1.5 rehash-threshold 0.8125 data
                                (nil nil))))
 (70 "npcjenna.0"
     (npc)
     (named :sname "nil" :rname "jenna.0" :dname "Jenna" :pronoun "She")
     (description :text "A tall strong woman, porcelain skin, covered in soot. She breathes heavily from years of breathing the harsh air by the forge.")
     (equipment :hat nil :shirt nil :pants "black.leather-pants" :shoes "brown.shoes" :ring nil :hand "hammer.0")
     (doing :text "Forging metal" :keywords nil)
     (where :location 13)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ("Worships" t "Spirit" t "of" t "Peace," t "woman," t "human," t "alive," t "Jenna" t)))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (71 "npctaylor.0"
     (npc)
     (named :sname "nil" :rname "taylor.0" :dname "Taylor" :pronoun "He")
     (description :text "A skinny charcoal skinned man, Always seems to be humming a tune. His white apron pockets overflow with wool thread.")
     (equipment :hat nil :shirt nil :pants "blue.jeans-worn" :shoes "brown.shoes" :ring nil :hand nil)
     (doing :text "Looks bored" :keywords nil)
     (where :location 5)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ("Worships" t "Spirit" t "of" t "Hope," t "man," t "human," t "alive," t "Taylor" t)))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (72 "npcalice.0"
     (npc)
     (named :sname "nil" :rname "alice.0" :dname "Alice" :pronoun "She")
     (description :text "A short olive skinned woman. Her stringy black hair is always in a haphazard bun. She’s gruff and to the point.")
     (equipment :hat nil :shirt nil :pants "blue.jeans-worn" :shoes "brown.shoes" :ring "wedding.ring" :hand "knife.0")
     (doing :text "Re-arraning fruits" :keywords nil)
     (where :location 11)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ("Worships" t "Spirit" t "of" t "Life," t "woman," t "human," t "alive," t "Alice" t)))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (73 "npcmary.beth.0"
     (npc)
     (named :sname "nil" :rname "mary.beth.0" :dname "Mary Beth" :pronoun "She")
     (description :text "A skinny woman with long straight red hair and freckles on her cheeks. She stares directly at you and says nothing waiting for your order, she’s no one’s therapist.")
     (equipment :hat nil :shirt nil :pants "black.leather-pants" :shoes "brown.shoes" :ring nil :hand "rag.0")
     (doing :text "Wiping down the bar" :keywords nil)
     (where :location 7)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ("Worships" t "Spirit" t "of" t "Vengeance," t "woman," t "human," t "alive," t "Mary" t "Beth" t)))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (74 "npcvengance.0"
     (npc)
     (named :sname "nil" :rname "vengance.0" :dname "Spirit of Vengeance" :pronoun "It")
     (description :text "A humanoid figure. Its head is bald. Skin luminesnt with a white glow. Its body cloaked in red fabric.")
     (equipment :hat nil :shirt nil :pants nil :shoes nil :ring nil :hand nil)
     (doing :text nil :keywords nil)
     (where :location 26)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ()))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (75 "npchope.0"
     (npc)
     (named :sname "nil" :rname "hope.0" :dname "Spirit of Hope" :pronoun "It")
     (description :text "A humanoid figure. Its face I is covered by long straigh black hair. Skin luminesnt with a soft blue glow. Its body wrapped in bandages.")
     (equipment :hat nil :shirt nil :pants nil :shoes nil :ring nil :hand nil)
     (doing :text nil :keywords nil)
     (where :location 26)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ()))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (76 "npcpeace.0"
     (npc)
     (named :sname "nil" :rname "peace.0" :dname "Spirit of Peace" :pronoun "It")
     (description :text "A humanoid figure. Its head covered in a white vale. Skin luminesnt with a red glow. Its body covered in shiny armor.")
     (equipment :hat nil :shirt nil :pants nil :shoes nil :ring nil :hand nil)
     (doing :text nil :keywords nil)
     (where :location 26)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ()))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (77 "npctime.0"
     (npc)
     (named :sname "nil" :rname "time.0" :dname "Spirit of Time" :pronoun "It")
     (description :text "A humanoid figure. Its head is obscured by dense fog. Skin luminesnt with a yellow glow. Its body bare.")
     (equipment :hat nil :shirt nil :pants nil :shoes nil :ring nil :hand nil)
     (doing :text nil :keywords nil)
     (where :location 26)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ()))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (78 "npclife.0"
     (npc)
     (named :sname "nil" :rname "life.0" :dname "Spirit of Life" :pronoun "It")
     (description :text "A humanoid figure. It has no head instead a mask made of wood floats in it place. Skin luminesnt with a green glow. Its body cloaked in mercury like fluid.")
     (equipment :hat nil :shirt nil :pants nil :shoes nil :ring nil :hand nil)
     (doing :text nil :keywords nil)
     (where :location 26)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ()))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (79 "npcdeath.0"
     (npc)
     (named :sname "nil" :rname "death.0" :dname "Spirit of Death" :pronoun "It")
     (description :text "A humanoid figure. Its head is bald, face featureless. Its body bare.")
     (equipment :hat nil :shirt nil :pants nil :shoes nil :ring nil :hand nil)
     (doing :text nil :keywords nil)
     (where :location 26)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ()))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (80 "npccharlotte.0"
     (npc)
     (named :sname "nil" :rname "charlotte.0" :dname "Charlotte" :pronoun "She")
     (description :text "A petite woman with long curly blonde hair and olive skin. She stares as if looking right through you and just as it becomes uncomfortable she smiles.")
     (equipment :hat nil :shirt nil :pants nil :shoes "Black.heels" :ring nil :hand nil)
     (doing :text "She's staring at you" :keywords nil)
     (where :location 23)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ("Worships" t "the" t "Spirit" t "of" t "Death," t "woman," t "human," t "alive," t "Charlotte" t)))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (81 "npcjacob.0"
     (npc)
     (named :sname "nil" :rname "jacob.0" :dname "Jacob" :pronoun "He")
     (description :text "A sweet looking hunched over old man. His skin is a sickly grey and his head completely bald. He walk slowly but deliberately leaning on a fine cane.")
     (equipment :hat nil :shirt nil :pants nil :shoes "black.shoes" :ring "temple.ring" :hand "black.cane")
     (doing :text "He's fallen asleep standing up." :keywords nil)
     (where :location 25)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ("Worships" t "the" t "Spirit" t "of" t "Death," t "man," t "human," t "alive," t "Jacob" t)))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (82 "npcfredrick.0"
     (npc)
     (named :sname "nil" :rname "fredrick.0" :dname "Fredrick" :pronoun "He")
     (description :text "A middle aged gentleman. Sickly pale and gaunt in the face. He wares a strange helmet as if to signify his position.")
     (equipment :hat "Strange.helmet" :shirt nil :pants "brown.pants" :shoes "black.shoes" :ring nil :hand "axe.0")
     (doing :text "He's chewing his lip." :keywords nil)
     (where :location 24)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ("Worships" t "the" t "Spirit" t "of" t "Peace," t "man," t "human," t "alive," t "Fredrick" t)))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (83 "npcanastasia.0"
     (npc)
     (named :sname "nil" :rname "anastasia.0" :dname "Anastasia" :pronoun "She")
     (description :text "A mysterious woman, her long silver hair goes all the way to the floor. She puts her nose up to everyone.")
     (equipment :hat nil :shirt nil :pants nil :shoes nil :ring nil :hand nil)
     (doing :text "She's crushing petals" :keywords nil)
     (where :location 22)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ("Worships" t "Spirit" t "of" t "Vengeance," t "woman," t "human," t "alive," t "Anastasia" t "Annastasia" t)))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (84 "npcwanderer.0"
     (npc)
     (named :sname "nil" :rname "wanderer.0" :dname "Wanderer" :pronoun "They")
     (description :text "A strange person who avoids most everyone. They don't like anyone.")
     (equipment :hat "tattered.hood" :shirt nil :pants "brown.pants" :shoes nil :ring nil :hand nil)
     (doing :text "Nibbling on what you think is a rat." :keywords nil)
     (where :location 15)
     (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                     ("Worships" t "Spirit" t "of" t "Vengeance," t "human," t "alive," t "wanderer" t)))
     (favour :level 0 :description-hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                                      (20 "Dislike" 50 "Mistrust" 75 "Amicable" 95 "Adore")))
     (preferences :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ("" nil))))
 (256 "clothing jenna.0"
      (named :sname "nil" :rname "jenna.0" :dname "Jenna" :pronoun "She")
      (description :text "A tall strong woman, porcelain skin, covered in soot. She breathes heavily from years of breathing the harsh air by the forge.")
      (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ())))
 (257 "clothing taylor.0"
      (named :sname "nil" :rname "taylor.0" :dname "Taylor" :pronoun "He")
      (description :text "A skinny charcoal skinned man, Always seems to be humming a tune. His white apron pockets overflow with wool thread.")
      (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ())))
 (258 "clothing alice.0"
      (named :sname "nil" :rname "alice.0" :dname "Alice" :pronoun "She")
      (description :text "A short olive skinned woman. Her stringy black hair is always in a haphazard bun. She’s gruff and to the point.")
      (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ())))
 (259 "clothing mary.beth.0"
      (named :sname "nil" :rname "mary.beth.0" :dname "Mary Beth" :pronoun "She")
      (description :text "A skinny woman with long straight red hair and freckles on her cheeks. She stares directly at you and says nothing waiting for your order, she’s no one’s therapist.")
      (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ())))
 (260 "clothing vengance.0"
      (named :sname "nil" :rname "vengance.0" :dname "Spirit of Vengeance" :pronoun "It")
      (description :text "A humanoid figure. Its head is bald. Skin luminesnt with a white glow. Its body cloaked in red fabric.")
      (attributes :hash nil))
 (261 "clothing hope.0"
      (named :sname "nil" :rname "hope.0" :dname "Spirit of Hope" :pronoun "It")
      (description :text "A humanoid figure. Its face I is covered by long straigh black hair. Skin luminesnt with a soft blue glow. Its body wrapped in bandages.")
      (attributes :hash nil))
 (262 "clothing peace.0"
      (named :sname "nil" :rname "peace.0" :dname "Spirit of Peace" :pronoun "It")
      (description :text "A humanoid figure. Its head covered in a white vale. Skin luminesnt with a red glow. Its body covered in shiny armor.")
      (attributes :hash nil))
 (263 "clothing time.0"
      (named :sname "nil" :rname "time.0" :dname "Spirit of Time" :pronoun "It")
      (description :text "A humanoid figure. Its head is obscured by dense fog. Skin luminesnt with a yellow glow. Its body bare.")
      (attributes :hash nil))
 (264 "clothing life.0"
      (named :sname "nil" :rname "life.0" :dname "Spirit of Life" :pronoun "It")
      (description :text "A humanoid figure. It has no head instead a mask made of wood floats in it place. Skin luminesnt with a green glow. Its body cloaked in mercury like fluid.")
      (attributes :hash nil))
 (265 "clothing death.0"
      (named :sname "nil" :rname "death.0" :dname "Spirit of Death" :pronoun "It")
      (description :text "A humanoid figure. Its head is bald, face featureless. Its body bare.")
      (attributes :hash nil))
 (266 "clothing charlotte.0"
      (named :sname "nil" :rname "charlotte.0" :dname "Charlotte" :pronoun "She")
      (description :text "A petite woman with long curly blonde hair and olive skin. She stares as if looking right through you and just as it becomes uncomfortable she smiles.")
      (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ())))
 (267 "clothing jacob.0"
      (named :sname "nil" :rname "jacob.0" :dname "Jacob" :pronoun "He")
      (description :text "A sweet looking hunched over old man. His skin is a sickly grey and his head completely bald. He walk slowly but deliberately leaning on a fine cane.")
      (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ())))
 (268 "clothing fredrick.0"
      (named :sname "nil" :rname "fredrick.0" :dname "Fredrick" :pronoun "He")
      (description :text "A middle aged gentleman. Sickly pale and gaunt in the face. He wares a strange helmet as if to signify his position.")
      (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ())))
 (269 "clothing anastasia.0"
      (named :sname "nil" :rname "anastasia.0" :dname "Anastasia" :pronoun "She")
      (description :text "A mysterious woman, her long silver hair goes all the way to the floor. She puts her nose up to everyone.")
      (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ())))
 (270 "clothing wanderer.0"
      (named :sname "nil" :rname "wanderer.0" :dname "Wanderer" :pronoun "They")
      (description :text "A strange person who avoids most everyone. They don't like anyone.")
      (attributes :hash #s(hash-table size 65 test equal rehash-size 1.5 rehash-threshold 0.8125 data
                                      ()))))

