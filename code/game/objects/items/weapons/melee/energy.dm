/obj/item/melee/energy
	var/active = 0
	flags = NOBLOODY

/obj/item/melee/energy/suicide_act(mob/user)
	viewers(user) << pick(SPAN_DANGER("[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku."), \
						SPAN_DANGER("[user] is falling on the [src.name]! It looks like \he's trying to commit suicide."))
	return (BRUTELOSS|FIRELOSS)


/obj/item/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "axe0"
	force = 40.0
	throwforce = 25.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = NOBLOODY
	obj_flags = OBJ_FLAG_CONDUCT
	item_flags = ITEM_FLAG_NO_SHIELD
	origin_tech = list(RESEARCH_TECH_COMBAT = 3)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1

/obj/item/melee/energy/axe/suicide_act(mob/user)
	viewers(user) << SPAN_DANGER("[user] swings the [src.name] towards /his head! It looks like \he's trying to commit suicide.")
	return (BRUTELOSS|FIRELOSS)


/obj/item/melee/energy/sword
	name = "energy sword"
	desc = "May the force be within you."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "sword0"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	item_flags = ITEM_FLAG_NO_SHIELD
	flags = NOBLOODY
	origin_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_SYNDICATE = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = 1
	edge = 1

/obj/item/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

/obj/item/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "blade"
	force = 70.0//Normal attacks deal very high damage.
	sharp = 1
	edge = 1
	throwforce = 1//Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = 4.0//So you can't hide it in your pocket or some such.
	item_flags = ITEM_FLAG_NO_SHIELD
	flags = NOBLOODY
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/datum/effect/system/spark_spread/spark_system