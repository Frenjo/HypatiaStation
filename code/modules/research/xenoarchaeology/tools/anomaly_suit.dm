//changes: rad protection up to 100 from 20/50 respectively
// Anomaly suits
/obj/item/clothing/suit/bio_suit/anomaly
	name = "anomaly suit"
	desc = "A sealed bio suit capable of insulating against exotic alien energies."
	icon_state = "engspace_suit"
	item_state = "engspace_suit"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 10, bomb = 0, bio = 100, rad = 100)

/obj/item/clothing/head/bio_hood/anomaly
	name = "anomaly hood"
	desc = "A sealed bio hood capable of insulating against exotic alien energies."
	icon_state = "engspace_helmet"
	item_state = "engspace_helmet"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 10, bomb = 0, bio = 100, rad = 100)

// Excavation suits
/obj/item/clothing/suit/space/anomaly
	name = "excavation suit"
	desc = "A pressure resistant excavation suit partially capable of insulating against exotic alien energies."
	icon_state = "cespace_suit"
	item_state = "cespace_suit"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 5, bomb = 0, bio = 100, rad = 100)
	can_store = list(/obj/item/flashlight, /obj/item/tank, /obj/item/suit_cooling_unit)

/obj/item/clothing/head/helmet/space/anomaly
	name = "excavation hood"
	desc = "A pressure resistant excavation hood partially capable of insulating against exotic alien energies."
	icon_state = "cespace_helmet"
	item_state = "cespace_helmet"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 5, bomb = 0, bio = 100, rad = 100)