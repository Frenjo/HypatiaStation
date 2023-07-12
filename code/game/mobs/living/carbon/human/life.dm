//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
//#define HUMAN_CRIT_MAX_OXYLOSS ( (last_tick_duration) /5) //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 100HP to get through, so (1/3)*last_tick_duration per second. Breaths however only happen every 4 ticks.
#define HUMAN_CRIT_MAX_OXYLOSS ((global.PCticker.getLastTickerTimeDuration()) / 5)

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

/mob/living/carbon/human
	var/oxygen_alert = 0
	var/toxins_alert = 0
	var/co2_alert = 0
	var/fire_alert = 0
	var/pressure_alert = 0
	//var/prev_gender = null // Debug for plural genders
	var/temperature_alert = 0
	var/in_stasis = 0

/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	// This duplicates some checks that are found later on (. = ..()) but it's necessary to prevent...
	// ... the blinded, fire_alert, life_tick and in_stasis variables being updated when they shouldn't be.
	if(isnull(loc))
		return
	if(monkeyizing)
		return

	/*
	//This code is here to try to determine what causes the gender switch to plural error. Once the error is tracked down and fixed, this code should be deleted
	//Also delete var/prev_gender once this is removed.
	if(prev_gender != gender)
		prev_gender = gender
		if(gender in list(PLURAL, NEUTER))
			message_admins("[src] ([ckey]) gender has been changed to plural or neuter. Please record what has happened recently to the person and then notify coders. (<A HREF='?_src_=holder;adminmoreinfo=\ref[src]'>?</A>)  (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?priv_msg=\ref[src]'>PM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[src]'>JMP</A>)")
	*/
	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = null
	fire_alert = 0 //Reset this here, because both breathe() and handle_environment() have a chance to set it.

	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++

	in_stasis = istype(loc, /obj/structure/closet/body_bag/cryobag) && loc:opened == 0
	if(in_stasis)
		loc:used++

	// This is here due to the wonky way that blinded, fire_alert and in_stasis are set.
	. = ..()

	if(life_tick % 30 == 15)
		hud_updateflag = 1022

	voice = GetVoice()

	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD && !in_stasis)
		if(global.CTair_system.current_cycle % 4 == 2 || failed_last_breath) 	//First, resolve location and get a breath
			breathe() 				//Only try to take a breath every 4 ticks, unless suffocating

		else //Still give containing object the chance to interact
			if(isobj(loc))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)

		//Updates the number of stored chemicals for powers
		handle_changeling()

		//Chemicals in the body
		handle_chemicals_in_body()

		//Disabilities
		handle_disabilities()

		//Random events (vomiting etc)
		handle_random_events()

		handle_virus_updates()

		//stuff in the stomach
		handle_stomach()

		handle_shock()

		handle_pain()

		handle_medical_side_effects()

	handle_stasis_bag()

	if(life_tick > 5 && timeofdeath && (timeofdeath < 5 || world.time - timeofdeath > 6000))	//We are long dead, or we're junk mobs spawned like the clowns on the clown shuttle
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Check if we're on fire
	handle_fire()

	//Status updates, death etc.
	handle_regular_status_updates()		//Optimized a bit
	update_canmove()

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	handle_regular_hud_updates()

	pulse = handle_pulse()

	// Grabbing
	for(var/obj/item/weapon/grab/G in src)
		G.process()

/mob/living/carbon/human/handle_mutations_and_radiation()
	if(species.flags & IS_SYNTHETIC) //Robots don't suffer from mutations or radloss.
		return
	if(in_stasis)
		return

	if(getFireLoss())
		if((COLD_RESISTANCE in mutations) || prob(1))
			heal_organ_damage(0, 1)

	// DNA2 - Gene processing.
	// The HULK stuff that was here is now in the hulk gene.
	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			speech_problem_flag = 1
			gene.OnMobLife(src)

	if(radiation)
		if(radiation > 100)
			radiation = 100
			Weaken(10)
			to_chat(src, SPAN_WARNING("You feel weak."))
			emote("collapse")

		if(radiation < 0)
			radiation = 0

		else
			if(species.flags & RAD_ABSORB)
				var/rads = radiation / 25
				radiation -= rads
				nutrition += rads
				adjustBruteLoss(-rads)
				adjustOxyLoss(-rads)
				adjustToxLoss(-rads)
				updatehealth()
				return

			var/damage = 0
			switch(radiation)
				if(1 to 49)
					radiation--
					if(prob(25))
						adjustToxLoss(1)
						damage = 1
						updatehealth()

				if(50 to 74)
					radiation -= 2
					damage = 1
					adjustToxLoss(1)
					if(prob(5))
						radiation -= 5
						Weaken(3)
						to_chat(src, SPAN_WARNING("You feel weak."))
						emote("collapse")
					updatehealth()

				if(75 to 100)
					radiation -= 3
					adjustToxLoss(3)
					damage = 1
					if(prob(1))
						to_chat(src, SPAN_WARNING("You mutate!"))
						randmutb(src)
						domutcheck(src, null)
						emote("gasp")
					updatehealth()

			if(damage && length(organs))
				var/datum/organ/external/O = pick(organs)
				if(istype(O))
					O.add_autopsy_data("Radiation Poisoning", damage)

