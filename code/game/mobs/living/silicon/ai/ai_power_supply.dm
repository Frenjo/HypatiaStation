/mob/living/silicon/ai/proc/create_power_supply()
	if(isnotnull(power_supply))
		qdel(power_supply)
	power_supply = new /obj/machinery/ai_power_supply(src)

/*
 * AI Power Supply
 *
 * A dummy object used for powering the AI since only machinery should be using power.
 * The alternative was to rewrite a bunch of AI code instead here we are.
*/
/obj/machinery/ai_power_supply
	name = "AI Power Supply"
	invisibility = INVISIBILITY_MAXIMUM

	power_state = USE_POWER_ACTIVE
	power_usage = list(
		USE_POWER_IDLE = 0,
		USE_POWER_ACTIVE = 1000
	)

	var/mob/living/silicon/ai/powered_ai = null

/obj/machinery/ai_power_supply/New(mob/living/silicon/ai/ai = null)
	. = ..()
	if(isnull(ai))
		qdel(src)

	powered_ai = ai
	loc = powered_ai

/obj/machinery/ai_power_supply/Destroy()
	powered_ai = null
	return ..()

/obj/machinery/ai_power_supply/proc/update_power()
	update_power_state(get_power_state())

/obj/machinery/ai_power_supply/proc/get_power_state()
	if(powered_ai.stat == DEAD || isitem(powered_ai.loc) || !powered_ai.anchored)
		return USE_POWER_OFF
	return USE_POWER_ACTIVE