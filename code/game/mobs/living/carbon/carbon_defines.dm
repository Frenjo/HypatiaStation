/mob/living/carbon
	gender = MALE

	var/list/stomach_contents = list()
	var/brain_op_stage = 0.0
	var/list/virus2 = list()
	var/antibodies = 0
	var/last_eating = 0		//Not sure what this does... I found it hidden in food.dm

	var/life_tick = 0		// The amount of life ticks that have processed on this mob.
	var/analgesic = 0		// when this is set, the mob isn't affected by shock or pain
							// life should decrease this by 1 every tick
	// total amount of wounds on mob, used to spread out healing and the like over all wounds
	var/number_wounds = 0
	var/obj/item/handcuffed = null //Whether or not the mob is handcuffed
	var/obj/item/legcuffed = null  //Same as handcuffs but for legs. Bear traps use this.
	//Surgery info
	var/datum/surgery_status/op_stage = new/datum/surgery_status
	//Active emote/pose
	var/pose = null

	var/pulse = PULSE_NORM	//current pulse level

	/*
	 * All below were moved from /mob.
	 * These need to be sorted eventually.
	 */
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""

	var/cpr_time = TRUE

	var/nutrition = 400
	var/overeatduration = 0 // How long this guy is overeating

	var/digitalcamo = 0 // Can they be tracked by the AI?

	// These appear to be cult-related.
	// They could all probably be moved down to /human later.
	var/bhunger = 0
	var/ajourn = FALSE
	var/seer = FALSE