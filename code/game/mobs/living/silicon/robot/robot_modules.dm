/*
 * Base Module
 */
/obj/item/weapon/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 100.0
	item_state = "electronic"
	flags = CONDUCT

	var/channels = list()
	var/list/modules = list()
	var/obj/item/emag = null
	var/obj/item/borg/upgrade/jetpack = null

/obj/item/weapon/robot_module/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	. = ..()

/obj/item/weapon/robot_module/New()
	modules.Add(new /obj/item/device/flashlight(src))
	modules.Add(new /obj/item/device/flash(src))
	emag = new /obj/item/toy/sword(src)
	emag.name = "Placeholder Emag Item"
//	jetpack = new /obj/item/toy/sword(src)
//	jetpack.name = "Placeholder Upgrade Item"

/obj/item/weapon/robot_module/Destroy()
	qdel(modules)
	qdel(emag)
	qdel(jetpack)
	modules = null
	emag = null
	jetpack = null
	return ..()

/obj/item/weapon/robot_module/proc/respawn_consumable(mob/living/silicon/robot/R)
	return

/obj/item/weapon/robot_module/proc/rebuild() // Rebuilds the list so it's possible to add/remove items from the module.
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(!isnull(O))
			modules.Add(O)

/obj/item/weapon/robot_module/proc/add_languages(mob/living/silicon/robot/R)
	R.add_language("Binary Audio Language", 0)

/*
 * Standard Module
 */
/obj/item/weapon/robot_module/standard
	name = "standard robot module"

/obj/item/weapon/robot_module/standard/New()
	. = ..()
	//modules.Add(new /obj/item/weapon/melee/baton(src))
	modules.Add(new /obj/item/weapon/melee/baton/loaded(src))
	modules.Add(new /obj/item/weapon/extinguisher(src))
	modules.Add(new /obj/item/weapon/wrench(src))
	modules.Add(new /obj/item/weapon/crowbar(src))
	modules.Add(new /obj/item/device/healthanalyzer(src))
	emag = new /obj/item/weapon/melee/energy/sword(src)

///obj/item/weapon/robot_module/standard/respawn_consumable(mob/living/silicon/robot/R)
	//var/obj/item/weapon/melee/baton/B = locate() in modules
	//if(B.charges < 10)
	//	B.charges += 1

/*
 * Medical Module
 */
/obj/item/weapon/robot_module/medical
	name = "medical robot module"

/obj/item/weapon/robot_module/medical/New()
	. = ..()
	modules.Add(new /obj/item/borg/sight/hud/med(src))
	modules.Add(new /obj/item/device/healthanalyzer(src))
	modules.Add(new /obj/item/device/reagent_scanner/adv(src))
	modules.Add(new /obj/item/weapon/reagent_containers/borghypo(src))
	modules.Add(new /obj/item/weapon/reagent_containers/glass/beaker/large(src))
	modules.Add(new /obj/item/weapon/reagent_containers/robodropper(src))
	modules.Add(new /obj/item/weapon/reagent_containers/syringe(src))
	modules.Add(new /obj/item/weapon/extinguisher/mini(src))

	emag = new /obj/item/weapon/reagent_containers/spray(src)
	emag.reagents.add_reagent("pacid", 250)
	emag.name = "Polyacid spray"

/obj/item/weapon/robot_module/medical/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/syringe/S = locate() in modules
	if(S.mode == 2)//SYRINGE_BROKEN
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(emag)
		var/obj/item/weapon/reagent_containers/spray/PS = emag
		PS.reagents.add_reagent("pacid", 2)

/*
 * Engineering Module
 */
/obj/item/weapon/robot_module/engineering
	name = "engineering robot module"

/obj/item/weapon/robot_module/engineering/New()
	. = ..()
	modules.Add(new /obj/item/borg/sight/meson(src))
	emag = new /obj/item/borg/stun(src)
	modules.Add(new /obj/item/weapon/rcd/borg(src))
	modules.Add(new /obj/item/weapon/extinguisher(src))
//	modules.Add(new /obj/item/device/flashlight(src))
	modules.Add(new /obj/item/weapon/weldingtool/largetank(src))
	modules.Add(new /obj/item/weapon/screwdriver(src))
	modules.Add(new /obj/item/weapon/wrench(src))
	modules.Add(new /obj/item/weapon/crowbar(src))
	modules.Add(new /obj/item/weapon/wirecutters(src))
	modules.Add(new /obj/item/device/multitool(src))
	modules.Add(new /obj/item/device/t_scanner(src))
	modules.Add(new /obj/item/device/analyzer(src))
	modules.Add(new /obj/item/taperoll/engineering(src))

	var/obj/item/stack/sheet/metal/cyborg/M = new /obj/item/stack/sheet/metal/cyborg(src)
	M.amount = 50
	modules.Add(M)

	var/obj/item/stack/sheet/rglass/cyborg/G = new /obj/item/stack/sheet/rglass/cyborg(src)
	G.amount = 50
	modules.Add(G)

	var/obj/item/stack/cable_coil/W = new /obj/item/stack/cable_coil(src)
	W.amount = 50
	modules.Add(W)

