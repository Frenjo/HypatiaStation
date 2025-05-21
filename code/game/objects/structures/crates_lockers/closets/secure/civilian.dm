/*
 * Chef
 */
/obj/structure/closet/secure/chef_personal
	name = "chef's locker"
	req_access = list(ACCESS_KITCHEN)

	starts_with = list(
		/obj/item/wardrobe/chef,
		/obj/item/radio/headset
	)

/obj/structure/closet/secure/chef_personal/New()
	. = ..()
	var/obj/item/storage/backpack/BPK = new /obj/item/storage/backpack(src)
	var/obj/item/storage/box/B = new(BPK)
	new /obj/item/pen(B)

/*
 * Booze Closet
 */
/obj/structure/closet/secure/bar
	name = "Booze"
	req_access = list(ACCESS_BAR)

	starts_with = list(
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/drinks/cans/beer
	)

/*
 * Bartender
 */
/obj/structure/closet/secure/barman_personal
	name = "barman's locker"
	req_access = list(ACCESS_BAR)

	starts_with = list(
		/obj/item/wardrobe/bartender,
		/obj/item/radio/headset
	)

/obj/structure/closet/secure/barman_personal/New()
	. = ..()
	var/obj/item/storage/backpack/BPK = new /obj/item/storage/backpack(src)
	new /obj/item/ammo_casing/shotgun/beanbag(BPK)
	new /obj/item/ammo_casing/shotgun/beanbag(BPK)
	new /obj/item/ammo_casing/shotgun/beanbag(BPK)
	new /obj/item/ammo_casing/shotgun/beanbag(BPK)
	var/obj/item/storage/box/B = new(BPK)
	new /obj/item/pen(B)

/*
 * Botanist
 */
/obj/structure/closet/secure/hydro_personal
	name = "botanist's locker"
	req_access = list(ACCESS_HYDROPONICS)

	starts_with = list(
		/obj/item/wardrobe/hydro,
		/obj/item/plant_analyser,
		/obj/item/radio/headset
	)

/obj/structure/closet/secure/hydro_personal/New()
	. = ..()
	var/obj/item/storage/backpack/BPK = new /obj/item/storage/backpack(src)
	var/obj/item/storage/box/B = new(BPK)
	new /obj/item/pen(B)

/*
 * Janitor
 */
/obj/structure/closet/secure/janitor_personal
	name = "janitor's locker"
	req_access = list(ACCESS_JANITOR)

	starts_with = list(
		/obj/item/wardrobe/janitor,
		/obj/item/pda/janitor
	)

/obj/structure/closet/secure/janitor_personal/New()
	. = ..()
	var/obj/item/storage/backpack/BPK = new /obj/item/storage/backpack(src)
	var/obj/item/storage/box/B = new(BPK)
	new /obj/item/pen(B)

/*
 * Lawyer
 */
/obj/structure/closet/secure/lawyer_personal
	name = "lawyer's locker"
	req_access = list(ACCESS_LAWYER)

	starts_with = list(
		/obj/item/wardrobe/lawyer,
		/obj/item/pda/lawyer,
		/obj/item/detective_scanner,
		/obj/item/storage/briefcase
	)

/obj/structure/closet/secure/lawyer_personal/New()
	. = ..()
	var/obj/item/storage/backpack/BPK = new /obj/item/storage/backpack(src)
	var/obj/item/storage/box/B = new(BPK)
	new /obj/item/pen(B)

/*
 * Librarian
 */
/obj/structure/closet/secure/librarian_personal
	name = "librarian's locker"
	req_access = list(ACCESS_LIBRARY)

	starts_with = list(
		/obj/item/wardrobe/librarian,
		/obj/item/barcodescanner
	)

/obj/structure/closet/secure/librarian_personal/New()
	. = ..()
	var/obj/item/storage/backpack/BPK = new /obj/item/storage/backpack(src)
	var/obj/item/storage/box/B = new(BPK)
	new /obj/item/pen(B)

/*
 * Counselor
 */
/obj/structure/closet/secure/counselor_personal
	name = "counselor's locker"
	req_access = list(ACCESS_CHAPEL_OFFICE)

	starts_with = list(
		/obj/item/wardrobe/chaplain,
		/obj/item/storage/backpack/cultpack,
		/obj/item/storage/bible,
		/obj/item/pda/chaplain,
		/obj/item/radio/headset,
		/obj/item/candlepack,
		/obj/item/candlepack
	)

/obj/structure/closet/secure/counselor_personal/New()
	. = ..()
	var/obj/item/storage/backpack/BPK = new /obj/item/storage/backpack(src)
	var/obj/item/storage/box/B = new(BPK)
	new /obj/item/pen(B)