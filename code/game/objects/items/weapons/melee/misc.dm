/obj/item/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "chain"
	item_state = "chain"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = alist(/decl/tech/combat = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

/obj/item/melee/chainofcommand/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide."))
	return (OXYLOSS)