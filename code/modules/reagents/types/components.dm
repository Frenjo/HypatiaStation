/datum/reagent/plasticide
	name = "Plasticide"
	id = "plasticide"
	description = "Liquid plastic, do not eat."
	reagent_state = REAGENT_LIQUID
	color = "#CF3600" // rgb: 207, 54, 0

	custom_metabolism = 0.01

/datum/reagent/plasticide/on_mob_life(mob/living/carbon/C)
	// Toxins are really weak, but without being treated, last very long.
	C.adjustToxLoss(0.2)
	. = ..()

/*
/datum/reagent/silicate
	name = "Silicate"
	id = "silicate"
	description = "A compound that can be used to reinforce glass."
	reagent_state = LIQUID
	color = "#C7FFFF" // rgb: 199, 255, 255

/datum/reagent/silicate/reaction_obj(var/obj/O, var/volume)
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
*/

/datum/reagent/glycerol
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	reagent_state = REAGENT_LIQUID
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01

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

/datum/reagent/oil
	name = "Oil"
	id = "oil"
	description = "A naturally occurring yellowish-black liquid chemical mixture consisting mainly of hydrocarbons."
	reagent_state = REAGENT_LIQUID
	color = "#281E15" // rgb: 40, 30, 21

/datum/reagent/phenol
	name = "Phenol"
	id = "phenol"
	description = "An aromatic ring of carbon with a hydroxyl group. A useful precursor to some medicines, but has no healing properties on its own."
	reagent_state = REAGENT_LIQUID
	color = "#E7EA91"

/datum/reagent/acetone
	name = "Acetone"
	id = "acetone"
	description = "A slick, slightly carcinogenic liquid. Has a multitude of mundane uses in everyday life."
	reagent_state = REAGENT_LIQUID
	color = "#AF14B7"

/datum/reagent/nitrous_oxide
	name = "Nitrous Oxide"
	id = "nitrous_oxide"
	description = "A potent oxidizer used as fuel in rockets and as an anaesthetic during surgery."
	reagent_state = REAGENT_LIQUID
	custom_metabolism = 1.5 * REAGENTS_METABOLISM
	color = "#808080"

/datum/reagent/nitrous_oxide/reaction_obj(obj/O, volume)
	if(isnull(O) || !volume)
		return
	var/turf/the_turf = GET_TURF(O)
	the_turf?.assume_gas(/decl/xgm_gas/nitrous_oxide, volume, T20C)
	qdel(src)

/datum/reagent/nitrous_oxide/reaction_turf(turf/T, volume)
	T.assume_gas(/decl/xgm_gas/nitrous_oxide, volume, T20C)
	qdel(src)

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/cryptobiolin/on_mob_life(mob/living/carbon/C)
	C.make_dizzy(1)
	if(!C.confused)
		C.confused = 1
	C.confused = max(C.confused, 20)
	holder.remove_reagent(id, 0.5 * REAGENTS_METABOLISM)
	. = ..()