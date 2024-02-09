//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/

///////////
//MATCHES//
///////////
/obj/item/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/items/cigarettes.dmi'
	icon_state = "match_unlit"
	var/lit = 0
	var/burnt = 0
	var/smoketime = 5
	w_class = 1.0
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1)
	attack_verb = list("burnt", "singed")

/obj/item/match/process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		burn_out()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/match/dropped(mob/user as mob)
	if(lit)
		burn_out()
	return ..()

/obj/item/match/proc/burn_out()
	lit = 0
	burnt = 1
	damtype = "brute"
	icon_state = "match_burnt"
	item_state = "cigoff"
	name = "burnt match"
	desc = "A match. This one has seen better days."
	GLOBL.processing_objects.Remove(src)

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = 1
	body_parts_covered = null
	attack_verb = list("burnt", "singed")
	var/lit = 0
	var/icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	var/icon_off = "cigoff"
	var/type_butt = /obj/item/cigbutt
	var/lastHolder = null
	var/smoketime = 300
	var/chem_volume = 15

/obj/item/clothing/mask/cigarette/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15

/obj/item/clothing/mask/cigarette/Destroy()
	qdel(reagents)
	return ..()

/obj/item/clothing/mask/cigarette/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(WT.isOn())//Badasses dont get blinded while lighting their cig with a welding tool
			light(SPAN_NOTICE("[user] casually lights the [name] with [W]."))

	else if(istype(W, /obj/item/lighter/zippo))
		var/obj/item/lighter/zippo/Z = W
		if(Z.lit)
			light(SPAN("rose", "With a flick of their wrist, [user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/lighter))
		var/obj/item/lighter/L = W
		if(L.lit)
			light(SPAN_NOTICE("[user] manages to light their [name] with [W]."))

	else if(istype(W, /obj/item/match))
		var/obj/item/match/M = W
		if(M.lit)
			light(SPAN_NOTICE("[user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/melee/energy/sword))
		var/obj/item/melee/energy/sword/S = W
		if(S.active)
			light(SPAN_WARNING("[user] swings their [W], barely missing their nose. They light their [name] in the process."))

	else if(istype(W, /obj/item/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [W], and manages to light their [name]."))

	//can't think of any other way to update the overlays :<
	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)
	return

/obj/item/clothing/mask/cigarette/afterattack(obj/item/reagent_containers/glass/glass, mob/user as mob, proximity)
	..()
	if(!proximity)
		return
	if(istype(glass))	//you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, SPAN_NOTICE("You dip \the [src] into \the [glass]."))
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("[glass] is empty."))
			else
				to_chat(user, SPAN_NOTICE("[src] is full."))

/obj/item/clothing/mask/cigarette/proc/light(flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		damtype = "fire"
		if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
			var/datum/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		flags &= ~NOREACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		GLOBL.processing_objects.Add(src)


/obj/item/clothing/mask/cigarette/process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		die()
		return
	if(location)
		location.hotspot_expose(700, 5)
	if(reagents && reagents.total_volume)	//	check if it has any reagents at all
		if(iscarbon(loc) && (src == loc:wear_mask)) // if it's in the human/monkey mouth, transfer reagents to the mob
			var/mob/living/carbon/C = loc
			if(prob(15)) // so it's not an instarape in case of acid
				reagents.reaction(C, INGEST)
			reagents.trans_to(C, REAGENTS_METABOLISM)
		else // else just remove some of the reagents
			reagents.remove_any(REAGENTS_METABOLISM)
	return

/obj/item/clothing/mask/cigarette/attack_self(mob/user as mob)
	if(lit == 1)
		user.visible_message(SPAN_NOTICE("[user] calmly drops and treads on the lit [src], putting it out instantly."))
		die()
	return ..()

/obj/item/clothing/mask/cigarette/proc/die()
	var/turf/T = get_turf(src)
	var/obj/item/butt = new type_butt(T)
	transfer_fingerprints_to(butt)
	if(ismob(loc))
		var/mob/living/M = loc
		to_chat(M, SPAN_NOTICE("Your [name] goes out."))
		M.u_equip(src)	//un-equip it so the overlays can update
		M.update_inv_wear_mask(0)
	GLOBL.processing_objects.Remove(src)
	qdel(src)

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	type_butt = /obj/item/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 1500
	chem_volume = 20

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"

/obj/item/clothing/mask/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 7200
	chem_volume = 30

/obj/item/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/items/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = 1
	throwforce = 1

/obj/item/cigbutt/New()
	..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	transform = turn(transform,rand(0,360))

/obj/item/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"


/obj/item/clothing/mask/cigarette/cigar/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(WT.isOn())
			light(SPAN_NOTICE("[user] insults [name] by lighting it with [W]."))

	else if(istype(W, /obj/item/lighter/zippo))
		var/obj/item/lighter/zippo/Z = W
		if(Z.lit)
			light(SPAN("rose", "With a flick of their wrist, [user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/lighter))
		var/obj/item/lighter/L = W
		if(L.lit)
			light(SPAN_NOTICE("[user] manages to offend their [name] by lighting it with [W]."))

	else if(istype(W, /obj/item/match))
		var/obj/item/match/M = W
		if(M.lit)
			light(SPAN_NOTICE("[user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/melee/energy/sword))
		var/obj/item/melee/energy/sword/S = W
		if(S.active)
			light("<span class='warning'>[user] swings their [W], barely missing their nose. They light their [name] in the process.</span>")

	else if(istype(W, /obj/item/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [W], and manages to light their [name] with the power of science."))

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/cigarette/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meershaum or something."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = 100

/obj/item/clothing/mask/cigarette/pipe/light(flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		damtype = "fire"
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		GLOBL.processing_objects.Add(src)

/obj/item/clothing/mask/cigarette/pipe/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		new /obj/effect/decal/cleanable/ash(location)
		if(ismob(loc))
			var/mob/living/M = loc
			to_chat(M, SPAN_NOTICE("Your [name] goes out, and you empty the ash."))
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			M.update_inv_wear_mask(0)
		GLOBL.processing_objects.Remove(src)
		return
	if(location)
		location.hotspot_expose(700, 5)

/obj/item/clothing/mask/cigarette/pipe/attack_self(mob/user as mob) //Refills the pipe. Can be changed to an attackby later, if loose tobacco is added to vendors or something.
	if(lit == 1)
		user.visible_message(SPAN_NOTICE("[user] puts out [src]."))
		lit = 0
		icon_state = icon_off
		item_state = icon_off
		GLOBL.processing_objects.Remove(src)
		return
	if(smoketime <= 0)
		to_chat(user, SPAN_NOTICE("You refill the pipe with tobacco."))
		smoketime = initial(smoketime)

/obj/item/clothing/mask/cigarette/pipe/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(WT.isOn())//
			light(SPAN_NOTICE("[user] recklessly lights [name] with [W]."))

	else if(istype(W, /obj/item/lighter/zippo))
		var/obj/item/lighter/zippo/Z = W
		if(Z.lit)
			light(SPAN("rose", "With much care, [user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/lighter))
		var/obj/item/lighter/L = W
		if(L.lit)
			light(SPAN_NOTICE("[user] manages to light their [name] with [W]."))

	else if(istype(W, /obj/item/match))
		var/obj/item/match/M = W
		if(M.lit)
			light(SPAN_NOTICE("[user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [W], and manages to light their [name] with the power of science."))

/obj/item/clothing/mask/cigarette/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
	smoketime = 400



/////////
//ZIPPO//
/////////
/obj/item/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items/lighters.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	var/icon_on = "lighter-g-on"
	var/icon_off = "lighter-g"
	w_class = 1
	throwforce = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")
	var/lit = 0

/obj/item/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon_state = "zippo"
	item_state = "zippo"
	icon_on = "zippoon"
	icon_off = "zippo"

/obj/item/lighter/random/New()
	var/color = pick("r","c","y","g")
	icon_on = "lighter-[color]-on"
	icon_off = "lighter-[color]"
	icon_state = icon_off

/obj/item/lighter/attack_self(mob/living/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!lit)
			lit = 1
			icon_state = icon_on
			item_state = icon_on
			if(istype(src, /obj/item/lighter/zippo))
				user.visible_message(SPAN("rose", "Without even breaking stride, [user] flips open and lights [src] in one smooth movement."))
			else
				if(prob(95))
					user.visible_message(SPAN_NOTICE("After a few attempts, [user] manages to light the [src]."))
				else
					to_chat(user, SPAN_WARNING("You burn yourself while lighting the lighter."))
					user.adjustFireLoss(5)
					user.visible_message(SPAN_NOTICE("After a few attempts, [user] manages to light the [src], they however burn their finger in the process."))

			//user.SetLuminosity(user.luminosity + 2)
			user.set_light(user.luminosity + 2)
			GLOBL.processing_objects.Add(src)
		else
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			if(istype(src, /obj/item/lighter/zippo) )
				user.visible_message(SPAN("rose", "You hear a quiet click, as [user] shuts off [src] without even looking at what they're doing."))
			else
				user.visible_message(SPAN_NOTICE("[user] quietly shuts off the [src]."))

			//user.SetLuminosity(user.luminosity - 2)
			user.set_light(user.luminosity - 2)
			GLOBL.processing_objects.Remove(src)
	else
		return ..()
	return


/obj/item/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return
	M.IgniteMob()

	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette) && user.zone_sel.selecting == "mouth" && lit)
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/lighter/zippo))
				cig.light(SPAN("rose", "[user] whips the [name] out and holds it for [M]."))
			else
				cig.light(SPAN_NOTICE("[user] holds the [name] out for [M], and lights the [cig.name]."))
	else
		..()

/obj/item/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return


/obj/item/lighter/pickup(mob/user)
	if(lit)
		//SetLuminosity(0)
		//user.SetLuminosity(user.luminosity+2)
		set_light(0)
		user.set_light(user.luminosity+2)
	return


/obj/item/lighter/dropped(mob/user)
	if(lit)
		//user.SetLuminosity(user.luminosity-2)
		//SetLuminosity(2)
		user.set_light(user.luminosity-2)
		set_light(2)
	return
