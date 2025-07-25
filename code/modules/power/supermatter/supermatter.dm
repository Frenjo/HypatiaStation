#define NITROGEN_RETARDATION_FACTOR 4		//Higher == N2 slows reaction more
//#define THERMAL_RELEASE_MODIFIER 10				//Higher == less heat released during reaction
#define THERMAL_RELEASE_MODIFIER 750
#define PLASMA_RELEASE_MODIFIER 1500				//Higher == less plasma released by reaction
#define OXYGEN_RELEASE_MODIFIER 750			//Higher == less oxygen released at high temperature/power
#define REACTION_POWER_MODIFIER 1.1					//Higher == more overall power

//These would be what you would get at point blank, decreases with distance
#define DETONATION_RADS 200
#define DETONATION_HALLUCINATION 600

#define WARNING_DELAY 30		//seconds between warnings.

/obj/machinery/power/supermatter
	name = "supermatter"
	desc = "A strangely translucent and iridescent crystal. \red You get headaches just from looking at it."
	icon = 'icons/obj/engine.dmi'
	icon_state = "darkmatter"

	density = TRUE
	anchored = TRUE

	//luminosity = 4
	light_range = 4
	light_color = "#8A8A00"

	var/gasefficency = 0.25

	var/base_icon_state = "darkmatter"

	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystalline hyperstructure returning to safe operating levels." // Fix a spelling mistake. -Frenjo
	var/warning_point = 100
	var/warning_alert = "Warning! Crystal hyperstructure instability!"
	var/emergency_point = 700
	var/emergency_alert = "DANGER! CRYSTAL DELAMINATION IMMINENT!"// Make this a bit more desperate sounding. -Frenjo
	var/explosion_point = 1000

	var/warning_color = "#B8B800"
	var/emergency_color = "#D9D900"

	var/emergency_issued = 0

	var/explosion_power = 8

	var/lastwarning = 0							// Time in 1/10th of seconds since the last sent warning
	var/power = 0

	var/oxygen = 0					// Moving this up here for easier debugging.

	//Temporary values so that we can optimize this
	//How much the bullets damage should be multiplied by when it is added to the internal variables
	var/config_bullet_energy = 2
	//How much of the power is left after processing is finished?
//	var/config_power_reduction_per_tick = 0.5
	//How much hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.1

	var/obj/item/radio/radio

/obj/machinery/power/supermatter/shard //Small subtype, less efficient and more sensitive, but less boom.
	name = "Supermatter Shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. \red You get headaches just from looking at it."
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

	warning_point = 50
	emergency_point = 500
	explosion_point = 900

	gasefficency = 0.125

	explosion_power = 3 //3,6,9,12? Or is that too small?


/obj/machinery/power/supermatter/initialise()
	. = ..()
	radio = new /obj/item/radio(src)

/obj/machinery/power/supermatter/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/machinery/power/supermatter/proc/explode()
	explosion(GET_TURF(src), explosion_power, explosion_power * 2, explosion_power * 3, explosion_power * 4, 1)
	qdel(src)

/obj/machinery/power/supermatter/proc/shift_light(lum, clr)
	if(lum != light_range || clr != light_color)
		set_light(lum, l_color = clr)

