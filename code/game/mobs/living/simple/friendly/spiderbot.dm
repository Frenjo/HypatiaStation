/mob/living/simple/spiderbot

	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 500
	pass_flags = PASS_FLAG_TABLE // Pass through tables!

	var/obj/item/radio/borg/radio = null
	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/cell/cell = null
	var/obj/machinery/camera/camera = null
	var/obj/item/mmi/mmi = null
	var/list/req_access = list(ACCESS_ROBOTICS) //Access needed to pop out the brain.

	name = "Spider-bot"
	desc = "A skittering robotic friend!"
	icon = 'icons/mob/robots.dmi'
	icon_state = "spiderbot-chassis"
	icon_living = "spiderbot-chassis"
	icon_dead = "spiderbot-smashed"
	wander = 0

	health = 10
	maxHealth = 10

	attacktext = "shocks"
	attacktext = "shocks"
	melee_damage_lower = 1
	melee_damage_upper = 3

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"

	var/obj/item/held_item = null //Storage for single item they can hold.
	var/emagged = 0               //IS WE EXPLODEN?
	var/syndie = 0                //IS WE SYNDICAT? (currently unused)
	speed = -1                    //Spiderbots gotta go fast.
	//pass_flags = PASS_FLAG_TABLE      //Maybe griefy?
	small = 1
	speak_emote = list("beeps","clicks","chirps")

/mob/living/simple/spiderbot/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		to_chat(user, SPAN_DANGER("\The [src] is already overloaded - better run."))
		return FALSE

	emagged = TRUE
	to_chat(user, SPAN_WARNING("You short out the security protocols and overload \the [src]'s cell, priming it to explode in a short time."))
	spawn(10 SECONDS)
		to_chat(src, SPAN_WARNING("Your cell seems to be outputting a lot of power..."))
	spawn(20 SECONDS)
		to_chat(src, SPAN_DANGER("Internal heat sensors are spiking! Something is badly wrong with your cell!"))
	spawn(30 SECONDS)
		explode()
	return TRUE

/mob/living/simple/spiderbot/attack_tool(obj/item/tool, mob/user)
	if(iswelder(tool))
		if(health >= maxHealth)
			to_chat(user, SPAN_INFO("\The [src] is undamaged!"))
			return TRUE
		var/obj/item/weldingtool/WT = tool
		if(!WT.remove_fuel(0, user))
			return TRUE

		health += pick(1, 1, 1, 2, 2, 3)
		add_fingerprint(user)
		user.visible_message(
			SPAN_INFO("[user] spot-welds some of the damage on \the [src]!"),
			SPAN_INFO("You spot-weld some of the damage on \the [src]!"),
			SPAN_WARNING("You hear welding.")
		)
		if(health > maxHealth)
			health = maxHealth
		return TRUE

	return ..()

/mob/living/simple/spiderbot/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/mmi) || istype(O, /obj/item/mmi/posibrain))
		var/obj/item/mmi/B = O
		if(src.mmi) //There's already a brain in it.
			user << "\red There's already a brain in [src]!"
			return
		if(!B.brainmob)
			user << "\red Sticking an empty MMI into the frame would sort of defeat the purpose."
			return
		if(!B.brainmob.key)
			var/ghost_can_reenter = 0
			if(B.brainmob.mind)
				for(var/mob/dead/observer/G in GLOBL.player_list)
					if(G.can_reenter_corpse && G.mind == B.brainmob.mind)
						ghost_can_reenter = 1
						break
			if(!ghost_can_reenter)
				user << "<span class='notice'>[O] is completely unresponsive; there's no point.</span>"
				return

		if(B.brainmob.stat == DEAD)
			user << "\red [O] is dead. Sticking it into the frame would sort of defeat the purpose."
			return

		if(jobban_isbanned(B.brainmob, "Cyborg"))
			user << "\red [O] does not seem to fit."
			return

		user << "\blue You install [O] in [src]!"

		user.drop_item()
		src.mmi = O
		src.transfer_personality(O)

		O.loc = src
		src.update_icon()
		return 1

	else if(istype(O, /obj/item/card/id) || istype(O, /obj/item/pda))
		if (!mmi)
			user << "\red There's no reason to swipe your ID - the spiderbot has no brain to remove."
			return 0

		var/obj/item/card/id/id_card

		if(istype(O, /obj/item/card/id))
			id_card = O
		else
			var/obj/item/pda/pda = O
			id_card = pda.id

		if(ACCESS_ROBOTICS in id_card.access)
			user << "\blue You swipe your access card and pop the brain out of [src]."
			eject_brain()

			if(held_item)
				held_item.loc = src.loc
				held_item = null

			return 1
		else
			user << "\red You swipe your card, with no effect."
			return 0
	else
		if(O.force)
			var/damage = O.force
			if(O.damtype == HALLOSS)
				damage = 0
			adjustBruteLoss(damage)
			visible_message(SPAN_DANGER("[src] has been attacked with \the [O] by [user]."))
		else
			to_chat(user, SPAN_WARNING("This weapon is ineffective, it does no damage."))
			visible_message(SPAN_WARNING("[user] gently taps [src] with \the [O]."))

