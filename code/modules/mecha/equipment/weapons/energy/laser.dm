// Laser
/obj/item/mecha_equipment/weapon/energy/laser
	name = "\improper CH-PS \"Immolator\" laser"
	icon_state = "laser"
	matter_amounts = /datum/design/mechfab/equipment/weapon/laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/laser::req_tech

	equip_cooldown = 0.8 SECONDS
	energy_drain = 30

	projectile = /obj/projectile/energy/pulse/laser
	fire_sound = 'sound/weapons/gun/laser.ogg'

/obj/item/mecha_equipment/weapon/energy/laser/heavy
	name = "\improper CH-LC \"Solaris\" laser cannon"
	icon_state = "laser_cannon"
	matter_amounts = /datum/design/mechfab/equipment/weapon/heavy_laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/heavy_laser::req_tech

	equip_cooldown = 1.5 SECONDS
	energy_drain = 60

	projectile = /obj/projectile/energy/pulse/laser/heavy
	fire_sound = 'sound/weapons/gun/lasercannonfire.ogg'

/obj/item/mecha_equipment/weapon/energy/laser/rigged
	name = "jury-rigged welder-laser"
	desc = "While not regulation, this inefficient weapon can be attached to working exosuits in desperate, or malicious, times."
	icon_state = "laser_rigged"
	matter_amounts = /datum/design/mechfab/equipment/weapon/rigged_laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/rigged_laser::req_tech

	mecha_types = MECHA_TYPE_WORKING | MECHA_TYPE_COMBAT

	equip_cooldown = 1.6 SECONDS
	energy_drain = 60

	attaches_to_string = "<em><i>working</i></em> and <em><i>combat</i></em> exosuits"

/obj/item/mecha_equipment/weapon/energy/laser/axis_projector
	name = "\improper UKN-EP \"Axis\" ocular energy projector" // UKN-EP = UnKNown Energy Projector.
	desc = "An exosuit module that appears to be constructed from \"alien\" technology, functioning as both a sophisticated camera lens and an extremely \
		high-power mixed-mode laser emitter. Interestingly, the vast majority of its components bear remarkable similarities to the scanning and targeting \
		suites contained in the heads of traditional combat exosuits."
	icon_state = "axis_projector_alien"

	mecha_types = MECHA_TYPE_THALES

	salvageable = FALSE

	allow_duplicates = FALSE
	allow_detach = FALSE

	attaches_to_string = "the <em><i>Thales</i></em> exosuit"

	var/burst_mode = TRUE
	var/burst_fire_count = 0

	var/burst_energy_drain = parent_type::energy_drain * 4
	var/heavy_energy_drain = (parent_type::energy_drain * 4) * 4

/obj/item/mecha_equipment/weapon/energy/laser/axis_projector/get_equip_info()
	. = ..()
	if(chassis.selected == src)
		. += " \[<a href='byond://?src=\ref[src];burst_mode=1'>[burst_mode ? "<b>Burst</b>" : "Burst"]</a>|<a href='byond://?src=\ref[src];cannon_mode=1'>[burst_mode ? "Cannon" : "<b>Cannon</b>"]</a>\]"
	else
		. += " \[\"Burst\"|\"Cannon\"\]"

/obj/item/mecha_equipment/weapon/energy/laser/axis_projector/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(topic.get("burst_mode"))
		burst_mode = TRUE
	if(topic.get("cannon_mode"))
		burst_mode = FALSE
	update_equip_info()

/obj/item/mecha_equipment/weapon/energy/laser/axis_projector/action_checks(atom/target)
	if(!..())
		return FALSE

	if(burst_mode)
		equip_cooldown = 0.5 SECONDS
		energy_drain = burst_energy_drain
		if(burst_fire_count == 0 || burst_fire_count >= 4)
			fire_sound = 'sound/weapons/gun/laser.ogg'
			projectile = /obj/projectile/energy/beam/laser/rapid
			burst_fire_count = 0
		else
			fire_sound = 'sound/weapons/gun/laser_pulse.ogg'
			projectile = /obj/projectile/energy/pulse/laser/rapid
		burst_fire_count++
	else
		equip_cooldown = 3 SECONDS
		energy_drain = heavy_energy_drain
		fire_sound = 'sound/weapons/gun/lasercannonfire.ogg'
		projectile = /obj/projectile/energy/beam/laser/heavy/slow
		burst_fire_count = 0
	return TRUE

// X-ray
/obj/item/mecha_equipment/weapon/energy/laser/xray
	name = "\improper CH-XS \"Penetrator\" X-ray laser"
	desc = "A large exosuit-mounted variant of the anti-armor xray rifle."
	icon_state = "xray"
	matter_amounts = /datum/design/mechfab/equipment/weapon/xray::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/xray::req_tech

	equip_cooldown = 0.6 SECONDS
	energy_drain = 150

	projectile = /obj/projectile/energy/pulse/laser/xray
	fire_sound = 'sound/weapons/gun/laser3.ogg'

/obj/item/mecha_equipment/weapon/energy/laser/xray/rigged
	name = "jury-rigged X-ray laser"
	desc = "A modified wormhole modulation array and meson-scanning control system allow this abomination to produce concentrated blasts of xrays."
	icon_state = "xray_rigged"
	matter_amounts = /datum/design/mechfab/equipment/weapon/rigged_xray::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/rigged_xray::req_tech

	mecha_types = MECHA_TYPE_WORKING | MECHA_TYPE_COMBAT

	equip_cooldown = 1.2 SECONDS
	energy_drain = 175

	attaches_to_string = "<em><i>working</i></em> and <em><i>combat</i></em> exosuits"

// Emitter
/obj/item/mecha_equipment/weapon/energy/brigand_emitter
	name = "\improper NT-EM \"BR1-G4ND\" mounted emitter" // NT-EM = NanoTrasen EMitter.
	desc = "An engineering-grade emitter fitted with a specially-designed mounting socket compatible with Brigand-type exosuits."
	icon_state = "xray" // Temporary sprite, but should basically never be seen anyway.

	mecha_types = MECHA_TYPE_BRIGAND

	equip_cooldown = 3 SECONDS
	energy_drain = 300

	salvageable = FALSE

	allow_duplicates = FALSE
	allow_detach = FALSE

	attaches_to_string = "the <em><i>Brigand</i></em> exosuit"

	projectile = /obj/projectile/energy/beam/emitter
	fire_sound = 'sound/weapons/gun/emitter.ogg'