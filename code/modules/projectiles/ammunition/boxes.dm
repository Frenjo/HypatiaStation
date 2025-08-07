/obj/item/ammo_magazine/a357
	name = "ammunition box (.357)"
	desc = "A box of .357 ammunition."
	icon_state = "357"

	matter_amounts = /datum/design/autolathe/a357::materials

	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 7
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c38
	name = "speed loader (.38)"
	desc = "A speed loader of .38 ammunition."
	icon_state = "38"

	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c45m
	name = "magazine (.45)"
	desc = "A magazine of .45 ammunition."
	icon_state = "45"

	matter_amounts = /datum/design/autolathe/c45m::materials

	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 7
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c45/empty
	max_ammo = 0

/obj/item/ammo_magazine/c45r
	name = "magazine (.45 rubber)"
	desc = "A magazine of .45 rubber ammunition."
	icon_state = "45"

	matter_amounts = /datum/design/autolathe/c45r::materials

	ammo_type = /obj/item/ammo_casing/c45r
	max_ammo = 7
	multiple_sprites = TRUE

/obj/item/ammo_magazine/c45r/empty
	max_ammo = 0

/obj/item/ammo_magazine/a418
	name = "ammunition box (.418)"
	desc = "A box of .418 ammunition."
	icon_state = "418"

	ammo_type = /obj/item/ammo_casing/a418
	max_ammo = 7
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a666
	name = "ammunition box (.666)"
	desc = "A box of .666 ammunition."
	icon_state = "666"

	ammo_type = /obj/item/ammo_casing/a666
	max_ammo = 4
	multiple_sprites = TRUE

/obj/item/ammo_magazine/mc9mm
	name = "magazine (9mm)"
	desc = "A magazine of 9mm ammunition."
	icon_state = "9x19p"

	origin_tech = alist(/decl/tech/combat = 2)

	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 8
	multiple_sprites = TRUE

/obj/item/ammo_magazine/mc9mm/empty
	max_ammo = 0

/obj/item/ammo_magazine/c9mm
	name = "ammunition box (9mm)"
	desc = "A box of 9mm ammunition."
	icon_state = "9mm"

	matter_amounts = /datum/design/weapon/ammo_9mm::materials
	origin_tech = /datum/design/weapon/ammo_9mm::req_tech

	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_magazine/c45
	name = "ammunition box (.45)"
	desc = "A box of .45 ammunition."
	icon_state = "9mm"

	origin_tech = alist(/decl/tech/combat = 2)

	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 30

/obj/item/ammo_magazine/a12mm
	name = "magazine (12mm)"
	desc = "A magazine of 12mm ammunition."
	icon_state = "12mm"

	origin_tech = alist(/decl/tech/combat = 2)

	ammo_type = /obj/item/ammo_casing/a12mm
	max_ammo = 20
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a12mm/empty
	max_ammo = 0

/obj/item/ammo_magazine/a50
	name = "magazine (.50)"
	desc = "A magazine of .50 ammunition."
	icon_state = "50ae"

	origin_tech = alist(/decl/tech/combat = 2)

	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 7
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a50/empty
	max_ammo = 0

/obj/item/ammo_magazine/a75
	name = "magazine (.75)"
	desc = "A magazine of .75 ammunition."
	icon_state = "75"

	ammo_type = /obj/item/ammo_casing/a75
	max_ammo = 8
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a75/empty
	max_ammo = 0

/obj/item/ammo_magazine/a762
	name = "magazine (a762)"
	desc = "A magazine of a762 ammunition."
	icon_state = "a762"

	origin_tech = alist(/decl/tech/combat = 2)

	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 50
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a762/empty
	max_ammo = 0