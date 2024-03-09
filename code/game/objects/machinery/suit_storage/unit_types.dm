/*
 * The units themselves.
 */
/obj/machinery/suit_storage_unit/standard
	helmet_type = /obj/item/clothing/head/helmet/space
	suit_type = /obj/item/clothing/suit/space
	mask_type = /obj/item/clothing/mask/breath

// Added a couple more of these for department- and species- specific storages. -Frenjo

// Species-specific first.
/obj/machinery/suit_storage_unit/skrell_white
	name = "suit storage unit (White Skrell)"
	helmet_type = /obj/item/clothing/head/helmet/space/skrell/white
	suit_type = /obj/item/clothing/suit/space/skrell/white
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/skrell_black
	name = "suit storage unit (Black Skrell)"
	helmet_type = /obj/item/clothing/head/helmet/space/skrell/black
	suit_type = /obj/item/clothing/suit/space/skrell/black
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/soghun
	name = "suit storage unit (Soghun Breacher)"
	helmet_type = /obj/item/clothing/head/helmet/space/soghun/helmet_cheap
	suit_type = /obj/item/clothing/suit/space/soghun/rig_cheap
	mask_type = /obj/item/clothing/mask/breath

/*
/obj/machinery/suit_storage_unit/tajara
	name = "suit storage unit (Tajara)"
	helmet_type = /obj/item/clothing/head/helmet/space/rig/tajara
	suit_type = /obj/item/clothing/suit/space/rig/tajara
	mask_type = /obj/item/clothing/mask/breath
*/

// Department-specific next.
/obj/machinery/suit_storage_unit/engineering
	name = "suit storage unit (Engineering)"
	helmet_type = /obj/item/clothing/head/helmet/space/rig
	suit_type = /obj/item/clothing/suit/space/rig
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/atmospherics
	name = "suit storage unit (Atmospherics)"
	helmet_type = /obj/item/clothing/head/helmet/space/rig/atmos
	suit_type = /obj/item/clothing/suit/space/rig/atmos
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/mining
	name = "suit storage unit (Mining)"
	helmet_type = /obj/item/clothing/head/helmet/space/rig/mining
	suit_type = /obj/item/clothing/suit/space/rig/mining
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/medical
	name = "suit storage unit (Medical)"
	helmet_type = /obj/item/clothing/head/helmet/space/rig/medical
	suit_type = /obj/item/clothing/suit/space/rig/medical
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/security
	name = "suit storage unit (Security)"
	helmet_type = /obj/item/clothing/head/helmet/space/rig/security
	suit_type = /obj/item/clothing/suit/space/rig/security
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/excavation
	name = "suit storage unit (Excavation)"
	helmet_type = /obj/item/clothing/head/helmet/space/anomaly
	suit_type = /obj/item/clothing/suit/space/anomaly
	mask_type = /obj/item/clothing/mask/breath

// Finally job specific.
/obj/machinery/suit_storage_unit/chief_engineer
	name = "suit storage unit (Advanced Engineering)"
	helmet_type = /obj/item/clothing/head/helmet/space/rig/elite
	suit_type = /obj/item/clothing/suit/space/rig/elite
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/clown
	name = "suit storage unit (Clown)"
	helmet_type = /obj/item/clothing/head/helmet/space/clown
	suit_type = /obj/item/clothing/suit/space/clown
	mask_type = /obj/item/clothing/mask/gas/clown_hat

/obj/machinery/suit_storage_unit/mime
	name = "suit storage unit (Mime)"
	helmet_type = /obj/item/clothing/head/helmet/space/mime
	suit_type = /obj/item/clothing/suit/space/mime
	mask_type = /obj/item/clothing/mask/gas/mime

/obj/machinery/suit_storage_unit/mailman
	name = "suit storage unit (Mailman)"
	helmet_type = /obj/item/clothing/head/helmet/space/mailmanvoid
	suit_type = /obj/item/clothing/suit/space/mailmanvoid
	mask_type = /obj/item/clothing/mask/breath