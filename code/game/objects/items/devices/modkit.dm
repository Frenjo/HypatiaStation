#define MODKIT_HELMET 1
#define MODKIT_SUIT 2
#define MODKIT_FULL 3

/obj/item/modkit
	name = "hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "modkit"
	var/parts = MODKIT_FULL
	var/list/target_species = list(SPECIES_HUMAN, SPECIES_SKRELL)

	var/list/permitted_types = list(
		/obj/item/clothing/head/helmet/space/rig,
		/obj/item/clothing/suit/space/rig
	)

/obj/item/modkit/afterattack(obj/O, mob/user as mob)
	if(!parts)
		to_chat(user, SPAN_WARNING("This kit has no parts for this modification left."))
		user.drop_from_inventory(src)
		qdel(src)
		return

	/* TODO: list comparison
	if(istype(O,to_type))
		user << "<span class='notice'>[O] is already modified.</span>"
		return
	*/

	if(!isturf(O.loc))
		to_chat(user, SPAN_WARNING("[O] must be safely placed on the ground for modification."))
		return

	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
	user.visible_message(
		SPAN_WARNING("[user] opens \the [src] and modifies \the [O]."),
		SPAN_WARNING("You open \the [src] and modify \the [O].")
	)

	var/obj/item/clothing/I = O
	if(istype(I))
		I.species_restricted = target_species.Copy()

	parts--
	if(!parts)
		user.drop_from_inventory(src)
		qdel(src)

/obj/item/modkit/tajaran
	name = "tajara hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user. This one looks like it's meant for Tajara."
	target_species = list(SPECIES_TAJARAN)

/obj/item/modkit/examine()
	..()
	to_chat(usr, "It looks as though it modifies hardsuits to fit the following users:")
	for(var/species in target_species)
		to_chat(usr, "- [species]")

#undef MODKIT_HELMET
#undef MODKIT_SUIT
#undef MODKIT_FULL