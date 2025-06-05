/mob/living/silicon/robot
	name = "Cyborg"
	real_name = "Cyborg"
	icon = 'icons/mob/silicon/robot/standard.dmi'
	icon_state = "robot"
	maxHealth = 200
	health = 200

	hud_type = /datum/hud/robot

	mob_bump_flag = ROBOT
	mob_swap_flags = ROBOT | MONKEY | SLIME | SIMPLE_ANIMAL
	mob_push_flags = ALLMOBS //trundle trundle

	var/default_law_type = BASE_LAW_TYPE

	// The overlay for the robot's "eye" lights.
	var/mutable_appearance/eye_lights = null

	var/sight_mode = 0
	var/custom_name = ""
	var/custom_sprite = FALSE // Due to all the sprites involved, a var for our custom borgs may be best.
	var/crisis //Admin-settable for combat module use.

	//Hud stuff
	var/atom/movable/screen/cells = null
	var/atom/movable/screen/inv1 = null
	var/atom/movable/screen/inv2 = null
	var/atom/movable/screen/inv3 = null

	//3 Modules can be activated at any one time.
	var/obj/item/robot_model/model = null
	var/module_active = null
	var/module_state_1 = null
	var/module_state_2 = null
	var/module_state_3 = null

	var/obj/item/radio/borg/radio = null
	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/cell/cell = null
	var/obj/machinery/camera/camera = null

	var/is_expanded = FALSE // Whether this robot has been equipped with an expander module.

	// Components are basically robot organs.
	var/list/components

	var/obj/item/mmi/mmi = null

	var/obj/item/pda/ai/rbPDA = null

	var/opened = FALSE
	var/emagged = FALSE
	var/wiresexposed = 0
	var/locked = 1
	var/has_power = 1
	var/list/req_access = list(ACCESS_ROBOTICS)
	var/ident = 0
	//var/list/laws = list()
	var/viewalerts = 0
	var/lower_mod = 0
	var/datum/effect/system/ion_trail_follow/ion_trail = null
	var/datum/effect/system/spark_spread/spark_system //So they can initialize sparks whenever/N
	var/jeton = 0
	var/borgwires = 31 // 0b11111
	var/killswitch = 0
	var/killswitch_time = 60
	var/weapon_lock = FALSE
	var/weaponlock_time = 120
	var/lawupdate = TRUE // Cyborgs will sync their laws with their AI by default.
	var/lockcharge //Used when locking down a borg to preserve cell charge
	var/speed = 0 //Cause sec borgs gotta go fast //No they dont!
	var/scrambledcodes = FALSE // Used to determine if a borg shows up on the robotics console.  Setting to one hides them.
	var/braintype = "Cyborg"
	var/pose