/obj/machinery/power/supermatter/process()
	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return  //Yeah just stop.

	if(isspace(L))	// Stop processing this stuff if we've been ejected.
		return

	if(damage > warning_point)	// while the core is still damaged and it's still worth noting its status
		shift_light(5, warning_color)
		if((world.timeofday - lastwarning) / 10 >= WARNING_DELAY)
			var/stability = num2text(round((damage / explosion_point) * 100))

			if(damage > emergency_point)
				shift_light(7, emergency_color)
				radio.autosay(addtext(emergency_alert, " Instability: ", stability, "%"), "Supermatter Monitor")
				world << sound('sound/effects/siren_shortened.ogg', volume = 100) // Play a sound if shit's fucked, yo. -Frenjo
				lastwarning = world.timeofday

			else if(damage >= damage_archived)	// The damage is still going up
				radio.autosay(addtext(warning_alert, " Instability: ", stability, "%"), "Supermatter Monitor")
				lastwarning = world.timeofday - 150

			else	 // Phew, we're safe
				shift_light(4, initial(light_color))
				radio.autosay(safe_alert, "Supermatter Monitor")
				lastwarning = world.timeofday

		if(damage > explosion_point)
			for(var/mob/living/mob in GLOBL.living_mob_list)
				if(loc.z == mob.loc.z)
					if(ishuman(mob))
						//Hilariously enough, running into a closet should make you get hit the hardest.
						mob.hallucination += max(50, min(300, DETONATION_HALLUCINATION * sqrt(1 / (get_dist(mob, src) + 1))))
					var/rads = DETONATION_RADS * sqrt(1 / (get_dist(mob, src) + 1))
					mob.apply_effect(rads, IRRADIATE)

			explode()

	//Ok, get the air from the turf
	var/datum/gas_mixture/env = L.return_air()

	//Remove gas from surrounding area
	var/datum/gas_mixture/removed = env.remove(gasefficency * env.total_moles)

	if(!removed || !removed.total_moles)
		damage += max((power - 1600) / 10, 0)
		power = min(power, 1600)
		return 1

	if(isnull(removed))
		return 1

	damage_archived = damage
	damage = max(damage + ((removed.temperature - 800) / 150) , 0)
	//Ok, 100% oxygen atmosphere = best reaction
	//Maxes out at 100% oxygen pressure
	oxygen = max(min((removed.gas[/decl/xgm_gas/oxygen] - (removed.gas[/decl/xgm_gas/nitrogen] * NITROGEN_RETARDATION_FACTOR)) / MOLES_CELLSTANDARD, 1), 0)

	var/temp_factor = 100

	if(oxygen > 0.8)
		// with a perfect gas mix, make the power less based on heat
		icon_state = "[base_icon_state]_glow"
	else
		// in normal mode, base the produced energy around the heat
		temp_factor = 60
		icon_state = base_icon_state

	power = max((removed.temperature * temp_factor / T0C) * oxygen + power, 0) //Total laser power plus an overload

	//We've generated power, now let's transfer it to the collectors for storing/usage
	transfer_energy()

	var/device_energy = power * REACTION_POWER_MODIFIER

	//To figure out how much temperature to add each tick, consider that at one atmosphere's worth
	//of pure oxygen, with all four lasers firing at standard energy and no N2 present, at room temperature
	//that the device energy is around 2140. At that stage, we don't want too much heat to be put out
	//Since the core is effectively "cold"

	//Also keep in mind we are only adding this temperature to (efficiency)% of the one tile the rock
	//is on. An increase of 4*C @ 25% efficiency here results in an increase of 1*C / (#tilesincore) overall.
	//removed.temperature += (device_energy / THERMAL_RELEASE_MODIFIER)
	var/thermal_power = THERMAL_RELEASE_MODIFIER
	removed.add_thermal_energy(device_energy * thermal_power)

	removed.temperature = max(0, min(removed.temperature, 2500))

	//Calculate how much gas to release
	removed.adjust_multi(
		/decl/xgm_gas/plasma, max(device_energy / PLASMA_RELEASE_MODIFIER, 0),
		/decl/xgm_gas/oxygen, max((device_energy + removed.temperature - T0C) / OXYGEN_RELEASE_MODIFIER, 0)
	)

	removed.update_values()

	env.merge(removed)

	for(var/mob/living/carbon/human/l in view(src, min(7, round(power ** 0.25)))) // If they can see it without mesons on.  Bad on them.
		if(!istype(l.glasses, /obj/item/clothing/glasses/meson))
			l.hallucination = max(0, min(200, l.hallucination + power * config_hallucination_power * sqrt(1 / max(1, get_dist(l, src)))))

	for(var/mob/living/l in range(src, round((power / 100) ** 0.25)))
		var/rads = (power / 10) * sqrt(1 / get_dist(l, src))
		l.apply_effect(rads, IRRADIATE)

	power -= (power / 500) ** 3

	return 1

