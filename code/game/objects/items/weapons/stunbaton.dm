//replaces our stun baton code with /tg/station's code
/obj/item/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "stunbaton"
	item_state = "baton"
	slot_flags = SLOT_BELT
	force = 15
	sharp = 0
	throwforce = 7
	w_class = 3
	origin_tech = list(RESEARCH_TECH_COMBAT = 2)
	attack_verb = list("beaten")
	var/stunforce = 7
	var/status = 0
	var/obj/item/cell/high/bcell = null
	var/hitcost = 1000

/obj/item/melee/baton/suicide_act(mob/user)
	user.visible_message(SPAN("suicide", "[user] is putting the live [name] in \his mouth! It looks like \he's trying to commit suicide."))
	return (FIRELOSS)

/obj/item/melee/baton/New()
	..()
	update_icon()
	return

/obj/item/melee/baton/loaded/New() //this one starts with a cell pre-installed.
	..()
	bcell = new(src)
	update_icon()
	return

/obj/item/melee/baton/proc/deductcharge(chrgdeductamt)
	if(bcell)
		if(bcell.use(chrgdeductamt))
			return 1
		else
			status = 0
			update_icon()
			return 0

/obj/item/melee/baton/update_icon()
	if(status)
		icon_state = "[initial(name)]_active"
	else if(!bcell)
		icon_state = "[initial(name)]_nocell"
	else
		icon_state = "[initial(name)]"

/obj/item/melee/baton/examine()
	set src in view(1)
	..()
	if(bcell)
		to_chat(usr, SPAN_NOTICE("The baton is [round(bcell.percent())]% charged."))
	if(!bcell)
		to_chat(usr, SPAN_WARNING("The baton does not have a power source installed."))

/obj/item/melee/baton/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool) && isnotnull(bcell))
		to_chat(user, SPAN_NOTICE("You remove \the [bcell] from \the [src]."))
		bcell.loc = get_turf(loc)
		bcell.updateicon()
		bcell = null
		status = 0
		update_icon()
		return TRUE

	return ..()

/obj/item/melee/baton/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell))
		if(!bcell)
			user.drop_item()
			W.loc = src
			bcell = W
			to_chat(user, SPAN_NOTICE("You install a cell in [src]."))
			update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] already has a cell."))

	..()

/obj/item/melee/baton/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		to_chat(user, SPAN_NOTICE("[src] is now [status ? "on" : "off"]."))
		playsound(loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		if(!bcell)
			to_chat(user, SPAN_WARNING("[src] does not have a power source!"))
		else
			to_chat(user, SPAN_WARNING("[src] is out of charge."))
	add_fingerprint(user)

/obj/item/melee/baton/attack(mob/M, mob/user)
	if(isrobot(M))
		..()
		return
	if(!isliving(M))
		return

	var/mob/living/L = M

	if(user.a_intent == "harm")
		..()

	if(!status)
		L.visible_message(SPAN_WARNING("[L] has been prodded with [src] by [user]. Luckily it was off."))
		return

	if(status)
		user.lastattacked = L
		L.lastattacker = user

		L.Stun(stunforce)
		L.Weaken(stunforce)
		L.apply_effect(STUTTER, stunforce)

		L.visible_message(SPAN_DANGER("[L] has been stunned with [src] by [user]!"))
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

		msg_admin_attack("[key_name(user)] stunned [key_name(L)] with the [src].")

		if(isrobot(loc))
			var/mob/living/silicon/robot/R = loc
			if(R && R.cell)
				R.cell.use(hitcost)
		else
			deductcharge(hitcost)

/obj/item/melee/baton/emp_act(severity)
	if(bcell)
		deductcharge(1000 / severity)
		if(bcell.reliability != 100 && prob(50 / severity))
			bcell.reliability -= 10 / severity
	..()


//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 5
	hitcost = 2500
	slot_flags = null