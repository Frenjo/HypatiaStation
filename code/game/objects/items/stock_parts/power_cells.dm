/*
 * Power Cell
 *
 * These are not technically a "stock part" but they perform much the same function.
 */
/obj/item/cell
	name = "basic power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	matter_amounts = /datum/design/power_cell/basic::materials
	origin_tech = /datum/design/power_cell/basic::req_tech
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = 3.0

	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000

	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.

/obj/item/cell/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is licking the electrodes of the [src.name]! It looks like \he's trying to commit suicide."))
	return (FIRELOSS)

/obj/item/cell/crap
	name = "\improper NanoTrasen brand rechargable AA battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = alist(/decl/tech/power_storage = 0)
	maxcharge = 500
	matter_amounts = alist(/decl/material/steel = 750, /decl/material/glass = 40)

/obj/item/cell/crap/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/secborg
	name = "security borg rechargable D battery"
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
	icon_state = "hpcell"
	matter_amounts = /datum/design/power_cell/hyper::materials
	origin_tech = /datum/design/power_cell/hyper::req_tech
	maxcharge = 30000

/obj/item/cell/hyper/empty/New()
	. = ..()
	charge = 0

/obj/item/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	origin_tech = null
	maxcharge = 30000
	matter_amounts = alist(/decl/material/steel = 750, /decl/material/glass = 90)

/obj/item/cell/infinite/use()
	return 1

/obj/item/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	icon_state = "potato_cell"
	origin_tech = alist(/decl/tech/power_storage = 1)

	charge = 100
	maxcharge = 300
	matter_amounts = alist()
	minor_fault = 1

/obj/item/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with plasma, it crackles with power."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "yellow slime extract"

	origin_tech = alist(/decl/tech/biotech = 4, /decl/tech/power_storage = 2)
	maxcharge = 10000
	maxcharge = 10000
	matter_amounts = alist()