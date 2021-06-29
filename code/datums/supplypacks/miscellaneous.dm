/decl/hierarchy/supply_pack/miscellaneous
	name = "Miscellaneous"
	hierarchy_type = /decl/hierarchy/supply_pack/miscellaneous


/decl/hierarchy/supply_pack/miscellaneous/wizard
	name = "Wizard costume"
	contains = list(
		/obj/item/weapon/staff,
		/obj/item/clothing/suit/wizrobe/fake,
		/obj/item/clothing/shoes/sandal,
		/obj/item/clothing/head/wizard/fake
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Wizard costume crate"


/decl/hierarchy/supply_pack/miscellaneous/hats
	num_contained = 4
	contains = list(
		/obj/item/clothing/head/collectable/chef,
		/obj/item/clothing/head/collectable/paper,
		/obj/item/clothing/head/collectable/tophat,
		/obj/item/clothing/head/collectable/captain,
		/obj/item/clothing/head/collectable/beret,
		/obj/item/clothing/head/collectable/welding,
		/obj/item/clothing/head/collectable/flatcap,
		/obj/item/clothing/head/collectable/pirate,
		/obj/item/clothing/head/collectable/kitty,
		/obj/item/clothing/head/collectable/rabbitears,
		/obj/item/clothing/head/collectable/wizard,
		/obj/item/clothing/head/collectable/hardhat,
		/obj/item/clothing/head/collectable/HoS,
		/obj/item/clothing/head/collectable/thunderdome,
		/obj/item/clothing/head/collectable/swat,
		/obj/item/clothing/head/collectable/slime,
		/obj/item/clothing/head/collectable/police,
		/obj/item/clothing/head/collectable/slime,
		/obj/item/clothing/head/collectable/xenom,
		/obj/item/clothing/head/collectable/petehat
	)
	name = "Collectable hat crate!"
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "Collectable hats crate! Brought to you by Bass.inc!"
	supply_method = /decl/supply_method/randomised


/decl/hierarchy/supply_pack/miscellaneous/costume
	num_contained = 2
	contains = list(
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/clothing/suit/wcoat,
		/obj/item/clothing/suit/hastur,
		/obj/item/clothing/suit/holidaypriest,
		/obj/item/clothing/suit/nun,
		/obj/item/clothing/suit/imperium_monk,
		/obj/item/clothing/suit/ianshirt,
		/obj/item/clothing/under/gimmick/rank/captain/suit,
		/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit,
		/obj/item/clothing/under/lawyer/purpsuit,
		/obj/item/clothing/under/rank/mailman,
		/obj/item/clothing/under/dress/dress_saloon,
		/obj/item/clothing/suit/suspenders,
		/obj/item/clothing/suit/storage/labcoat/mad,
		/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
		/obj/item/clothing/under/schoolgirl,
		/obj/item/clothing/under/owl,
		/obj/item/clothing/under/waiter,
		/obj/item/clothing/under/gladiator,
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/scratch,
		/obj/item/clothing/under/wedding/bride_white,
		/obj/item/clothing/suit/chef,
		/obj/item/clothing/suit/apron/overalls,
		/obj/item/clothing/under/redcoat,
		/obj/item/clothing/under/kilt
	)
	name = "Costumes crate"
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Actor Costumes"
	access = access_theatre
	supply_method = /decl/supply_method/randomised


/decl/hierarchy/supply_pack/miscellaneous/formal_wear
	contains = list(
		/obj/item/clothing/head/bowler,
		/obj/item/clothing/head/that,
		/obj/item/clothing/suit/storage/lawyer/bluejacket,
		/obj/item/clothing/suit/storage/lawyer/purpjacket,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/suit_jacket/female,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/red,
		/obj/item/clothing/under/lawyer/bluesuit,
		/obj/item/clothing/under/lawyer/purpsuit,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/suit/wcoat
	)
	name = "Formalwear closet"
	cost = 30
	containertype = /obj/structure/closet
	containername = "Formalwear for the best occasions."


/decl/hierarchy/supply_pack/miscellaneous/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "EFTPOS scanner"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "EFTPOS crate"