/mob/living/simple/spiderbot/proc/transfer_personality(obj/item/mmi/M)

		src.mind = M.brainmob.mind
		src.mind.key = M.brainmob.key
		src.ckey = M.brainmob.ckey
		src.name = "Spider-bot ([M.brainmob.name])"

/mob/living/simple/spiderbot/proc/explode() //When emagged.
	visible_message(SPAN_DANGER("[src] makes an odd warbling noise, fizzles, and explodes!"))
	explosion(GET_TURF(src), -1, -1, 3, 5)
	eject_brain()
	Die()

/mob/living/simple/spiderbot/proc/update_icon()
	if(mmi)
		if(istype(mmi,/obj/item/mmi))
			icon_state = "spiderbot-chassis-mmi"
			icon_living = "spiderbot-chassis-mmi"
		if(istype(mmi, /obj/item/mmi/posibrain))
			icon_state = "spiderbot-chassis-posi"
			icon_living = "spiderbot-chassis-posi"

	else
		icon_state = "spiderbot-chassis"
		icon_living = "spiderbot-chassis"

/mob/living/simple/spiderbot/proc/eject_brain()
	if(mmi)
		var/turf/T = GET_TURF(src)
		if(isnotnull(T))
			mmi.loc = T
		if(mind)
			mind.transfer_to(mmi.brainmob)
		mmi = null
		src.name = "Spider-bot"
		update_icon()

/mob/living/simple/spiderbot/Destroy()
	eject_brain()
	return ..()

/mob/living/simple/spiderbot/New()

	radio = new /obj/item/radio/borg(src)
	camera = new /obj/machinery/camera(src)
	camera.c_tag = "Spiderbot-[real_name]"
	camera.network = list("SS13")

	..()

/mob/living/simple/spiderbot/Die()

	GLOBL.living_mob_list.Remove(src)
	GLOBL.dead_mob_list.Add(src)

	if(camera)
		camera.status = 0

	held_item.loc = src.loc
	held_item = null

	robogibs(src.loc, viruses)
	qdel(src)
	return

//Cannibalized from the parrot mob. ~Zuhayr
/mob/living/simple/spiderbot/verb/drop_held_item()
	set name = "Drop held item"
	set category = "Spiderbot"
	set desc = "Drop the item you're holding."

	if(stat)
		return

	if(!held_item)
		usr << "\red You have nothing to drop!"
		return 0

	if(istype(held_item, /obj/item/grenade))
		visible_message("\red [src] launches \the [held_item]!", "\red You launch \the [held_item]!", "You hear a skittering noise and a thump!")
		var/obj/item/grenade/G = held_item
		G.loc = src.loc
		G.prime()
		held_item = null
		return 1

	visible_message("\blue [src] drops \the [held_item]!", "\blue You drop \the [held_item]!", "You hear a skittering noise and a soft thump.")

	held_item.loc = src.loc
	held_item = null
	return 1

/mob/living/simple/spiderbot/verb/get_item()
	set name = "Pick up item"
	set category = "Spiderbot"
	set desc = "Allows you to take a nearby small item."

	if(stat)
		return -1

	if(held_item)
		src << "\red You are already holding \the [held_item]"
		return 1

	var/list/items = list()
	for(var/obj/item/I in view(1,src))
		if(I.loc != src && I.w_class <= 2)
			items.Add(I)

	var/obj/selection = input("Select an item.", "Pickup") in items

	if(selection)
		for(var/obj/item/I in view(1, src))
			if(selection == I)
				held_item = selection
				selection.loc = src
				visible_message("\blue [src] scoops up \the [held_item]!", "\blue You grab \the [held_item]!", "You hear a skittering noise and a clink.")
				return held_item
		src << "\red \The [selection] is too far away."
		return 0

	src << "\red There is nothing of interest to take."
	return 0

/mob/living/simple/spiderbot/examine()
	..()
	if(src.held_item)
		usr << "It is carrying \a [src.held_item] \icon[src.held_item]."
