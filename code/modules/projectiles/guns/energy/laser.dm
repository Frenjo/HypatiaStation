/obj/item/gun/energy/laser
	name = "laser gun"
	desc = "A basic weapon designed to kill with concentrated energy bolts."
	icon_state = "laser"
	item_state = "laser"

	origin_tech = alist(/decl/tech/magnets = 2, /decl/tech/combat = 3)

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

	self_charging = TRUE
	recharge_time = 0.4 SECONDS

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

	matter_amounts = /datum/design/weapon/lasercannon::materials
	origin_tech = /datum/design/weapon/lasercannon::req_tech

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

	origin_tech = alist(
		/decl/tech/materials = 3, /decl/tech/magnets = 2, /decl/tech/combat = 5,
		/decl/tech/syndicate = 2
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

	origin_tech = alist(/decl/tech/magnets = 2, /decl/tech/combat = 1)

	clumsy_check = FALSE

	gun_setting = GUN_SETTING_SPECIAL

	self_charging = TRUE
	recharge_time = 0.4 SECONDS

	var/vest_type = null

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