/obj/item/gun/energy/taser
	name = "taser gun"
	desc = "A small, low capacity gun used for non-lethal takedowns."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.

	fire_sound = 'sound/weapons/Taser.ogg'

	cell_type = /obj/item/cell/crap

	gun_setting = GUN_SETTING_STUN
	pulse_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode
	)

/obj/item/gun/energy/taser/cyborg
	cell_type = /obj/item/cell/secborg
	self_charging = TRUE

/obj/item/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "A high-tech revolver that fires stun cartridges. The stun cartridges can be recharged using a conventional energy weapon recharger."
	icon_state = "stunrevolver"

	matter_amounts = /datum/design/weapon/stunrevolver::materials
	origin_tech = /datum/design/weapon/stunrevolver::req_tech

	fire_sound = 'sound/weapons/Gunshot.ogg'

	charge_cost = 125

	gun_setting = GUN_SETTING_STUN
	pulse_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode
	)

/obj/item/gun/energy/disabler
	name = "disabler"
	desc = "A non-lethal self-defence weapon that exhausts organic targets, weakening them until they collapse."
	icon_state = "disabler"

	origin_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 3, /decl/tech/power_storage = 1)

	fire_sound = 'sound/weapons/taser2.ogg'

	gun_setting = GUN_SETTING_DISABLE
	pulse_projectile_types = list(
		GUN_SETTING_DISABLE = /obj/item/projectile/energy/pulse/disabler
	)
	beam_projectile_types = list(
		GUN_SETTING_DISABLE = /obj/item/projectile/energy/beam/disabler
	)

/obj/item/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many of the syndicates stealth specialists."
	icon_state = "crossbow"
	item_state = "crossbow"

	w_class = 2
	origin_tech = alist(/decl/tech/magnets = 2, /decl/tech/combat = 2, /decl/tech/syndicate = 5)

	fire_sound = 'sound/weapons/Genhit.ogg'

	silenced = 1

	cell_type = /obj/item/cell/crap

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(
		GUN_SETTING_SPECIAL = /obj/item/projectile/energy/bolt
	)

	self_charging = TRUE
	recharge_time = 0.4 SECONDS

/obj/item/gun/energy/crossbow/update_icon()
	return

/obj/item/gun/energy/crossbow/largecrossbow
	name = "Energy Crossbow"
	desc = "A weapon favored by syndicate infiltration teams."

	w_class = 4
	//matter_amounts = /datum/design/weapon/largecrossbow::materials
	//origin_tech = /datum/design/weapon/largecrossbow::req_tech

	force = 10

	pulse_projectile_types = list(
		GUN_SETTING_SPECIAL = /obj/item/projectile/energy/bolt/large
	)