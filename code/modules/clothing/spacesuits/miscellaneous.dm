//Captain's Spacesuit
/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	item_state = "capspacehelmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	inv_flags = INV_FLAG_HIDE_FACE
	permeability_coefficient = 0.01
	armor = list(melee = 65, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 50)

//Captain's space suit This is not the proper path but I don't currently know enough about how this all works to mess with it.
/obj/item/clothing/suit/armor/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive NanoTrasen armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state = "capspacesuit"
	w_class = 4
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS
	allowed = list(
		/obj/item/tank/emergency/oxygen, /obj/item/flashlight, /obj/item/gun/energy,
		/obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing,
		/obj/item/melee/baton, /obj/item/handcuffs
	)
	slowdown = 1.5
	armor = list(melee = 65, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 50)
	inv_flags = INV_FLAG_HIDE_GLOVES | INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES | INV_FLAG_HIDE_TAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7

//Deathsquad suit
/obj/item/clothing/head/helmet/space/deathsquad
	name = "deathsquad helmet"
	desc = "That's not red paint. That's real blood."
	icon_state = "deathsquad"
	item_state = "deathsquad"
	armor = list(melee = 65, bullet = 55, laser = 35, energy = 20, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0.2

/obj/item/clothing/head/helmet/space/deathsquad/beret
	name = "officer's beret"
	desc = "An armored beret commonly used by special operations officers."
	icon_state = "beret_badge"
	armor = list(melee = 65, bullet = 55, laser = 35, energy = 20, bomb = 30, bio = 30, rad = 30)
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE | ITEM_FLAG_COVERS_EYES
	inv_flags = INV_FLAG_HIDE_EARS | INV_FLAG_HIDE_EYES | INV_FLAG_BLOCK_HAIR
	siemens_coefficient = 0.9

//Space santa outfit suit
/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE | ITEM_FLAG_COVERS_EYES
	inv_flags = INV_FLAG_HIDE_EARS | INV_FLAG_HIDE_EYES | INV_FLAG_BLOCK_HAIR

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 0
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE | ITEM_FLAG_ONE_SIZE_FITS_ALL
	allowed = list(/obj/item) //for stuffing exta special presents


//Space pirate outfit
/obj/item/clothing/head/helmet/space/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 30)
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE | ITEM_FLAG_COVERS_EYES
	inv_flags = INV_FLAG_HIDE_EARS | INV_FLAG_HIDE_EYES | INV_FLAG_BLOCK_HAIR
	siemens_coefficient = 0.9

/obj/item/clothing/suit/space/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	w_class = 3
	allowed = list(
		/obj/item/gun, /obj/item/ammo_magazine, /obj/item/ammo_casing,
		/obj/item/melee/baton, /obj/item/handcuffs, /obj/item/tank/emergency/oxygen
	)
	slowdown = 0
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0.9

// Re-added spacesuits for the clown and mime, literally renamed/edited copies of the anomaly/mailman suits.
// Half of this stuff is preserved thanks to TehFlaminTaco, his github had all the OG stuff, code + sprites. -Frenjo
/obj/item/clothing/suit/space/clown
	name = "Clown's EVA Suit"
	desc = "A pressure resistant spacesuit in the colours of the clown. HONK!"
	icon_state = "clownspace_suit"
	item_state = "clownspace_suit"
	allowed = list(/obj/item/flashlight, /obj/item/tank)

/obj/item/clothing/head/helmet/space/clown
	name = "Clown's EVA Helmet"
	desc = "A pressure resistant spacesuit helmet in the colours of the clown. HONK!"
	icon_state = "clownspace_helmet"
	item_state = "clownspace_helmet"


/obj/item/clothing/suit/space/mime
	name = "Mime's EVA Suit"
	desc = "A pressure resistant spacesuit in the colours of the mime. ..."
	icon_state = "mimespace_suit"
	item_state = "mimespace_suit"
	allowed = list(/obj/item/flashlight, /obj/item/tank)

/obj/item/clothing/head/helmet/space/mime
	name = "Mime's EVA Helmet"
	desc = "A pressure resistant spacesuit helmet in the colours of the mime. ..."
	icon_state = "mimespace_helmet"
	item_state = "mimespace_helmet"