/obj/machinery/artifact
	name = "alien artifact"
	desc = "A large alien device."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano00"
	density = TRUE

	var/static/list/all_effect_types = SUBTYPESOF(/datum/artifact_effect)
	var/datum/artifact_effect/my_effect
	var/datum/artifact_effect/secondary_effect

	var/icon_num = 0
	var/being_used = 0

/obj/machinery/artifact/initialise()
	. = ..()

	//setup primary effect - these are the main ones (mixed)
	var/effect_type = pick(all_effect_types)
	my_effect = new effect_type(src)

	//75% chance to have a secondary stealthy (and mostly bad) effect
	if(prob(75))
		effect_type = pick(all_effect_types)
		secondary_effect = new effect_type(src)
		if(prob(75))
			secondary_effect.ToggleActivate(0)

	icon_num = rand(0, 11)
	icon_state = "ano[icon_num]0"
	if(icon_num == 7 || icon_num == 8)
		name = "large crystal"
		desc = pick(\
			"It shines faintly as it catches the light.",\
			"It appears to have a faint inner glow.",\
			"It seems to draw you inward as you look it at.",\
			"Something twinkles faintly as you look at it.",\
			"It's mesmerizing to behold."\
		)
		if(prob(50))
			my_effect.trigger = TRIGGER_ENERGY
	else if(icon_num == 9)
		name = "alien computer"
		desc = "It is covered in strange markings."
		if(prob(75))
			my_effect.trigger = TRIGGER_TOUCH
	else if(icon_num == 10)
		desc = "A large alien device, there appear to be some kind of vents in the side."
		if(prob(50))
			my_effect.trigger = rand(6, 12)
	else if(icon_num == 11)
		name = "sealed alien pod"
		desc = "A strange alien device."
		if(prob(25))
			my_effect.trigger = rand(1, 4)

/obj/machinery/artifact/process()
	var/turf/L = loc
	if(isnull(L) || !istype(L)) 	// We're inside a container or on null turf, either way stop processing effects
		return

	if(my_effect)
		my_effect.process()
	if(secondary_effect)
		secondary_effect.process()

	if(pulledby)
		Bumped(pulledby)

	//if either of our effects rely on environmental factors, work that out
	var/trigger_cold = 0
	var/trigger_hot = 0
	var/trigger_plasma = 0
	var/trigger_oxy = 0
	var/trigger_co2 = 0
	var/trigger_nitro = 0
	if((my_effect.trigger >= TRIGGER_HEAT && my_effect.trigger <= TRIGGER_NITRO) || (my_effect.trigger >= TRIGGER_HEAT && my_effect.trigger <= TRIGGER_NITRO))
		var/turf/T = GET_TURF(src)
		var/datum/gas_mixture/env = T.return_air()
		if(env)
			if(env.temperature < 225)
				trigger_cold = 1
			else if(env.temperature > 375)
				trigger_hot = 1

			if(env.gas[/decl/xgm_gas/plasma] >= 10)
				trigger_plasma = 1
			if(env.gas[/decl/xgm_gas/oxygen] >= 10)
				trigger_oxy = 1
			if(env.gas[/decl/xgm_gas/carbon_dioxide] >= 10)
				trigger_co2 = 1
			if(env.gas[/decl/xgm_gas/nitrogen] >= 10)
				trigger_nitro = 1

	//COLD ACTIVATION
	if(trigger_cold)
		if(my_effect.trigger == TRIGGER_COLD && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_COLD && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)
	else
		if(my_effect.trigger == TRIGGER_COLD && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_COLD && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)

	//HEAT ACTIVATION
	if(trigger_hot)
		if(my_effect.trigger == TRIGGER_HEAT && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_HEAT && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)
	else
		if(my_effect.trigger == TRIGGER_HEAT && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_HEAT && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)

	//PLASMA GAS ACTIVATION
	if(trigger_plasma)
		if(my_effect.trigger == TRIGGER_PLASMA && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_PLASMA && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)
	else
		if(my_effect.trigger == TRIGGER_PLASMA && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_PLASMA && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)

	//OXYGEN GAS ACTIVATION
	if(trigger_oxy)
		if(my_effect.trigger == TRIGGER_OXY && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_OXY && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)
	else
		if(my_effect.trigger == TRIGGER_OXY && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_OXY && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)

	//CO2 GAS ACTIVATION
	if(trigger_co2)
		if(my_effect.trigger == TRIGGER_CO2 && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_CO2 && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)
	else
		if(my_effect.trigger == TRIGGER_CO2 && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_CO2 && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)

	//NITROGEN GAS ACTIVATION
	if(trigger_nitro)
		if(my_effect.trigger == TRIGGER_NITRO && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_NITRO && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)
	else
		if(my_effect.trigger == TRIGGER_NITRO && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_NITRO && !secondary_effect.activated)
			secondary_effect.ToggleActivate(0)

/obj/machinery/artifact/attack_hand(mob/user)
	if(get_dist(user, src) > 1)
		to_chat(user, SPAN_WARNING("You can't reach [src] from here."))
		return
	if(ishuman(user) && user:gloves)
		to_chat(user, "<b>You touch [src]</b> with your gloved hands, [pick("but nothing of note happens", "but nothing happens", "but nothing interesting happens", "but you notice nothing different", "but nothing seems to have happened")].")
		return

	src.add_fingerprint(user)

	if(my_effect.trigger == TRIGGER_TOUCH)
		to_chat(user, "<b>You touch [src].<b>")
		my_effect.ToggleActivate()
	else
		to_chat(user, "<b>You touch [src],</b> [pick("but nothing of note happens", "but nothing happens", "but nothing interesting happens", "but you notice nothing different", "but nothing seems to have happened")].")

	if(prob(25) && secondary_effect && secondary_effect.trigger == TRIGGER_TOUCH)
		secondary_effect.ToggleActivate(0)

	if(my_effect.effect == EFFECT_TOUCH)
		my_effect.DoEffectTouch(user)

	if(secondary_effect && secondary_effect.effect == EFFECT_TOUCH && secondary_effect.activated)
		secondary_effect.DoEffectTouch(user)

