/obj/item/gun/energy/ion
	name = "ion rifle"
	desc = "A man portable anti-armour weapon designed to disable mechanical threats."
	icon_state = "ionrifle"

	w_class = 4
	slot_flags = SLOT_BACK
	origin_tech = list(RESEARCH_TECH_COMBAT = 2, RESEARCH_TECH_MAGNETS = 4)

	fire_sound = 'sound/weapons/Laser.ogg'

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/ion)

/obj/item/gun/energy/ion/emp_act(severity)
	if(severity <= 2)
		. = ..()