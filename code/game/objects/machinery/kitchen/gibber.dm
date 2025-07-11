/obj/machinery/gibber
	name = "gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 500
	)

	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	var/mob/living/occupant // Mob who has been put inside

//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/turf/input_plate

/obj/machinery/gibber/autogibber/New()
	..()
	spawn(5)
		for(var/i in GLOBL.cardinal)
			var/obj/machinery/mineral/input/input_obj = locate( /obj/machinery/mineral/input, get_step(src.loc, i) )
			if(input_obj)
				if(isturf(input_obj.loc))
					input_plate = input_obj.loc
					qdel(input_obj)
					break

		if(!input_plate)
			log_misc("a [src] didn't find an input plate.")
			return

/obj/machinery/gibber/autogibber/Bumped(var/atom/A)
	if(!input_plate) return

	if(isliving(A))
		var/mob/living/L = A

		if(L.loc == input_plate)
			L.forceMove(src)
			L.gib()


/obj/machinery/gibber/New()
	..()
	add_overlay("grjam")

/obj/machinery/gibber/update_icon()
	cut_overlays()
	if (dirty)
		add_overlay("grbloody")
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		add_overlay("grjam")
	else if (operating)
		add_overlay("gruse")
	else
		add_overlay("gridle")

/obj/machinery/gibber/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/gibber/relaymove(mob/user)
	src.go_out()
	return

/obj/machinery/gibber/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		user << "\red It's locked and running"
		return
	else
		src.startgibbing(user)

/obj/machinery/gibber/attackby(obj/item/grab/G, mob/user)
	if(src.occupant)
		user << "\red The gibber is full, empty it first!"
		return

	if( !(istype(G, /obj/item/grab)) )
		user << "\red This item is not suitable for the gibber!"
		return

	if(!iscarbon(G.affecting) && !issimple(G.affecting))
		user << "\red This item is not suitable for the gibber!"
		return

	if(G.state < 2)
		user << "\red You need a better grip to do that!"
		return

	if(G.affecting.abiotic(TRUE))
		user << "\red Subject may not have abiotic items on."
		return

	user.visible_message("\red [user] starts to put [G.affecting] into the gibber!")
	src.add_fingerprint(user)
	if(do_after(user, 30) && G && G.affecting && !occupant)
		user.visible_message("\red [user] stuffs [G.affecting] into the gibber!")
		var/mob/M = G.affecting
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		src.occupant = M
		qdel(G)
		update_icon()

/obj/machinery/gibber/verb/eject()
	set category = PANEL_OBJECT
	set name = "Empty Gibber"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	if (!src.occupant)
		return
	for(var/obj/O in src)
		O.forceMove(loc)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	src.occupant = null
	update_icon()
	return


/obj/machinery/gibber/proc/startgibbing(mob/user)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("\red You hear a loud metallic grinding sound.")
		return
	use_power(1000)
	visible_message("\red You hear a loud squelchy grinding sound.")
	src.operating = 1
	update_icon()

	var/totalslabs = 3
	var/obj/item/reagent_holder/food/snacks/meat/allmeat[totalslabs]

	if(ishuman(src.occupant))
		var/mob/living/carbon/human/H = src.occupant
		var/sourcename = H.real_name
		var/sourcejob = H.job
		var/sourcenutriment = H.nutrition / 15
		var/sourcetotalreagents = H.reagents.total_volume

		for(var/i=1 to totalslabs)
			var/obj/item/reagent_holder/food/snacks/meat/human/newmeat = new
			newmeat.name = sourcename + newmeat.name
			newmeat.subjectname = sourcename
			newmeat.subjectjob = sourcejob
			newmeat.reagents.add_reagent("nutriment", sourcenutriment / totalslabs) // Thehehe. Fat guys go first
			H.reagents.trans_to(newmeat, round (sourcetotalreagents / totalslabs, 1)) // Transfer all the reagents from the
			allmeat[i] = newmeat

		H.attack_log += "\[[time_stamp()]\] Was gibbed by <b>[user]/[user.ckey]</b>" //One shall not simply gib a mob unnoticed!
		user.attack_log += "\[[time_stamp()]\] Gibbed <b>[H]/[H.ckey]</b>"
		msg_admin_attack("[user.name] ([user.ckey]) gibbed [H] ([H.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		H.death(1)
		H.ghostize()

	else if(iscarbon(occupant) || issimple(occupant))
		// I don't think /simple_animal actually did anything with their nutrition so it would just always be 400.
		var/nutrition = iscarbon(occupant) ? src.occupant:nutrition : 400
		var/sourcename = occupant.name
		var/sourcenutriment = nutrition / 15
		var/sourcetotalreagents = 0

		if(ismonkey(occupant) || isalien(occupant)) // why are you gibbing aliens? oh well
			totalslabs = 3
			sourcetotalreagents = occupant.reagents.total_volume
		else if(istype(occupant, /mob/living/simple/cow) || isbear(occupant))
			totalslabs = 2
		else
			totalslabs = 1
			sourcenutriment = nutrition / 30 // small animals don't have as much nutrition

		for(var/i=1 to totalslabs)
			var/obj/item/reagent_holder/food/snacks/meat/newmeat = new /obj/item/reagent_holder/food/snacks/meat()
			newmeat.name = "[sourcename]-[newmeat.name]"

			newmeat.reagents.add_reagent("nutriment", sourcenutriment / totalslabs)

			// Transfer reagents from the old mob to the meat
			if(iscarbon(occupant))
				occupant.reagents.trans_to(newmeat, round(sourcetotalreagents / totalslabs, 1))

			allmeat[i] = newmeat

		if(isnotnull(occupant.client)) // Gibbed a cow with a client in it? log that shit
			occupant.attack_log += "\[[time_stamp()]\] Was gibbed by <b>[user]/[user.ckey]</b>"
			user.attack_log += "\[[time_stamp()]\] Gibbed <b>[src.occupant]/[occupant.ckey]</b>"
			msg_admin_attack("\[[time_stamp()]\] <b>[key_name(user)]</b> gibbed <b>[key_name(occupant)]</b>")

		occupant.death(1)
		occupant.ghostize()

	qdel(occupant)

	spawn(src.gibtime)
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		operating = 0
		for (var/i=1 to totalslabs)
			var/obj/item/meatslab = allmeat[i]
			var/turf/Tx = locate(src.x - i, src.y, src.z)
			meatslab.forceMove(loc)
			meatslab.throw_at(Tx,i,3)
			if (!Tx.density)
				new /obj/effect/decal/cleanable/blood/gibs(Tx,i)
		src.operating = 0
		update_icon()
