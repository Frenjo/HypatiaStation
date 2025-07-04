// PRESETS

// EMP

/obj/machinery/camera/emp_proof/New()
	..()
	upgradeEmpProof()

// X-RAY

/obj/machinery/camera/xray
	icon_state = "xraycam" // Thanks to Krutchen for the icons.

/obj/machinery/camera/xray/New()
	..()
	upgradeXRay()

// MOTION

/obj/machinery/camera/motion/New()
	..()
	upgradeMotion()

// ALL UPGRADES

/obj/machinery/camera/all/New()
	..()
	upgradeEmpProof()
	upgradeXRay()
	upgradeMotion()

// AUTONAME

/obj/machinery/camera/autoname
	var/number = 0 //camera number in area

/obj/machinery/camera/autoname/New()
	..()

//This camera type automatically sets it's name to whatever the area that it's in is called.
/obj/machinery/camera/autoname/initialise()
	. = ..()

	number = 1
	var/area/A = GET_AREA(src)
	if(isnotnull(A))
		// Optimise this to use the area's machines list.
		FOR_MACHINES_TYPED(cam, /obj/machinery/camera/autoname)
			if(cam == src)
				continue
			var/area/CA = GET_AREA(cam)
			if(CA.type == A.type)
				if(cam.number)
					number = max(number, cam.number+1)
		c_tag = "[A.name] #[number]"

// CHECKS

/obj/machinery/camera/proc/isEmpProof()
	if(assembly && assembly.upgrades)
		return (locate(/obj/item/stack/sheet/plasma) in assembly.upgrades)
	else
		return 0

/obj/machinery/camera/proc/isXRay()
	if(assembly && assembly.upgrades)
		return (locate(/obj/item/reagent_holder/food/snacks/grown/carrot) in assembly.upgrades)
	else
		return 0

/obj/machinery/camera/proc/isMotion()
	if(assembly && assembly.upgrades)
		return (locate(/obj/item/assembly/prox_sensor) in assembly.upgrades)
	else
		return 0

// UPGRADE PROCS

/obj/machinery/camera/proc/upgradeEmpProof()
	if(assembly && assembly.upgrades)
		assembly.upgrades.Add(new /obj/item/stack/sheet/plasma(assembly))

/obj/machinery/camera/proc/upgradeXRay()
	if(assembly && assembly.upgrades)
		assembly.upgrades.Add(new /obj/item/reagent_holder/food/snacks/grown/carrot(assembly))

// If you are upgrading Motion, and it isn't in the camera's New(), add it to the machines list.
/obj/machinery/camera/proc/upgradeMotion()
	if(assembly && assembly.upgrades)
		assembly.upgrades.Add(new /obj/item/assembly/prox_sensor(assembly))