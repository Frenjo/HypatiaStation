// Ported from Haine and WrongEnd with much gratitude!
/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=WHAT-EVER=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */
/obj/effect/window_spawner
	name = "window grille spawner"
	icon = 'icons/obj/effects/window_spawner.dmi'
	icon_state = "wingrille"
	density = TRUE
	anchored = TRUE
	pressure_resistance = 4 * ONE_ATMOSPHERE

	var/win_path = /obj/structure/window/basic
	var/activated = FALSE

// Stops ZAS expanding zones past us, the windows will block the zone anyway.
/obj/effect/window_spawner/CanPass()
	return FALSE

/obj/effect/window_spawner/initialise()
	. = ..()
	if(global.PCticker?.current_state < GAME_STATE_PLAYING)
		activate()

/obj/effect/window_spawner/proc/activate()
	if(activated)
		return

	if(!locate(/obj/structure/grille) in get_turf(src))
		var/obj/structure/grille/G = new /obj/structure/grille(loc)
		handle_grille_spawn(G)

	var/list/neighbours = list()
	for(var/dir in GLOBL.cardinal)
		var/turf/T = get_step(src, dir)
		var/obj/effect/window_spawner/other = locate(/obj/effect/window_spawner) in T
		if(isnull(other))
			var/found_connection = FALSE
			if(locate(/obj/structure/grille) in T)
				for(var/obj/structure/window/W in T)
					if(W.type == win_path && W.dir == get_dir(T, src))
						found_connection = TRUE
						qdel(W)
			if(!found_connection)
				var/obj/structure/window/new_win = new win_path(loc)
				new_win.set_dir(dir)
				handle_window_spawn(new_win)
		else
			neighbours |= other

	activated = TRUE

	for(var/obj/effect/window_spawner/other in neighbours)
		if(!other.activated)
			other.activate()
	qdel(src)

/obj/effect/window_spawner/proc/handle_window_spawn(obj/structure/window/W)
	return

// Currently unused, could be useful for pre-wired electrified windows.
/obj/effect/window_spawner/proc/handle_grille_spawn(obj/structure/grille/G)
	return

/obj/effect/window_spawner/reinforced
	name = "reinforced window grille spawner"
	icon_state = "r-wingrille"
	win_path = /obj/structure/window/reinforced

/obj/effect/window_spawner/plasma
	name = "plasma window grille spawner"
	icon_state = "p-wingrille"
	win_path = /obj/structure/window/plasmabasic

/obj/effect/window_spawner/reinforced_plasma
	name = "reinforced plasma window grille spawner"
	icon_state = "pr-wingrille"
	win_path = /obj/structure/window/plasmareinforced