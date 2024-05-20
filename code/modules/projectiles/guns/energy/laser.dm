/obj/item/gun/energy/laser
	name = "laser gun"
	desc = "A basic weapon designed to kill with concentrated energy bolts."
	icon_state = "laser"
	item_state = "laser"

	origin_tech = list(/datum/tech/magnets = 2, /datum/tech/combat = 3)

	fire_sound = 'sound/weapons/Laser.ogg'

	gun_setting = GUN_SETTING_KILL
	pulse_projectile_types = list(GUN_SETTING_KILL = /obj/item/projectile/energy/pulse/laser)
	beam_projectile_types = list(GUN_SETTING_KILL = /obj/item/projectile/energy/beam/laser)

/obj/item/gun/energy/laser/practice
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."

	clumsy_check = FALSE

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/practice)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/practice)

/obj/item/gun/energy/laser/retro
	name = "retro laser"
	icon_state = "retro"
	desc = "An older model of the basic lasergun, no longer used by NanoTrasen's security or military forces. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."

/obj/item/gun/energy/laser/captain
	icon_state = "caplaser"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."

	origin_tech = null

	force = 10

	var/charge_tick = 0

/obj/item/gun/energy/laser/captain/New()
	. = ..()
	GLOBL.processing_objects.Add(src)

/obj/item/gun/energy/laser/captain/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/gun/energy/laser/captain/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(!power_supply)
		return 0
	power_supply.give(100)
	update_icon()
	return 1

/obj/item/gun/energy/laser/cyborg/load_into_chamber()
	if(in_chamber)
		return 1
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(isnotnull(R?.cell))
			R.cell.use(100)
			projectile_from_setting()
			in_chamber = new projectile_type(src)
			return 1
	return 0

/obj/item/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the L.A.S.E.R. cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"

	origin_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 4, /datum/tech/power_storage = 3)

	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	fire_delay = 2 SECONDS

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/heavy)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/heavy)

/obj/item/gun/energy/lasercannon/isHandgun()
	return FALSE

/obj/item/gun/energy/lasercannon/cyborg/load_into_chamber()
	if(in_chamber)
		return 1
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(isnotnull(R?.cell))
			R.cell.use(250)
			projectile_from_setting()
			in_chamber = new projectile_type(src)
			return 1
	return 0

/obj/item/gun/energy/xray
	name = "x-ray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts."
	icon_state = "xray"

	origin_tech = list(
		/datum/tech/materials = 3, /datum/tech/magnets = 2, /datum/tech/combat = 5,
		/datum/tech/syndicate = 2
	)

	fire_sound = 'sound/weapons/laser3.ogg'

	charge_cost = 50

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/xray)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/xray)

/*
 * Laser Tag Guns
 */
/obj/item/gun/energy/laser/tag
	name = "laser tag gun"
	desc = "Standard issue weapon of the Imperial Guard."

	origin_tech = list(/datum/tech/magnets = 2, /datum/tech/combat = 1)

	clumsy_check = FALSE

	gun_setting = GUN_SETTING_SPECIAL

	var/charge_tick = 0
	var/vest_type = null

/obj/item/gun/energy/laser/tag/New()
	. = ..()
	GLOBL.processing_objects.Add(src)

/obj/item/gun/energy/laser/tag/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/gun/energy/laser/tag/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(isnull(power_supply))
		return 0
	power_supply.give(100)
	update_icon()
	return 1

/obj/item/gun/energy/laser/tag/special_check(mob/living/carbon/human/M)
	if(ishuman(M))
		if(istype(M.wear_suit, vest_type))
			return 1
		to_chat(M, SPAN_WARNING("You need to be wearing your laser tag vest!"))
	return 0

/obj/item/gun/energy/laser/tag/blue
	icon_state = "bluetag"

	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/tag/blue)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/tag/blue)

	vest_type = /obj/item/clothing/suit/laser_tag/blue

/obj/item/gun/energy/laser/tag/red
	icon_state = "redtag"

	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/tag/red)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/tag/red)

	vest_type = /obj/item/clothing/suit/laser_tag/red