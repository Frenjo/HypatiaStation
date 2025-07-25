// Marauder
/obj/mecha/combat/marauder
	name = "\improper Marauder"
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations."
	icon_state = "marauder"
	infra_luminosity = 3

	force = 45

	health = 500
	move_delay = 0.5 SECONDS
	max_temperature = 60000
	deflect_chance = 25
	damage_resistance = list("brute" = 50, "fire" = 30, "bullet" = 55, "laser" = 40, "energy" = 30, "bomb" = 30)
	internal_damage_threshold = 25

	operation_req_access = list(ACCESS_CENT_SPECOPS)
	add_req_access = FALSE

	max_equip = 5
	mecha_type = MECHA_TYPE_MARAUDER

	wreckage = /obj/structure/mecha_wreckage/marauder

	zoom_capable = TRUE

	var/thrusters = 0
	var/smoke = 5
	var/smoke_ready = TRUE
	var/smoke_cooldown = 100
	var/datum/effect/system/smoke_spread/smoke_system

/obj/mecha/combat/marauder/initialise()
	. = ..()
	smoke_system = new /datum/effect/system/smoke_spread(src)
	smoke_system.set_up(3, 0, src)
	smoke_system.attach(src)

/obj/mecha/combat/marauder/Destroy()
	QDEL_NULL(smoke_system)
	return ..()

/obj/mecha/combat/marauder/verb/toggle_thrusters()
	set category = "Exosuit Interface"
	set name = "Toggle Thrusters"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return
	if(isnull(occupant))
		return

	if(get_charge() > 0)
		thrusters = !thrusters
		balloon_alert(occupant, "[thrusters ? "en" : "dis"]abled thrusters")
		send_byjax(occupant, "exosuit.browser", "thrusters_command", "[thrusters ? "Dis" : "En"]able Thrusters")
		log_message("Toggled thrusters.")

/obj/mecha/combat/marauder/verb/smoke()
	set category = "Exosuit Interface"
	set name = "Smoke"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	if(smoke_ready && smoke > 0)
		smoke_system.start()
		smoke--
		smoke_ready = FALSE
		spawn(smoke_cooldown)
			smoke_ready = TRUE

/obj/mecha/combat/marauder/get_stats_part()
	. = ..()
	. += {"<b>Thrusters:</b> [thrusters ? "enabled" : "disabled"]
		<br>
		<b>Smoke:</b> [smoke]
	"}

/obj/mecha/combat/marauder/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];thrusters=1'><span id="thrusters_command">[thrusters ? "Dis" : "En"]able Thrusters</span></a><br>
		<a href='byond://?src=\ref[src];zoom=1'><span id="zoom_command">[zoom_mode ? "Dis" : "En"]able Zoom Mode</span></a><br>
		<a href='byond://?src=\ref[src];smoke=1'>Smoke</a>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/combat/marauder/Topic(href, href_list)
	. = ..()
	if(href_list["thrusters"])
		toggle_thrusters()
	if(href_list["smoke"])
		smoke()

/obj/mecha/combat/marauder/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Equipped variant
/obj/mecha/combat/marauder/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/energy/pulse, /obj/item/mecha_equipment/weapon/ballistic/launcher/missile_rack,
		/obj/item/mecha_equipment/tesla_energy_relay, /obj/item/mecha_equipment/ranged_armour_booster,
		/obj/item/mecha_equipment/emp_insulation/hardened
	)

// Seraph
/obj/mecha/combat/marauder/seraph
	name = "\improper Seraph"
	desc = "Heavy-duty, command-type exosuit. This is a custom model, utilized only by high-ranking military personnel."
	icon_state = "seraph"

	force = 55

	move_delay = 0.3 SECONDS
	health = 550
	internal_damage_threshold = 20

	operation_req_access = list(ACCESS_CENT_CREED)

	max_equip = 6

	wreckage = /obj/structure/mecha_wreckage/seraph

// Equipped variant
/obj/mecha/combat/marauder/seraph/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/ballistic/scattershot, /obj/item/mecha_equipment/weapon/ballistic/launcher/missile_rack,
		/obj/item/mecha_equipment/teleporter, /obj/item/mecha_equipment/tesla_energy_relay, /obj/item/mecha_equipment/ranged_armour_booster,
		/obj/item/mecha_equipment/emp_insulation/hardened
	)

// Mauler
/obj/mecha/combat/marauder/mauler
	name = "\improper Mauler"
	desc = "Heavy-duty, combat exosuit, developed off of the existing Marauder model."
	icon_state = "mauler"

	activation_sound = 'sound/mecha/voice/nominalsyndi.ogg'
	activation_sound_volume = 90

	operation_req_access = list(ACCESS_SYNDICATE)

	wreckage = /obj/structure/mecha_wreckage/mauler

	zoom_sound = 'sound/mecha/voice/image_enhsyndi.ogg'
	zoom_sound_volume = 90.5

// Equipped variant
/obj/mecha/combat/marauder/mauler/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/energy/pulse, /obj/item/mecha_equipment/weapon/ballistic/launcher/missile_rack,
		/obj/item/mecha_equipment/tesla_energy_relay, /obj/item/mecha_equipment/ranged_armour_booster,
		/obj/item/mecha_equipment/emp_insulation/hardened
	)