// Reagent declarations
/datum/reagent/blood
	data = new/list("donor" = null, "viruses" = null, "blood_DNA" = null, "blood_type" = null, "resistances" = null, "trace_chem" = null, "antibodies" = null)
	name = "Blood"
	id = "blood"
	reagent_state = REAGENT_LIQUID
	color = "#C80000" // rgb: 200, 0, 0

/datum/reagent/blood/reaction_mob(mob/M, method = TOUCH, volume)
	var/datum/reagent/blood/self = src
	qdel(src)
	if(self.data && self.data["viruses"])
		for(var/datum/disease/D in self.data["viruses"])
			//var/datum/disease/virus = new D.type(0, D, 1)
			// We don't spread.
			if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS)
				continue
			if(method == TOUCH)
				M.contract_disease(D)
			else //injected
				M.contract_disease(D, 1, 0)
	if(self.data && self.data["virus2"] && iscarbon(M))//infecting...
		var/list/vlist = self.data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(method == TOUCH)
					infect_virus2(M, V.getcopy())
				else
					infect_virus2(M, V.getcopy(),1) //injected, force infection!

	if(self.data && self.data["antibodies"] && iscarbon(M))//... and curing
		var/mob/living/carbon/C = M
		C.antibodies |= self.data["antibodies"]

/datum/reagent/blood/reaction_turf(turf/simulated/T, volume)//splash the blood all over the place
	if(!istype(T))
		return
	var/datum/reagent/blood/self = src
	qdel(src)
	if(!(volume >= 3))
		return
	//var/datum/disease/D = self.data["virus"]
	if(!self.data["donor"] || ishuman(self.data["donor"]))
		var/obj/effect/decal/cleanable/blood/blood_prop = locate() in T //find some blood here
		if(!blood_prop) //first blood!
			blood_prop = new(T)
			blood_prop.blood_DNA[self.data["blood_DNA"]] = self.data["blood_type"]

		for(var/datum/disease/D in self.data["viruses"])
			var/datum/disease/newVirus = D.Copy(1)
			blood_prop.viruses += newVirus
			newVirus.holder = blood_prop

		if(self.data["virus2"])
			blood_prop.virus2 = virus_copylist(self.data["virus2"])

	else if(ismonkey(self.data["donor"]))
		var/obj/effect/decal/cleanable/blood/blood_prop = locate() in T
		if(!blood_prop)
			blood_prop = new(T)
			blood_prop.blood_DNA["Non-Human DNA"] = "A+"
		for(var/datum/disease/D in self.data["viruses"])
			var/datum/disease/newVirus = D.Copy(1)
			blood_prop.viruses += newVirus
			newVirus.holder = blood_prop

	else if(isalien(self.data["donor"]))
		var/obj/effect/decal/cleanable/blood/xeno/blood_prop = locate() in T
		if(!blood_prop)
			blood_prop = new(T)
			blood_prop.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"
		for(var/datum/disease/D in self.data["viruses"])
			var/datum/disease/newVirus = D.Copy(1)
			blood_prop.viruses += newVirus
			newVirus.holder = blood_prop
	return


/* Must check the transfering of reagents and their data first. They all can point to one disease datum.

			Del()
				if(src.data["virus"])
					var/datum/disease/D = src.data["virus"]
					D.cure(0)
				..()
*/

/datum/reagent/vaccine
	//data must contain virus type
	name = "Vaccine"
	id = "vaccine"
	reagent_state = REAGENT_LIQUID
	color = "#C81040" // rgb: 200, 16, 64

/datum/reagent/vaccine/reaction_mob(mob/M, method = TOUCH, volume)
	var/datum/reagent/vaccine/self = src
	qdel(src)
	if(self.data&&method == INGEST)
		for(var/datum/disease/D in M.viruses)
			if(istype(D, /datum/disease/advance))
				var/datum/disease/advance/A = D
				if(A.GetDiseaseID() == self.data)
					D.cure()
			else
				if(D.type == self.data)
					D.cure()

			M.resistances += self.data
	return


/datum/reagent/water
	name = "Water"
	id = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = REAGENT_LIQUID
	color = "#0064C8" // rgb: 0, 100, 200

	custom_metabolism = 0.01

