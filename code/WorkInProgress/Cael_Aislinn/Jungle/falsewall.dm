//simplified copy of /obj/structure/falsewall

/obj/effect/landmark/falsewall_spawner
	name = "falsewall spawner"

/obj/structure/temple_falsewall
	name = "wall"
	anchored = TRUE
	icon = 'icons/turf/walls.dmi'
	icon_state = "plasma0"
	opacity = TRUE
	var/closed_wall_dir = 0
	var/opening = 0
	var/mineral = /decl/material/plasma
	var/is_metal = 0

/obj/structure/temple_falsewall/New()
	..()
	spawn(10)
		if(prob(95))
			desc = pick("Something seems slightly off about it.","")

		var/junction = 0 //will be used to determine from which side the wall is connected to other walls

		for(var/turf/simulated/wall/reinforced/riveted/W in orange(src,1))
			if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
				junction |= get_dir(src,W)

		closed_wall_dir = junction
		density = TRUE
		icon_state = "[mineral][closed_wall_dir]"

/obj/structure/temple_falsewall/attack_hand(mob/user as mob)
	if(opening)
		return

	if(density)
		opening = 1
		if(is_metal)
			icon_state = "metalfwall_open"
			flick("metalfwall_opening", src)
		else
			icon_state = "[mineral]fwall_open"
			flick("[mineral]fwall_opening", src)
		sleep(15)
		src.density = FALSE
		//SetOpacity(0)
		set_opacity(0)
		opening = 0
	else
		opening = 1
		icon_state = "[mineral][closed_wall_dir]"
		if(is_metal)
			flick("metalfwall_closing", src)
		else
			flick("[mineral]fwall_closing", src)
		density = TRUE
		sleep(15)
		//SetOpacity(1)
		set_opacity(1)
		opening = 0