/obj/machinery/power/supermatter/bullet_act(obj/item/projectile/proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0	// This stops people from being able to really power up the supermatter
				// Then bring it inside to explode instantly upon landing on a valid turf.

	if(proj.flag != "bullet")
		power += proj.damage * config_bullet_energy
	else
		damage += proj.damage * config_bullet_energy
	return 0

/obj/machinery/power/supermatter/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/power/supermatter/attack_robot(mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	else
		to_chat(user, SPAN_WARNING("You attempt to interface with the control circuits but find they are not connected to your network. Maybe in a future firmware update."))

/obj/machinery/power/supermatter/attack_ai(mob/user)
	to_chat(user, SPAN_WARNING("You attempt to interface with the control circuits but find they are not connected to your network. Maybe in a future firmware update."))

/obj/machinery/power/supermatter/attack_hand(mob/user)
	user.visible_message(
		SPAN_WARNING("The [user] reaches out and touches \the [src], inducing a resonance... \his body starts to glow and bursts into flames before flashing into ash."),
		SPAN_DANGER("You reach out and touch \the [src]. Everything starts burning and all you can hear is ringing. Your last thought is \"That was not a wise decision.\""),
		SPAN_WARNING("You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.")
	)

	Consume(user)

/obj/machinery/power/supermatter/proc/transfer_energy()
	for(var/obj/machinery/power/rad_collector/R in GLOBL.rad_collectors)
		if(get_dist(R, src) <= 15) // Better than using orange() every process
			R.receive_pulse(power)

/obj/machinery/power/supermatter/attackby(obj/item/W, mob/living/user)
	user.visible_message(
		SPAN_WARNING("\The [user] touches \a [W] to \the [src] as a silence fills the room..."),
		//"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>"
		// Not sure if this is a valid replacement for this? But I mean, it compiles so... -Frenjo
		SPAN_DANGER("You touch \the [W] to \the [src] when everything suddenly goes silent.") + "\n" + SPAN_NOTICE("\The [W] flashes into dust as you flinch away from \the [src]."),
		SPAN_WARNING("Everything suddenly goes silent.")
	)

	user.drop_from_inventory(W)
	Consume(W)

	user.apply_effect(150, IRRADIATE)

/obj/machinery/power/supermatter/Bumped(atom/movable/AM)
	if(isliving(AM))
		AM.visible_message(
			SPAN_WARNING("\The [AM] slams into \the [src] inducing a resonance... \his body starts to glow and catch flame before flashing into ash."),
			SPAN_DANGER("You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\""),
			SPAN_WARNING("You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.")
		)
	else
		AM.visible_message(
			SPAN_WARNING("\The [AM] smacks into \the [src] and rapidly flashes to ash."),
			SPAN_WARNING("You hear a loud crack as you are washed with a wave of heat.")
		)

	Consume(AM)

/obj/machinery/power/supermatter/proc/Consume(mob/living/user)
	if(istype(user))
		user.dust()
		power += 200
	else
		qdel(user)

	power += 200

	//Some poor sod got eaten, go ahead and irradiate people nearby.
	for(var/mob/living/l in range(10))
		if(l in view())
			l.show_message(
				SPAN_WARNING("As \the [src] slowly stops resonating, you find your skin covered in new radiation burns."), 1,
				SPAN_WARNING("The unearthly ringing subsides and you notice you have new radiation burns."), 2
			)
		else
			l.show_message(SPAN_WARNING("You hear an uneartly ringing and notice your skin is covered in fresh radiation burns."), 2)
		var/rads = 500 * sqrt(1 / (get_dist(l, src) + 1))
		l.apply_effect(rads, IRRADIATE)

#undef WARNING_DELAY

#undef DETONATION_RADS
#undef DETONATION_HALLUCINATION

#undef NITROGEN_RETARDATION_FACTOR
#undef THERMAL_RELEASE_MODIFIER
#undef PLASMA_RELEASE_MODIFIER
#undef OXYGEN_RELEASE_MODIFIER
#undef REACTION_POWER_MODIFIER