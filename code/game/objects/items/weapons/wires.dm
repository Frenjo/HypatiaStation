// WIRES
/obj/item/wire
	desc = "This is just a simple piece of regular insulated wire."
	name = "wire"
	icon = 'icons/obj/power.dmi'
	icon_state = "item_wire"
	matter_amounts = list(MATERIAL_METAL = 40)
	attack_verb = list("whipped", "lashed", "disciplined", "tickled")

	var/amount = 1.0
	var/laying = 0.0
	var/old_lay = null

/obj/item/wire/suicide_act(mob/user)
	viewers(user) << SPAN_DANGER("[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.")
	return (OXYLOSS)

/obj/item/wire/proc/update()
	if(src.amount > 1)
		src.icon_state = "spool_wire"
		src.desc = "This is just spool of regular insulated wire. It consists of about [src.amount] unit\s of wire."
	else
		src.icon_state = "item_wire"
		src.desc = "This is just a simple piece of regular insulated wire."
	return

/obj/item/wire/attack_self(mob/user as mob)
	if(src.laying)
		src.laying = 0
		to_chat(user, SPAN_INFO("You're done laying wire!"))
	else
		to_chat(user, SPAN_INFO("You are not using this to lay wire..."))
	return