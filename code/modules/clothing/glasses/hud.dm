/obj/item/clothing/glasses/hud
	name = "\improper HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	item_flags = null //doesn't protect eyes because it's a monocle, duh
	origin_tech = alist(/decl/tech/magnets = 3, /decl/tech/biotech = 2)
	var/list/icon/current = list() //the current hud icons

/obj/item/clothing/glasses/hud/proc/process_hud(mob/M)
	return


/obj/item/clothing/glasses/hud/health
	name = "health scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	matter_amounts = /datum/design/medical/health_hud::materials
	origin_tech = /datum/design/medical/health_hud::req_tech

/obj/item/clothing/glasses/hud/health/process_hud(mob/M)
	process_med_hud(M, 1)


/obj/item/clothing/glasses/hud/security
	name = "security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	matter_amounts = /datum/design/security_hud::materials
	origin_tech = /datum/design/security_hud::req_tech

	var/static/list/jobs[0]

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensenshades"
	item_state = "jensenshades"
	vision_flags = SEE_MOBS
	invisa_view = 2

/obj/item/clothing/glasses/hud/security/process_hud(mob/M)
	process_sec_hud(M, 1)