/obj/item/weapon/robot_module/engineering/respawn_consumable(mob/living/silicon/robot/R)
	var/list/stacks = list(
		/obj/item/stack/sheet/metal,
		/obj/item/stack/sheet/rglass,
		/obj/item/stack/cable_coil
	)
	for(var/T in stacks)
		var/O = locate(T) in modules
		if(!isnull(O))
			if(O:amount < 50)
				O:amount++
		else
			modules.Remove(null)
			O = new T(src)
			modules.Add(O)
			O:amount = 1

/*
 * Security Module
 */
/obj/item/weapon/robot_module/security
	name = "security robot module"

/obj/item/weapon/robot_module/security/New()
	. = ..()
	modules.Add(new /obj/item/borg/sight/hud/sec(src))
	modules.Add(new /obj/item/weapon/handcuffs/cyborg(src))
	//modules.Add(new /obj/item/weapon/melee/baton(src))
	modules.Add(new /obj/item/weapon/melee/baton/loaded(src))
	modules.Add(new /obj/item/weapon/gun/energy/taser/cyborg(src))
	modules.Add(new /obj/item/taperoll/police(src))
	emag = new /obj/item/weapon/gun/energy/laser/cyborg(src)

/obj/item/weapon/robot_module/security/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/device/flash/F = locate() in modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/weapon/gun/energy/taser/cyborg/T = locate() in modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost)
		T.update_icon()
	else
		T.charge_tick = 0
	//var/obj/item/weapon/melee/baton/B = locate() in modules
	//if(B.charges < 10)
	//	B.charges += 1

/*
 * Janitor Module
 */
/obj/item/weapon/robot_module/janitor
	name = "janitorial robot module"

/obj/item/weapon/robot_module/janitor/New()
	. = ..()
	modules.Add(new /obj/item/weapon/soap/nanotrasen(src))
	modules.Add(new /obj/item/weapon/storage/bag/trash(src))
	modules.Add(new /obj/item/weapon/mop(src))
	modules.Add(new /obj/item/device/lightreplacer(src))

	emag = new /obj/item/weapon/reagent_containers/spray(src)
	emag.reagents.add_reagent("lube", 250)
	emag.name = "Lube spray"

/obj/item/weapon/robot_module/janitor/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/device/lightreplacer/LR = locate() in modules
	LR.Charge(R)
	if(emag)
		var/obj/item/weapon/reagent_containers/spray/S = emag
		S.reagents.add_reagent("lube", 2)

/*
 * Service Module
 */
/obj/item/weapon/robot_module/butler
	name = "service robot module"

/obj/item/weapon/robot_module/butler/New()
	. = ..()
	modules.Add(new /obj/item/weapon/reagent_containers/food/drinks/cans/beer(src))
	modules.Add(new /obj/item/weapon/reagent_containers/food/condiment/enzyme(src))
	modules.Add(new /obj/item/weapon/pen/robopen(src))

	var/obj/item/weapon/rsf/M = new /obj/item/weapon/rsf(src)
	M.matter = 30
	modules.Add(M)

	modules.Add(new /obj/item/weapon/reagent_containers/robodropper(src))

	var/obj/item/weapon/lighter/zippo/L = new /obj/item/weapon/lighter/zippo(src)
	L.lit = 1
	modules.Add(L)

	modules.Add(new /obj/item/weapon/tray/robotray(src))
	modules.Add(new /obj/item/weapon/reagent_containers/food/drinks/shaker(src))

	emag = new /obj/item/weapon/reagent_containers/food/drinks/cans/beer(src)
	var/datum/reagents/R = new /datum/reagents(50)
	emag.reagents = R
	R.my_atom = emag
	R.add_reagent("beer2", 50)
	emag.name = "Mickey Finn's Special Brew"

/obj/item/weapon/robot_module/butler/add_languages(mob/living/silicon/robot/R)
//full set of languages
	R.add_language("Sol Common", 1)
	R.add_language("Sinta'unathi", 1)
	R.add_language("Siik'maas", 1)
	R.add_language("Siik'tajr", 0)
	R.add_language("Skrellian", 1)
	R.add_language("Rootspeak", 0)
	R.add_language("Tradeband", 1)
	R.add_language("Gutter", 1)

