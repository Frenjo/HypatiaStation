////////////////////////////////
//////// Mecha Wreckage ////////
////////////////////////////////
/obj/structure/mecha_wreckage
	name = "exosuit wreckage"
	desc = "Remains of some unfortunate mecha. Completely irreparable."
	icon = 'icons/obj/mecha/mecha.dmi'

	density = TRUE

	climbable = FALSE

	var/list/part_salvage = list()
	var/list/welder_salvage = list(
		/obj/item/stack/sheet/plasteel,
		/obj/item/stack/sheet/steel,
		/obj/item/stack/rods
	)
	var/list/wirecutters_salvage = list(
		/obj/item/stack/cable_coil
	)
	var/list/crowbar_salvage = list()
	var/salvage_num = 5

/obj/structure/mecha_wreckage/New()
	. = ..()
	for(var/i = 0; i < 2; i++)
		if(!isemptylist(part_salvage) && prob(40))
			var/part = pick(part_salvage)
			welder_salvage.Add(part)
			part_salvage.Remove(part)

/obj/structure/mecha_wreckage/attack_tool(obj/item/tool, mob/user)
	if(iswelder(tool))
		if(salvage_num <= 0)
			to_chat(user, SPAN_WARNING("You don't see anything that can be cut with \the [tool]."))
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if(!isemptylist(welder_salvage) && welder.remove_fuel(0, user))
			var/type = prob(70) ? pick(welder_salvage) : null
			if(type)
				var/N = new type(GET_TURF(user))
				user.visible_message(
					SPAN_NOTICE("[user] cuts \the [N] from \the [src]."),
					SPAN_NOTICE("You cut \the [N] from \the [src]."),
					SPAN_WARNING("You hear welding.")
				)
				if(istype(N, /obj/item/mecha_part/part))
					welder_salvage.Remove(type)
				salvage_num--
			else
				to_chat(user, SPAN_WARNING("You failed to salvage anything valuable from \the [src]."))
		return TRUE

	if(iswirecutter(tool))
		if(salvage_num <= 0)
			to_chat(user, SPAN_WARNING("You don't see anything that can be cut with \the [tool]."))
			return TRUE
		if(!isemptylist(wirecutters_salvage))
			var/type = prob(70) ? pick(wirecutters_salvage) : null
			if(isnotnull(type))
				var/N = new type(GET_TURF(user))
				user.visible_message(
					SPAN_NOTICE("[user] cuts \the [N] from \the [src]."),
					SPAN_NOTICE("You cut \the [N] from \the [src].")
				)
				salvage_num--
			else
				to_chat(user, SPAN_WARNING("You failed to salvage anything valuable from \the [src]."))
		return TRUE

	if(iscrowbar(tool))
		if(!isemptylist(crowbar_salvage))
			var/obj/S = pick(crowbar_salvage)
			if(isnotnull(S))
				S.loc = GET_TURF(user)
				crowbar_salvage.Remove(S)
				user.visible_message(
					SPAN_NOTICE("[user] pries \the [S] from \the [src]."),
					SPAN_NOTICE("You pry \the [S] from \the [src].")
				)
		else
			to_chat(user, SPAN_WARNING("You don't see anything that can be pried with \the [tool]."))
		return TRUE

	return ..()