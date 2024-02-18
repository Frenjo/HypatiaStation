/obj/machinery/bluespace_beacon
	name = "Bluespace Gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	icon = 'icons/obj/machines/beacons.dmi'
	icon_state = "floor_beaconf"

	level = 1		// underfloor
	layer = 2.5
	anchored = TRUE

	var/obj/item/radio/beacon/Beacon

/obj/machinery/bluespace_beacon/New()
	..()
	var/turf/T = loc
	Beacon = new /obj/item/radio/beacon
	Beacon.invisibility = INVISIBILITY_MAXIMUM
	Beacon.loc = T

	hide(T.intact)

/obj/machinery/bluespace_beacon/Destroy()
	if(Beacon)
		qdel(Beacon)
	return ..()

// update the invisibility and icon
/obj/machinery/bluespace_beacon/hide(var/intact)
	invisibility = intact ? 101 : 0
	updateicon()

// update the icon_state
/obj/machinery/bluespace_beacon/proc/updateicon()
	var/state="floor_beacon"

	if(invisibility)
		icon_state = "[state]f"

	else
		icon_state = "[state]"

/obj/machinery/bluespace_beacon/process()
	if(!Beacon)
		var/turf/T = loc
		Beacon = new /obj/item/radio/beacon
		Beacon.invisibility = INVISIBILITY_MAXIMUM
		Beacon.loc = T
	if(Beacon)
		if(Beacon.loc != loc)
			Beacon.loc = loc

	updateicon()