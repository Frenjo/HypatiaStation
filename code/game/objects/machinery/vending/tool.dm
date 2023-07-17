/*
 * Vending Machine Types
 *
 * These predominantly contain tools.
 */
/obj/machinery/vending/assist
	products = list(
		/obj/item/device/assembly/prox_sensor = 5, /obj/item/device/assembly/igniter = 3, /obj/item/device/assembly/signaler = 4,
		/obj/item/wirecutters = 1, /obj/item/cartridge/signal = 4
	)
	contraband = list(/obj/item/device/flashlight = 5, /obj/item/device/assembly/timer = 2)

	ad_list = list(
		"Only the finest!",
		"Have some tools.",
		"The most robust equipment.",
		"The finest gear in space!"
	)

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"

	//req_access = list(access_maint_tunnels) // Maintenance access.

	products = list(
		/obj/item/stack/cable_coil/random = 10, /obj/item/crowbar = 5, /obj/item/weldingtool = 3, /obj/item/wirecutters = 5,
		/obj/item/wrench = 5, /obj/item/device/analyzer = 5, /obj/item/device/t_scanner = 5, /obj/item/screwdriver = 5
	)
	contraband = list(/obj/item/weldingtool/hugetank = 2, /obj/item/clothing/gloves/fyellow = 2)
	premium = list(/obj/item/clothing/gloves/yellow = 1)

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"

	req_access = list(ACCESS_ENGINE_EQUIP) // Engineering Equipment access.

	products = list(
		/obj/item/clothing/glasses/meson = 2, /obj/item/device/multitool = 4, /obj/item/airlock_electronics = 10,
		/obj/item/module/power_control = 10, /obj/item/airalarm_electronics = 10, /obj/item/cell/high = 10
	)
	contraband = list(/obj/item/cell/potato = 3)
	premium = list(/obj/item/storage/belt/utility = 3)

//This one's from bay12
/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_deny = "engi-deny"

	req_access = list(ACCESS_ENGINE_EQUIP)

	products = list(
		/obj/item/clothing/under/rank/chief_engineer = 4, /obj/item/clothing/under/rank/engineer = 4, /obj/item/clothing/shoes/orange = 4,
		/obj/item/clothing/head/hardhat = 4, /obj/item/storage/belt/utility = 4, /obj/item/clothing/glasses/meson = 4,
		/obj/item/clothing/gloves/yellow = 4, /obj/item/screwdriver = 12, /obj/item/crowbar = 12, /obj/item/wirecutters = 12,
		/obj/item/device/multitool = 12, /obj/item/wrench = 12, /obj/item/device/t_scanner = 12, /obj/item/stack/cable_coil/heavyduty = 8,
		/obj/item/cell = 8, /obj/item/weldingtool = 8, /obj/item/clothing/head/welding = 8, /obj/item/light/tube = 10,
		/obj/item/clothing/suit/fire = 4, /obj/item/stock_part/scanning_module = 5, /obj/item/stock_part/micro_laser = 5,
		/obj/item/stock_part/matter_bin = 5, /obj/item/stock_part/manipulator = 5, /obj/item/stock_part/console_screen = 5
	)
	// There was an incorrect entry (cablecoil/power). I improvised to cablecoil/heavyduty.
	// Another invalid entry, /obj/item/circuitry. I don't even know what that would translate to, removed it.
	// The original products list wasn't finished. The ones without given quantities became quantity 5. -Sayu