/turf/simulated/wall/cult
	name = "wall"
	desc = "The patterns engraved on the wall seem to shift as you try to focus on them. You feel sick"
	icon = 'icons/turf/walls/cult.dmi'
	icon_state = "cult0"
	material = /decl/material/cult // Placeholder.

/turf/simulated/wall/cult/dismantle_wall(devastated = FALSE, explode = FALSE)
	if(!devastated)
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		new /obj/effect/decal/cleanable/blood(src)
		new /obj/structure/cultgirder(src)
	else
		new /obj/effect/decal/cleanable/blood(src)
		new /obj/effect/decal/remains/human(src)

	for(var/obj/O in contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	ChangeTurf(/turf/simulated/floor/plating)