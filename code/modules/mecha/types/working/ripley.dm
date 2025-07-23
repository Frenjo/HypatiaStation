/obj/mecha/working/ripley
	name = "\improper APLU \"Ripley\""
	desc = "Autonomous Power Loader Unit. The workhorse of the exosuit world."
	icon_state = "ripley"

	health = 200
	move_delay = 0.6 SECONDS
	max_temperature = 20000

	mecha_type = MECHA_TYPE_RIPLEY

	wreckage = /obj/structure/mecha_wreckage/ripley

	cargo_capacity = 15

	var/custom_goliath_overlay = FALSE
	var/goliath_hides = 0
	var/static/max_goliath_hides = 3

/obj/mecha/working/ripley/Destroy()
	for(var/i = 1, i <= goliath_hides, i++)
		new /obj/item/stack/goliath_hide(loc)
	damage_resistance["brute"] = initial(damage_resistance["brute"])
	return ..()

/obj/mecha/working/ripley/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/goliath_hide))
		if(isnotnull(occupant))
			to_chat(user, SPAN_WARNING("You can't add armour onto \the [src] while someone is inside!"))
			return TRUE
		if(goliath_hides < max_goliath_hides)
			var/obj/item/stack/goliath_hide/hide = I
			if(!hide.use(1))
				return TRUE

			damage_resistance["brute"] += 10 // 10% increased resistance per plate.
			to_chat(user, SPAN_INFO("You strengthen the armour on \the [src], improving its resistance against melee attacks."))
			goliath_hides++

			if(goliath_hides == max_goliath_hides)
				desc = initial(desc) + " It is wearing a fearsome carapace entirely composed of goliath hide plates - the pilot must be an experienced monster hunter."
			else
				desc = initial(desc) + " Its armour is enhanced with some goliath hide plates."
			update_overlays()
		else
			to_chat(user, SPAN_WARNING("You can't improve the armour on \the [src] any further."))
		return TRUE
	return ..()

/obj/mecha/working/ripley/moved_inside(mob/living/carbon/human/pilot)
	. = ..()
	if(!.)
		return FALSE
	update_overlays()

/obj/mecha/working/ripley/mmi_moved_inside(obj/item/mmi/mmi_as_oc, mob/user)
	. = ..()
	if(!.)
		return FALSE
	update_overlays()

/obj/mecha/working/ripley/go_out()
	. = ..()
	if(!.)
		return FALSE
	update_overlays()

/obj/mecha/working/ripley/proc/update_overlays()
	cut_overlays()
	var/image/new_overlay = null
	var/overlay_prefix = custom_goliath_overlay ? initial(icon_state) : "ripley"
	var/overlay_suffix = isnotnull(occupant) ? "" : "-open"
	if(!goliath_hides)
		return
	if(goliath_hides < max_goliath_hides)
		new_overlay = image('icons/obj/mecha/mecha_overlays.dmi', "[overlay_prefix]-g[overlay_suffix]")
	else
		new_overlay = image('icons/obj/mecha/mecha_overlays.dmi', "[overlay_prefix]-g-full[overlay_suffix]")

	if(isnull(new_overlay))
		return

	new_overlay.plane = plane
	add_overlay(new_overlay)

/obj/mecha/working/ripley/firefighter
	name = "\improper APLU \"Firefighter\""
	desc = "Standard APLU chassis refitted with additional thermal protection and cistern."
	icon_state = "firefighter"

	health = 250
	max_temperature = 65000
	damage_resistance = list("fire" = 50, "bullet" = 20, "bomb" = 50)

	wreckage = /obj/structure/mecha_wreckage/ripley/firefighter

/obj/mecha/working/ripley/death
	name = "\improper DEATH-RIPLEY"
	desc = "OH SHIT IT'S THE DEATHSQUAD WE'RE ALL GONNA DIE"
	icon_state = "deathripley"

	move_delay = 0.2 SECONDS
	step_energy_drain = 0

	mecha_type = MECHA_TYPE_DEATH_RIPLEY
	starts_with = list(
		/obj/item/mecha_equipment/tool/hydraulic_clamp/safety
	)

	wreckage = /obj/structure/mecha_wreckage/ripley/deathripley

/obj/mecha/working/ripley/mining
	name = "\improper APLU \"Miner\""
	desc = "An old, dusty mining ripley."

	starts_with = list(/obj/item/mecha_equipment/tool/hydraulic_clamp)

