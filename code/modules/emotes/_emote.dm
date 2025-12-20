#define EMOTE_VISIBLE 1
#define EMOTE_AUDIBLE 2

/decl/emote
	var/key = ""
	var/message = ""
	var/message_type = EMOTE_VISIBLE
	var/accepts_target = FALSE

	var/sound_path = null
	var/sound_volume = 100

	var/check_muzzle = FALSE
	var/message_muzzle = ""
	var/check_miming = FALSE
	var/message_miming = ""

/decl/emote/proc/can_use_emote(mob/user)
	return TRUE

/decl/emote/proc/get_emote_message(mob/user, param)
	if(check_miming && ishuman(user) && user:miming)
		message_type = EMOTE_VISIBLE
		return message_miming ? message_miming : message

	if(check_muzzle && iscarbon(user) && istype(user:wear_mask, /obj/item/clothing/mask/muzzle))
		message_type = EMOTE_AUDIBLE
		return message_muzzle

	if(accepts_target && param)
		var/mob/target = null
		for(var/mob/possible_target in view(null, user))
			if(param == possible_target.name)
				target = possible_target
				break
		if(isnotnull(target))
			var/new_message = copytext(message, 1, -1)
			new_message += " at [target][copytext(message, -1, 0)]"
			return new_message

	return message

/decl/emote/proc/do_emote(mob/user, param)
	if(!can_use_emote(user))
		return
	if(isliving(user) && user:stat != CONSCIOUS)
		return

	var/output_message = "<B>[user]</B>[get_emote_message(user, param)]"

	for_no_type_check(var/mob/M, GLOBL.dead_mob_list)
		if(isnull(M.client) || isnewplayer(M))
			continue //skip monkeys, leavers and new players
		if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(user, null)))
			M.show_message(output_message)

	if(message_type & EMOTE_VISIBLE)
		for(var/mob/O in get_mobs_in_view(world.view, user))
			O.show_message(output_message, message_type)
	else if(message_type & EMOTE_AUDIBLE)
		for(var/mob/O in (hearers(user.loc, null) | get_mobs_in_view(world.view, user)))
			O.show_message(output_message, message_type)

	if(isnotnull(sound_path))
		playsound(user, sound_path, sound_volume, 0)