/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	if(isnull(environment))
		return

	//Stuff like the xenomorph's plasma regen happens here.
	species.handle_environment_special(src)

	//Moved pressure calculations here for use in skip-processing check.
	var/pressure = environment.return_pressure()
	var/adjusted_pressure = calculate_affecting_pressure(pressure) //Returns how much pressure actually affects the mob.

	if(!isspace(get_turf(src))) //space is not meant to change your body temperature.
		var/loc_temp = T0C
		if(ismecha(loc))
			var/obj/mecha/M = loc
			loc_temp = M.return_temperature()
		else if(isspace(get_turf(src)))
		else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/cell = loc
			loc_temp = cell.air_contents.temperature
		else
			loc_temp = environment.temperature

		if(adjusted_pressure < species.warning_high_pressure && adjusted_pressure > species.warning_low_pressure && abs(loc_temp - bodytemperature) < 20 && bodytemperature < species.heat_level_1 && bodytemperature > species.cold_level_1)
			return // Temperatures are within normal ranges, fuck all this processing. ~Ccomp

		//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection
		var/temp_adj = 0
		if(loc_temp < bodytemperature)			//Place is colder than we are
			var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1 - thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
		else if(loc_temp > bodytemperature)			//Place is hotter than we are
			var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1 - thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

		//Use heat transfer as proportional to the gas density. However, we only care about the relative density vs standard 101 kPa/20 C air. Therefore we can use mole ratios
		var/relative_density = environment.total_moles / MOLES_CELLSTANDARD
		temp_adj *= relative_density

		if(temp_adj > BODYTEMP_HEATING_MAX)
			temp_adj = BODYTEMP_HEATING_MAX
		if(temp_adj < BODYTEMP_COOLING_MAX)
			temp_adj = BODYTEMP_COOLING_MAX
		//to_world("Environment: [loc_temp], [src]: [bodytemperature], Adjusting: [temp_adj]")
		bodytemperature += temp_adj

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature > species.heat_level_1)
		//Body temperature is too hot.
		fire_alert = max(fire_alert, 1)
		if(status_flags & GODMODE)
			return 1	//godmode

		var/burn_damage = 0
		if(bodytemperature < species.heat_level_2)
			burn_damage = HEAT_DAMAGE_LEVEL_1
		else if(bodytemperature < species.heat_level_3)
			burn_damage = HEAT_DAMAGE_LEVEL_2
		else
			burn_damage = HEAT_DAMAGE_LEVEL_3
		take_overall_damage(burn = burn_damage, used_weapon = "High Body Temperature")
		fire_alert = max(fire_alert, 2)

	else if(bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
		fire_alert = max(fire_alert, 1)
		if(status_flags & GODMODE)
			return 1	//godmode

		if(!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/burn_damage = 0
			if(bodytemperature < species.cold_level_2)
				burn_damage = COLD_DAMAGE_LEVEL_1
			else if(bodytemperature < species.cold_level_3)
				burn_damage = COLD_DAMAGE_LEVEL_2
			else
				burn_damage = COLD_DAMAGE_LEVEL_3
			take_overall_damage(burn = burn_damage, used_weapon = "Low Body Temperature")
			fire_alert = max(fire_alert, 1)

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
	if(status_flags & GODMODE)
		return 1	//godmode

	if(adjusted_pressure >= species.hazard_high_pressure)
		var/pressure_damage = min(((adjusted_pressure / species.hazard_high_pressure) - 1) * PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE)
		take_overall_damage(brute = pressure_damage, used_weapon = "High Pressure")
		pressure_alert = 2
	else if(adjusted_pressure >= species.warning_high_pressure)
		pressure_alert = 1
	else if(adjusted_pressure >= species.warning_low_pressure)
		pressure_alert = 0
	else if(adjusted_pressure >= species.hazard_low_pressure)
		pressure_alert = -1

		if(!(COLD_RESISTANCE in mutations))
			take_overall_damage(brute = LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
			pressure_alert = -2
		else
			pressure_alert = -1

	for(var/g in environment.gas)
		if(GLOBL.gas_data.flags[g] & XGM_GAS_CONTAMINANT && environment.gas[g] > GLOBL.gas_data.overlay_limit[g] + 1)
			pl_effects()
			break
	return

/mob/living/carbon/human/calculate_affecting_pressure(pressure)
	..()
	var/pressure_difference = abs(pressure - ONE_ATMOSPHERE)
	var/pressure_adjustment_coefficient = 1	//Determins how much the clothing you are wearing protects you in percent.

	if(head?.flags & STOPSPRESSUREDAMAGE)
		pressure_adjustment_coefficient -= PRESSURE_HEAD_REDUCTION_COEFFICIENT

	if(wear_suit?.flags & STOPSPRESSUREDAMAGE)
		pressure_adjustment_coefficient -= PRESSURE_SUIT_REDUCTION_COEFFICIENT

		//Handles breaches in your space suit. 10 suit damage equals a 100% loss of pressure reduction.
		if(istype(wear_suit, /obj/item/clothing/suit/space))
			var/obj/item/clothing/suit/space/S = wear_suit
			if(S.can_breach && S.damage)
				var/pressure_loss = S.damage * 0.1
				pressure_adjustment_coefficient += pressure_loss

	pressure_adjustment_coefficient = min(1, max(pressure_adjustment_coefficient, 0)) //So it isn't less than 0 or larger than 1.

	pressure_difference = pressure_difference * pressure_adjustment_coefficient

	if(pressure > ONE_ATMOSPHERE)
		return ONE_ATMOSPHERE + pressure_difference
	else
		return ONE_ATMOSPHERE - pressure_difference

/mob/living/carbon/human/proc/handle_disabilities()
	if(disabilities & EPILEPSY)
		if(prob(1) && paralysis < 1)
			visible_message(
				SPAN_DANGER("[src] starts having a seizure!"),
				SPAN_WARNING("You have a seizure!")
			)
			Paralyse(10)
			make_jittery(1000)
	if(disabilities & COUGHING)
		if(prob(5) && paralysis <= 1)
			drop_item()
			spawn(0)
				emote("cough")
				return
	if(disabilities & TOURETTES)
		speech_problem_flag = 1
		if(prob(10) && paralysis <= 1)
			Stun(10)
			spawn(0)
				switch(rand(1, 3))
					if(1)
						emote("twitch")
					if(2 to 3)
						say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
				var/old_x = pixel_x
				var/old_y = pixel_y
				pixel_x += rand(-2, 2)
				pixel_y += rand(-1, 1)
				sleep(2)
				pixel_x = old_x
				pixel_y = old_y
				return
	if(disabilities & NERVOUS)
		speech_problem_flag = 1
		if(prob(10))
			stuttering = max(10, stuttering)
	// No. -- cib
	/*if (getBrainLoss() >= 60 && stat != 2)
		if (prob(3))
			switch(pick(1,2,3))
				if(1)
					say(pick("IM A PONY NEEEEEEIIIIIIIIIGH", "without oxigen blob don't evoluate?", "CAPTAINS A COMDOM", "[pick("", "that meatball traitor")] [pick("joerge", "george", "gorge", "gdoruge")] [pick("mellens", "melons", "mwrlins")] is grifing me HAL;P!!!", "can u give me [pick("telikesis","halk","eppilapse")]?", "THe saiyans screwed", "Bi is THE BEST OF BOTH WORLDS>", "I WANNA PET TEH monkeyS", "stop grifing me!!!!", "SOTP IT#"))
				if(2)
					say(pick("FUS RO DAH","fucking 4rries!", "stat me", ">my face", "roll it easy!", "waaaaaagh!!!", "red wonz go fasta", "FOR TEH EMPRAH", "lol2cat", "dem dwarfs man, dem dwarfs", "SPESS MAHREENS", "hwee did eet fhor khayosss", "lifelike texture ;_;", "luv can bloooom", "PACKETS!!!"))
				if(3)
					emote("drool")
	*/

	if(stat != DEAD)
		var/rn = rand(0, 200)
		if(getBrainLoss() >= 5)
			if(0 <= rn && rn <= 3)
				custom_pain("Your head feels numb and painful.")
		if(getBrainLoss() >= 15)
			if(4 <= rn && rn <= 6)
				if(eye_blurry <= 0)
					to_chat(src, SPAN_WARNING("It becomes hard to see for some reason."))
					eye_blurry = 10
		if(getBrainLoss() >= 35)
			if(7 <= rn && rn <= 9)
				if(hand && equipped())
					to_chat(src, "Your hand won't respond properly, you drop what you're holding.")
					drop_item()
		if(getBrainLoss() >= 50)
			if(10 <= rn && rn <= 12)
				if(!lying)
					to_chat(src, SPAN_WARNING("Your legs won't respond properly, you fall down."))
					resting = 1

/mob/living/carbon/human/proc/handle_stasis_bag()
	// Handle side effects from stasis bag
	if(in_stasis)
		// First off, there's no oxygen supply, so the mob will slowly take brain damage
		adjustBrainLoss(0.1)

		// Next, the method to induce stasis has some adverse side-effects, manifesting
		// as cloneloss
		adjustCloneLoss(0.1)

/mob/living/carbon/human/proc/breathe()
	if(reagents.has_reagent("lexorin"))
		return
	if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
		return
	if(isnotnull(species) && (species.flags & NO_BREATHE || species.flags & IS_SYNTHETIC))
		return

	var/datum/gas_mixture/environment = loc.return_air()
	var/datum/gas_mixture/breath

	// HACK NEED CHANGING LATER
	if(health < CONFIG_GET(health_threshold_crit))
		losebreath++

	if(losebreath > 0) //Suffocating so do not take a breath
		losebreath--
		if(prob(10)) //Gasp per 10 ticks? Sounds about right.
			spawn()
				emote("gasp")
		if(isobj(loc))
			var/obj/location_as_object = loc
			location_as_object.handle_internal_lifeform(src, 0)
	else
		//First, check for air from internal atmosphere (using an air tank and mask generally)
		breath = get_breath_from_internal(BREATH_VOLUME) // Super hacky -- TLE
		//breath = get_breath_from_internal(0.5) // Manually setting to old BREATH_VOLUME amount -- TLE

		//No breath from internal atmosphere so get breath from location
		if(!breath)
			if(isobj(loc))
				var/obj/location_as_object = loc
				breath = location_as_object.handle_internal_lifeform(src, BREATH_MOLES)
			else if(isturf(loc))
				var/breath_moles = 0
				/*if(environment.return_pressure() > ONE_ATMOSPHERE)
					// Loads of air around (pressure effect will be handled elsewhere), so lets just take a enough to fill our lungs at normal atmos pressure (using n = Pv/RT)
					breath_moles = (ONE_ATMOSPHERE*BREATH_VOLUME/R_IDEAL_GAS_EQUATION*environment.temperature)
				else*/
					// Not enough air around, take a percentage of what's there to model this properly
				breath_moles = environment.total_moles * BREATH_PERCENTAGE

				breath = loc.remove_air(breath_moles)

				if(istype(wear_mask, /obj/item/clothing/mask) && breath)
					var/obj/item/clothing/mask/M = wear_mask
					var/datum/gas_mixture/filtered = M.filter_air(breath)
					loc.assume_air(filtered)

				if(!is_lung_ruptured())
					if(!breath || breath.total_moles < BREATH_MOLES / 5 || breath.total_moles > BREATH_MOLES * 5)
						if(prob(5))
							rupture_lung()

				// Handle filtering
				var/block = FALSE
				if(wear_mask?.flags & BLOCK_GAS_SMOKE_EFFECT)
					block = TRUE
				if(glasses?.flags & BLOCK_GAS_SMOKE_EFFECT)
					block = TRUE
				if(head?.flags & BLOCK_GAS_SMOKE_EFFECT)
					block = TRUE

				if(!block)
					for(var/obj/effect/smoke/chem/smoke in view(1, src))
						if(smoke.reagents.total_volume)
							smoke.reagents.reaction(src, INGEST)
							spawn(5)
								if(isnotnull(smoke))
									smoke.reagents.copy_to(src, 10) // I dunno, maybe the reagents enter the blood stream through the lungs?
							break // If they breathe in the nasty stuff once, no need to continue checking

		else //Still give containing object the chance to interact
			if(isobj(loc))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)

	handle_breath(breath)

	if(breath)
		loc.assume_air(breath)

		//spread some viruses while we are at it
		if(length(virus2))
			if(prob(10) && get_infection_chance(src))
//				log_debug("[src] : Exhaling some viruses")
				for(var/mob/living/carbon/M in view(1, src))
					spread_disease_to(M)


/mob/living/carbon/human/proc/get_breath_from_internal(volume_needed)
	if(isnotnull(internal))
		if(!contents.Find(internal))
			internal = null
		if(!wear_mask || !(wear_mask.flags & AIRTIGHT))
			internal = null
		if(internal)
			return internal.remove_air_volume(volume_needed)
		else if(internals)
			internals.icon_state = "internal0"
	return null


/mob/living/carbon/human/proc/handle_breath(datum/gas_mixture/breath)
	if(status_flags & GODMODE)
		return

	if(isnull(breath) || (breath.total_moles == 0) || suiciding)
		if(reagents.has_reagent("inaprovaline"))
			return

		if(suiciding)
			adjustOxyLoss(2)//If you are suiciding, you should die a little bit faster
			failed_last_breath = TRUE
			oxygen_alert = max(oxygen_alert, 1)
			return 0

		if(health > CONFIG_GET(health_threshold_crit))
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			failed_last_breath = TRUE
		else
			adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)
			failed_last_breath = TRUE

		oxygen_alert = max(oxygen_alert, 1)

		return 0

	var/safe_pressure_min = 16 // Minimum safe partial pressure of breathable gas (usually O2), in kPa
	//var/safe_oxygen_max = 140 // Maximum safe partial pressure of O2, in kPa (Not used for now)
	var/safe_exhaled_max = 10 // Yes it's an arbitrary value who cares?
	var/safe_toxins_max = 0.005
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/inhaled_gas_used = 0

	var/breath_pressure = (breath.total_moles * R_IDEAL_GAS_EQUATION * breath.temperature) / BREATH_VOLUME

	var/inhaling
	var/poison
	var/exhaling
	var/no_exhale = FALSE

	var/breath_type
	var/poison_type
	var/exhale_type

	var/failed_inhale = FALSE
	var/failed_exhale = FALSE

	if(isnotnull(species.breath_type))
		breath_type = species.breath_type
		inhaling = breath.gas[breath_type]
	else
		inhaling = /decl/xgm_gas/oxygen

	if(isnotnull(species.poison_type))
		poison_type = species.poison_type
		poison = breath.gas[poison_type]
	else
		poison = /decl/xgm_gas/plasma

	if(isnotnull(species.exhale_type))
		exhale_type = species.exhale_type
		exhaling = breath.gas[exhale_type]
	else
		no_exhale = TRUE

	var/inhale_pp = (inhaling / breath.total_moles) * breath_pressure
	var/toxins_pp = (poison / breath.total_moles) * breath_pressure
	var/exhaled_pp = (exhaling / breath.total_moles) * breath_pressure

	// Not enough to breathe
	if(inhale_pp < safe_pressure_min)
		if(prob(20))
			spawn(0)
				emote("gasp")
		if(inhale_pp > 0)
			var/ratio = inhale_pp/safe_pressure_min
			// Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
			// The hell? By definition ratio > 1, and HUMAN_MAX_OXYLOSS = 1... why do we even have this?
			adjustOxyLoss(min(5 * (1 - ratio), HUMAN_MAX_OXYLOSS))
			failed_inhale = TRUE
			inhaled_gas_used = inhaling * ratio / 6
		else
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			failed_inhale = TRUE

		oxygen_alert = max(oxygen_alert, 1)

	else
		// We're in safe limits
		inhaled_gas_used = inhaling / 6
		oxygen_alert = 0

	breath.adjust_gas(breath_type, -inhaled_gas_used)

	if(!no_exhale)
		breath.adjust_gas(exhale_type, inhaled_gas_used)

	// Too much exhaled gas in the air
	if(exhaled_pp > safe_exhaled_max)
		if(!co2_alert|| prob(15))
			var/word = pick("extremely dizzy", "short of breath", "faint", "confused")
			to_chat(src, SPAN_DANGER("You feel [word]."))

		adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		co2_alert = 1
		failed_exhale = TRUE

	else if(exhaled_pp > safe_exhaled_max * 0.7)
		if(!co2_alert || prob(1))
			var/word = pick("dizzy", "short of breath", "faint", "momentarily confused")
			to_chat(src, SPAN_WARNING("You feel [word]."))

		//scale linearly from 0 to 1 between safe_exhaled_max and safe_exhaled_max*0.7
		var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp) / (safe_exhaled_max * 0.3)

		//give them some oxyloss, up to the limit - we don't want people falling unconcious due to CO2 alone until they're pretty close to safe_exhaled_max.
		if(getOxyLoss() < 50 * ratio)
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		co2_alert = 1
		failed_exhale = TRUE

	else if(exhaled_pp > safe_exhaled_max * 0.6)
		if(prob(0.3))
			var/word = pick("a little dizzy", "short of breath")
			to_chat(src, SPAN_WARNING("You feel [word]."))

	else
		co2_alert = 0

	// Too much poison in the air.
	if(toxins_pp > safe_toxins_max)
		var/ratio = (poison/safe_toxins_max) * 10
		if(reagents)
			reagents.add_reagent("toxin", clamp(ratio, MIN_PLASMA_DAMAGE, MAX_PLASMA_DAMAGE))
		toxins_alert = max(toxins_alert, 1)
	else
		toxins_alert = 0

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas[/decl/xgm_gas/sleeping_agent])
		var/SA_pp = (breath.gas[/decl/xgm_gas/sleeping_agent] / breath.total_moles) * breath_pressure
		// Enough to make us paralysed for a bit
		if(SA_pp > SA_para_min)
			// 3 gives them one second to wake up and run away a bit!
			Paralyse(3)
			// Enough to make us sleep as well
			if(SA_pp > SA_sleep_min)
				sleeping = min(sleeping + 2, 10)
		// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
		else if(SA_pp > 0.15)
			if(prob(20))
				spawn(0)
					emote(pick("giggle", "laugh"))
		breath.adjust_gas(/decl/xgm_gas/sleeping_agent, -breath.gas[/decl/xgm_gas/sleeping_agent])

	// Were we able to breathe?
	if(failed_inhale || failed_exhale)
		failed_last_breath = TRUE
	else
		failed_last_breath = FALSE
		adjustOxyLoss(-5)

	// Hot air hurts :(
	if((breath.temperature < species.cold_level_1 || breath.temperature > species.heat_level_1) && !(COLD_RESISTANCE in mutations))
		if(status_flags & GODMODE)
			return 1

		var/damage = 0
		if(breath.temperature < species.cold_level_1)
			if(prob(20))
				to_chat(src, SPAN_DANGER("You feel your face freezing and icicles forming in your lungs!"))
			if(breath.temperature < species.cold_level_3)
				damage = COLD_GAS_DAMAGE_LEVEL_3
			else if(breath.temperature < species.cold_level_2)
				damage = COLD_GAS_DAMAGE_LEVEL_2
			else
				damage = COLD_GAS_DAMAGE_LEVEL_1
			apply_damage(damage, BURN, "Head", used_weapon = "Excessive Cold")
			fire_alert = max(fire_alert, 1)
		else if(breath.temperature > species.heat_level_1)
			if(prob(20))
				to_chat(src, SPAN_DANGER("You feel your face burning and a searing heat in your lungs!"))
			if(breath.temperature > species.heat_level_3)
				damage = HEAT_GAS_DAMAGE_LEVEL_3
			else if(breath.temperature > species.heat_level_2)
				damage = HEAT_GAS_DAMAGE_LEVEL_2
			else
				damage = HEAT_GAS_DAMAGE_LEVEL_1
			apply_damage(damage, BURN, "head", used_weapon = "Excessive Heat")
			fire_alert = max(fire_alert, 2)

		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - bodytemperature
		if(temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * BREATH_PERCENTAGE)
		temp_adj *= relative_density

		if(temp_adj > BODYTEMP_HEATING_MAX)
			temp_adj = BODYTEMP_HEATING_MAX
		if(temp_adj < BODYTEMP_COOLING_MAX)
			temp_adj = BODYTEMP_COOLING_MAX
		//to_world("Breath: [breath.temperature], [src]: [bodytemperature], Adjusting: [temp_adj]")
		bodytemperature += temp_adj
	return 1

