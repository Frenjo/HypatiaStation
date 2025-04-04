/obj/item/soulstone
	name = "Soul Stone Shard"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	desc = "A fragment of the legendary treasure known simply as the 'Soul Stone'. The shard still flickers with a fraction of the full artefacts power."
	w_class = 1.0
	slot_flags = SLOT_BELT
	origin_tech = alist(/decl/tech/materials = 4, /decl/tech/bluespace = 4)
	var/imprinted = "empty"

//////////////////////////////Capturing////////////////////////////////////////////////////////

/obj/item/soulstone/attack(mob/living/carbon/human/M, mob/user)
	if(!ishuman(M))//If target is not a human.
		return ..()
	if(istype(M, /mob/living/carbon/human/dummy))
		return..()

	if(M.has_brain_worms()) //Borer stuff - RR
		to_chat(user, SPAN_WARNING("This being is corrupted by an alien intelligence and cannot be soul trapped."))
		return..()

	M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their soul captured with [src.name] by [user.name] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [src.name] to capture the soul of [M.name] ([M.ckey])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] to capture the soul of [M.name] ([M.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	transfer_soul("VICTIM", M, user)
	return

	/*attack(mob/living/simple/shade/M, mob/user)//APPARENTLY THEY NEED THEIR OWN SPECIAL SNOWFLAKE CODE IN THE LIVING ANIMAL DEFINES
		if(!istype(M, /mob/living/simple/shade))//If target is not a shade
			return ..()
		user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [src.name] to capture the soul of [M.name] ([M.ckey])</font>"

		transfer_soul("SHADE", M, user)
		return*/
///////////////////Options for using captured souls///////////////////////////////////////

/obj/item/soulstone/attack_self(mob/user)
	if(!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = "<TT><B>Soul Stone</B><BR>"
	for(var/mob/living/simple/shade/A in src)
		dat += "Captured Soul: [A.name]<br>"
		dat += {"<A href='byond://?src=\ref[src];choice=Summon'>Summon Shade</A>"}
		dat += "<br>"
		dat += {"<a href='byond://?src=\ref[src];choice=Close'> Close</a>"}
	user << browse(dat, "window=aicard")
	onclose(user, "aicard")
	return

/obj/item/soulstone/Topic(href, href_list)
	var/mob/U = usr
	if(!in_range(src, U) || U.machine != src)
		U << browse(null, "window=aicard")
		U.unset_machine()
		return

	add_fingerprint(U)
	U.set_machine(src)

	switch(href_list["choice"])//Now we switch based on choice.
		if("Close")
			U << browse(null, "window=aicard")
			U.unset_machine()
			return

		if("Summon")
			for(var/mob/living/simple/shade/A in src)
				A.status_flags &= ~GODMODE
				A.canmove = TRUE
				to_chat(A, "<b>You have been released from your prison, but you are still bound to [U.name]'s will. Help them suceed in their goals at all costs.</b>")
				A.forceMove(U.loc)
				A.cancel_camera()
				src.icon_state = "soulstone"
	attack_self(U)


///////////////////////////Transferring to constructs/////////////////////////////////////////////////////
/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive"

/obj/structure/constructshell/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/soulstone))
		I.transfer_soul("CONSTRUCT", src, user)
		return TRUE
	return ..()

////////////////////////////Proc for moving soul in and out off stone//////////////////////////////////////
/obj/item/proc/transfer_soul(choice, target, mob/U)
	switch(choice)
		if("VICTIM")
			var/mob/living/carbon/human/T = target
			var/obj/item/soulstone/C = src
			if(C.imprinted != "empty")
				to_chat(U, "\red <b>Capture failed!</b>: \black The soul stone has already been imprinted with [C.imprinted]'s mind!")
			else
				if(T.stat == CONSCIOUS)
					to_chat(U, "\red <b>Capture failed!</b>: \black Kill or maim the victim first!")
				else
					if(T.client == null)
						to_chat(U, "\red <b>Capture failed!</b>: \black The soul has already fled it's mortal frame.")
					else
						if(length(C.contents))
							to_chat(U, "\red <b>Capture failed!</b>: \black The soul stone is full! Use or free an existing soul to make room.")
						else
							for(var/obj/item/W in T)
								T.drop_from_inventory(W)
							new /obj/effect/decal/remains/human(T.loc) //Spawns a skeleton
							T.invisibility = INVISIBILITY_MAXIMUM
							var/atom/movable/overlay/animation = new /atom/movable/overlay(T.loc)
							animation.icon_state = "blank"
							animation.icon = 'icons/mob/mob.dmi'
							animation.master = T
							flick("dust-h", animation)
							qdel(animation)
							var/mob/living/simple/shade/S = new /mob/living/simple/shade(T.loc)
							S.forceMove(C) //put shade in stone
							S.status_flags |= GODMODE //So they won't die inside the stone somehow
							S.canmove = FALSE//Can't move out of the soul stone
							S.name = "Shade of [T.real_name]"
							S.real_name = "Shade of [T.real_name]"
							if(T.client)
								T.client.mob = S
							S.cancel_camera()
							C.icon_state = "soulstone2"
							C.name = "Soul Stone: [S.real_name]"
							to_chat(S, "Your soul has been captured! You are now bound to [U.name]'s will, help them suceed in their goals at all costs.")
							to_chat(U, "\blue <b>Capture successful!</b>: \black [T.real_name]'s soul has been ripped from their body and stored within the soul stone.")
							to_chat(U, "The soulstone has been imprinted with [S.real_name]'s mind, it will no longer react to other souls.")
							C.imprinted = "[S.name]"
							qdel(T)
		if("SHADE")
			var/mob/living/simple/shade/T = target
			var/obj/item/soulstone/C = src
			if(T.stat == DEAD)
				to_chat(U, "\red <b>Capture failed!</b>: \black The shade has already been banished!")
			else
				if(length(C.contents))
					to_chat(U, "\red <b>Capture failed!</b>: \black The soul stone is full! Use or free an existing soul to make room.")
				else
					if(T.name != C.imprinted)
						to_chat(U, "\red <b>Capture failed!</b>: \black The soul stone has already been imprinted with [C.imprinted]'s mind!")
					else
						T.forceMove(C) //put shade in stone
						T.status_flags |= GODMODE
						T.canmove = FALSE
						T.health = T.maxHealth
						C.icon_state = "soulstone2"
						to_chat(T, "Your soul has been recaptured by the soul stone, its arcane energies are reknitting your ethereal form.")
						to_chat(U, "\blue <b>Capture successful!</b>: \black [T.name]'s has been recaptured and stored within the soul stone.")
		if("CONSTRUCT")
			var/obj/structure/constructshell/T = target
			var/obj/item/soulstone/C = src
			var/mob/living/simple/shade/A = locate() in C
			if(A)
				var/construct_class = alert(U, "Please choose which type of construct you wish to create.", , "Juggernaut", "Wraith", "Artificer")
				switch(construct_class)
					if("Juggernaut")
						var/mob/living/simple/construct/armoured/Z = new /mob/living/simple/construct/armoured(GET_TURF(T))
						Z.key = A.key
						if(iscultist(U))
							if(IS_GAME_MODE(/datum/game_mode/cult))
								var/datum/game_mode/cult/cult = global.PCticker.mode
								cult.add_cultist(Z.mind)
							else
								global.PCticker.mode.cult.Add(Z.mind)
							global.PCticker.mode.update_cult_icons_added(Z.mind)
						qdel(T)
						to_chat(Z, "<B>You are playing a Juggernaut. Though slow, you can withstand extreme punishment, and rip apart enemies and walls alike.</B>")
						to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
						Z.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/conjure/lesserforcewall(Z)
						Z.cancel_camera()
						qdel(C)

					if("Wraith")
						var/mob/living/simple/construct/wraith/Z = new /mob/living/simple/construct/wraith(GET_TURF(T))
						Z.key = A.key
						if(iscultist(U))
							if(IS_GAME_MODE(/datum/game_mode/cult))
								var/datum/game_mode/cult/cult = global.PCticker.mode
								cult.add_cultist(Z.mind)
							else
								global.PCticker.mode.cult.Add(Z.mind)
							global.PCticker.mode.update_cult_icons_added(Z.mind)
						qdel(T)
						to_chat(Z, "<B>You are playing a Wraith. Though relatively fragile, you are fast, deadly, and even able to phase through walls.</B>")
						to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
						Z.spell_list += new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift(Z)
						Z.cancel_camera()
						qdel(C)

					if("Artificer")
						var/mob/living/simple/construct/builder/Z = new /mob/living/simple/construct/builder(GET_TURF(T))
						Z.key = A.key
						if(iscultist(U))
							if(IS_GAME_MODE(/datum/game_mode/cult))
								var/datum/game_mode/cult/cult = global.PCticker.mode
								cult.add_cultist(Z.mind)
							else
								global.PCticker.mode.cult.Add(Z.mind)
							global.PCticker.mode.update_cult_icons_added(Z.mind)
						qdel(T)
						to_chat(Z, "<B>You are playing an Artificer. You are incredibly weak and fragile, but you are able to construct fortifications, repair allied constructs (by clicking on them), and even create new constructs.</B>")
						to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
						Z.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/conjure/construct/lesser(Z)
						Z.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/conjure/wall(Z)
						Z.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/conjure/floor(Z)
						Z.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/conjure/soulstone(Z)
						Z.cancel_camera()
						qdel(C)
			else
				to_chat(U, "\red <b>Creation failed!</b>: \black The soul stone is empty! Go kill someone!")
	return