/datum/reagent/water/reaction_turf(turf/simulated/T, volume)
	if(!istype(T))
		return
	qdel(src)
	if(volume >= 3)
		if(T.wet >= 1)
			return
		T.wet = 1
		if(T.wet_overlay)
			T.overlays -= T.wet_overlay
			T.wet_overlay = null
		T.wet_overlay = image('icons/effects/water.dmi', T, "wet_floor")
		T.overlays += T.wet_overlay

		spawn(800)
			if(!istype(T))
				return
			if(T.wet >= 2)
				return
			T.wet = 0
			if(T.wet_overlay)
				T.overlays -= T.wet_overlay
				T.wet_overlay = null

	for(var/mob/living/carbon/slime/M in T)
		M.adjustToxLoss(rand(15, 20))

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature - 2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)
	return

/datum/reagent/water/reaction_obj(obj/O, volume)
	qdel(src)
	var/turf/T = get_turf(O)
	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature - 2000,lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/monkeycube))
		var/obj/item/weapon/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()
	return

/datum/reagent/water/reaction_mob(mob/living/M, method = TOUCH, volume)
	if(method == TOUCH && isliving(M))
		M.adjust_fire_stacks(-(volume / 10))
		if(M.fire_stacks <= 0)
			M.ExtinguishMob()
		return


/datum/reagent/water/water/holywater
	name = "Holy Water"
	id = "holywater"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#E0E8EF" // rgb: 224, 232, 239

/datum/reagent/water/water/holywater/on_mob_life(mob/living/M as mob)
	if(ishuman(M))
		if((M.mind in ticker.mode.cult) && prob(10))
			to_chat(M, SPAN_INFO("A cooling sensation from inside you brings you an untold calmness."))
			ticker.mode.remove_cultist(M.mind)
			for(var/mob/O in viewers(M, null))
				O.show_message(SPAN_INFO("[M]'s eyes blink and become clearer."), 1) // So observers know it worked.
	holder.remove_reagent(src.id, 10 * REAGENTS_METABOLISM) //high metabolism to prevent extended uncult rolls.
	return


/datum/reagent/lube
	name = "Space Lube"
	id = "lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	reagent_state = REAGENT_LIQUID
	color = "#009CA8" // rgb: 0, 156, 168
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lube/reaction_turf(turf/simulated/T, volume)
	if(!istype(T))
		return
	qdel(src)
	if(volume >= 1)
		if(T.wet >= 2)
			return
		T.wet = 2
		spawn(800)
			if(!istype(T))
				return
			T.wet = 0
			if(T.wet_overlay)
				T.overlays -= T.wet_overlay
				T.wet_overlay = null
			return


/datum/reagent/plasticide
	name = "Plasticide"
	id = "plasticide"
	description = "Liquid plastic, do not eat."
	reagent_state = REAGENT_LIQUID
	color = "#CF3600" // rgb: 207, 54, 0

	custom_metabolism = 0.01

/datum/reagent/plasticide/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	// Toxins are really weak, but without being treated, last very long.
	M.adjustToxLoss(0.2)
	..()
	return


/datum/reagent/slimetoxin
	name = "Mutation Toxin"
	id = "mutationtoxin"
	description = "A corruptive toxin produced by slimes."
	reagent_state = REAGENT_LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	overdose = REAGENTS_OVERDOSE

/datum/reagent/slimetoxin/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(ishuman(M))
		var/mob/living/carbon/human/human = M
		if(human.dna.mutantrace == null)
			to_chat(M, SPAN_DANGER("Your flesh rapidly mutates!"))
			human.dna.mutantrace = "slime"
			human.update_mutantrace()
	..()
	return


/datum/reagent/aslimetoxin
	name = "Advanced Mutation Toxin"
	id = "amutationtoxin"
	description = "An advanced corruptive toxin produced by slimes."
	reagent_state = REAGENT_LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	overdose = REAGENTS_OVERDOSE