/*
/mob/living/carbon/human/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how many increments apart they are
	if(difference > 50)
		increments = difference/5
	else
		increments = difference/10
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature = min(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature = max(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change
*/

/mob/living/carbon/human/proc/stabilize_body_temperature()
	if(species.flags & IS_SYNTHETIC)
		bodytemperature += species.synth_temp_gain		//just keep putting out heat.
		return

	var/body_temperature_difference = species.body_temperature - bodytemperature

	if(abs(body_temperature_difference) < 0.5)
		return //fuck this precision
	if(on_fire)
		return //too busy for pesky convection

	if(bodytemperature < species.cold_level_1) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
		if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
			nutrition -= 2
		var/recovery_amt = max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		//to_world("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
//		log_debug("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(species.cold_level_1 <= bodytemperature && bodytemperature <= species.heat_level_1)
		var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
		//to_world("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
//		log_debug("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(bodytemperature > species.heat_level_1) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
		//We totally need a sweat system cause it totally makes sense...~
		var/recovery_amt = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers
		//to_world("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
//		log_debug("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt

//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = 0
	//Handle normal clothing
	if(isnotnull(head))
		if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= head.heat_protection
	if(isnotnull(wear_suit))
		if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_suit.heat_protection
	if(isnotnull(w_uniform))
		if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= w_uniform.heat_protection
	if(isnotnull(shoes))
		if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= shoes.heat_protection
	if(isnotnull(gloves))
		if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= gloves.heat_protection
	if(isnotnull(wear_mask))
		if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_mask.heat_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)

	var/thermal_protection = 0.0
	if(isnotnull(thermal_protection_flags))
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & UPPER_TORSO)
			thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
		if(thermal_protection_flags & LOWER_TORSO)
			thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1, thermal_protection)

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	var/thermal_protection_flags = 0
	//Handle normal clothing

	if(isnotnull(head))
		if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= head.cold_protection
	if(isnotnull(wear_suit))
		if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_suit.cold_protection
	if(isnotnull(w_uniform))
		if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= w_uniform.cold_protection
	if(isnotnull(shoes))
		if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= shoes.cold_protection
	if(isnotnull(gloves))
		if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= gloves.cold_protection
	if(isnotnull(wear_mask))
		if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_mask.cold_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_cold_protection(temperature)
	if(COLD_RESISTANCE in mutations)
		return 1 //Fully protected from the cold.

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)

	var/thermal_protection = 0.0
	if(isnotnull(thermal_protection_flags))
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & UPPER_TORSO)
			thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
		if(thermal_protection_flags & LOWER_TORSO)
			thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1, thermal_protection)

