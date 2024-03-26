/obj/structure/mineral_door/steel
	name = "steel door"
	icon_state = "steel"
	material = /decl/material/steel
	hardness = 3

/obj/structure/mineral_door/silver
	name = "silver door"
	icon_state = "silver"
	material = /decl/material/silver
	hardness = 3

/obj/structure/mineral_door/gold
	name = "gold door"
	icon_state = "gold"
	material = /decl/material/gold

/obj/structure/mineral_door/uranium
	name = "uranium door"
	icon_state = "uranium"
	material = /decl/material/uranium
	hardness = 3
	light_range = 2

/obj/structure/mineral_door/sandstone
	name = "sandstone door"
	icon_state = "sandstone"
	material = /decl/material/sandstone
	hardness = 0.5

/obj/structure/mineral_door/wood
	name = "wood door"
	icon_state = "wood"
	material = /decl/material/wood
	sound_path = 'sound/effects/doorcreaky.ogg'
	hardness = 1

/obj/structure/mineral_door/resin
	name = "resin door"
	icon_state = "resin"
	material = /decl/material/resin
	sound_path = 'sound/effects/attackblob.ogg'
	hardness = 1.5
	var/close_delay = 100

/obj/structure/mineral_door/resin/TryToSwitchState(atom/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/datum/organ/internal/xenos/hivenode) in M.internal_organs)
		return ..()

/obj/structure/mineral_door/resin/Open()
	. = ..()
	spawn(close_delay)
		if(!isSwitchingStates && state == 1)
			Close()

/obj/structure/mineral_door/resin/CheckHardness()
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	. = ..()