/datum/reagent/aslimetoxin/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(iscarbon(M) && M.stat != DEAD)
		to_chat(M, SPAN_DANGER("Your flesh rapidly mutates!"))
		if(M.monkeyizing)
			return
		M.monkeyizing = 1
		M.canmove = FALSE
		M.icon = null
		M.overlays.Cut()
		M.invisibility = 101
		for(var/obj/item/W in M)
			if(istype(W, /obj/item/weapon/implant))	//TODO: Carn. give implants a dropped() or something
				qdel(W)
				continue
			W.reset_plane_and_layer()
			W.loc = M.loc
			W.dropped(M)
		var/mob/living/carbon/slime/new_mob = new /mob/living/carbon/slime(M.loc)
		new_mob.a_intent = "hurt"
		new_mob.universal_speak = 1
		if(M.mind)
			M.mind.transfer_to(new_mob)
		else
			new_mob.key = M.key
		qdel(M)
	..()
	return


/datum/reagent/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	reagent_state = REAGENT_LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose = REAGENTS_OVERDOSE

/datum/reagent/space_drugs/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.druggy = max(M.druggy, 15)
	if(isturf(M.loc) && !istype(M.loc, /turf/space))
		if(M.canmove && !M.restrained())
			if(prob(10))
				step(M, pick(cardinal))
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
	holder.remove_reagent(src.id, 0.5 * REAGENTS_METABOLISM)
	return

/*		silicate
			name = "Silicate"
			id = "silicate"
			description = "A compound that can be used to reinforce glass."
			reagent_state = LIQUID
			color = "#C7FFFF" // rgb: 199, 255, 255

			reaction_obj(var/obj/O, var/volume)
				del(src)
				if(istype(O,/obj/structure/window))
					if(O:silicate <= 200)

						O:silicate += volume
						O:health += volume * 3

						if(!O:silicateIcon)
							var/icon/I = icon(O.icon,O.icon_state,O.dir)

							var/r = (volume / 100) + 1
							var/g = (volume / 70) + 1
							var/b = (volume / 50) + 1
							I.SetIntensity(r,g,b)
							O.icon = I
							O:silicateIcon = I
						else
							var/icon/I = O:silicateIcon

							var/r = (volume / 100) + 1
							var/g = (volume / 70) + 1
							var/b = (volume / 50) + 1
							I.SetIntensity(r,g,b)
							O.icon = I
							O:silicateIcon = I

				return*/


/datum/reagent/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "A colorless, odorless gas."
	reagent_state = REAGENT_GAS
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01

/datum/reagent/oxygen/on_mob_life(mob/living/M as mob, alien)
	if(M.stat == DEAD)
		return
	if(alien && (alien == IS_VOX || alien == IS_PLASMALIN))
		M.adjustToxLoss(REAGENTS_METABOLISM)
		holder.remove_reagent(src.id, REAGENTS_METABOLISM) //By default it slowly disappears.
		return
	..()


/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile metal."
	color = "#6E3B08" // rgb: 110, 59, 8

	custom_metabolism = 0.01


/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "A colorless, odorless, tasteless gas."
	reagent_state = REAGENT_GAS
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01

/datum/reagent/nitrogen/on_mob_life(mob/living/M as mob, alien)
	if(M.stat == DEAD)
		return
	if(alien && alien == IS_VOX)
		M.adjustOxyLoss(-2 * REM)
		holder.remove_reagent(src.id, REAGENTS_METABOLISM) //By default it slowly disappears.
		return
	..()


/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	reagent_state = REAGENT_GAS
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01


/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	reagent_state = REAGENT_SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160

	custom_metabolism = 0.01


/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	reagent_state = REAGENT_LIQUID
	color = "#484848" // rgb: 72, 72, 72
	overdose = REAGENTS_OVERDOSE

/datum/reagent/mercury/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))
	M.adjustBrainLoss(2)
	..()
	return


/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	reagent_state = REAGENT_SOLID
	color = "#BF8C00" // rgb: 191, 140, 0

	custom_metabolism = 0.01


/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the builing block of life."
	reagent_state = REAGENT_SOLID
	color = "#1C1300" // rgb: 30, 20, 0

	custom_metabolism = 0.01

/datum/reagent/carbon/reaction_turf(turf/T, volume)
	qdel(src)
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)