/obj/item/weapon/robot_module/butler/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/food/condiment/enzyme/E = locate() in modules
	E.reagents.add_reagent("enzyme", 2)
	if(emag)
		var/obj/item/weapon/reagent_containers/food/drinks/cans/beer/B = emag
		B.reagents.add_reagent("beer2", 2)

/*
 * Mining Module
 */
/obj/item/weapon/robot_module/miner
	name = "miner robot module"

/obj/item/weapon/robot_module/miner/New()
	. = ..()
	modules.Add(new /obj/item/borg/sight/meson(src))
	emag = new /obj/item/borg/stun(src)
	modules.Add(new /obj/item/weapon/storage/bag/ore(src))
	modules.Add(new /obj/item/weapon/pickaxe/borgdrill(src))
	modules.Add(new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src))
//	modules.Add(new /obj/item/weapon/shovel(src) Uneeded due to buffed drill

/*
 * Syndicate Module
 */
/obj/item/weapon/robot_module/syndicate
	name = "syndicate robot module"

/obj/item/weapon/robot_module/syndicate/New()
	modules.Add(new /obj/item/weapon/melee/energy/sword(src))
	modules.Add(new /obj/item/weapon/gun/energy/pulse_rifle/destroyer(src))
	modules.Add(new /obj/item/weapon/card/emag(src))

/*
 * Combat Module
 */
/obj/item/weapon/robot_module/combat
	name = "combat robot module"

/obj/item/weapon/robot_module/combat/New()
	modules.Add(new /obj/item/borg/sight/thermal(src))
	modules.Add(new /obj/item/weapon/gun/energy/laser/cyborg(src))
	modules.Add(new /obj/item/weapon/pickaxe/plasmacutter(src))
	modules.Add(new /obj/item/borg/combat/shield(src))
	modules.Add(new /obj/item/borg/combat/mobility(src))
	modules.Add(new /obj/item/weapon/wrench(src)) // Is a combat android really going to be stopped by a chair?
	emag = new /obj/item/weapon/gun/energy/lasercannon/cyborg(src)

/*
 * Drone Module
 */
/obj/item/weapon/robot_module/drone
	name = "drone module"

/obj/item/weapon/robot_module/drone/New()
	//TODO: Replace with shittier flashlight and work out why we can't remove the flash. ~Z
	. = ..()
	modules.Add(new /obj/item/weapon/weldingtool(src))
	modules.Add(new /obj/item/weapon/screwdriver(src))
	modules.Add(new /obj/item/weapon/wrench(src))
	modules.Add(new /obj/item/weapon/crowbar(src))
	modules.Add(new /obj/item/weapon/wirecutters(src))
	modules.Add(new /obj/item/device/multitool(src))
	modules.Add(new /obj/item/device/lightreplacer(src))
	modules.Add(new /obj/item/weapon/reagent_containers/spray/cleaner(src))
	modules.Add(new /obj/item/weapon/gripper(src))
	modules.Add(new /obj/item/weapon/matter_decompiler(src))

	emag = new /obj/item/weapon/card/emag(src)
	emag.name = "Cryptographic Sequencer"

	var/list/stacktypes = list(
		/obj/item/stack/rods = 10,
		/obj/item/stack/tile/plasteel = 10,
		/obj/item/stack/sheet/metal/cyborg = 10,
		/obj/item/stack/sheet/wood/cyborg = 1,
		/obj/item/stack/cable_coil = 30,
		/obj/item/stack/sheet/glass/cyborg = 10,
		/obj/item/stack/sheet/mineral/plastic/cyborg = 1
	)

	for(var/T in stacktypes)
		var/obj/item/stack/sheet/W = new T(src)
		W.amount = stacktypes[T]
		modules.Add(W)

/obj/item/weapon/robot_module/drone/add_languages(mob/living/silicon/robot/R)
	. = ..() //not much ROM to spare in that tiny microprocessor!

/obj/item/weapon/robot_module/drone/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/spray/cleaner/C = locate() in modules
	C.reagents.add_reagent("cleaner", 10)

	var/list/stacks = list(
		/obj/item/stack/sheet/metal,
		/obj/item/stack/cable_coil,
		/obj/item/stack/sheet/glass/cyborg,
		/obj/item/stack/rods,
		/obj/item/stack/tile/plasteel
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

	var/obj/item/device/lightreplacer/LR = locate() in modules
	LR.Charge(R)