/*
/mob/living/carbon/human/proc/add_fire_protection(var/temp)
	var/fire_prot = 0
	if(head)
		if(head.protective_temperature > temp)
			fire_prot += (head.protective_temperature/10)
	if(wear_mask)
		if(wear_mask.protective_temperature > temp)
			fire_prot += (wear_mask.protective_temperature/10)
	if(glasses)
		if(glasses.protective_temperature > temp)
			fire_prot += (glasses.protective_temperature/10)
	if(ears)
		if(ears.protective_temperature > temp)
			fire_prot += (ears.protective_temperature/10)
	if(wear_suit)
		if(wear_suit.protective_temperature > temp)
			fire_prot += (wear_suit.protective_temperature/10)
	if(w_uniform)
		if(w_uniform.protective_temperature > temp)
			fire_prot += (w_uniform.protective_temperature/10)
	if(gloves)
		if(gloves.protective_temperature > temp)
			fire_prot += (gloves.protective_temperature/10)
	if(shoes)
		if(shoes.protective_temperature > temp)
			fire_prot += (shoes.protective_temperature/10)

	return fire_prot

/mob/living/carbon/human/proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
	if(nodamage)
		return
	//world <<"body_part = [body_part], exposed_temperature = [exposed_temperature], exposed_intensity = [exposed_intensity]"
	var/discomfort = min(abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)

	if(exposed_temperature > bodytemperature)
		discomfort *= 4

	if(mutantrace == "plant")
		discomfort *= TEMPERATURE_DAMAGE_COEFFICIENT * 2 //I don't like magic numbers. I'll make mutantraces a datum with vars sometime later. -- Urist
	else
		discomfort *= TEMPERATURE_DAMAGE_COEFFICIENT //Dangercon 2011 - now with less magic numbers!
	//world <<"[discomfort]"

	switch(body_part)
		if(HEAD)
			apply_damage(2.5*discomfort, BURN, "head")
		if(UPPER_TORSO)
			apply_damage(2.5*discomfort, BURN, "chest")
		if(LEGS)
			apply_damage(0.6*discomfort, BURN, "l_leg")
			apply_damage(0.6*discomfort, BURN, "r_leg")
		if(ARMS)
			apply_damage(0.4*discomfort, BURN, "l_arm")
			apply_damage(0.4*discomfort, BURN, "r_arm")
*/

