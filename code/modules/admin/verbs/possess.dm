/proc/possess(obj/O as obj in GLOBL.movable_atom_list)
	set category = PANEL_ADMIN
	set name = "Possess Object"

	if(istype(O, /obj/singularity))
		if(CONFIG_GET(/decl/configuration_entry/forbid_singulo_possession))
			usr << "It is forbidden to possess singularities."
			return

	var/turf/T = GET_TURF(O)

	if(isnotnull(T))
		log_admin("[key_name(usr)] has possessed [O] ([O.type]) at ([T.x], [T.y], [T.z])")
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at ([T.x], [T.y], [T.z])", 1)
	else
		log_admin("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location")
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location", 1)

	if(!usr.control_object) //If you're not already possessing something...
		usr.name_archive = usr.real_name

	usr.loc = O
	usr.real_name = O.name
	usr.name = O.name
	usr.client.eye = O
	usr.control_object = O
	feedback_add_details("admin_verb", "PO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/release(obj/O as obj in GLOBL.movable_atom_list)
	set category = PANEL_ADMIN
	set name = "Release Object"
	//usr.loc = GET_TURF(usr)

	if(usr.control_object && usr.name_archive) //if you have a name archived and if you are actually relassing an object
		usr.real_name = usr.name_archive
		usr.name = usr.real_name
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.name = H.get_visible_name()
//		usr.regenerate_icons() //So the name is updated properly

	usr.loc = O.loc // Appear where the object you were controlling is -- TLE
	usr.client.eye = usr
	usr.control_object = null
	feedback_add_details("admin_verb", "RO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/givetestverbs(mob/M as mob in GLOBL.mob_list)
	set category = PANEL_DEBUG
	set desc = "Give this guy possess/release verbs"
	set name = "Give Possessing Verbs"

	M.verbs += /proc/possess
	M.verbs += /proc/release
	feedback_add_details("admin_verb", "GPV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!