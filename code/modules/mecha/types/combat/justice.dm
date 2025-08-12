#define MOVE_DELAY_ANGRY (0.45 SECONDS)
#define MOVE_DELAY_SAFETY (0.25 SECONDS)

/obj/mecha/combat/justice
	name = "\improper Justice"
	desc = "A black-and-red Syndicate exosuit designed for execution orders. For safety reasons, it is advised against standing too close."
	icon_state = "justice"

	force = 60

	activation_sound = 'sound/mecha/voice/nominalsyndi.ogg'
	activation_sound_volume = 90

	health = 200
	move_delay = MOVE_DELAY_SAFETY
	max_temperature = 40000
	damage_resistance = list("brute" = 30, "fire" = 30, "bullet" = 20, "laser" = 20, "energy" = 30, "bomb" = 30)

	operation_req_access = list(ACCESS_SYNDICATE)
	add_req_access = FALSE

	mecha_type = MECHA_TYPE_JUSTICE
	max_equip = 3

	var/weapons_safety = TRUE

/obj/mecha/combat/justice/Move(new_loc, direction)
	. = ..()
	update_icon()

/obj/mecha/combat/justice/update_icon()
	. = ..()
	if(isnotnull(occupant))
		icon_state = weapons_safety ? "justice" : "justice-angry"
	if(!check_for_support())
		icon_state = "[icon_state]-fly"

/obj/mecha/combat/justice/melee_action(atom/target)
	if(weapons_safety)
		return
	. = ..()
	playsound(src, 'sound/mecha/justice/blade_attack.ogg', 50, TRUE)

/obj/mecha/combat/justice/verb/toggle_safety()
	set category = "Exosuit Interface"
	set name = "Toggle Safety"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return
	if(isnull(occupant))
		return

	set_safety(occupant)
	playsound(src, 'sound/mecha/justice/blade_safety.ogg', 75, FALSE) // Everyone needs to hear this sound.
	balloon_alert(occupant, "[weapons_safety ? "en" : "dis"]abled safety")
	send_byjax(occupant, "exosuit.browser", "safety_command", "[weapons_safety ? "Dis" : "En"]able Safety")
	log_message("Toggled safety.")

/obj/mecha/combat/justice/proc/set_safety(mob/user)
	weapons_safety = !weapons_safety
	if(weapons_safety)
		move_delay = MOVE_DELAY_SAFETY
	else
		move_delay = MOVE_DELAY_ANGRY
	update_icon()

#undef MOVE_DELAY_SAFETY
#undef MOVE_DELAY_ANGRY