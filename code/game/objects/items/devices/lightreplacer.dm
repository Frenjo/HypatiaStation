
// Light Replacer (LR)
//
// ABOUT THE DEVICE
//
// This is a device supposedly to be used by Janitors and Janitor Cyborgs which will
// allow them to easily replace lights. This was mostly designed for Janitor Cyborgs since
// they don't have hands or a way to replace lightbulbs.
//
// HOW IT WORKS
//
// You attack a light fixture with it, if the light fixture is broken it will replace the
// light fixture with a working light; the broken light is then placed on the floor for the
// user to then pickup with a trash bag. If it's empty then it will just place a light in the fixture.
//
// HOW TO REFILL THE DEVICE
//
// It will need to be manually refilled with lights.
// If it's part of a robot module, it will charge when the Robot is inside a Recharge Station.
//
// EMAGGED FEATURES
//
// NOTICE: The Cyborg cannot use the emagged Light Replacer and the light's explosion was nerfed. It cannot create holes in the station anymore.
//
// I'm not sure everyone will react the emag's features so please say what your opinions are of it.
//
// When emagged it will rig every light it replaces, which will explode when the light is on.
// This is VERY noticable, even the device's name changes when you emag it so if anyone
// examines you when you're holding it in your hand, you will be discovered.
// It will also be very obvious who is setting all these lights off, since only Janitor Borgs and Janitors have easy
// access to them, and only one of them can emag their device.
//
// The explosion cannot insta-kill anyone with 30% or more health.

#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3

/obj/item/lightreplacer
	name = "light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."

	icon = 'icons/obj/janitor.dmi'
	icon_state = "lightreplacer0"
	item_state = "electronic"

	flags = CONDUCT
	slot_flags = SLOT_BELT
	origin_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_MATERIALS = 2)

	var/max_uses = 20
	var/uses = 0
	var/emagged = 0
	var/failmsg = ""
	// How much to increase per each glass?
	var/increment = 5
	// How much to take from the glass?
	var/decrement = 1
	var/charge = 1

/obj/item/lightreplacer/New()
	uses = max_uses / 2
	failmsg = "The [name]'s refill light blinks red."
	..()

/obj/item/lightreplacer/examine()
	set src in view(2)
	..()
	to_chat(usr, "It has [uses] lights remaining.")

/obj/item/lightreplacer/attackby(obj/item/W, mob/user)
	if(istype(W,  /obj/item/card/emag) && emagged == 0)
		Emag()
		return

	if(istype(W, /obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/G = W
		if(G.amount - decrement >= 0 && uses < max_uses)
			var/remaining = max(G.amount - decrement, 0)
			if(!remaining && !(G.amount - decrement) == 0)
				to_chat(user, "There isn't enough glass.")
				return
			G.amount = remaining
			if(!G.amount)
				user.drop_item()
				qdel(G)
			AddUses(increment)
			to_chat(user, "You insert a piece of glass into the [src].name. You have [uses] lights remaining.")
			return

	if(istype(W, /obj/item/light))
		var/obj/item/light/L = W
		if(L.status == 0) // LIGHT OKAY
			if(uses < max_uses)
				AddUses(1)
				to_chat(user, "You insert the [L.name] into the [src].name. You have [uses] lights remaining.")
				user.drop_item()
				qdel(L)
				return
		else
			to_chat(user, "You need a working light.")
			return


/obj/item/lightreplacer/attack_self(mob/user)
	/* // This would probably be a bit OP. If you want it though, uncomment the code.
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.emagged)
			src.Emag()
			usr << "You shortcircuit the [src]."
			return
	*/
	to_chat(usr, "It has [uses] lights remaining.")

/obj/item/lightreplacer/update_icon()
	icon_state = "lightreplacer[emagged]"


/obj/item/lightreplacer/proc/Use(mob/user)
	playsound(src, 'sound/machines/click.ogg', 50, 1)
	AddUses(-1)
	return 1

// Negative numbers will subtract
/obj/item/lightreplacer/proc/AddUses(amount = 1)
	uses = min(max(uses + amount, 0), max_uses)

/obj/item/lightreplacer/proc/Charge(mob/user)
	charge += 1
	if(charge > 7)
		AddUses(1)
		charge = 1

/obj/item/lightreplacer/proc/ReplaceLight(obj/machinery/light/target, mob/living/U)
	if(target.status == LIGHT_OK)
		to_chat(U, "There is a working [target.get_fitting_name()] already inserted.")
	else if(!CanUse(U))
		to_chat(U, failmsg)
	else if(Use(U))
		to_chat(U, SPAN_NOTICE("You replace the [target.get_fitting_name()] with the [src]."))
		if(target.status != LIGHT_EMPTY)
			target.remove_bulb()

		var/obj/item/light/L = new target.light_type()
		target.insert_bulb(L)

/obj/item/lightreplacer/proc/Emag()
	emagged = !emagged
	playsound(src, "sparks", 100, 1)
	if(emagged)
		name = "Shortcircuited [initial(name)]"
	else
		name = initial(name)
	update_icon()

//Can you use it?
/obj/item/lightreplacer/proc/CanUse(mob/living/user)
	src.add_fingerprint(user)
	//Not sure what else to check for. Maybe if clumsy?
	if(uses > 0)
		return 1
	else
		return 0

#undef LIGHT_OK
#undef LIGHT_EMPTY
#undef LIGHT_BROKEN
#undef LIGHT_BURNED