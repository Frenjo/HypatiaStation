/**
 * PDA Cartridge Types
 * Ensure ordering retains parity with pda_types.dm.
 */

// Civilian
/obj/item/cartridge/lawyer
	name = "\improper P.R.O.V.E. cartridge"
	icon_state = "cart-s"
	access_security = TRUE

/*
/obj/item/cartridge/botanist
	name = "\improper Green Thumb v4.20 cartridge"
	icon_state = "cart-b"
	access_flora = TRUE
*/

/obj/item/cartridge/janitor
	name = "\improper CustodiPRO cartridge"
	desc = "The ultimate in clean-room design."
	icon_state = "cart-j"
	access_janitor = TRUE

/obj/item/cartridge/clown
	name = "\improper Honkworks 5.0 cartridge"
	icon_state = "cart-clown"
	access_clown = TRUE
	charges = 5

/obj/item/cartridge/mime
	name = "\improper Gestur-O 1000 cartridge"
	icon_state = "cart-mi"
	access_mime = TRUE
	charges = 5

// Medical
/obj/item/cartridge/medical
	name = "\improper Med-U cartridge"
	icon_state = "cart-m"
	access_medical = TRUE

/obj/item/cartridge/chemistry
	name = "\improper ChemWhiz cartridge"
	icon_state = "cart-chem"
	access_reagent_scanner = TRUE

// Science
/obj/item/cartridge/signal
	name = "generic signaler cartridge"
	desc = "A data cartridge with an integrated radio signaler module."

/obj/item/cartridge/signal/initialise()
	. = ..()
	radio = new /obj/item/radio/integrated/signal(src)

/obj/item/cartridge/signal/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/item/cartridge/signal/toxins
	name = "\improper Signal Ace 2 cartridge"
	desc = "Complete with integrated radio signaler!"
	icon_state = "cart-tox"
	access_reagent_scanner = TRUE
	access_atmos = TRUE

// Engineering
/obj/item/cartridge/engineering
	name = "\improper Power-ON cartridge"
	icon_state = "cart-e"
	access_engine = TRUE

/obj/item/cartridge/atmos
	name = "\improper BreatheDeep cartridge"
	icon_state = "cart-a"
	access_atmos = TRUE

// Security
/obj/item/cartridge/security
	name = "\improper R.O.B.U.S.T. cartridge"
	icon_state = "cart-s"
	access_security = TRUE

/obj/item/cartridge/security/initialise()
	. = ..()
	radio = new /obj/item/radio/integrated/beepsky(src)

/obj/item/cartridge/detective
	name = "\improper D.E.T.E.C.T. cartridge"
	icon_state = "cart-s"
	access_security = TRUE
	access_medical = TRUE

// Cargo
/obj/item/cartridge/quartermaster
	name = "\improper Space Parts & Space Vendors cartridge"
	desc = "Perfect for the Quartermaster on the go!"
	icon_state = "cart-q"
	access_quartermaster = TRUE

/obj/item/cartridge/quartermaster/initialise()
	. = ..()
	radio = new /obj/item/radio/integrated/mule(src)

// Heads
/obj/item/cartridge/head
	name = "\improper Easy-Record DELUXE cartridge"
	icon_state = "cart-h"
	access_status_display = TRUE

/obj/item/cartridge/captain
	name = "\improper Value-PAK cartridge"
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

/obj/item/cartridge/hop
	name = "\improper HumanResources9001 cartridge"
	icon_state = "cart-h"
	access_status_display = TRUE
	access_quartermaster = TRUE
	access_janitor = TRUE
	access_security = TRUE

/obj/item/cartridge/hop/initialise()
	. = ..()
	radio = new /obj/item/radio/integrated/mule(src)

/obj/item/cartridge/hos
	name = "\improper R.O.B.U.S.T. DELUXE cartridge"
	icon_state = "cart-hos"
	access_status_display = TRUE
	access_security = TRUE

/obj/item/cartridge/hos/initialise()
	. = ..()
	radio = new /obj/item/radio/integrated/beepsky(src)

/obj/item/cartridge/ce
	name = "\improper Power-On DELUXE cartridge"
	icon_state = "cart-ce"
	access_status_display = TRUE
	access_engine = TRUE
	access_atmos = TRUE

/obj/item/cartridge/cmo
	name = "\improper Med-U DELUXE cartridge"
	icon_state = "cart-cmo"
	access_status_display = TRUE
	access_reagent_scanner = TRUE
	access_medical = TRUE

/obj/item/cartridge/rd
	name = "\improper Signal Ace DELUXE cartridge"
	icon_state = "cart-rd"
	access_status_display = TRUE
	access_reagent_scanner = TRUE
	access_atmos = TRUE

/obj/item/cartridge/rd/initialise()
	. = ..()
	radio = new /obj/item/radio/integrated/signal(src)

// Syndicate
/obj/item/cartridge/syndicate
	name = "\improper Detomatix cartridge"
	icon_state = "cart"
	access_remote_door = TRUE
	remote_door_id = "smindicate" //Make sure this matches the syndicate shuttle's shield/door id!!	//don't ask about the name, testing.
	charges = 4