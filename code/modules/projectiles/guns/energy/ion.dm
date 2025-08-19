/obj/item/gun/energy/ion
	name = "ion rifle"
	desc = "A man portable anti-armour weapon designed to disable mechanical threats."
	icon_state = "ionrifle"

	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	origin_tech = alist(/decl/tech/magnets = 4, /decl/tech/combat = 2)

	fire_sound = 'sound/weapons/gun/laser.ogg'

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/projectile/ion)

/obj/item/gun/energy/ion/emp_act(severity)
	if(severity <= 2)
		. = ..()