/datum/reagent/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "A chemical element with a characteristic odour."
	reagent_state = REAGENT_GAS
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE

/datum/reagent/chlorine/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.take_organ_damage(1 * REM, 0)
	..()
	return


/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "A highly-reactive chemical element."
	reagent_state = REAGENT_GAS
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE

/datum/reagent/fluorine/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.adjustToxLoss(1 * REM)
	..()
	return


/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	reagent_state = REAGENT_SOLID
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01


/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	reagent_state = REAGENT_SOLID
	color = "#832828" // rgb: 131, 40, 40

	custom_metabolism = 0.01


/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	reagent_state = REAGENT_SOLID
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lithium/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))
	..()
	return


/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = REAGENT_SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255

/datum/reagent/sugar/on_mob_life(mob/living/M as mob)
	M.nutrition += 1 * REM
	..()
	return


/datum/reagent/glycerol
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	reagent_state = REAGENT_LIQUID
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01


/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	reagent_state = REAGENT_LIQUID
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01


/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	reagent_state = REAGENT_SOLID
	color = "#C7C7C7" // rgb: 199,199,199

/datum/reagent/radium/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.apply_effect(2 * REM, IRRADIATE, 0)
	// radium may increase your chances to cure a disease
	if(iscarbon(M)) // make sure to only use it on carbon mobs
		var/mob/living/carbon/C = M
		if(C.virus2.len)
			for(var/ID in C.virus2)
				var/datum/disease2/disease/V = C.virus2[ID]
				if(prob(5))
					if(prob(50))
						M.radiation += 50 // curing it that way may kill you instead
						var/mob/living/carbon/human/H
						if(ishuman(C))
							H = C
						if(!H || (H.species && !(H.species.flags & RAD_ABSORB)))
							M.adjustToxLoss(100)
					M:antibodies |= V.antigen
	..()
	return

/datum/reagent/radium/reaction_turf(turf/T, volume)
	qdel(src)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return


/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	reagent_state = REAGENT_SOLID
	color = "#673910" // rgb: 103, 57, 16

/datum/reagent/thermite/reaction_turf(turf/T, volume)
	qdel(src)
	if(volume >= 5)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.thermite = 1
			W.overlays += image('icons/effects/effects.dmi', icon_state = "#673910")
	return

/datum/reagent/thermite/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.adjustFireLoss(1)
	..()
	return


/datum/reagent/virus_food
	name = "Virus Food"
	id = "virusfood"
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	reagent_state = REAGENT_LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#899613" // rgb: 137, 150, 19

/datum/reagent/virus_food/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.nutrition += nutriment_factor * REM
	..()
	return


/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a metal."
	reagent_state = REAGENT_SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE


/datum/reagent/gold
	name = "Gold"
	id = "gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	reagent_state = REAGENT_SOLID
	color = "#F7C430" // rgb: 247, 196, 48


/datum/reagent/silver
	name = "Silver"
	id = "silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = REAGENT_SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208


/datum/reagent/uranium
	name ="Uranium"
	id = "uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	reagent_state = REAGENT_SOLID
	color = "#B8B8C0" // rgb: 184, 184, 192

/datum/reagent/uranium/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.apply_effect(1, IRRADIATE, 0)
	..()
	return

/datum/reagent/uranium/reaction_turf(turf/T, volume)
	qdel(src)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return


/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = REAGENT_SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168


/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = REAGENT_SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168


/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Required for welders. Flamable."
	reagent_state = REAGENT_LIQUID
	color = "#660000" // rgb: 102, 0, 0
	overdose = REAGENTS_OVERDOSE

/datum/reagent/fuel/reaction_obj(obj/O, volume)
	var/turf/the_turf = get_turf(O)
	if(!the_turf)
		return //No sense trying to start a fire if you don't have a turf to set on fire. --NEO
	new /obj/effect/decal/cleanable/liquid_fuel(the_turf, volume)

/datum/reagent/fuel/reaction_turf(turf/T, volume)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)
	return

/datum/reagent/fuel/reaction_mob(mob/living/M, method = TOUCH, volume)//Splashing people with welding fuel to make them easy to ignite!
	if(!isliving(M))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(volume / 10)
		return

