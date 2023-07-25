/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/weapons/ammo.dmi'
	icon_state = "s-casing"

	w_class = 1
	flags = CONDUCT
	slot_flags = SLOT_BELT

	throwforce = 1

	var/caliber = ""								// Which kind of guns it can be loaded into
	var/projectile_type = null						// The bullet type to create when New() is called
	var/obj/item/projectile/loaded_bullet = null 	// The loaded bullet

/obj/item/ammo_casing/New()
	. = ..()
	if(isnotnull(projectile_type))
		loaded_bullet = new projectile_type(src)
	pixel_x = rand(-10.0, 10)
	pixel_y = rand(-10.0, 10)
	dir = pick(GLOBL.cardinal)

/obj/item/ammo_casing/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/screwdriver))
		if(isnotnull(loaded_bullet))
			if(initial(loaded_bullet.name) == "bullet")
				var/tmp_label = ""
				var/label_text = sanitize(input(user, "Inscribe some text into \the [initial(loaded_bullet.name)]", "Inscription", tmp_label))
				if(length(label_text) > 20)
					to_chat(user, SPAN_WARNING("The inscription can be at most 20 characters long."))
				else
					if(label_text == "")
						to_chat(user, SPAN_INFO("You scratch the inscription off of [initial(loaded_bullet)]."))
						loaded_bullet.name = initial(loaded_bullet.name)
					else
						to_chat(user, SPAN_INFO("You inscribe \"[label_text]\" into \the [initial(loaded_bullet.name)]."))
						loaded_bullet.name = "[initial(loaded_bullet.name)] \"[label_text]\""
			else
				to_chat(user, SPAN_INFO("You can only inscribe a metal bullet."))	//because inscribing beanbags is silly
		else
			to_chat(user, SPAN_INFO("There is no bullet in the casing to inscribe anything into."))

//Boxes of ammo
/obj/item/ammo_magazine
	name = "ammo box (.357)"
	desc = "A box of ammo"
	icon = 'icons/obj/weapons/ammo.dmi'
	icon_state = "357"
	item_state = "syringe_kit"

	flags = CONDUCT
	slot_flags = SLOT_BELT
	matter_amounts = list(MATERIAL_METAL = 50000)

	throwforce = 2
	w_class = 1.0
	throw_speed = 4
	throw_range = 10

	var/list/stored_ammo = list()
	var/ammo_type = /obj/item/ammo_casing
	var/max_ammo = 7
	var/multiple_sprites = FALSE

/obj/item/ammo_magazine/New()
	. = ..()
	for(var/i = 1, i <= max_ammo, i++)
		stored_ammo.Add(new ammo_type(src))
	update_icon()

/obj/item/ammo_magazine/update_icon()
	if(multiple_sprites)
		icon_state = "[initial(icon_state)]-[length(stored_ammo)]"
	desc = "There are [length(stored_ammo)] shell\s left!"