/obj/item/dnainjector
	name = "\improper DNA injector"
	desc = "This injects the person with DNA."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"
	var/block=0
	var/datum/dna2/record/buf=null
	var/s_time = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
	var/uses = 1
	var/nofail
	var/is_bullet = 0
	var/inuse = 0

	// USE ONLY IN PREMADE SYRINGES.  WILL NOT WORK OTHERWISE.
	var/datatype=0
	var/value=0

/obj/item/dnainjector/New()
	. = ..()
	if(datatype && block)
		buf = new /datum/dna2/record()
		buf.dna = new /datum/dna()
		buf.types = datatype
		buf.dna.ResetSE()
		//testing("[name]: DNA2 SE blocks prior to SetValue: [english_list(buf.dna.SE)]")
		SetValue(value)
		//testing("[name]: DNA2 SE blocks after SetValue: [english_list(buf.dna.SE)]")

/obj/item/dnainjector/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/dnainjector/proc/GetRealBlock(var/selblock)
	if(selblock==0)
		return block
	else
		return selblock

/obj/item/dnainjector/proc/GetState(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEState(real_block)
	else
		return buf.dna.GetUIState(real_block)

/obj/item/dnainjector/proc/SetState(var/on, var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEState(real_block,on)
	else
		return buf.dna.SetUIState(real_block,on)

/obj/item/dnainjector/proc/GetValue(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEValue(real_block)
	else
		return buf.dna.GetUIValue(real_block)

/obj/item/dnainjector/proc/SetValue(var/val,var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEValue(real_block,val)
	else
		return buf.dna.SetUIValue(real_block,val)

/obj/item/dnainjector/proc/inject(mob/M, mob/user)
	if(isliving(M))
		M.radiation += rand(5,20)

	if (!(MUTATION_NO_CLONE in M.mutations)) // prevents drained people from having their DNA changed
		if (buf.types & DNA2_BUF_UI)
			if (!block) //isolated block?
				M.UpdateAppearance(buf.dna.UI.Copy())
				if (buf.types & DNA2_BUF_UE) //unique enzymes? yes
					M.real_name = buf.dna.real_name
					M.name = buf.dna.real_name
				uses--
			else
				M.dna.SetUIValue(block,src.GetValue())
				M.UpdateAppearance()
				uses--
		if (buf.types & DNA2_BUF_SE)
			if (!block) //isolated block?
				M.dna.SE = buf.dna.SE.Copy()
				M.dna.UpdateSE()
			else
				M.dna.SetSEValue(block,src.GetValue())
			domutcheck(M, null, block!=null)
			uses--
			if(prob(5))
				trigger_side_effect(M)

	spawn(0)//this prevents the collapse of space-time continuum
		if (user)
			user.drop_from_inventory(src)
		qdel(src)
	return uses

/obj/item/dnainjector/attack(mob/M, mob/user)
	if(!ismob(M))
		return
	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return

	M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been injected with [name] by [user.name] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [name] to inject [M.name] ([M.ckey])</font>"
	log_attack("[user.name] ([user.ckey]) used the [name] to inject [M.name] ([M.ckey])")

	if (user)
		if(ishuman(M))
			if(!inuse)
				var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
				O.source = user
				O.target = M
				O.item = src
				O.s_loc = user.loc
				O.t_loc = M.loc
				O.place = "dnainjector"
				src.inuse = 1
				spawn(50) // Not the best fix. There should be an failure proc, for /effect/equip_e/, which is called when the first initital checks fail
					inuse = 0
				M.requests += O
				if (buf.types & DNA2_BUF_SE)
					if(block)// Isolated injector
						testing("Isolated block [block] injector with contents: [GetValue()]")
						if(GetState() && block == GLOBL.dna_data.monkey_block && ishuman(M))
							message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the Isolated [name] \red(MONKEY)")
							log_attack("[key_name(user)] injected [key_name(M)] with the Isolated [name] (MONKEY)")
							log_game("[key_name_admin(user)] injected [key_name_admin(M)] with the Isolated [name] \red(MONKEY)")
						else
							log_attack("[key_name(user)] injected [key_name(M)] with the Isolated [name]")
					else
						testing("DNA injector with contents: [english_list(buf.dna.SE)]")
						if(GetState(GLOBL.dna_data.monkey_block) && ishuman(M))
							message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name] \red(MONKEY)")
							log_attack("[key_name(user)] injected [key_name(M)] with the [name] (MONKEY)")
							log_game("[key_name_admin(user)] injected [key_name_admin(M)] with the [name] \red(MONKEY)")
						else
	//						message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name]")
							log_attack("[key_name(user)] injected [key_name(M)] with the [name]")
				else
	//				message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name]")
					log_attack("[key_name(user)] injected [key_name(M)] with the [name]")

				spawn( 0 )
					O.process()
					return
		else
			if(!inuse)

				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red [] has been injected with [] by [].", M, src, user), 1)
					//Foreach goto(192)
				if(!(ishuman(M) || ismonkey(M)))
					to_chat(user, SPAN_WARNING("Apparently it didn't work."))
					return

				if (buf.types & DNA2_BUF_SE)
					if(block)// Isolated injector
						testing("Isolated block [block] injector with contents: [GetValue()]")
						if(GetState() && block == GLOBL.dna_data.monkey_block && ishuman(M))
							message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the Isolated [name] \red(MONKEY)")
							log_attack("[key_name(user)] injected [key_name(M)] with the Isolated [name] (MONKEY)")
							log_game("[key_name_admin(user)] injected [key_name_admin(M)] with the Isolated [name] \red(MONKEY)")
						else
							log_attack("[key_name(user)] injected [key_name(M)] with the Isolated [name]")
					else
						testing("DNA injector with contents: [english_list(buf.dna.SE)]")
						if(GetState(GLOBL.dna_data.monkey_block) && ishuman(M))
							message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name] \red(MONKEY)")
							log_game("[key_name(user)] injected [key_name(M)] with the [name] (MONKEY)")
						else
	//						message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name]")
							log_game("[key_name(user)] injected [key_name(M)] with the [name]")
				else
//					message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name]")
					log_game("[key_name(user)] injected [key_name(M)] with the [name]")
				inuse = 1
				inject(M, user)//Now we actually do the heavy lifting.
				spawn(50)
					inuse = 0
				/*
				A user injecting themselves could mean their own transformation and deletion of mob.
				I don't have the time to figure out how this code works so this will do for now.
				I did rearrange things a bit.
				*/
				if(user)//If the user still exists. Their mob may not.
					if(M)//Runtime fix: If the mob doesn't exist, mob.name doesnt work. - Nodrak
						user.show_message(text("\red You inject [M.name]"))
					else
						user.show_message(text("\red You finish the injection."))
	return



/obj/item/dnainjector/hulkmut
	name = "DNA injector (hulk)"
	desc = "This will make you big and strong, but give you a bad skin condition."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/hulkmut/New()
	block = GLOBL.dna_data.hulk_block
	..()

/obj/item/dnainjector/antihulk
	name = "DNA injector (anti-hulk)"
	desc = "Cures green skin."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antihulk/New()
	block = GLOBL.dna_data.hulk_block
	..()

/obj/item/dnainjector/xraymut
	name = "DNA injector (x-ray)"
	desc = "Finally you can see what the Captain does."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 8

/obj/item/dnainjector/xraymut/New()
	block = GLOBL.dna_data.xray_block
	..()

/obj/item/dnainjector/antixray
	name = "DNA injector (anti-xray)"
	desc = "It will make you see harder."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 8

/obj/item/dnainjector/antixray/New()
	block = GLOBL.dna_data.xray_block
	..()

/obj/item/dnainjector/firemut
	name = "DNA injector (fire)"
	desc = "Gives you fire."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 10

/obj/item/dnainjector/firemut/New()
	block = GLOBL.dna_data.fire_block
	..()

/obj/item/dnainjector/antifire
	name = "DNA injector (anti-fire)"
	desc = "Cures fire."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 10

/obj/item/dnainjector/antifire/New()
	block = GLOBL.dna_data.fire_block
	..()

/obj/item/dnainjector/telemut
	name = "DNA injector (tele)"
	desc = "Super brain man!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 12

/obj/item/dnainjector/telemut/New()
	block = GLOBL.dna_data.tele_block
	..()

/obj/item/dnainjector/antitele
	name = "DNA injector (anti-tele)"
	desc = "Will make you not able to control your mind."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 12

/obj/item/dnainjector/antitele/New()
	block = GLOBL.dna_data.tele_block
	..()

/obj/item/dnainjector/nobreath
	name = "DNA injector (no breath)"
	desc = "Hold your breath and count to infinity."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/nobreath/New()
	block = GLOBL.dna_data.no_breath_block
	..()

/obj/item/dnainjector/antinobreath
	name = "DNA injector (anti-no breath)"
	desc = "Hold your breath and count to 100."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antinobreath/New()
	block = GLOBL.dna_data.no_breath_block
	..()

/obj/item/dnainjector/remoteview
	name = "DNA injector (remote view)"
	desc = "Stare into the distance for a reason."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/remoteview/New()
	block = GLOBL.dna_data.remote_view_block
	..()

/obj/item/dnainjector/antiremoteview
	name = "DNA injector (anti-remote view)"
	desc = "Cures green skin."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antiremoteview/New()
	block = GLOBL.dna_data.remote_view_block
	..()

/obj/item/dnainjector/regenerate
	name = "DNA injector (regeneration)"
	desc = "Healthy but hungry."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/regenerate/New()
	block = GLOBL.dna_data.regenerate_block
	..()

/obj/item/dnainjector/antiregenerate
	name = "DNA injector (anti-regeneration)"
	desc = "Sickly but sated."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antiregenerate/New()
	block = GLOBL.dna_data.regenerate_block
	..()

/obj/item/dnainjector/runfast
	name = "DNA injector (increase run)"
	desc = "Running Man."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/runfast/New()
	block = GLOBL.dna_data.increase_run_block
	..()

/obj/item/dnainjector/antirunfast
	name = "DNA injector (anti-increase run)"
	desc = "Walking Man."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antirunfast/New()
	block = GLOBL.dna_data.increase_run_block
	..()

/obj/item/dnainjector/morph
	name = "DNA injector (morph)"
	desc = "A total makeover."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/morph/New()
	block = GLOBL.dna_data.morph_block
	..()

/obj/item/dnainjector/antimorph
	name = "DNA injector (anti-morph)"
	desc = "Cures identity crisis."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antimorph/New()
	block = GLOBL.dna_data.morph_block
	..()

/* No COLDBLOCK on bay
/obj/item/dnainjector/cold
	name = "DNA injector (cold)"
	desc = "Feels a bit chilly."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = COLDBLOCK
		..()

/obj/item/dnainjector/anticold
	name = "DNA injector (anti-cold)"
	desc = "Feels room-temperature."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = COLDBLOCK
		..()
*/

/obj/item/dnainjector/noprints
	name = "DNA injector (no prints)"
	desc = "Better than a pair of budget insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/noprints/New()
	block = GLOBL.dna_data.no_prints_block
	..()

/obj/item/dnainjector/antinoprints
	name = "DNA injector (anti-no prints)"
	desc = "Not quite as good as a pair of budget insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antinoprints/New()
	block = GLOBL.dna_data.no_prints_block
	..()

/obj/item/dnainjector/insulation
	name = "DNA injector (shock immunity)"
	desc = "Better than a pair of real insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/insulation/New()
	block = GLOBL.dna_data.shock_immunity_block
	..()

/obj/item/dnainjector/antiinsulation
	name = "DNA injector (anti-shock immunity)"
	desc = "Not quite as good as a pair of real insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antiinsulation/New()
	block = GLOBL.dna_data.shock_immunity_block
	..()

/obj/item/dnainjector/midgit
	name = "DNA injector (small size)"
	desc = "Makes you shrink."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/midgit/New()
	block = GLOBL.dna_data.small_size_block
	..()

/obj/item/dnainjector/antimidgit
	name = "DNA injector (anti-small size)"
	desc = "Makes you grow. But not too much."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antimidgit/New()
	block = GLOBL.dna_data.small_size_block
	..()

/////////////////////////////////////
/obj/item/dnainjector/antiglasses
	name = "DNA injector (anti-glasses)"
	desc = "Toss away those glasses!"
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 1

/obj/item/dnainjector/antiglasses/New()
	block = GLOBL.dna_data.glasses_block
	..()

/obj/item/dnainjector/glassesmut
	name = "DNA injector (glasses)"
	desc = "Will make you need dorkish glasses."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 1

/obj/item/dnainjector/glassesmut/New()
	block = GLOBL.dna_data.glasses_block
	..()

/obj/item/dnainjector/epimut
	name = "DNA injector (epi)"
	desc = "Shake shake shake the room!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 3

/obj/item/dnainjector/epimut/New()
	block = GLOBL.dna_data.headache_block
	..()

/obj/item/dnainjector/antiepi
	name = "DNA injector (anti-epi)"
	desc = "Will fix you up from shaking the room."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 3

/obj/item/dnainjector/antiepi/New()
	block = GLOBL.dna_data.headache_block
	..()

/obj/item/dnainjector/anticough
	name = "DNA injector (anti-cough)"
	desc = "Will stop that awful noise."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 5

/obj/item/dnainjector/anticough/New()
	block = GLOBL.dna_data.cough_block
	..()

/obj/item/dnainjector/coughmut
	name = "DNA injector (cough)"
	desc = "Will bring forth a sound of horror from your throat."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 5

/obj/item/dnainjector/coughmut/New()
	block = GLOBL.dna_data.cough_block
	..()

/obj/item/dnainjector/clumsymut
	name = "DNA injector (clumsy)"
	desc = "Makes clumsy minions."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 6

/obj/item/dnainjector/clumsymut/New()
	block = GLOBL.dna_data.clumsy_block
	..()

/obj/item/dnainjector/anticlumsy
	name = "DNA injector (anti-clumsy)"
	desc = "Cleans up confusion."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 6

/obj/item/dnainjector/anticlumsy/New()
	block = GLOBL.dna_data.clumsy_block
	..()

/obj/item/dnainjector/antitour
	name = "DNA injector (anti-tour)"
	desc = "Will cure Tourette's."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 7

/obj/item/dnainjector/antitour/New()
	block = GLOBL.dna_data.twitch_block
	..()

/obj/item/dnainjector/tourmut
	name = "DNA injector (tour)"
	desc = "Gives you a nasty case off Tourette's."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 7

/obj/item/dnainjector/tourmut/New()
	block = GLOBL.dna_data.twitch_block
	..()

/obj/item/dnainjector/stuttmut
	name = "DNA injector (stutt)"
	desc = "Makes you s-s-stuttterrr."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 9

/obj/item/dnainjector/stuttmut/New()
	block = GLOBL.dna_data.nervous_block
	..()

/obj/item/dnainjector/antistutt
	name = "DNA injector (anti-stutt)"
	desc = "Fixes that speaking impairment."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 9

/obj/item/dnainjector/antistutt/New()
	block = GLOBL.dna_data.nervous_block
	..()

/obj/item/dnainjector/blindmut
	name = "DNA injector (blind)"
	desc = "Makes you not see anything."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 11

/obj/item/dnainjector/blindmut/New()
	block = GLOBL.dna_data.blind_block
	..()

/obj/item/dnainjector/antiblind
	name = "DNA injector (anti-blind)"
	desc = "ITS A MIRACLE!!!"
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 11

/obj/item/dnainjector/antiblind/New()
	block = GLOBL.dna_data.blind_block
	..()

/obj/item/dnainjector/deafmut
	name = "DNA injector (deaf)"
	desc = "Sorry, what did you say?"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 13

/obj/item/dnainjector/deafmut/New()
	block = GLOBL.dna_data.deaf_block
	..()

/obj/item/dnainjector/antideaf
	name = "DNA injector (anti-deaf)"
	desc = "Will make you hear once more."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 13

/obj/item/dnainjector/antideaf/New()
	block = GLOBL.dna_data.deaf_block
	..()

/obj/item/dnainjector/hallucination
	name = "DNA injector (halluctination)"
	desc = "What you see isn't always what you get."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/hallucination/New()
	block = GLOBL.dna_data.hallucination_block
	..()

/obj/item/dnainjector/antihallucination
	name = "DNA injector (anti-hallucination)"
	desc = "What you see is what you get."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antihallucination/New()
	block = GLOBL.dna_data.hallucination_block
	..()

/obj/item/dnainjector/h2m
	name = "DNA injector (human > monkey)"
	desc = "Will make you a flea bag."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 14

/obj/item/dnainjector/h2m/New()
	block = GLOBL.dna_data.monkey_block
	..()

/obj/item/dnainjector/m2h
	name = "DNA injector (monkey > human)"
	desc = "Will make you...less hairy."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 14

/obj/item/dnainjector/m2h/New()
	block = GLOBL.dna_data.monkey_block
	..()