/datum/reagent/fuel/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.adjustToxLoss(1)
	..()
	return


/datum/reagent/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	reagent_state = REAGENT_LIQUID
	color = "#A5F0EE" // rgb: 165, 240, 238
	overdose = REAGENTS_OVERDOSE

/datum/reagent/space_cleaner/reaction_obj(obj/O, volume)
	if(istype(O, /obj/effect/decal/cleanable))
		qdel(O)
	else
		if(O)
			O.clean_blood()

/datum/reagent/space_cleaner/reaction_turf(turf/T, volume)
	if(volume >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.dirt = 0
		T.clean_blood()
		for(var/obj/effect/decal/cleanable/C in T.contents)
			src.reaction_obj(C, volume)
			qdel(C)

		for(var/mob/living/carbon/slime/M in T)
			M.adjustToxLoss(rand(5, 10))

/datum/reagent/space_cleaner/reaction_mob(mob/M, method = TOUCH, volume)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.r_hand)
			C.r_hand.clean_blood()
		if(C.l_hand)
			C.l_hand.clean_blood()
		if(C.wear_mask)
			if(C.wear_mask.clean_blood())
				C.update_inv_wear_mask(0)
		if(ishuman(M))
			var/mob/living/carbon/human/H = C
			if(H.head)
				if(H.head.clean_blood())
					H.update_inv_head(0)
			if(H.wear_suit)
				if(H.wear_suit.clean_blood())
					H.update_inv_wear_suit(0)
			else if(H.w_uniform)
				if(H.w_uniform.clean_blood())
					H.update_inv_w_uniform(0)
			if(H.shoes)
				if(H.shoes.clean_blood())
					H.update_inv_shoes(0)
			else
				H.clean_blood(1)
				return
		M.clean_blood()


/datum/reagent/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/impedrezene/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.jitteriness = max(M.jitteriness - 5, 0)
	if(prob(80))
		M.adjustBrainLoss(1 * REM)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3)
	if(prob(10))
		M.emote("drool")
	..()
	return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/nanites
	name = "Nanomachines"
	id = "nanites"
	description = "Microscopic construction robots."
	reagent_state = REAGENT_LIQUID
	color = "#535E66" // rgb: 83, 94, 102

/datum/reagent/nanites/reaction_mob(mob/M, method = TOUCH, volume)
	qdel(src)
	if((prob(10) && method == TOUCH) || method == INGEST)
		M.contract_disease(new /datum/disease/robotic_transformation(0), 1)


/datum/reagent/xenomicrobes
	name = "Xenomicrobes"
	id = "xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	reagent_state = REAGENT_LIQUID
	color = "#535E66" // rgb: 83, 94, 102

/datum/reagent/xenomicrobes/reaction_mob(mob/M, method = TOUCH, volume)
	qdel(src)
	if((prob(10) && method == TOUCH) || method == INGEST)
		M.contract_disease(new /datum/disease/xeno_transformation(0), 1)


/datum/reagent/fluorosurfactant //foam precursor
	name = "Fluorosurfactant"
	id = "fluorosurfactant"
	description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
	reagent_state = REAGENT_LIQUID
	color = "#9E6B38" // rgb: 158, 107, 56


/datum/reagent/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	id = "foaming_agent"
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	reagent_state = REAGENT_SOLID
	color = "#664B63" // rgb: 102, 75, 99


/datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A highly addictive stimulant extracted from the tobacco plant."
	reagent_state = REAGENT_LIQUID
	color = "#181818" // rgb: 24, 24, 24


/datum/reagent/ammonia
	name = "Ammonia"
	id = "ammonia"
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = REAGENT_GAS
	color = "#404030" // rgb: 64, 64, 48


/datum/reagent/ultraglue
	name = "Ultra Glue"
	id = "glue"
	description = "An extremely powerful bonding agent."
	color = "#FFFFCC" // rgb: 255, 255, 204


/datum/reagent/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	description = "A secondary amine, mildly corrosive."
	reagent_state = REAGENT_LIQUID
	color = "#604030" // rgb: 96, 64, 48