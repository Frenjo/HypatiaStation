// Variants with different cell configurations for mapping.
/obj/machinery/power/apc/standard/none
	cell_type = null

/obj/machinery/power/apc/standard/potato
	cell_type = /obj/item/cell/potato

/obj/machinery/power/apc/standard/crap
	cell_type = /obj/item/cell/crap

/obj/machinery/power/apc/standard/cell
	cell_type = /obj/item/cell

/obj/machinery/power/apc/standard/apc
	cell_type = /obj/item/cell/apc

/obj/machinery/power/apc/standard/high
	cell_type = /obj/item/cell/high

/obj/machinery/power/apc/standard/super
	cell_type = /obj/item/cell/super

/obj/machinery/power/apc/standard/hyper
	cell_type = /obj/item/cell/hyper

// These are for disused on-station places, IE the old prison wing or old security dorms.
/obj/machinery/power/apc/disused
	icon_state = "apc1"
	opened = 1
	shorted = 1
	lighting = POWERCHAN_OFF
	equipment = POWERCHAN_OFF
	environ = POWERCHAN_OFF
	operating = 0
	chargemode = 0
	locked = 0
	coverlocked = 0

/obj/machinery/power/apc/disused/none
	cell_type = null

/obj/machinery/power/apc/disused/potato
	cell_type = /obj/item/cell/potato

/obj/machinery/power/apc/disused/crap
	cell_type = /obj/item/cell/crap

/obj/machinery/power/apc/disused/cell
	cell_type = /obj/item/cell

/obj/machinery/power/apc/disused/apc
	cell_type = /obj/item/cell/apc

/obj/machinery/power/apc/disused/high
	cell_type = /obj/item/cell/high

/obj/machinery/power/apc/disused/super
	cell_type = /obj/item/cell/super

/obj/machinery/power/apc/disused/hyper
	cell_type = /obj/item/cell/hyper

// These are for abandoned off-station places, IE the derelict or white ship.
/obj/machinery/power/apc/abandoned
	lighting = POWERCHAN_OFF
	equipment = POWERCHAN_OFF
	environ = POWERCHAN_OFF
	operating = 0
	chargemode = 0
	locked = 0
	coverlocked = 0

/obj/machinery/power/apc/abandoned/none
	cell_type = null

/obj/machinery/power/apc/abandoned/potato
	cell_type = /obj/item/cell/potato

/obj/machinery/power/apc/abandoned/crap
	cell_type = /obj/item/cell/crap

/obj/machinery/power/apc/abandoned/cell
	cell_type = /obj/item/cell

/obj/machinery/power/apc/abandoned/apc
	cell_type = /obj/item/cell/apc

/obj/machinery/power/apc/abandoned/high
	cell_type = /obj/item/cell/high

/obj/machinery/power/apc/abandoned/super
	cell_type = /obj/item/cell/super

/obj/machinery/power/apc/abandoned/hyper
	cell_type = /obj/item/cell/hyper

// These are for away mission locations, IE the Academy or Black Market Packers.
/obj/machinery/power/apc/away
	locked = 0

// These are switched fully on, but still unlocked.
/obj/machinery/power/apc/away/on
	lighting = POWERCHAN_ON_AUTO
	equipment = POWERCHAN_ON_AUTO
	environ = POWERCHAN_ON_AUTO

/obj/machinery/power/apc/away/on/none
	cell_type = null

/obj/machinery/power/apc/away/on/potato
	cell_type = /obj/item/cell/potato

/obj/machinery/power/apc/away/on/crap
	cell_type = /obj/item/cell/crap

/obj/machinery/power/apc/away/on/cell
	cell_type = /obj/item/cell

/obj/machinery/power/apc/away/on/apc
	cell_type = /obj/item/cell/apc

/obj/machinery/power/apc/away/on/high
	cell_type = /obj/item/cell/high

/obj/machinery/power/apc/away/on/super
	cell_type = /obj/item/cell/super

/obj/machinery/power/apc/away/on/hyper
	cell_type = /obj/item/cell/hyper

// These are switched fully off, but still unlocked.
/obj/machinery/power/apc/away/off
	lighting = POWERCHAN_OFF
	equipment = POWERCHAN_OFF
	environ = POWERCHAN_OFF

/obj/machinery/power/apc/away/off/none
	cell_type = null

/obj/machinery/power/apc/away/off/potato
	cell_type = /obj/item/cell/potato

/obj/machinery/power/apc/away/off/crap
	cell_type = /obj/item/cell/crap

/obj/machinery/power/apc/away/off/cell
	cell_type = /obj/item/cell

/obj/machinery/power/apc/away/off/apc
	cell_type = /obj/item/cell/apc

/obj/machinery/power/apc/away/off/high
	cell_type = /obj/item/cell/high

/obj/machinery/power/apc/away/off/super
	cell_type = /obj/item/cell/super

/obj/machinery/power/apc/away/off/hyper
	cell_type = /obj/item/cell/hyper
// End variants.