/obj/mecha/working/ripley/mining/initialise()
	// Chance for different drill types.
	if(prob(25)) // Possible diamond drill... Feeling lucky?
		starts_with.Add(/obj/item/mecha_equipment/tool/drill/diamond)
	else
		starts_with.Add(/obj/item/mecha_equipment/tool/drill)
	. = ..()

/obj/mecha/working/ripley/rescue_ranger
	name = "\improper APLU \"Rescue Ranger\""
	desc = "A modified APLU chassis fitted with mounting hardpoints for basic medical equipment. It is painted in the Vey-Med(&copy; all rights reserved) livery."
	icon_state = "rescue_ranger"

	health = 175
	move_delay = 0.5 SECONDS

	step_sound_volume = 25
	turn_sound = 'sound/mecha/movement/mechmove01.ogg'

	mecha_type = MECHA_TYPE_RESCUE_RANGER
	excluded_equipment = list(
		/obj/item/mecha_equipment/tool/hydraulic_clamp/rescue
	) // This can fit the regular hydraulic clamp since it has cargo capacity.

	wreckage = /obj/structure/mecha_wreckage/ripley/rescue_ranger

	cargo_capacity = 10

	custom_goliath_overlay = TRUE

// Sindy
/obj/mecha/working/ripley/sindy
	name = "\improper APLU \"Sindy\""
	desc = "A sinister variant of the standard APLU chassis fitted with rudimentary targeting systems and mounting hardpoints for basic weaponry."
	icon_state = "sindy"

	health = 225
	move_delay = 0.5 SECONDS
	max_temperature = 42500
	damage_resistance = list("brute" = 20, "fire" = 15, "bullet" = 15, "laser" = 15, "energy" = 15, "bomb" = 25)

	activation_sound = 'sound/mecha/voice/nominalsyndi.ogg'
	activation_sound_volume = 90

	operation_req_access = list(ACCESS_SYNDICATE)
	add_req_access = FALSE

	mecha_type = MECHA_TYPE_SINDY
	max_equip = 4

	wreckage = /obj/structure/mecha_wreckage/ripley/sindy

	cargo_capacity = 10

	custom_goliath_overlay = TRUE

/obj/mecha/working/ripley/sindy/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Equipped variant
/obj/mecha/working/ripley/sindy/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/energy/laser/heavy, /obj/item/mecha_equipment/tool/hydraulic_clamp,
		/obj/item/mecha_equipment/melee_armour_booster, /obj/item/mecha_equipment/emp_insulation/hardened
	)

// Paddy
/obj/mecha/working/ripley/paddy
	name = "\improper APLU \"Paddy\""
	desc = "A modified variant of the standard APLU chassis intended for light security use."
	icon_state = "paddy"

	health = 225
	move_delay = 0.4 SECONDS // Faster than a Ripley because it's less armoured, but slower than the more specialised Gygax.
	damage_resistance = list("brute" = 0, "fire" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0)

	mecha_type = MECHA_TYPE_PADDY

	wreckage = /obj/structure/mecha_wreckage/ripley/paddy

	cargo_capacity = 2

	custom_goliath_overlay = TRUE

	// Whether the flashers are active.
	var/flashers = FALSE
	// The overlay for the flashers.
	var/mutable_appearance/flasher_lights

/obj/mecha/working/ripley/paddy/go_out()
	flashers = FALSE
	. = ..()

/obj/mecha/working/ripley/paddy/update_overlays()
	. = ..()
	if(!flashers)
		return
	flasher_lights = mutable_appearance('icons/obj/mecha/mecha_overlays.dmi', "paddy-flashers", UNLIT_EFFECTS_PLANE)
	add_overlay(flasher_lights)

/obj/mecha/working/ripley/paddy/get_stats_part()
	. = ..()
	. += "<b>Flashers: [flashers ? "enabled" : "disabled"]</b>"

/obj/mecha/working/ripley/paddy/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];flashers=1'><span id="flashers_command">[flashers ? "Dis" : "En"]able Flashers</span></a>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/working/ripley/paddy/Topic(href, href_list)
	. = ..()
	if(href_list["flashers"])
		toggle_flashers()

/obj/mecha/working/ripley/paddy/verb/toggle_flashers()
	set category = "Exosuit Interface"
	set name = "Toggle Flashers"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	flashers = !flashers
	balloon_alert(occupant, "[flashers ? "en" : "dis"]abled flashers")
	send_byjax(occupant, "exosuit.browser", "flashers_command", "[flashers ? "Dis" : "En"]able Flashers")
	update_overlays()