/obj/machinery/artifact/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/reagent_holder))
		if(W.reagents.has_reagent("hydrogen", 1) || W.reagents.has_reagent("water", 1))
			if(my_effect.trigger == TRIGGER_WATER)
				my_effect.ToggleActivate()
			if(secondary_effect && secondary_effect.trigger == TRIGGER_WATER && prob(25))
				secondary_effect.ToggleActivate(0)
		else if(W.reagents.has_reagent("acid", 1) || W.reagents.has_reagent("pacid", 1) || W.reagents.has_reagent("diethylamine", 1))
			if(my_effect.trigger == TRIGGER_ACID)
				my_effect.ToggleActivate()
			if(secondary_effect && secondary_effect.trigger == TRIGGER_ACID && prob(25))
				secondary_effect.ToggleActivate(0)
		else if(W.reagents.has_reagent("plasma", 1) || W.reagents.has_reagent("thermite", 1))
			if(my_effect.trigger == TRIGGER_VOLATILE)
				my_effect.ToggleActivate()
			if(secondary_effect && secondary_effect.trigger == TRIGGER_VOLATILE && prob(25))
				secondary_effect.ToggleActivate(0)
		else if(W.reagents.has_reagent("toxin", 1) || W.reagents.has_reagent("cyanide", 1) || W.reagents.has_reagent("amanitin", 1) || W.reagents.has_reagent("neurotoxin", 1))
			if(my_effect.trigger == TRIGGER_TOXIN)
				my_effect.ToggleActivate()
			if(secondary_effect && secondary_effect.trigger == TRIGGER_TOXIN && prob(25))
				secondary_effect.ToggleActivate(0)
	else if(istype(W,/obj/item/melee/baton) && W:status ||\
			istype(W,/obj/item/melee/energy) ||\
			istype(W,/obj/item/melee/cultblade) ||\
			istype(W,/obj/item/card/emag) ||\
			ismultitool(W))
		if(my_effect.trigger == TRIGGER_ENERGY)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_ENERGY && prob(25))
			secondary_effect.ToggleActivate(0)

	else if(istype(W,/obj/item/match) && W:lit ||\
			iswelder(W) && W:welding ||\
			istype(W,/obj/item/lighter) && W:lit)
		if(my_effect.trigger == TRIGGER_HEAT)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_HEAT && prob(25))
			secondary_effect.ToggleActivate(0)
	else
		..()
		if(my_effect.trigger == TRIGGER_FORCE && W.force >= 10)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_FORCE && prob(25))
			secondary_effect.ToggleActivate(0)

/obj/machinery/artifact/Bumped(atom/movable/M)
	..()
	if(isobj(M))
		if(M:throwforce >= 10)
			if(my_effect.trigger == TRIGGER_FORCE)
				my_effect.ToggleActivate()
			if(secondary_effect && secondary_effect.trigger == TRIGGER_FORCE && prob(25))
				secondary_effect.ToggleActivate(0)
	else if(ishuman(M) && !istype(M:gloves, /obj/item/clothing/gloves))
		var/warn = 0

		if(my_effect.trigger == TRIGGER_TOUCH && prob(50))
			my_effect.ToggleActivate()
			warn = 1
		if(secondary_effect && secondary_effect.trigger == TRIGGER_TOUCH && prob(25))
			secondary_effect.ToggleActivate(0)
			warn = 1

		if(my_effect.effect == EFFECT_TOUCH && prob(50))
			my_effect.DoEffectTouch(M)
			warn = 1
		if(secondary_effect && secondary_effect.effect == EFFECT_TOUCH && secondary_effect.activated && prob(50))
			secondary_effect.DoEffectTouch(M)
			warn = 1

		if(warn)
			to_chat(M, "<b>You accidentally touch [src].<b>")
	..()

/obj/machinery/artifact/bullet_act(obj/item/projectile/P)
	if(istype(P,/obj/item/projectile/bullet) ||\
		istype(P,/obj/item/projectile/hivebotbullet))
		if(my_effect.trigger == TRIGGER_FORCE)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_FORCE && prob(25))
			secondary_effect.ToggleActivate(0)

	else if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/ion))
		if(my_effect.trigger == TRIGGER_ENERGY)
			my_effect.ToggleActivate()
		if(secondary_effect && secondary_effect.trigger == TRIGGER_ENERGY && prob(25))
			secondary_effect.ToggleActivate(0)

/obj/machinery/artifact/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
			else
				if(my_effect.trigger == TRIGGER_FORCE || my_effect.trigger == TRIGGER_HEAT)
					my_effect.ToggleActivate()
				if(secondary_effect && (secondary_effect.trigger == TRIGGER_FORCE || secondary_effect.trigger == TRIGGER_HEAT) && prob(25))
					secondary_effect.ToggleActivate(0)
		if(3.0)
			if(my_effect.trigger == TRIGGER_FORCE || my_effect.trigger == TRIGGER_HEAT)
				my_effect.ToggleActivate()
			if(secondary_effect && (secondary_effect.trigger == TRIGGER_FORCE || secondary_effect.trigger == TRIGGER_HEAT) && prob(25))
				secondary_effect.ToggleActivate(0)
	return

/obj/machinery/artifact/Move()
	..()
	if(my_effect)
		my_effect.UpdateMove()
	if(secondary_effect)
		secondary_effect.UpdateMove()