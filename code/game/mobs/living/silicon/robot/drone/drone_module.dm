/*
 * Drone Module
 */
/obj/item/robot_module/drone
	name = "drone module"

/obj/item/robot_module/drone/New()
	//TODO: Replace with shittier flashlight and work out why we can't remove the flash. ~Z
	. = ..()
	modules.Add(new /obj/item/weldingtool(src))
	modules.Add(new /obj/item/screwdriver(src))
	modules.Add(new /obj/item/wrench(src))
	modules.Add(new /obj/item/crowbar(src))
	modules.Add(new /obj/item/wirecutters(src))
	modules.Add(new /obj/item/multitool(src))
	modules.Add(new /obj/item/lightreplacer(src))
	modules.Add(new /obj/item/reagent_holder/spray/cleaner(src))
	modules.Add(new /obj/item/gripper(src))
	modules.Add(new /obj/item/matter_decompiler(src))

	emag = new /obj/item/card/emag(src)
	emag.name = "Cryptographic Sequencer"

	var/list/stacktypes = list(
		/obj/item/stack/rods = 10,
		/obj/item/stack/tile/metal/grey = 10,
		/obj/item/stack/sheet/steel/cyborg = 10,
		/obj/item/stack/sheet/wood/cyborg = 1,
		/obj/item/stack/cable_coil = 30,
		/obj/item/stack/sheet/glass/cyborg = 10,
		/obj/item/stack/sheet/plastic/cyborg = 1
	)

	for(var/T in stacktypes)
		var/obj/item/stack/sheet/W = new T(src)
		W.amount = stacktypes[T]
		modules.Add(W)

/obj/item/robot_module/drone/add_languages(mob/living/silicon/robot/R)
	. = ..() //not much ROM to spare in that tiny microprocessor!

/obj/item/robot_module/drone/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/reagent_holder/spray/cleaner/C = locate() in modules
	C.reagents.add_reagent("cleaner", 10)

	var/list/stacks = list(
		/obj/item/stack/sheet/steel,
		/obj/item/stack/cable_coil,
		/obj/item/stack/sheet/glass/cyborg,
		/obj/item/stack/rods,
		/obj/item/stack/tile/metal/grey
	)

	for(var/T in stacks)
		var/O = locate(T) in modules
		var/obj/item/stack/sheet/S = O

		if(isnull(S))
			modules.Remove(null)
			S = new T(src)
			modules.Add(S)
			S.amount = 0

		if(S?.amount < 15)
			S.amount++

	var/obj/item/lightreplacer/LR = locate() in modules
	LR.Charge(R)