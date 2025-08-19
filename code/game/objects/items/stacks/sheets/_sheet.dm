/obj/item/stack/sheet
	name = "sheet"
	icon = 'icons/obj/items/stacks/sheets.dmi'

	force = 5
	throwforce = 5
	max_amount = 50
	throw_speed = 3
	throw_range = 3
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")

	var/decl/material/material
	var/perunit

/obj/item/stack/sheet/New()
	SHOULD_CALL_PARENT(TRUE)

	if(isnotnull(material))
		material = GET_DECL_INSTANCE(material)
		perunit = material.per_unit
	. = ..()

// Since the sheetsnatcher was consolidated into weapon/storage/bag we now use
// item/attackby() properly, making this unnecessary

/*/obj/item/stack/sheet/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/storage/bag/sheetsnatcher))
		var/obj/item/storage/bag/sheetsnatcher/S = W
		if(!S.mode)
			S.add(src,user)
		else
			for (var/obj/item/stack/sheet/stack in locate(src.x,src.y,src.z))
				S.add(stack,user)
	..()*/