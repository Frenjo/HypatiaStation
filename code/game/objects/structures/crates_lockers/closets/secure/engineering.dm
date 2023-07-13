/*
 * Chief Engineer
 */
/obj/structure/closet/secure_closet/engineering_chief
	name = "Chief Engineer's Locker"
	req_access = list(ACCESS_CE)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"

	starts_with = list(
		/obj/item/blueprints,
		/obj/item/clothing/under/rank/chief_engineer,
		/obj/item/clothing/head/hardhat/white,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/gloves/yellow,
		/obj/item/clothing/shoes/brown,
		/obj/item/cartridge/ce,
		/obj/item/device/radio/headset/heads/ce,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/device/multitool,
		/obj/item/device/flash,
		/obj/item/taperoll/engineering
	)

/obj/structure/closet/secure_closet/engineering_chief/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/industrial)
	else
		starts_with.Add(/obj/item/storage/satchel/eng)
	if(prob(70))
		starts_with.Add(/obj/item/clothing/tie/storage/brown_vest)
	else
		starts_with.Add(/obj/item/clothing/tie/storage/webbing)
	. = ..()

/*
 * Electrical
 */
/obj/structure/closet/secure_closet/engineering_electrical
	name = "Electrical Supplies"
	req_access = list(ACCESS_ENGINE_EQUIP)
	icon_state = "secureengelec1"
	icon_closed = "secureengelec"
	icon_locked = "secureengelec1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengelecbroken"
	icon_off = "secureengelecoff"

	starts_with = list(
		/obj/item/clothing/gloves/yellow,
		/obj/item/clothing/gloves/yellow,
		/obj/item/storage/toolbox/electrical,
		/obj/item/storage/toolbox/electrical,
		/obj/item/storage/toolbox/electrical,
		/obj/item/module/power_control,
		/obj/item/module/power_control,
		/obj/item/module/power_control,
		/obj/item/device/multitool,
		/obj/item/device/multitool,
		/obj/item/device/multitool,

		/obj/item/storage/box/circuits,
		/obj/item/storage/box/circuits
	)

/*
 * Welding
 */
/obj/structure/closet/secure_closet/engineering_welding
	name = "Welding Supplies"
	req_access = list(ACCESS_CONSTRUCTION)
	icon_state = "secureengweld1"
	icon_closed = "secureengweld"
	icon_locked = "secureengweld1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengweldbroken"
	icon_off = "secureengweldoff"

	starts_with = list(
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/welding,
		/obj/item/weldingtool/largetank,
		/obj/item/weldingtool/largetank,
		/obj/item/weldingtool/largetank,
		/obj/item/weldpack,
		/obj/item/weldpack,
		/obj/item/weldpack
	)

/*
 * Engineer
 */
/obj/structure/closet/secure_closet/engineering_personal
	name = "Engineer's Locker"
	req_access = list(ACCESS_ENGINE_EQUIP)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"

	starts_with = list(
		/obj/item/storage/toolbox/mechanical,
		/obj/item/device/radio/headset/engi,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/cartridge/engineering,
		/obj/item/taperoll/engineering
	)

/obj/structure/closet/secure_closet/engineering_personal/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/industrial)
	else
		starts_with.Add(/obj/item/storage/satchel/eng)
	if(prob(70))
		starts_with.Add(/obj/item/clothing/tie/storage/brown_vest)
	else
		starts_with.Add(/obj/item/clothing/tie/storage/webbing)
	. = ..()

/*
 * Atmospheric Technician
 */
/obj/structure/closet/secure_closet/atmos_personal
	name = "Technician's Locker"
	req_access = list(ACCESS_ATMOSPHERICS)
	icon_state = "secureatm1"
	icon_closed = "secureatm"
	icon_locked = "secureatm1"
	icon_opened = "secureatmopen"
	icon_broken = "secureatmbroken"
	icon_off = "secureatmoff"

	starts_with = list(
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/device/flashlight,
		/obj/item/extinguisher,
		/obj/item/device/radio/headset/engi,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/cartridge/atmos,
		/obj/item/taperoll/engineering
	)

/obj/structure/closet/secure_closet/atmos_personal/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/industrial)
	else
		starts_with.Add(/obj/item/storage/satchel/eng)
	if(prob(70))
		starts_with.Add(/obj/item/clothing/tie/storage/brown_vest)
	else
		starts_with.Add(/obj/item/clothing/tie/storage/webbing)
	. = ..()