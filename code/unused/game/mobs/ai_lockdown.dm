/mob/living/silicon/ai/proc/lockdown()
	set category = PANEL_AI_COMMANDS
	set name = "Lockdown"

	if(usr.stat == 2)
		usr <<"You cannot initiate lockdown because you are dead!"
		return

	src << "<b>Initiating lockdowns has been disabled due to system stress.</b>"
//	Commented this out to disable Lockdowns -- TLE
/*	to_world("\red Lockdown initiated by [usr.name]!")

	for(var/obj/machinery/fire_alarm/FA in GLOBL.machines) //activate firealarms
		spawn( 0 )
			if(FA.lockdownbyai == 0)
				FA.lockdownbyai = 1
				FA.alarm()
	for_no_type_check(var/obj/machinery/door/airlock/AL, GLOBL.airlocks_list) //close airlocks
		spawn( 0 )
			if(AL.canAIControl() && AL.icon_state == "door0" && AL.lockdownbyai == 0)
				AL.close()
				AL.lockdownbyai = 1

	var/obj/machinery/computer/communications/C = pick(GLOBL.communications_consoles)
	C?.post_status("alert", "lockdown")
*/

/*	src.verbs -= /mob/living/silicon/ai/proc/lockdown
	src.verbs += /mob/living/silicon/ai/proc/disablelockdown
	usr << "\red Disable lockdown command enabled!"
	winshow(usr,"rpane",1)
*/

/mob/living/silicon/ai/proc/disablelockdown()
	set category = PANEL_AI_COMMANDS
	set name = "Disable Lockdown"

	if(usr.stat == 2)
		usr <<"You cannot disable lockdown because you are dead!"
		return

	to_world("\red Lockdown cancelled by [usr.name]!")

	for(var/obj/machinery/fire_alarm/FA in GLOBL.machines) //deactivate firealarms
		spawn( 0 )
			if(FA.lockdownbyai == 1)
				FA.lockdownbyai = 0
				FA.reset()
	for_no_type_check(var/obj/machinery/door/airlock/AL, GLOBL.airlocks_list) //open airlocks
		spawn ( 0 )
			if(AL.canAIControl() && AL.lockdownbyai == 1)
				AL.open()
				AL.lockdownbyai = 0

/*	src.verbs -= /mob/living/silicon/ai/proc/disablelockdown
	src.verbs += /mob/living/silicon/ai/proc/lockdown
	usr << "\red Disable lockdown command removed until lockdown initiated again!"
	winshow(usr,"rpane",1)
*/