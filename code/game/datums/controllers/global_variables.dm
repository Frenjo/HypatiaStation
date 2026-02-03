/*
 * Global Variables Controller
 *
 * The beauty in this world is that everyone can change it. ~ Maurice Lévy
 */
GLOBAL_BYOND(datum/controller/global_variables/GLOBL) // Set in /datum/global_init/New()

// This should NOT use CONTROLLER_DEF.
/datum/controller/global_variables
	name = "Global Variables"

/datum/controller/global_variables/New()
	. = ..()
	var/datum/controller/dummy_controller = new /datum/controller()
	var/list/controller_vars = dummy_controller.vars.Copy()
	controller_vars["vars"] = null

	var/list/global_procs = typesof(/datum/controller/global_variables/proc)
	var/expected_len = vars.len - controller_vars.len
	if(global_procs.len != expected_len)
		warning("Unable to detect all global initialisation procs! Expected [expected_len] got [global_procs.len]!")
		if(global_procs.len)
			var/list/expected_global_procs = vars - controller_vars
			for(var/p in global_procs)
				expected_global_procs -= replacetext("[p]", "InitGlobal", "")
			TO_WORLD_LOG("Missing procs: [expected_global_procs.Join(", ")]")

	for(var/p in global_procs)
		var/tick_start = world.time
		call(src, p)()
		var/tick_end = world.time
		if(tick_end - tick_start)
			warning("Global [replacetext("[p]", "InitGlobal", "")] slept during initialisation!")

	spawn(1)
		QDEL_NULL(dummy_controller)