/mob/living/carbon/human/proc/handle_chemicals_in_body()
	if(isnotnull(reagents) && !(species.flags & IS_SYNTHETIC)) //Synths don't process reagents.
		var/alien = 0 //Not the best way to handle it, but neater than checking this for every single reagent proc.
		if(species?.reagent_tag)
			alien = species.reagent_tag
			reagents.metabolize(src, alien)

	if(species.name != SPECIES_PLASMALIN) // Plasmalins aren't affected by plasmaloss.
		var/total_plasmaloss = 0
		for(var/obj/item/I in src)
			if(I.contaminated)
				total_plasmaloss += global.vsc.plc.CONTAMINATION_LOSS
		if(status_flags & GODMODE)
			return 0	//godmode
		adjustToxLoss(total_plasmaloss)

	if(species.flags & REQUIRE_LIGHT)
		var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
		if(isturf(loc)) //else, there's considered to be no light
			var/turf/T = loc
			if(isnotnull(T))
				light_amount = T.get_lumcount(0.5) * 10 //hardcapped so it's not abused by having a ton of flashlights
			else
				light_amount = 1
		nutrition += light_amount
		traumatic_shock -= light_amount

		if(species.flags & IS_PLANT)
			if(nutrition > 500)
				nutrition = 500
			if(light_amount >= 3) //if there's enough light, heal
				adjustBruteLoss(-(light_amount))
				adjustToxLoss(-(light_amount))
				adjustOxyLoss(-(light_amount))
				//TODO: heal wounds, heal broken limbs.

	if(dna?.mutantrace == "shadow")
		var/light_amount = 0
		if(isturf(loc))
			var/turf/T = loc
			var/atom/movable/lighting_overlay/L = locate(/atom/movable/lighting_overlay) in T
			if(isnotnull(L))
				light_amount = L.lum_r + L.lum_g + L.lum_b //hardcapped so it's not abused by having a ton of flashlights
			else
				light_amount = 10
		if(light_amount > 2) //if there's enough light, start dying
			take_overall_damage(1, 1)
		else if(light_amount < 2) //heal in the dark
			heal_overall_damage(1, 1)

/*	//The fucking FAT mutation is the dumbest shit ever. It makes the code so difficult to work with
	if(FAT in mutations)
		if(overeatduration < 100)
			src << "\blue You feel fit again!"
			mutations.Remove(FAT)
			update_mutantrace(0)
			update_mutations(0)
			update_inv_w_uniform(0)
			update_inv_wear_suit()
	else
		if(overeatduration > 500)
			src << "\red You suddenly feel blubbery!"
			mutations.Add(FAT)
			update_mutantrace(0)
			update_mutations(0)
			update_inv_w_uniform(0)
			update_inv_wear_suit()
*/

	// nutrition decrease
	if(nutrition > 0 && stat != DEAD)
		nutrition = max (0, nutrition - HUNGER_FACTOR)

	if(nutrition > 450)
		if(overeatduration < 600) //capped so people don't take forever to unfat
			overeatduration++
	else
		if(overeatduration > 1)
			overeatduration -= 2 //doubled the unfat rate

	if(species.flags & REQUIRE_LIGHT)
		if(nutrition < 200)
			take_overall_damage(2, 0)
			traumatic_shock++

	if(drowsyness)
		drowsyness--
		eye_blurry = max(2, eye_blurry)
		if(prob(5))
			sleeping += 1
			Paralyse(5)

	confused = max(0, confused - 1)
	// decrement dizziness counter, clamped to 0
	if(resting)
		dizziness = max(0, dizziness - 15)
		jitteriness = max(0, jitteriness - 15)
	else
		dizziness = max(0, dizziness - 3)
		jitteriness = max(0, jitteriness - 3)

	if(!(species.flags & IS_SYNTHETIC))
		handle_trace_chems()

	updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/human/proc/handle_regular_status_updates()
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = 1
		silent = 0
	else				//ALIVE. LIGHTS ARE ON
		updatehealth()	//TODO
		if(!in_stasis)
			stabilize_body_temperature()	//Body temperature adjusts itself
			handle_organs()	//Optimized.
			handle_blood()

		if(health <= CONFIG_GET(health_threshold_dead) || (species.has_organ["brain"] && !has_brain()))
			death()
			blinded = 1
			silent = 0
			return 1

		// the analgesic effect wears off slowly
		analgesic = max(0, analgesic - 1)

		//UNCONSCIOUS. NO-ONE IS HOME
		if((getOxyLoss() > 50) || (CONFIG_GET(health_threshold_crit) > health))
			Paralyse(3)

			/* Done by handle_breath()
			if( health <= 20 && prob(1) )
				spawn(0)
					emote("gasp")
			if(!reagents.has_reagent("inaprovaline"))
				adjustOxyLoss(1)*/

		if(hallucination)
			if(hallucination >= 20)
				if(prob(3))
					fake_attack(src)
				if(!handling_hal)
					spawn handle_hallucinations() //The not boring kind!

			if(hallucination <= 2)
				hallucination = 0
				halloss = 0
			else
				hallucination -= 2

		else
			for(var/atom/a in hallucinations)
				qdel(a)

			if(halloss > 100)
				visible_message(
					"<B>[src]</B> slumps to the ground, too weak to continue fighting.",
					SPAN_NOTICE("You're in too much pain to keep going...")
				)
				Paralyse(10)
				setHalLoss(99)

		if(paralysis)
			AdjustParalysis(-1)
			blinded = 1
			stat = UNCONSCIOUS
			if(halloss > 0)
				adjustHalLoss(-3)
		else if(sleeping)
			speech_problem_flag = 1
			handle_dreams()
			adjustHalLoss(-3)
			if((mind?.active && isnotnull(client)) || immune_to_ssd) //This also checks whether a client is connected, if not, sleep is not reduced.
				sleeping = max(sleeping-1, 0)
			blinded = 1
			stat = UNCONSCIOUS
			if(prob(2) && health && !hal_crit && isnotnull(client))
				spawn(0)
					emote("snore")
		else if(resting)
			if(halloss > 0)
				adjustHalLoss(-3)
		//CONSCIOUS
		else
			stat = CONSCIOUS
			if(halloss > 0)
				adjustHalLoss(-1)

		if(embedded_flag && !(life_tick % 10))
			var/list/E
			E = get_visible_implants(0)
			if(!length(E))
				embedded_flag = 0


		//Eyes
		if(sdisabilities & BLIND)	//disabled-blind, doesn't get better on its own
			blinded = 1
		else if(eye_blind)			//blindness, heals slowly over time
			eye_blind = max(eye_blind - 1, 0)
			blinded = 1
		else if(istype(glasses, /obj/item/clothing/glasses/sunglasses/blindfold))	//resting your eyes with a blindfold heals blurry eyes faster
			eye_blurry = max(eye_blurry - 3, 0)
			blinded = 1
		else if(eye_blurry)	//blurry eyes heal slowly
			eye_blurry = max(eye_blurry - 1, 0)

		//Ears
		if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
			ear_deaf = max(ear_deaf, 1)
		else if(ear_deaf)			//deafness, heals slowly over time
			ear_deaf = max(ear_deaf - 1, 0)
		else if(istype(l_ear, /obj/item/clothing/ears/earmuffs) || istype(r_ear, /obj/item/clothing/ears/earmuffs))	//resting your ears with earmuffs heals ear damage faster
			ear_damage = max(ear_damage - 0.15, 0)
			ear_deaf = max(ear_deaf, 1)
		else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
			ear_damage = max(ear_damage-0.05, 0)

		//Other
		if(stunned)
			speech_problem_flag = 1
			AdjustStunned(-1)

		if(weakened)
			weakened = max(weakened - 1, 0)	//before you get mad Rockdtben: I done this so update_canmove isn't called multiple times

		if(stuttering)
			speech_problem_flag = 1
			stuttering = max(stuttering - 1, 0)
		if(slurring)
			speech_problem_flag = 1
			slurring = max(slurring - 1, 0)
		if(silent)
			speech_problem_flag = 1
			silent = max(silent - 1, 0)

		if(druggy)
			druggy = max(druggy - 1, 0)

		if(isnotnull(gloves) && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += 1

	return 1

/mob/living/carbon/human/proc/handle_regular_hud_updates()
	if(hud_updateflag)
		handle_hud_list()

	if(isnull(client))
		return 0

	for(var/image/hud in client.images)
		if(copytext(hud.icon_state, 1, 4) == "hud") //ugly, but icon comparison is worse, I believe
			client.images.Remove(hud)

	client.screen.Remove(
		GLOBL.global_hud.blurry, GLOBL.global_hud.druggy, GLOBL.global_hud.vimpaired,
		GLOBL.global_hud.darkMask, GLOBL.global_hud.nvg, GLOBL.global_hud.science,
		GLOBL.global_hud.thermal, GLOBL.global_hud.meson
	)

	update_action_buttons()

	if(damageoverlay.overlays)
		damageoverlay.overlays = list()

	if(stat == UNCONSCIOUS)
		//Critical damage passage overlay
		if(health <= 0)
			var/image/I
			switch(health)
				if(-20 to -10)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage1")
				if(-30 to -20)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage2")
				if(-40 to -30)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage3")
				if(-50 to -40)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage4")
				if(-60 to -50)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage5")
				if(-70 to -60)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage6")
				if(-80 to -70)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage7")
				if(-90 to -80)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage8")
				if(-95 to -90)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage9")
				if(-INFINITY to -95)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "passage10")
			damageoverlay.overlays.Add(I)
	else
		//Oxygen damage overlay
		if(oxyloss)
			var/image/I
			switch(oxyloss)
				if(10 to 20)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "oxydamageoverlay1")
				if(20 to 25)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "oxydamageoverlay2")
				if(25 to 30)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "oxydamageoverlay3")
				if(30 to 35)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "oxydamageoverlay4")
				if(35 to 40)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "oxydamageoverlay5")
				if(40 to 45)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "oxydamageoverlay6")
				if(45 to INFINITY)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "oxydamageoverlay7")
			damageoverlay.overlays.Add(I)

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = getBruteLoss() + getFireLoss() + damageoverlaytemp
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/image/I
			switch(hurtdamage)
				if(10 to 25)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "brutedamageoverlay1")
				if(25 to 40)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "brutedamageoverlay2")
				if(40 to 55)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "brutedamageoverlay3")
				if(55 to 70)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "brutedamageoverlay4")
				if(70 to 85)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "brutedamageoverlay5")
				if(85 to INFINITY)
					I = image("icon" = 'icons/mob/screen/screen1_full.dmi', "icon_state" = "brutedamageoverlay6")
			damageoverlay.overlays.Add(I)

	if(stat == DEAD)
		sight |= (SEE_TURFS | SEE_MOBS | SEE_OBJS)
		see_in_dark = 8
		if(!druggy)
			see_invisible = SEE_INVISIBLE_LEVEL_TWO
		if(healths)
			healths.icon_state = "health7"	//DEAD healthmeter
		if(isnotnull(client))
			if(client.view != world.view)
				if(locate(/obj/item/weapon/gun/energy/sniperrifle, contents))
					var/obj/item/weapon/gun/energy/sniperrifle/s = locate() in src
					if(s.zoom)
						s.zoom()

	else
		sight &= ~(SEE_TURFS | SEE_MOBS | SEE_OBJS)
		see_in_dark = species.darksight
		see_invisible = see_in_dark > 2 ? SEE_INVISIBLE_LEVEL_ONE : SEE_INVISIBLE_LIVING
		if(isnotnull(dna))
			switch(dna.mutantrace)
				if("slime")
					see_in_dark = 3
					see_invisible = SEE_INVISIBLE_LEVEL_ONE
				if("shadow")
					see_in_dark = 8
					see_invisible = SEE_INVISIBLE_LEVEL_ONE

		if(XRAY in mutations)
			sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
			see_in_dark = 8
			if(!druggy)
				see_invisible = SEE_INVISIBLE_LEVEL_TWO

		if(seer)
			var/obj/effect/rune/R = locate() in loc
			if(isnotnull(R) && R.word1 == cultwords["see"] && R.word2 == cultwords["hell"] && R.word3 == cultwords["join"])
				see_invisible = SEE_INVISIBLE_OBSERVER
			else
				see_invisible = SEE_INVISIBLE_LIVING
				seer = FALSE

		var/glasses_processed = FALSE
		if(istype(wear_mask, /obj/item/clothing/mask/gas/voice/space_ninja))
			var/obj/item/clothing/mask/gas/voice/space_ninja/O = wear_mask
			glasses_processed = TRUE
			process_glasses(O.ninja_vision.glasses)

		if(isnotnull(glasses))
			glasses_processed = TRUE
			process_glasses(glasses)

		if(!seer && !glasses_processed)
			see_invisible = SEE_INVISIBLE_LIVING

		if(isnotnull(healths))
			if(analgesic)
				healths.icon_state = "health_health_numb"
			else
				switch(hal_screwyhud)
					if(1)
						healths.icon_state = "health6"
					if(2)
						healths.icon_state = "health7"
					else
						//switch(health - halloss)
						switch(100 - ((species?.flags & NO_PAIN & !IS_SYNTHETIC) ? 0 : traumatic_shock))
							if(100 to INFINITY)
								healths.icon_state = "health0"
							if(80 to 100)
								healths.icon_state = "health1"
							if(60 to 80)
								healths.icon_state = "health2"
							if(40 to 60)
								healths.icon_state = "health3"
							if(20 to 40)
								healths.icon_state = "health4"
							if(0 to 20)
								healths.icon_state = "health5"
							else
								healths.icon_state = "health6"

		if(nutrition_icon)
			switch(nutrition)
				if(450 to INFINITY)
					nutrition_icon.icon_state = "nutrition0"
				if(350 to 450)
					nutrition_icon.icon_state = "nutrition1"
				if(250 to 350)
					nutrition_icon.icon_state = "nutrition2"
				if(150 to 250)
					nutrition_icon.icon_state = "nutrition3"
				else
					nutrition_icon.icon_state = "nutrition4"

		if(isnotnull(pressure))
			pressure.icon_state = "pressure[pressure_alert]"

		if(isnotnull(pullin))
			if(isnotnull(pulling))
				pullin.icon_state = "pull1"
			else
				pullin.icon_state = "pull0"
