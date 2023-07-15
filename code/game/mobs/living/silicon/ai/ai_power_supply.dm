/*
 * AI Power Supply
 *
 * A dummy object used for powering the AI since only machinery should be using power.
 * The alternative was to rewrite a bunch of AI code instead here we are.
*/
/obj/machinery/ai_power_supply
	name = "AI Power Supply"
	invisibility = INVISIBILITY_MAXIMUM

	use_power = 2
	active_power_usage = 1000

	var/mob/living/silicon/ai/powered_ai = null

/obj/machinery/ai_power_supply/New(mob/living/silicon/ai/ai = null)
	. = ..()
	if(isnull(ai))
		qdel(src)

	powered_ai = ai
	loc = powered_ai.loc
	use_power(1) // Just in case we need to wake up the power system.

/obj/machinery/ai_power_supply/process()
	if(isnull(powered_ai) || powered_ai.stat & DEAD)
		qdel(src)
	if(!powered_ai.anchored)
		loc = powered_ai.loc
		use_power = 0
	if(powered_ai.anchored)
		use_power = 2