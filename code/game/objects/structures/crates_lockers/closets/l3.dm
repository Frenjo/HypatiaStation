/*
 * Level 3 Biohazard
 */
/obj/structure/closet/l3
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	icon_state = "bio"
	icon_closed = "bio"
	icon_opened = "bioopen"

/*
 * Level 3 Biohazard General
 */
/obj/structure/closet/l3/general
	icon_state = "bio_general"
	icon_closed = "bio_general"
	icon_opened = "bio_generalopen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/general,
		/obj/item/clothing/head/bio_hood/general
	)

/*
 * Level 3 Biohazard Virology
 */
/obj/structure/closet/l3/virology
	icon_state = "bio_virology"
	icon_closed = "bio_virology"
	icon_opened = "bio_virologyopen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/virology,
		/obj/item/clothing/head/bio_hood/virology,
		/obj/item/clothing/mask/breath,
		/obj/item/tank/oxygen
	)

/*
 * Level 3 Biohazard Security
 */
/obj/structure/closet/l3/security
	icon_state = "bio_security"
	icon_closed = "bio_security"
	icon_opened = "bio_securityopen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/security,
		/obj/item/clothing/head/bio_hood/security
	)

/*
 * Level 3 Biohazard Janitor
 */
/obj/structure/closet/l3/janitor
	icon_state = "bio_janitor"
	icon_closed = "bio_janitor"
	icon_opened = "bio_janitoropen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/janitor,
		/obj/item/clothing/head/bio_hood/janitor
	)

/*
 * Level 3 Biohazard Scientist
 */
/obj/structure/closet/l3/scientist
	icon_state = "bio_scientist"
	icon_closed = "bio_scientist"
	icon_opened = "bio_scientistopen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist
	)