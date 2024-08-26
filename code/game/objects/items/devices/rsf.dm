/*
CONTAINS:
RSF

*/
#define MODE_DOSH 0
#define MODE_DRINKING_GLASS 1
#define MODE_PAPER 2
#define MODE_PEN 3
#define MODE_DICE_PACK 4
#define MODE_CIGARETTE 5
/obj/item/rsf
	name = "rapid-service-fabricator (RSF)"
	desc = "A device used to rapidly deploy service items."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	var/matter = 0
	var/mode = MODE_DOSH
	w_class = 3.0

/obj/item/rsf/New()
	. = ..()
	desc = "An RSF. It currently holds [matter]/30 fabrication-units."

/obj/item/rsf/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/rcd_ammo))
		if((matter + 10) > 30)
			to_chat(user, SPAN_WARNING("The RSF can't hold any more matter."))
			return TRUE
		qdel(I)
		matter += 10
		playsound(src, 'sound/machines/click.ogg', 10, 1)
		to_chat(user, SPAN_INFO("The RSF now holds [matter]/30 fabrication-units."))
		desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return TRUE
	return ..()

/obj/item/rsf/attack_self(mob/user)
	playsound(src, 'sound/effects/pop.ogg', 50, 0)
	if(mode == MODE_DOSH)
		mode = MODE_DRINKING_GLASS
		user << "Changed dispensing mode to 'Drinking Glass'"
		return
	if(mode == MODE_DRINKING_GLASS)
		mode = MODE_PAPER
		user << "Changed dispensing mode to 'Paper'"
		return
	if(mode == MODE_PAPER)
		mode = MODE_PEN
		user << "Changed dispensing mode to 'Pen'"
		return
	if(mode == MODE_PEN)
		mode = MODE_DICE_PACK
		user << "Changed dispensing mode to 'Dice Pack'"
		return
	if(mode == MODE_DICE_PACK)
		mode = MODE_CIGARETTE
		user << "Changed dispensing mode to 'Cigarette'"
		return
	if(mode == MODE_CIGARETTE)
		mode = MODE_DOSH
		user << "Changed dispensing mode to 'Dosh'"
		return
	// Change mode

/obj/item/rsf/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(!(istype(A, /obj/structure/table) || istype(A, /turf/open/floor)))
		return

	if(istype(A, /obj/structure/table) && mode == MODE_DOSH)
		if(istype(A, /obj/structure/table) && matter >= 1)
			user << "Dispensing Dosh..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/spacecash/c10(A.loc)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 200 //once money becomes useful, I guess changing this to a high ammount, like 500 units a kick, till then, enjoy dosh!
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /turf/open/floor) && mode == MODE_DOSH)
		if(istype(A, /turf/open/floor) && matter >= 1)
			user << "Dispensing Dosh..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/spacecash/c10(A)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 200 //once money becomes useful, I guess changing this to a high ammount, like 500 units a kick, till then, enjoy dosh!
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /obj/structure/table) && mode == MODE_DRINKING_GLASS)
		if(istype(A, /obj/structure/table) && matter >= 1)
			user << "Dispensing Drinking Glass..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/reagent_holder/food/drinks/drinkingglass(A.loc)
			if (isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 50
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /turf/open/floor) && mode == MODE_DRINKING_GLASS)
		if(istype(A, /turf/open/floor) && matter >= 1)
			user << "Dispensing Drinking Glass..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/reagent_holder/food/drinks/drinkingglass(A)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 50
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /obj/structure/table) && mode == MODE_PAPER)
		if(istype(A, /obj/structure/table) && matter >= 1)
			user << "Dispensing Paper Sheet..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/paper(A.loc)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 10
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /turf/open/floor) && mode == MODE_PAPER)
		if(istype(A, /turf/open/floor) && matter >= 1)
			user << "Dispensing Paper Sheet..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/paper(A)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 10
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /obj/structure/table) && mode == MODE_PEN)
		if(istype(A, /obj/structure/table) && matter >= 1)
			user << "Dispensing Pen..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/pen(A.loc)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 50
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /turf/open/floor) && mode == MODE_PEN)
		if(istype(A, /turf/open/floor) && matter >= 1)
			user << "Dispensing Pen..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/pen(A)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 50
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /obj/structure/table) && mode == MODE_DICE_PACK)
		if(istype(A, /obj/structure/table) && matter >= 1)
			user << "Dispensing Dice Pack..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/storage/pill_bottle/dice(A.loc)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 200
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /turf/open/floor) && mode == MODE_DICE_PACK)
		if(istype(A, /turf/open/floor) && matter >= 1)
			user << "Dispensing Dice Pack..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/storage/pill_bottle/dice(A)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 200
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /obj/structure/table) && mode == MODE_CIGARETTE)
		if(istype(A, /obj/structure/table) && matter >= 1)
			user << "Dispensing Cigarette..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/clothing/mask/cigarette(A.loc)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 10
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return

	else if(istype(A, /turf/open/floor) && mode == MODE_CIGARETTE)
		if(istype(A, /turf/open/floor) && matter >= 1)
			user << "Dispensing Cigarette..."
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			new /obj/item/clothing/mask/cigarette(A)
			if(isrobot(user))
				var/mob/living/silicon/robot/engy = user
				engy.cell.charge -= 10
			else
				matter--
				user << "The RSF now holds [matter]/30 fabrication-units."
				desc = "An RSF. It currently holds [matter]/30 fabrication-units."
		return
#undef MODE_DOSH
#undef MODE_DRINKING_GLASS
#undef MODE_PAPER
#undef MODE_PEN
#undef MODE_DICE_PACK
#undef MODE_CIGARETTE