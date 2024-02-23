//Skrell space gear. Sleek like a wetsuit.
/obj/item/clothing/head/helmet/space/skrell
	name = "Skrellian helmet"
	desc = "Smoothly contoured and polished to a shine. Still looks like a fishbowl."
	armor = list(melee = 20, bullet = 20, laser = 50, energy = 50, bomb = 50, bio = 100, rad = 100)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL)
	sprite_sheets = list(
		SPECIES_HUMAN = 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/helmet.dmi'
	)

/obj/item/clothing/head/helmet/space/skrell/white
	icon_state = "skrell_helmet_white"
	item_state = "skrell_helmet_white"
	item_color = "skrell_helmet_white"

/obj/item/clothing/head/helmet/space/skrell/black
	icon_state = "skrell_helmet_black"
	item_state = "skrell_helmet_black"
	item_color = "skrell_helmet_black"

/obj/item/clothing/suit/space/skrell
	name = "Skrellian hardsuit"
	desc = "Seems like a wetsuit with reinforced plating seamlessly attached to it. Very chic."
	armor = list(melee = 20, bullet = 20, laser = 50, energy = 50, bomb = 50, bio = 100, rad = 100)
	allowed = list(
		/obj/item/flashlight, /obj/item/tank, /obj/item/storage/bag/ore,
		/obj/item/t_scanner, /obj/item/pickaxe, /obj/item/rcd
	)
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL)
	sprite_sheets = list(
		SPECIES_HUMAN = 'icons/mob/species/skrell/suit.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/suit.dmi'
	)

/obj/item/clothing/suit/space/skrell/white
	icon_state = "skrell_suit_white"
	item_state = "skrell_suit_white"
	item_color = "skrell_suit_white"

/obj/item/clothing/suit/space/skrell/black
	icon_state = "skrell_suit_black"
	item_state = "skrell_suit_black"
	item_color = "skrell_suit_black"

//Soghun space gear. Huge and restrictive.
/obj/item/clothing/head/helmet/space/soghun
	armor = list(melee = 40, bullet = 30, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 50)
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	var/up = 0 //So Soghun helmets play nicely with the weldervision check.
	species_restricted = list(SPECIES_SOGHUN)
	sprite_sheets = list(
		SPECIES_SOGHUN = 'icons/mob/species/soghun/helmet.dmi'
	)

/obj/item/clothing/head/helmet/space/soghun/helmet_cheap
	name = "NT breacher helmet"
	desc = "Hey! Watch it with that thing! It's a knock-off of a Soghun battle-helm, and that spike could put someone's eye out."
	icon_state = "soghun_helm_cheap"
	item_state = "soghun_helm_cheap"
	item_color = "soghun_helm_cheap"

/obj/item/clothing/suit/space/soghun
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 50)
	allowed = list(
		/obj/item/flashlight, /obj/item/tank, /obj/item/storage/bag/ore,
		/obj/item/t_scanner, /obj/item/pickaxe, /obj/item/rcd
	)
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list(SPECIES_SOGHUN)
	sprite_sheets = list(
		SPECIES_SOGHUN = 'icons/mob/species/soghun/suit.dmi'
	)

/obj/item/clothing/suit/space/soghun/rig_cheap
	name = "NT breacher chassis"
	desc = "A cheap NT knock-off of a Soghun battle-rig. Looks like a fish, moves like a fish, steers like a cow."
	icon_state = "rig-soghun-cheap"
	item_state = "rig-soghun-cheap"
	slowdown = 3

/obj/item/clothing/head/helmet/space/soghun/breacher
	name = "breacher helm"
	desc = "Weathered, ancient and battle-scarred. The helmet is too."
	icon_state = "soghun_breacher"
	item_state = "soghun_breacher"
	item_color = "soghun_breacher"

/obj/item/clothing/suit/space/soghun/breacher
	name = "breacher chassis"
	desc = "Huge, bulky and absurdly heavy. It must be like wearing a tank."
	icon_state = "soghun_breacher"
	item_state = "soghun_breacher"
	item_color = "soghun_breacher"
	slowdown = 1

// Vox space gear (vaccuum suit, low pressure armour)
// Can't be equipped by any other species due to bone structure and vox cybernetics.
/obj/item/clothing/suit/space/vox
	w_class = 3
	allowed = list(
		/obj/item/gun, /obj/item/ammo_magazine, /obj/item/ammo_casing,
		/obj/item/melee/baton, /obj/item/melee/energy/sword, /obj/item/handcuffs,
		/obj/item/tank
	)
	slowdown = 2
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 30)
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list(SPECIES_VOX, SPECIES_VOX_ARMALIS)
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/suit.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/armalis/suit.dmi',
	)

