/mob/living/silicon/hivebot
	name = "Robot"
	icon = 'icons/mob/silicon/hivebot.dmi'
	icon_state = "basic"
	health = 80
	var/health_max = 80
	robot_talk_understand = 2

//HUD
	var/atom/movable/screen/cells = null
	var/atom/movable/screen/inv1 = null
	var/atom/movable/screen/inv2 = null
	var/atom/movable/screen/inv3 = null

//3 Modules can be activated at any one time.
	var/obj/item/robot_model/module = null
	var/module_active = null
	var/module_state_1 = null
	var/module_state_2 = null
	var/module_state_3 = null

	var/obj/item/radio/radio = null

	var/list/req_access = list(ACCESS_ROBOTICS)
	var/energy = 4000
	var/energy_max = 4000
	var/jetpack = 0

	var/mob/living/silicon/hive_mainframe/mainframe = null
	var/dependent = 0
	var/shell = 1

/mob/living/silicon/hive_mainframe
	name = "Robot Mainframe"
	voice_name = "synthesized voice"

	icon_state = "hive_main"
	health = 200
	var/health_max = 200
	robot_talk_understand = 2

	anchored = TRUE
	var/online = 1
	var/mob/living/silicon/hivebot = null
	var/hivebot_name = null
	var/force_mind = 0