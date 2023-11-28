/obj/machinery/power/apc/proc/get_malf_status(mob/user)
	if(global.CTticker && global.CTticker.mode && (user.mind in global.CTticker.mode.malf_ai) && isAI(user))
		if(src.malfai == (user:parent ? user:parent : user))
			if(src.occupant == user)
				return 3 // 3 = User is shunted in this APC
			else if(istype(user.loc, /obj/machinery/power/apc))
				return 4 // 4 = User is shunted in another APC
			else
				return 2 // 2 = APC hacked by user, and user is in its core.
		else
			return 1 // 1 = APC not hacked.
	else
		return 0 // 0 = User is not a Malf AI

/obj/machinery/power/apc/proc/malfoccupy(mob/living/silicon/ai/malf)
	if(!istype(malf))
		return
	if(istype(malf.loc, /obj/machinery/power/apc)) // Already in an APC
		to_chat(malf, SPAN_WARNING("You must evacuate your current apc first."))
		return
	if(isNotStationLevel(src.z))
		return
	src.occupant = new /mob/living/silicon/ai(src, malf.laws, null, 1)
	src.occupant.adjustOxyLoss(malf.getOxyLoss())
	if(!findtext(src.occupant.name,"APC Copy"))
		src.occupant.name = "[malf.name] APC Copy"
	if(malf.parent)
		src.occupant.parent = malf.parent
	else
		src.occupant.parent = malf
	malf.mind.transfer_to(src.occupant)
	src.occupant.eyeobj.name = "[src.occupant.name] (AI Eye)"
	if(malf.parent)
		qdel(malf)
	src.occupant.verbs += /mob/living/silicon/ai/proc/corereturn
	src.occupant.verbs += /datum/game_mode/malfunction/proc/takeover
	src.occupant.cancel_camera()

/obj/machinery/power/apc/proc/malfvacate(forced)
	if(!src.occupant)
		return
	if(src.occupant.parent && src.occupant.parent.stat != DEAD)
		src.occupant.mind.transfer_to(src.occupant.parent)
		src.occupant.parent.adjustOxyLoss(src.occupant.getOxyLoss())
		src.occupant.parent.cancel_camera()
		qdel(src.occupant)
		if(IS_SEC_LEVEL(/decl/security_level/delta))
			for(var/obj/item/pinpointer/point in world)
				for(var/datum/mind/AI_mind in global.CTticker.mode.malf_ai)
					var/mob/living/silicon/ai/A = AI_mind.current // the current mob the mind owns
					if(A.stat != DEAD)
						point.the_disk = A //The pinpointer tracks the AI back into its core.
	else
		to_chat(src.occupant, SPAN_WARNING("Primary core damaged, unable to return core processes."))
		if(forced)
			src.occupant.loc = src.loc
			src.occupant.death()
			src.occupant.gib()
			for(var/obj/item/pinpointer/point in world)
				point.the_disk = null //the pinpointer will go back to pointing at the nuke disc.