/obj/item/clothing/head/helmet/space/vox
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 30)
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE | ITEM_FLAG_COVERS_EYES
	species_restricted = list(SPECIES_VOX, SPECIES_VOX_ARMALIS)
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/head.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/armalis/head.dmi',
	)

/obj/item/clothing/head/helmet/space/vox/pressure
	name = "alien helmet"
	icon_state = "vox-pressure"
	item_state = "vox-pressure"
	desc = "Hey, wasn't this a prop in \'The Abyss\'?"

/obj/item/clothing/suit/space/vox/pressure
	name = "alien pressure suit"
	icon_state = "vox-pressure"
	item_state = "vox-pressure"
	desc = "A huge, armoured, pressurized suit, designed for distinctly nonhuman proportions."

/obj/item/clothing/head/helmet/space/vox/carapace
	name = "alien visor"
	icon_state = "vox-carapace"
	item_state = "vox-carapace"
	desc = "A glowing visor, perhaps stolen from a depressed Cylon."

/obj/item/clothing/suit/space/vox/carapace
	name = "alien carapace armour"
	icon_state = "vox-carapace"
	item_state = "vox-carapace"
	desc = "An armoured, segmented carapace with glowing purple lights. It looks pretty run-down."

/obj/item/clothing/head/helmet/space/vox/stealth
	name = "alien stealth helmet"
	icon_state = "vox-stealth"
	item_state = "vox-stealth"
	desc = "A smoothly contoured, matte-black alien helmet."

/obj/item/clothing/suit/space/vox/stealth
	name = "alien stealth suit"
	icon_state = "vox-stealth"
	item_state = "vox-stealth"
	desc = "A sleek black suit. It seems to have a tail, and is very heavy."

/obj/item/clothing/head/helmet/space/vox/medic
	name = "alien goggled helmet"
	icon_state = "vox-medic"
	item_state = "vox-medic"
	desc = "An alien helmet with enormous goggled lenses."

/obj/item/clothing/suit/space/vox/medic
	name = "alien armour"
	icon_state = "vox-medic"
	item_state = "vox-medic"
	desc = "An almost organic looking nonhuman pressure suit."

/obj/item/clothing/under/vox
	has_sensor = 0
	species_restricted = list(SPECIES_VOX)

/obj/item/clothing/under/vox/vox_casual
	name = "alien clothing"
	desc = "This doesn't look very comfortable."
	icon_state = "vox-casual-1"
	item_color = "vox-casual-1"
	item_state = "vox-casual-1"

/obj/item/clothing/under/vox/vox_robes
	name = "alien robes"
	desc = "Weird and flowing!"
	icon_state = "vox-casual-2"
	item_color = "vox-casual-2"
	item_state = "vox-casual-2"

/obj/item/clothing/gloves/yellow/vox
	desc = "These bizarre gauntlets seem to be fitted for... bird claws?"
	name = "insulated gauntlets"
	icon_state = "gloves-vox"
	item_state = "gloves-vox"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	item_color = "gloves-vox"
	species_restricted = list(SPECIES_VOX, SPECIES_VOX_ARMALIS)
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/gloves.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/armalis/gloves.dmi',
	)

/obj/item/clothing/shoes/magboots/vox
	desc = "A pair of heavy, jagged armoured foot pieces, seemingly suitable for a velociraptor."
	name = "vox boots"
	item_state = "boots-vox"
	icon_state = "boots-vox"
	species_restricted = list(SPECIES_VOX, SPECIES_VOX_ARMALIS)
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/feet.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/armalis/feet.dmi',
	)

/obj/item/clothing/shoes/magboots/vox/attack_self(mob/user)
	if(magpulse)
		UNSET_ITEM_FLAGS(src, ITEM_FLAG_NO_SLIP)
		magpulse = 0
		to_chat(user, "You relax your deathgrip on the flooring.")
	else
		SET_ITEM_FLAGS(src, ITEM_FLAG_NO_SLIP)
		magpulse = 1
		to_chat(user, "You dig your claws deeply into the flooring, bracing yourself.")

/obj/item/clothing/shoes/magboots/vox/examine()
	set src in view()
	..()

// Plasmalin gear.
/obj/item/clothing/head/helmet/space/plasmalin
	name = "envirohelmet"
	desc = "A space-capable helmet designed to prevent a Plasmalin from combusting in a human-breathable atmosphere."
	icon_state = "rig0-standard-plasmalin"
	item_state = "rig0-standard-plasmalin"
	species_restricted = list(SPECIES_PLASMALIN)