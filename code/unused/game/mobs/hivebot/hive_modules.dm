/obj/item/hive_module
	name = "hive robot module"
	icon = 'icons/obj/items/module.dmi'
	icon_state = "std_module"
	w_class = 2.0
	item_state = "electronic"
	flags = FPRINT|TABLEPASS | CONDUCT
	var/list/modules = list()

/obj/item/hive_module/standard
	name = "give standard robot module"

/obj/item/hive_module/engineering
	name = "HiveBot engineering robot module"

/obj/item/hive_module/New()//Shit all the mods have
	src.modules += new /obj/item/flash(src)


/obj/item/hive_module/standard/New()
	..()
	src.modules += new /obj/item/melee/baton(src)
	src.modules += new /obj/item/extinguisher(src)
	//var/obj/item/gun/mp5/M = new /obj/item/gun/mp5(src)
	//M.weapon_lock = 0
	//src.modules += M


/obj/item/hive_module/engineering/New()

	src.modules += new /obj/item/extinguisher(src)
	src.modules += new /obj/item/screwdriver(src)
	src.modules += new /obj/item/weldingtool(src)
	src.modules += new /obj/item/wrench(src)
	src.modules += new /obj/item/gas_analyser(src)
	src.modules += new /obj/item/flashlight(src)

	var/obj/item/rcd/R = new /obj/item/rcd(src)
	R.matter = 30
	src.modules += R

	src.modules += new /obj/item/t_scanner(src)
	src.modules += new /obj/item/crowbar(src)
	src.modules += new /obj/item/wirecutters(src)
	src.modules += new /obj/item/multitool(src)

	var/obj/item/stack/sheet/steel/M = new /obj/item/stack/sheet/steel(src, 50)
	src.modules += M

	var/obj/item/stack/sheet/glass/reinforced/G = new /obj/item/stack/sheet/glass/reinforced(src)
	G.amount = 50
	src.modules += G

	var/obj/item/cable_coil/W = new /obj/item/cable_coil(src)
	W.amount = 50
	src.modules += W
