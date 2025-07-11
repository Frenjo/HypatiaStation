/mob/living/silicon/robot/Process_Spacemove()
	if(model)
		for(var/obj/item/tank/jetpack/J in model.modules)
			if(J && istype(J, /obj/item/tank/jetpack))
				if(J.allow_thrust(0.01))	return 1
	if(..())	return 1
	return 0

//No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/movement_delay()
	. = ..() //Incase I need to add stuff other than "speed" later
	. += speed

	if(module_active && istype(module_active, /obj/item/robot_module/combat_mobility))
		. += -3

	. += CONFIG_GET(/decl/configuration_entry/robot_delay)

/mob/living/silicon/robot/Move(a, b, flag)
	. = ..()
	model.on_move(src)