//		if(rest)	//Not used with new UI
//			if(resting || lying || sleeping)
//				rest.icon_state = "rest1"
//			else
//				rest.icon_state = "rest0"
		if(isnotnull(toxin))
			if(hal_screwyhud == 4 || toxins_alert)
				toxin.icon_state = "tox1"
			else
				toxin.icon_state = "tox0"
		if(isnotnull(oxygen))
			if(hal_screwyhud == 3 || oxygen_alert)
				oxygen.icon_state = "oxy1"
			else
				oxygen.icon_state = "oxy0"
		if(isnotnull(fire))
			if(fire_alert)
				fire.icon_state = "fire[fire_alert]" //fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
			else
				fire.icon_state = "fire0"

		if(isnotnull(bodytemp))
			if(isnull(species))
				switch(bodytemperature) //310.055 optimal body temp
					if(370 to INFINITY)
						bodytemp.icon_state = "temp4"
					if(350 to 370)
						bodytemp.icon_state = "temp3"
					if(335 to 350)
						bodytemp.icon_state = "temp2"
					if(320 to 335)
						bodytemp.icon_state = "temp1"
					if(300 to 320)
						bodytemp.icon_state = "temp0"
					if(295 to 300)
						bodytemp.icon_state = "temp-1"
					if(280 to 295)
						bodytemp.icon_state = "temp-2"
					if(260 to 280)
						bodytemp.icon_state = "temp-3"
					else
						bodytemp.icon_state = "temp-4"
			else
				var/temp_step
				if(bodytemperature >= species.body_temperature)
					temp_step = (species.heat_level_1 - species.body_temperature) / 4

					if(bodytemperature >= species.heat_level_1)
						bodytemp.icon_state = "temp4"
					else if(bodytemperature >= species.body_temperature + temp_step * 3)
						bodytemp.icon_state = "temp3"
					else if(bodytemperature >= species.body_temperature + temp_step * 2)
						bodytemp.icon_state = "temp2"
					else if(bodytemperature >= species.body_temperature + temp_step * 1)
						bodytemp.icon_state = "temp1"
					else
						bodytemp.icon_state = "temp0"

				else if(bodytemperature < species.body_temperature)
					temp_step = (species.body_temperature - species.cold_level_1) / 4

					if(bodytemperature <= species.cold_level_1)
						bodytemp.icon_state = "temp-4"
					else if(bodytemperature <= species.body_temperature - temp_step * 3)
						bodytemp.icon_state = "temp-3"
					else if(bodytemperature <= species.body_temperature - temp_step * 2)
						bodytemp.icon_state = "temp-2"
					else if(bodytemperature <= species.body_temperature - temp_step * 1)
						bodytemp.icon_state = "temp-1"
					else
						bodytemp.icon_state = "temp0"

		if(isnotnull(blind))
			if(blinded)
				blind.invisibility = 0 // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
			else
				blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

		if(disabilities & NEARSIGHTED)	//this looks meh but saves a lot of memory by not requiring to add var/prescription
			if(isnotnull(glasses))		//to every /obj/item
				var/obj/item/clothing/glasses/G = glasses
				if(!G.prescription)
					client.screen.Add(GLOBL.global_hud.vimpaired)
			else
				client.screen.Add(GLOBL.global_hud.vimpaired)

		if(eye_blurry)
			client.screen.Add(GLOBL.global_hud.blurry)
		if(druggy)
			client.screen.Add(GLOBL.global_hud.druggy)

		var/masked = FALSE

		if(istype(head, /obj/item/clothing/head/welding) || istype(head, /obj/item/clothing/head/helmet/space/soghun))
			var/obj/item/clothing/head/welding/O = head
			if(!O.up && CONFIG_GET(welding_protection_tint))
				client.screen.Add(GLOBL.global_hud.darkMask)
				masked = TRUE

		if(!masked && istype(glasses, /obj/item/clothing/glasses/welding))
			var/obj/item/clothing/glasses/welding/O = glasses
			if(!O.up && CONFIG_GET(welding_protection_tint))
				client.screen.Add(GLOBL.global_hud.darkMask)

		if(isnotnull(machine))
			if(!machine.check_eye(src))
				reset_view(null)
		else
			var/isRemoteObserve = FALSE
			if((mRemote in mutations) && remoteview_target)
				if(remoteview_target.stat == CONSCIOUS)
					isRemoteObserve = TRUE
			if(!isRemoteObserve && isnotnull(client) && !client.adminobs)
				remoteview_target = null
				reset_view(null)
	return 1

