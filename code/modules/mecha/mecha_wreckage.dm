///////////////////////////////////
////////  Mecha wreckage   ////////
///////////////////////////////////
/obj/effect/decal/mecha_wreckage
	name = "exosuit wreckage"
	desc = "Remains of some unfortunate mecha. Completely irreparable."
	icon = 'icons/mecha/mecha.dmi'
	density = TRUE
	anchored = FALSE
	opacity = FALSE

	var/list/parts = list()
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

/obj/effect/decal/mecha_wreckage/New()
	. = ..()
	for(var/i = 0; i < 2; i++)
		if(!isemptylist(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage.Add(part)
			parts.Remove(part)

/obj/effect/decal/mecha_wreckage/ex_act(severity)
	if(severity < 2)
		spawn
			qdel(src)
	return

/obj/effect/decal/mecha_wreckage/bullet_act(obj/item/projectile/Proj)
	return

/obj/effect/decal/mecha_wreckage/attackby(obj/item/W, mob/user)
	if(iswelder(W))
		var/obj/item/weldingtool/WT = W
		if(salvage_num <= 0)
			to_chat(user, "You don't see anything that can be cut with [W].")
			return
		if(!isemptylist(welder_salvage) && WT.remove_fuel(0, user))
			var/type = prob(70) ? pick(welder_salvage) : null
			if(type)
				var/N = new type(GET_TURF(user))
				user.visible_message(
					"[user] cuts [N] from [src].",
					"You cut [N] from [src].",
					"You hear the sound of a welder nearby."
				)
				if(istype(N, /obj/item/mecha_part/part))
					welder_salvage -= type
				salvage_num--
			else
				to_chat(user, "You failed to salvage anything valuable from [src].")
		else
			return
	if(iswirecutter(W))
		if(salvage_num <= 0)
			to_chat(user, "You don't see anything that can be cut with [W].")
			return
		else if(!isemptylist(wirecutters_salvage))
			var/type = prob(70) ? pick(wirecutters_salvage) : null
			if(type)
				var/N = new type(GET_TURF(user))
				user.visible_message(
					"[user] cuts [N] from [src].",
					"You cut [N] from [src]."
				)
				salvage_num--
			else
				to_chat(user, "You failed to salvage anything valuable from [src].")
	if(iscrowbar(W))
		if(!isemptylist(crowbar_salvage))
			var/obj/S = pick(crowbar_salvage)
			if(S)
				S.loc = GET_TURF(user)
				crowbar_salvage -= S
				user.visible_message(
					"[user] pries [S] from [src].",
					"You pry [S] from [src]."
				)
			return
		else
			to_chat(user, "You don't see anything that can be pried with [W].")
	else
		..()
	return

// Working
/obj/effect/decal/mecha_wreckage/ripley
	name = "Ripley wreckage"
	icon_state = "ripley-broken"
	parts = list(
		/obj/item/mecha_part/part/ripley_torso,
		/obj/item/mecha_part/part/ripley_left_arm,
		/obj/item/mecha_part/part/ripley_right_arm,
		/obj/item/mecha_part/part/ripley_left_leg,
		/obj/item/mecha_part/part/ripley_right_leg
	)

/obj/effect/decal/mecha_wreckage/ripley/firefighter
	name = "Firefighter wreckage"
	icon_state = "firefighter-broken"
	parts = list(
		/obj/item/mecha_part/part/ripley_torso,
		/obj/item/mecha_part/part/ripley_left_arm,
		/obj/item/mecha_part/part/ripley_right_arm,
		/obj/item/mecha_part/part/ripley_left_leg,
		/obj/item/mecha_part/part/ripley_right_leg,
		/obj/item/clothing/suit/fire
	)

/obj/effect/decal/mecha_wreckage/ripley/deathripley
	name = "Death-Ripley wreckage"
	icon_state = "deathripley-broken"

/obj/effect/decal/mecha_wreckage/hoverpod
	name = "Hover pod wreckage"
	icon_state = "engineering_pod-broken"

/obj/effect/decal/mecha_wreckage/ripley/dreadnought
	name = "Dreadnought wreckage"
	icon_state = "dreadnought-broken"

/obj/effect/decal/mecha_wreckage/ripley/dreadnought/bulwark
	name = "Bulwark wreckage"
	icon_state = "bulwark-broken"

// Medical
/obj/effect/decal/mecha_wreckage/odysseus
	name = "Odysseus wreckage"
	icon_state = "odysseus-broken"
	parts = list(
		/obj/item/mecha_part/part/odysseus_torso,
		/obj/item/mecha_part/part/odysseus_head,
		/obj/item/mecha_part/part/odysseus_left_arm,
		/obj/item/mecha_part/part/odysseus_right_arm,
		/obj/item/mecha_part/part/odysseus_left_leg,
		/obj/item/mecha_part/part/odysseus_right_leg
	)

/obj/effect/decal/mecha_wreckage/gygax/serenity
	name = "Serenity wreckage"
	icon_state = "serenity-broken"

// Combat
/obj/effect/decal/mecha_wreckage/gygax
	name = "Gygax wreckage"
	icon_state = "gygax-broken"
	parts = list(
		/obj/item/mecha_part/part/gygax_torso,
		/obj/item/mecha_part/part/gygax_head,
		/obj/item/mecha_part/part/gygax_left_arm,
		/obj/item/mecha_part/part/gygax_right_arm,
		/obj/item/mecha_part/part/gygax_left_leg,
		/obj/item/mecha_part/part/gygax_right_leg
	)

/obj/effect/decal/mecha_wreckage/gygax/dark
	name = "Dark Gygax wreckage"
	icon_state = "darkgygax-broken"

/obj/effect/decal/mecha_wreckage/durand
	name = "Durand wreckage"
	icon_state = "durand-broken"
	parts = list(
		/obj/item/mecha_part/part/durand_torso,
		/obj/item/mecha_part/part/durand_head,
		/obj/item/mecha_part/part/durand_left_arm,
		/obj/item/mecha_part/part/durand_right_arm,
		/obj/item/mecha_part/part/durand_left_leg,
		/obj/item/mecha_part/part/durand_right_leg
	)

/obj/effect/decal/mecha_wreckage/durand/archambeau
	name = "Archambeau wreckage"
	icon_state = "archambeau-broken"

/obj/effect/decal/mecha_wreckage/marauder
	name = "Marauder wreckage"
	icon_state = "marauder-broken"

/obj/effect/decal/mecha_wreckage/mauler
	name = "Mauler Wreckage"
	icon_state = "mauler-broken"
	desc = "The syndicate won't be very happy about this..."

/obj/effect/decal/mecha_wreckage/seraph
	name = "Seraph wreckage"
	icon_state = "seraph-broken"

/obj/effect/decal/mecha_wreckage/phazon
	name = "Phazon wreckage"
	icon_state = "phazon-broken"

/obj/effect/decal/mecha_wreckage/honk
	name = "H.O.N.K wreckage"
	icon_state = "honk-broken"
	parts = list(
		/obj/item/mecha_part/chassis/honk,
		/obj/item/mecha_part/part/honk_torso,
		/obj/item/mecha_part/part/honk_head,
		/obj/item/mecha_part/part/honk_left_arm,
		/obj/item/mecha_part/part/honk_right_arm,
		/obj/item/mecha_part/part/honk_left_leg,
		/obj/item/mecha_part/part/honk_right_leg
	)