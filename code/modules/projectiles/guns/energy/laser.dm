/obj/item/weapon/gun/energy/laser
	name = "laser gun"
	desc = "a basic weapon designed kill with concentrated energy bolts"
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	w_class = 3.0
	m_amt = 2000
	origin_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MAGNETS = 2)
	gun_setting = GUN_SETTING_KILL
	pulse_projectile_types = list(GUN_SETTING_KILL = /obj/item/projectile/energy/pulse/laser)
	beam_projectile_types = list(GUN_SETTING_KILL = /obj/item/projectile/energy/beam/laser)

/obj/item/weapon/gun/energy/laser/practice
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/practice)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/practice)
	clumsy_check = 0

/obj/item/weapon/gun/energy/laser/retro
	name = "retro laser"
	icon_state = "retro"
	desc = "An older model of the basic lasergun, no longer used by NanoTrasen's security or military forces. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."

/obj/item/weapon/gun/energy/laser/captain
	icon_state = "caplaser"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."
	force = 10
	origin_tech = null
	var/charge_tick = 0

/obj/item/weapon/gun/energy/laser/captain/New()
	..()
	GLOBL.processing_objects.Add(src)

/obj/item/weapon/gun/energy/laser/captain/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/weapon/gun/energy/laser/captain/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(!power_supply)
		return 0
	power_supply.give(100)
	update_icon()
	return 1

/obj/item/weapon/gun/energy/laser/cyborg/load_into_chamber()
	if(in_chamber)
		return 1
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			R.cell.use(100)
			projectile_from_setting()
			in_chamber = new projectile_type(src)
			return 1
	return 0

/obj/item/weapon/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the L.A.S.E.R. cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	origin_tech = list(RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_POWERSTORAGE = 3)
	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/heavy)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/heavy)
	fire_delay = 20

/obj/item/weapon/gun/energy/lasercannon/isHandgun()
	return 0

/obj/item/weapon/gun/energy/lasercannon/cyborg/load_into_chamber()
	if(in_chamber)
		return 1
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			R.cell.use(250)
			projectile_from_setting()
			in_chamber = new projectile_type(src)
			return 1
	return 0

/obj/item/weapon/gun/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts."
	icon_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	origin_tech = list(
		RESEARCH_TECH_COMBAT = 5, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_MAGNETS = 2,
		RESEARCH_TECH_SYNDICATE = 2
	)
	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/xray)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/xray)
	charge_cost = 50

////////////////////Laser Tag////////////////////
/obj/item/weapon/gun/energy/laser/bluetag
	name = "laser tag gun"
	icon_state = "bluetag"
	desc = "Standard issue weapon of the Imperial Guard"
	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/tag/blue)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/tag/blue)
	origin_tech = list(RESEARCH_TECH_COMBAT = 1, RESEARCH_TECH_MAGNETS = 2)
	clumsy_check = 0
	var/charge_tick = 0

/obj/item/weapon/gun/energy/laser/bluetag/special_check(mob/living/carbon/human/M)
	if(ishuman(M))
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			return 1
		to_chat(M, SPAN_WARNING("You need to be wearing your laser tag vest!"))
	return 0

/obj/item/weapon/gun/energy/laser/bluetag/New()
	..()
	GLOBL.processing_objects.Add(src)

/obj/item/weapon/gun/energy/laser/bluetag/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/weapon/gun/energy/laser/bluetag/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(!power_supply)
		return 0
	power_supply.give(100)
	update_icon()
	return 1

/obj/item/weapon/gun/energy/laser/redtag
	name = "laser tag gun"
	icon_state = "redtag"
	desc = "Standard issue weapon of the Imperial Guard"
	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/laser/tag/red)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/laser/tag/red)
	origin_tech = list(RESEARCH_TECH_COMBAT = 1, RESEARCH_TECH_MAGNETS = 2)
	clumsy_check = 0
	var/charge_tick = 0

/obj/item/weapon/gun/energy/laser/redtag/special_check(mob/living/carbon/human/M)
	if(ishuman(M))
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			return 1
		to_chat(M, SPAN_WARNING("You need to be wearing your laser tag vest!"))
	return 0

/obj/item/weapon/gun/energy/laser/redtag/New()
	..()
	GLOBL.processing_objects.Add(src)

/obj/item/weapon/gun/energy/laser/redtag/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/weapon/gun/energy/laser/redtag/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(!power_supply)
		return 0
	power_supply.give(100)
	update_icon()
	return 1