/mob/living/carbon/human/proc/process_glasses(obj/item/clothing/glasses/G)
	if(G?.active)
		see_in_dark += G.darkness_view
		if(isnotnull(G.overlay))
			client.screen |= G.overlay
		if(G.vision_flags)
			sight |= G.vision_flags
			if(!druggy)
				see_invisible = SEE_INVISIBLE_MINIMUM
		if(istype(G, /obj/item/clothing/glasses/night))
			see_invisible = SEE_INVISIBLE_MINIMUM
/* HUD shit goes here, as long as it doesn't modify sight flags */
// The purpose of this is to stop xray and w/e from preventing you from using huds -- Love, Doohl
		if(istype(G, /obj/item/clothing/glasses/sunglasses/sechud))
			var/obj/item/clothing/glasses/sunglasses/sechud/O = G
			O.hud?.process_hud(src)
			if(!druggy)
				see_invisible = SEE_INVISIBLE_LIVING
		else if(istype(G, /obj/item/clothing/glasses/hud))
			var/obj/item/clothing/glasses/hud/O = G
			O.process_hud(src)
			if(!druggy)
				see_invisible = SEE_INVISIBLE_LIVING

/mob/living/carbon/human/proc/handle_random_events()
	// Puke if toxloss is too high
	if(!stat)
		if(getToxLoss() >= 45 && nutrition > 20)
			vomit()

	//0.1% chance of playing a scary sound to someone who's in complete darkness
	//if(isturf(loc) && rand(1,1000) == 1)
		//var/turf/currentTurf = loc
		//if(!currentTurf.lighting_lumcount)
		//	playsound_local(src,pick(scarySounds),50, 1, -1)

/mob/living/carbon/human/proc/handle_virus_updates()
	if(status_flags & GODMODE)
		return 0	//godmode
	if(bodytemperature > 406)
		for(var/datum/disease/D in viruses)
			D.cure()
		for (var/ID in virus2)
			var/datum/disease2/disease/V = virus2[ID]
			V.cure(src)

	if(life_tick % 3) //don't spam checks over all objects in view every tick.
		for(var/obj/effect/decal/cleanable/O in view(1, src))
			if(istype(O, /obj/effect/decal/cleanable/blood))
				var/obj/effect/decal/cleanable/blood/B = O
				if(length(B.virus2))
					for (var/ID in B.virus2)
						var/datum/disease2/disease/V = B.virus2[ID]
						infect_virus2(src, V.getcopy())

			else if(istype(O, /obj/effect/decal/cleanable/mucus))
				var/obj/effect/decal/cleanable/mucus/M = O
				if(length(M.virus2))
					for (var/ID in M.virus2)
						var/datum/disease2/disease/V = M.virus2[ID]
						infect_virus2(src, V.getcopy())

	if(length(virus2))
		for (var/ID in virus2)
			var/datum/disease2/disease/V = virus2[ID]
			if(isnull(V)) // Trying to figure out a runtime error that keeps repeating
				CRASH("virus2 nulled before calling activate()")
			else
				V.activate(src)
			// activate may have deleted the virus
			if(isnull(V))
				continue

			// check if we're immune
			if(V.antigen & antibodies)
				V.dead = 1

	return

/mob/living/carbon/human/proc/handle_stomach()
	spawn(0)
		for(var/mob/living/M in stomach_contents)
			if(M.loc != src)
				stomach_contents.Remove(M)
				continue
			if(iscarbon(M) && stat != DEAD)
				if(M.stat == DEAD)
					M.death(1)
					stomach_contents.Remove(M)
					qdel(M)
					continue
				if(global.CTair_system.current_cycle % 3 == 1)
					if(!(M.status_flags & GODMODE))
						M.adjustBruteLoss(5)
					nutrition += 10

/mob/living/carbon/human/proc/handle_changeling()
	mind?.changeling?.regenerate()

/mob/living/carbon/human/handle_shock()
	..()
	if(status_flags & GODMODE)
		return 0	//godmode
	if(analgesic || (species?.flags & NO_PAIN))
		return // analgesic avoids all traumatic shock temporarily

	if(health < CONFIG_GET(health_threshold_softcrit))// health 0 makes you immediately collapse
		shock_stage = max(shock_stage, 61)

	if(traumatic_shock >= 80)
		shock_stage += 1
	else if(health < CONFIG_GET(health_threshold_softcrit))
		shock_stage = max(shock_stage, 61)
	else
		shock_stage = min(shock_stage, 160)
		shock_stage = max(shock_stage - 1, 0)
		return

	if(shock_stage == 10)
		var/word = pick("It hurts so much!", "You really need some painkillers..", "Dear god, the pain!")
		to_chat(src, SPAN_DANGER("[word]"))

	if(shock_stage >= 30)
		if(shock_stage == 30)
			emote("me", 1, "is having trouble keeping their eyes open.")
		eye_blurry = max(2, eye_blurry)
		stuttering = max(stuttering, 5)

	if(shock_stage == 40)
		var/word = pick("The pain is excruciating!", "Please, just end the pain!", "Your whole body is going numb!")
		to_chat(src, SPAN_DANGER("[word]"))

	if(shock_stage >= 60)
		if(shock_stage == 60)
			emote("me", 1, "'s body becomes limp.")
		if(prob(2))
			var/word = pick("The pain is excruciating!", "Please, just end the pain!", "Your whole body is going numb!")
			to_chat(src, SPAN_DANGER("[word]"))
			Weaken(20)

	if(shock_stage >= 80)
		if(prob(5))
			var/word = pick("The pain is excruciating!", "Please, just end the pain!", "Your whole body is going numb!")
			to_chat(src, SPAN_DANGER("[word]"))
			Weaken(20)

	if(shock_stage >= 120)
		if(prob(2))
			var/word = pick("You black out!", "You feel like you could die any moment now.", "You're about to lose consciousness.")
			to_chat(src, SPAN_DANGER("[word]"))
			Paralyse(5)

	if(shock_stage == 150)
		emote("me", 1, "can no longer stand, collapsing!")
		Weaken(20)

	if(shock_stage >= 150)
		Weaken(20)

