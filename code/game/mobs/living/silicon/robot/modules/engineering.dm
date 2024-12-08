/*
 * Engineering Module
 */
/obj/item/robot_module/engineering
	name = "engineering robot module"

/obj/item/robot_module/engineering/New()
	. = ..()
	modules.Add(new /obj/item/borg/sight/meson(src))
	emag = new /obj/item/borg/stun(src)
	modules.Add(new /obj/item/rcd/borg(src))
	modules.Add(new /obj/item/extinguisher(src))
//	modules.Add(new /obj/item/flashlight(src))
	modules.Add(new /obj/item/weldingtool/largetank(src))
	modules.Add(new /obj/item/screwdriver(src))
	modules.Add(new /obj/item/wrench(src))
	modules.Add(new /obj/item/crowbar(src))
	modules.Add(new /obj/item/wirecutters(src))
	modules.Add(new /obj/item/multitool(src))
	modules.Add(new /obj/item/t_scanner(src))
	modules.Add(new /obj/item/gas_analyser(src))
	modules.Add(new /obj/item/taperoll/engineering(src))

	var/obj/item/stack/sheet/steel/cyborg/M = new /obj/item/stack/sheet/steel/cyborg(src)
	M.amount = 50
	modules.Add(M)

	var/obj/item/stack/sheet/glass/reinforced/cyborg/G = new /obj/item/stack/sheet/glass/reinforced/cyborg(src)
	G.amount = 50
	modules.Add(G)

	var/obj/item/stack/cable_coil/W = new /obj/item/stack/cable_coil(src)
	W.amount = 50
	modules.Add(W)

/obj/item/robot_module/engineering/respawn_consumable(mob/living/silicon/robot/R)
	var/list/stacks = list(
		/obj/item/stack/sheet/steel,
		/obj/item/stack/sheet/glass/reinforced,
		/obj/item/stack/cable_coil
	)
	for(var/T in stacks)
		var/O = locate(T) in modules
		if(isnotnull(O))
			if(O:amount < 50)
				O:amount++
		else
			modules.Remove(null)
			O = new T(src)
			modules.Add(O)
			O:amount = 1