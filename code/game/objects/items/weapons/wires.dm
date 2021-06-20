// WIRES

/obj/item/weapon/wire/proc/update()
	if(src.amount > 1)
		src.icon_state = "spool_wire"
		src.desc = "This is just spool of regular insulated wire. It consists of about [src.amount] unit\s of wire."
	else
		src.icon_state = "item_wire"
		src.desc = "This is just a simple piece of regular insulated wire."
	return

/obj/item/weapon/wire/attack_self(mob/user as mob)
	if(src.laying)
		src.laying = 0
		to_chat(user, SPAN_INFO("You're done laying wire!"))
	else
		to_chat(user, SPAN_INFO("You are not using this to lay wire..."))
	return