/mob/living/carbon/human/proc/handle_pulse()
	if(life_tick % 5)
		return pulse	//update pulse every 5 life ticks (~1 tick/sec, depending on server load)

	if(species?.flags & NO_BLOOD)
		return PULSE_NONE //No blood, no pulse.

	if(stat == DEAD)
		return PULSE_NONE	//that's it, you're dead, nothing can influence your pulse

	var/temp = PULSE_NORM

	if(round(vessel.get_reagent_amount("blood")) <= BLOOD_VOLUME_BAD)	//how much blood do we have
		temp = PULSE_THREADY	//not enough :(

	if(status_flags & FAKEDEATH)
		temp = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds

	//handles different chems' influence on pulse
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.id in GLOBL.bradycardics)
			if(temp <= PULSE_THREADY && temp >= PULSE_NORM)
				temp--

		if(R.id in GLOBL.tachycardics)
			if(temp <= PULSE_FAST && temp >= PULSE_NONE)
				temp++

		if(R.id in GLOBL.heartstopper) //To avoid using fakedeath
			temp = PULSE_NONE

		if(R.id in GLOBL.cheartstopper) //Conditional heart-stoppage
			if(R.volume >= R.overdose)
				temp = PULSE_NONE

	return temp

/*
	Called by life(), instead of having the individual hud items update icons each tick and check for status changes
	we only set those statuses and icons upon changes.  Then those HUD items will simply add those pre-made images.
	This proc below is only called when those HUD elements need to change as determined by the mobs hud_updateflag.
*/

/mob/living/carbon/human/proc/handle_hud_list()
	if(BITTEST(hud_updateflag, HEALTH_HUD))
		var/image/holder = hud_list[HEALTH_HUD]
		if(stat == DEAD)
			holder.icon_state = "hudhealth-100" 	// X_X
		else
			var/percentage_health = RoundHealth(((0.0 + health) / species.total_health) * 100)
			holder.icon_state = "hud[percentage_health]"

		hud_list[HEALTH_HUD] = holder

	if(BITTEST(hud_updateflag, STATUS_HUD))
		var/foundVirus = 0
		for(var/datum/disease/D in viruses)
			if(!D.hidden[SCANNER])
				foundVirus++
		for(var/ID in virus2)
			if(ID in virusDB)
				foundVirus = 1
				break

		var/image/holder = hud_list[STATUS_HUD]
		var/image/holder2 = hud_list[STATUS_HUD_OOC]
		if(stat == DEAD)
			holder.icon_state = "huddead"
			holder2.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder.icon_state = "hudxeno"
			holder2.icon_state = "hudxeno"
		else if(foundVirus)
			holder.icon_state = "hudill"
		else if(has_brain_worms())
			var/mob/living/simple_animal/borer/B = has_brain_worms()
			if(B.controlling)
				holder.icon_state = "hudbrainworm"
			else
				holder.icon_state = "hudhealthy"
			holder2.icon_state = "hudbrainworm"
		else
			holder.icon_state = "hudhealthy"
			if(length(virus2))
				holder2.icon_state = "hudill"
			else
				holder2.icon_state = "hudhealthy"

		hud_list[STATUS_HUD] = holder
		hud_list[STATUS_HUD_OOC] = holder2

	if(BITTEST(hud_updateflag, ID_HUD))
		var/image/holder = hud_list[ID_HUD]
		if(isnotnull(wear_id))
			var/obj/item/weapon/card/id/I = wear_id.get_id()
			holder.icon_state = isnotnull(I) ? "hud[ckey(I.get_job_name())]" : "hudunknown"
		else
			holder.icon_state = "hudunknown"

		hud_list[ID_HUD] = holder

	if(BITTEST(hud_updateflag, WANTED_HUD))
		var/image/holder = hud_list[WANTED_HUD]
		holder.icon_state = "hudblank"
		var/perpname = name
		if(isnotnull(wear_id))
			var/obj/item/weapon/card/id/I = wear_id.get_id()
			if(isnotnull(I))
				perpname = I.registered_name

		for(var/datum/data/record/E in GLOBL.data_core.general)
			if(E.fields["name"] == perpname)
				for(var/datum/data/record/R in GLOBL.data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						holder.icon_state = "hudwanted"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
						holder.icon_state = "hudprisoner"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
						holder.icon_state = "hudparolled"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
						holder.icon_state = "hudreleased"
						break
		hud_list[WANTED_HUD] = holder

	if(BITTEST(hud_updateflag, IMPLOYAL_HUD) || BITTEST(hud_updateflag, IMPCHEM_HUD) || BITTEST(hud_updateflag, IMPTRACK_HUD))
		var/image/holder1 = hud_list[IMPTRACK_HUD]
		var/image/holder2 = hud_list[IMPLOYAL_HUD]
		var/image/holder3 = hud_list[IMPCHEM_HUD]

		holder1.icon_state = "hudblank"
		holder2.icon_state = "hudblank"
		holder3.icon_state = "hudblank"

		for(var/obj/item/weapon/implant/I in src)
			if(I.implanted)
				if(istype(I, /obj/item/weapon/implant/tracking))
					holder1.icon_state = "hud_imp_tracking"
				if(istype(I, /obj/item/weapon/implant/loyalty))
					holder2.icon_state = "hud_imp_loyal"
				if(istype(I, /obj/item/weapon/implant/chem))
					holder3.icon_state = "hud_imp_chem"

		hud_list[IMPTRACK_HUD] = holder1
		hud_list[IMPLOYAL_HUD] = holder2
		hud_list[IMPCHEM_HUD] = holder3

	if(BITTEST(hud_updateflag, SPECIALROLE_HUD))
		var/image/holder = hud_list[SPECIALROLE_HUD]
		holder.icon_state = "hudblank"
		if(isnotnull(mind))
			switch(mind.special_role)
				if("traitor", "Syndicate")
					holder.icon_state = "hudsyndicate"
				if("Revolutionary")
					holder.icon_state = "hudrevolutionary"
				if("Head Revolutionary")
					holder.icon_state = "hudheadrevolutionary"
				if("Cultist")
					holder.icon_state = "hudcultist"
				if("Changeling")
					holder.icon_state = "hudchangeling"
				if("Wizard", "Fake Wizard")
					holder.icon_state = "hudwizard"
				if("Death Commando")
					holder.icon_state = "huddeathsquad"
				if("Ninja")
					holder.icon_state = "hudninja"

			hud_list[SPECIALROLE_HUD] = holder
	hud_updateflag = 0

/mob/living/carbon/human/handle_fire()
	if(..())
		return

	var/burn_temperature = fire_burn_temperature()
	var/thermal_protection = get_heat_protection(burn_temperature)

	if(thermal_protection < 1 && bodytemperature < burn_temperature)
		bodytemperature += round(BODYTEMP_HEATING_MAX * (1 - thermal_protection), 1)

#undef HUMAN_MAX_OXYLOSS
#undef HUMAN_CRIT_MAX_OXYLOSS