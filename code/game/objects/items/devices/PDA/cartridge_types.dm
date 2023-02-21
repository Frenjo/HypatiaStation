/**
 * PDA Cartridge Types
 * Ensure ordering retains parity with pda_types.dm.
 */

// Civilian
/obj/item/weapon/cartridge/lawyer
	name = "P.R.O.V.E. Cartridge"
	icon_state = "cart-s"
	access_security = TRUE

/*
/obj/item/weapon/cartridge/botanist
	name = "Green Thumb v4.20"
	icon_state = "cart-b"
	access_flora = TRUE
*/

/obj/item/weapon/cartridge/janitor
	name = "CustodiPRO Cartridge"
	desc = "The ultimate in clean-room design."
	icon_state = "cart-j"
	access_janitor = TRUE

/obj/item/weapon/cartridge/clown
	name = "Honkworks 5.0"
	icon_state = "cart-clown"
	access_clown = TRUE
	charges = 5

/obj/item/weapon/cartridge/mime
	name = "Gestur-O 1000"
	icon_state = "cart-mi"
	access_mime = TRUE
	charges = 5

// Medical
/obj/item/weapon/cartridge/medical
	name = "Med-U Cartridge"
	icon_state = "cart-m"
	access_medical = TRUE

/obj/item/weapon/cartridge/chemistry
	name = "ChemWhiz Cartridge"
	icon_state = "cart-chem"
	access_reagent_scanner = TRUE

// Science
/obj/item/weapon/cartridge/signal
	name = "generic signaler cartridge"
	desc = "A data cartridge with an integrated radio signaler module."

/obj/item/weapon/cartridge/signal/initialize()
	. = ..()
	radio = new /obj/item/radio/integrated/signal(src)

/obj/item/weapon/cartridge/signal/Destroy()
	qdel(radio)
	return ..()

/obj/item/weapon/cartridge/signal/toxins
	name = "Signal Ace 2"
	desc = "Complete with integrated radio signaler!"
	icon_state = "cart-tox"
	access_reagent_scanner = TRUE
	access_atmos = TRUE

// Engineering
/obj/item/weapon/cartridge/engineering
	name = "Power-ON Cartridge"
	icon_state = "cart-e"
	access_engine = TRUE

/obj/item/weapon/cartridge/atmos
	name = "BreatheDeep Cartridge"
	icon_state = "cart-a"
	access_atmos = TRUE

// Security
/obj/item/weapon/cartridge/security
	name = "R.O.B.U.S.T. Cartridge"
	icon_state = "cart-s"
	access_security = TRUE

/obj/item/weapon/cartridge/security/initialize()
	. = ..()
	radio = new /obj/item/radio/integrated/beepsky(src)

/obj/item/weapon/cartridge/detective
	name = "D.E.T.E.C.T. Cartridge"
	icon_state = "cart-s"
	access_security = TRUE
	access_medical = TRUE

// Cargo
/obj/item/weapon/cartridge/quartermaster
	name = "Space Parts & Space Vendors Cartridge"
	desc = "Perfect for the Quartermaster on the go!"
	icon_state = "cart-q"
	access_quartermaster = TRUE

/obj/item/weapon/cartridge/quartermaster/initialize()
	. = ..()
	radio = new /obj/item/radio/integrated/mule(src)

// Heads
/obj/item/weapon/cartridge/head
	name = "Easy-Record DELUXE"
	icon_state = "cart-h"
	access_status_display = TRUE

/obj/item/weapon/cartridge/captain
	name = "Value-PAK Cartridge"
	desc = "Now with 200% more value!"
	icon_state = "cart-c"
	access_quartermaster = TRUE
	access_janitor = TRUE
	access_engine = TRUE
	access_security = TRUE
	access_medical = TRUE
	access_reagent_scanner = TRUE
	access_status_display = TRUE
	access_atmos = TRUE

/obj/item/weapon/cartridge/hop
	name = "HumanResources9001"
	icon_state = "cart-h"
	access_status_display = TRUE
	access_quartermaster = TRUE
	access_janitor = TRUE
	access_security = TRUE

/obj/item/weapon/cartridge/hop/initialize()
	. = ..()
	radio = new /obj/item/radio/integrated/mule(src)

/obj/item/weapon/cartridge/hos
	name = "R.O.B.U.S.T. DELUXE"
	icon_state = "cart-hos"
	access_status_display = TRUE
	access_security = TRUE

/obj/item/weapon/cartridge/hos/initialize()
	. = ..()
	radio = new /obj/item/radio/integrated/beepsky(src)

/obj/item/weapon/cartridge/ce
	name = "Power-On DELUXE"
	icon_state = "cart-ce"
	access_status_display = TRUE
	access_engine = TRUE
	access_atmos = TRUE

/obj/item/weapon/cartridge/cmo
	name = "Med-U DELUXE"
	icon_state = "cart-cmo"
	access_status_display = TRUE
	access_reagent_scanner = TRUE
	access_medical = TRUE

/obj/item/weapon/cartridge/rd
	name = "Signal Ace DELUXE"
	icon_state = "cart-rd"
	access_status_display = TRUE
	access_reagent_scanner = TRUE
	access_atmos = TRUE

/obj/item/weapon/cartridge/rd/initialize()
	. = ..()
	radio = new /obj/item/radio/integrated/signal(src)

// Syndicate
/obj/item/weapon/cartridge/syndicate
	name = "Detomatix Cartridge"
	icon_state = "cart"
	access_remote_door = TRUE
	remote_door_id = "smindicate" //Make sure this matches the syndicate shuttle's shield/door id!!	//don't ask about the name, testing.
	charges = 4