/*
 * Power Cells
 *
 * These are not technically a "stock part" but they perform much the same function.
 */
/obj/item/cell/crap
	name = "\improper NanoTrasen brand rechargeable AA battery"
	desc = "A rechargeable electrochemical power cell. You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = alist(/decl/tech/power_storage = 0)
	maxcharge = 500
	matter_amounts = alist(/decl/material/steel = 750, /decl/material/glass = 40)

/obj/item/cell/crap/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/secborg
	name = "security robot rechargeable D battery"
	origin_tech = alist(/decl/tech/power_storage = 0)
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	matter_amounts = alist(/decl/material/steel = 750, /decl/material/glass = 40)

/obj/item/cell/secborg/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/apc
	name = "\improper APC power cell"
	origin_tech = alist(/decl/tech/power_storage = 1)
	maxcharge = 5000
	matter_amounts = alist(/decl/material/steel = 750, /decl/material/glass = 50)

/obj/item/cell/apc/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/high
	name = "high-capacity power cell"
	icon_state = "hcell"
	matter_amounts = /datum/design/power_cell/high::materials
	origin_tech = /datum/design/power_cell/high::req_tech
	maxcharge = 10000

/obj/item/cell/high/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/super
	name = "super-capacity power cell"
	icon_state = "scell"
	matter_amounts = /datum/design/power_cell/super::materials
	origin_tech = /datum/design/power_cell/super::req_tech
	maxcharge = 20000

/obj/item/cell/super/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/hyper
	name = "hyper-capacity power cell"
	desc = "A rechargeable electrochemical power cell. This one has an exciting chrome finish, as it is an uber-capacity cell type!"
	icon_state = "hpcell"
	matter_amounts = /datum/design/power_cell/hyper::materials
	origin_tech = /datum/design/power_cell/hyper::req_tech
	maxcharge = 30000

/obj/item/cell/hyper/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/bluespace
	name = "bluespace power cell"
	desc = "A rechargeable power cell. This one appears to be electromagnetic instead of electrochemical, and utilises \"alien\" technology for extreme capacity."
	icon_state = "bscell"
	matter_amounts = alist(
		/decl/material/steel = 1.75 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.9,
		/decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5, /decl/material/gold = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5,
		/decl/material/diamond = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5, /decl/material/plasma = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5
	)
	origin_tech = alist(/decl/tech/materials = 6, /decl/tech/magnets = 6, /decl/tech/power_storage = 6, /decl/tech/bluespace = 4)
	maxcharge = 40000

/obj/item/cell/infinite
	name = "infinite-capacity power cell"
	desc = "An power cell that appears to never run out of charge."
	icon_state = "icell"
	origin_tech = null
	maxcharge = 40000
	matter_amounts = alist(/decl/material/steel = 1.75 MATERIAL_SHEETS, /decl/material/glass = 0.25 MATERIAL_SHEETS)

/obj/item/cell/infinite/use()
	return 1

/obj/item/cell/potato
	name = "potato battery"
	desc = "A rechargeable starch based power cell."
	icon_state = "potato_cell"
	origin_tech = alist(/decl/tech/power_storage = 1)

	charge = 100
	maxcharge = 300
	matter_amounts = alist()
	minor_fault = 1

/obj/item/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with plasma, it crackles with power."
	icon = 'icons/mob/simple/slimes.dmi'
	icon_state = "yellow slime extract"

	origin_tech = alist(/decl/tech/biotech = 4, /decl/tech/power_storage = 2)
	maxcharge = 10000
	maxcharge = 10000
	matter_amounts = alist()