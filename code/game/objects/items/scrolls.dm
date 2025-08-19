/obj/item/teleportation_scroll
	name = "scroll of teleportation"
	desc = "A scroll for moving around."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	var/uses = 4.0
	w_class = WEIGHT_CLASS_SMALL
	item_state = "paper"
	throw_speed = 4
	throw_range = 20
	origin_tech = alist(/decl/tech/bluespace = 4)

/obj/item/teleportation_scroll/attack_self(mob/user)
	user.set_machine(src)
	var/dat = "<B>Teleportation Scroll:</B><BR>"
	dat += "Number of uses: [src.uses]<BR>"
	dat += "<HR>"
	dat += "<B>Four uses use them wisely:</B><BR>"
	dat += "<A href='byond://?src=\ref[src];spell_teleport=1'>Teleport</A><BR>"
	dat += "Kind regards,<br>Wizards Federation<br><br>P.S. Don't forget to bring your gear, you'll need it to cast most spells.<HR>"
	SHOW_BROWSER(user, dat, "window=scroll")
	onclose(user, "scroll")
	return

/obj/item/teleportation_scroll/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE
	if(user.stat || user.restrained() || loc != user)
		return FALSE
	if(!ishuman(user))
		return FALSE

	if(user == loc || (in_range(src, user) && isturf(loc)))
		user.set_machine(src)
		if(topic.has("spell_teleport"))
			if(uses >= 1)
				teleportscroll(user)
	attack_self(user)

/obj/item/teleportation_scroll/proc/teleportscroll(mob/user)
	var/A

	A = input(user, "Area to jump to", "BOOYEA", A) in GLOBL.teleportlocs
	var/area/thearea = GLOBL.teleportlocs[A]

	if(user.stat || user.restrained())
		return
	if(!(user == loc || (in_range(src, user) && isturf(src.loc))))
		return

	make_smoke(5, FALSE, user.loc, user)
	var/list/L = list()
	for_no_type_check(var/turf/T, get_area_turfs(thearea.type))
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L += T

	if(!length(L))
		to_chat(user, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
		return

	if(user && user.buckled)
		user.buckled.unbuckle()

	var/list/tempL = L
	var/attempt = null
	var/success = 0
	while(length(tempL))
		attempt = pick(tempL)
		success = user.Move(attempt)
		if(!success)
			tempL.Remove(attempt)
		else
			break

	if(!success)
		user.forceMove(pick(L))

	make_smoke(5, FALSE, user.loc, user)
	src.uses -= 1