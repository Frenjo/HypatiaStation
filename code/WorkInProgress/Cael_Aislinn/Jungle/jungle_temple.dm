//randomly generated temples, indiana jones style (minus the cultists, probably)

/area/jungle/temple_one
	name = "temple"
	dynamic_lighting = 1
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "temple1"

/area/jungle/temple_two
	name = "temple"
	dynamic_lighting = 1
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "temple2"

/area/jungle/temple_three
	name = "temple"
	dynamic_lighting = 1
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "temple3"

/area/jungle/temple_four
	name = "temple"
	dynamic_lighting = 1
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "temple4"

/area/jungle/temple_five
	name = "temple"
	dynamic_lighting = 1
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "temple5"

/area/jungle/temple_six
	name = "temple"
	dynamic_lighting = 1
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "temple6"

/obj/effect/landmark/door_spawner
	name = "door spawner"

//******//
// Loot //
//******//

/obj/effect/landmark/glowshroom_spawn
	icon_state = "x3"
	invisibility = INVISIBILITY_MAXIMUM

/obj/effect/landmark/glowshroom_spawn/New()
	if(prob(10))
		new /obj/effect/glowshroom(src.loc)
	qdel(src)

/obj/effect/landmark/loot_spawn
	name = "loot spawner"
	icon_state = "grabbed1"
	var/low_probability = 0

/obj/effect/landmark/loot_spawn/New()
	switch(pick( \
	low_probability * 1000;"nothing", \
	200 - low_probability * 175;"treasure", \
	25 + low_probability * 75;"remains", \
	25 + low_probability * 75;"plants", \
	5; "blob", \
	50 + low_probability * 50;"clothes", \
	"glasses", \
	100 - low_probability * 50;"weapons", \
	100 - low_probability * 50;"spacesuit", \
	"health", \
	25 + low_probability * 75;"snacks", \
	25;"alien", \
	"lights", \
	25 - low_probability * 25;"engineering", \
	25 - low_probability * 25;"coffin", \
	25;"mimic", \
	25;"viscerator", \
	))
		if("treasure")
			var/obj/structure/closet/crate/C = new(src.loc)
			if(prob(33))
				//coins

				var/amount = rand(2, 6)
				var/list/possible_spawns = list()
				for(var/coin_type in typesof(/obj/item/coin))
					possible_spawns += coin_type

				//no icon_state for mythril coins
				possible_spawns -= /obj/item/coin/mythril

				var/coin_type = pick(possible_spawns)
				for(var/i = 0, i < amount, i++)
					new coin_type(C)
			else if(prob(50))
				//bars

				var/amount = rand(2, 6)
				var/quantity = rand(10, 50)
				var/list/possible_spawns = list(
					/obj/item/stack/sheet/sandstone,
					/obj/item/stack/sheet/gold,
					/obj/item/stack/sheet/silver,
					/obj/item/stack/sheet/diamond,
					/obj/item/stack/sheet/plasma,
					/obj/item/stack/sheet/uranium,
					/obj/item/stack/sheet/bananium,
					/obj/item/stack/sheet/adamantine,
					/obj/item/stack/sheet/mythril
				)
				var/bar_type = pick(possible_spawns)
				for(var/i = 0, i < amount, i++)
					var/obj/item/stack/sheet/M = new bar_type(C)
					M.amount = quantity
			else
				//credits

				var/amount = rand(2, 6)
				var/list/possible_spawns = list(
					/obj/item/stack/sheet/gold,
					/obj/item/stack/sheet/silver,
					/obj/item/stack/sheet/diamond,
					/obj/item/stack/sheet/plasma,
					/obj/item/stack/sheet/uranium,
					/obj/item/stack/sheet/bananium,
					/obj/item/stack/sheet/adamantine,
					/obj/item/stack/sheet/mythril
				)

				var/cash_type = pick(possible_spawns)
				for(var/i = 0,i < amount, i++)
					new cash_type(C)
		if("remains")
			if(prob(50))
				new /obj/effect/decal/remains/human(src.loc)
			else
				new /obj/effect/decal/remains/xeno(src.loc)
		if("plants")
			if(prob(25))
				new /obj/effect/glowshroom(src.loc)
			else if(prob(33))
				new /obj/item/reagent_holder/food/snacks/grown/mushroom/libertycap(src.loc)
			else if(prob(50))
				new /obj/item/reagent_holder/food/snacks/grown/ambrosiavulgaris(src.loc)
		if("blob")
			new /obj/effect/blob/core(src.loc)
		if("clothes")
			var/obj/structure/closet/C = new(src.loc)
			C.icon_state = "blue"
			C.icon_closed = "blue"
			if(prob(33))
				new /obj/item/clothing/under/rainbow(C)
				new /obj/item/clothing/shoes/rainbow(C)
				new /obj/item/clothing/head/soft/rainbow(C)
				new /obj/item/clothing/gloves/rainbow(C)
			else if(prob(50))
				new /obj/item/clothing/under/psyche(C)
			else
				new /obj/item/clothing/under/syndicate/combat(C)
				new /obj/item/clothing/shoes/swat(C)
				new /obj/item/clothing/gloves/swat(C)
				new /obj/item/clothing/mask/balaclava(C)
		if("glasses")
			var/obj/structure/closet/C = new(src.loc)
			var/new_type = pick(
			/obj/item/clothing/glasses/material, \
			/obj/item/clothing/glasses/thermal, \
			/obj/item/clothing/glasses/meson, \
			/obj/item/clothing/glasses/night, \
			/obj/item/clothing/glasses/hud/health, \
			/obj/item/clothing/glasses/hud/health \
			)
			new new_type(C)
		if("weapons")
			var/obj/structure/closet/crate/secure/weapon/C = new(src.loc)
			var/new_type = pick(
			200; /obj/item/hatchet, \
			/obj/item/gun/projectile/pistol, \
			/obj/item/gun/projectile/deagle, \
			/obj/item/gun/projectile/russian, \
			)
			new new_type(C)
		if("spacesuit")
			var/obj/structure/closet/syndicate/C = new(src.loc)
			if(prob(25))
				new /obj/item/clothing/suit/space/syndicate/black(C)
				new /obj/item/clothing/head/helmet/space/syndicate/black(C)
				new /obj/item/tank/oxygen/red(C)
				new /obj/item/clothing/mask/breath(C)
			else if(prob(33))
				new /obj/item/clothing/suit/space/syndicate/blue(C)
				new /obj/item/clothing/head/helmet/space/syndicate/blue(C)
				new /obj/item/tank/oxygen/red(C)
				new /obj/item/clothing/mask/breath(C)
			else if(prob(50))
				new /obj/item/clothing/suit/space/syndicate/green(C)
				new /obj/item/clothing/head/helmet/space/syndicate/green(C)
				new /obj/item/tank/oxygen/red(C)
				new /obj/item/clothing/mask/breath(C)
			else
				new /obj/item/clothing/suit/space/syndicate/orange(C)
				new /obj/item/clothing/head/helmet/space/syndicate/orange(C)
				new /obj/item/tank/oxygen/red(C)
				new /obj/item/clothing/mask/breath(C)
		if("health")
			//hopefully won't be necessary, but there were an awful lot of traps to get through...
			var/obj/structure/closet/crate/medical/C = new(src.loc)
			if(prob(50))
				new /obj/item/storage/firstaid/regular(C)
			if(prob(50))
				new /obj/item/storage/firstaid/fire(C)
			if(prob(50))
				new /obj/item/storage/firstaid/o2(C)
			if(prob(50))
				new /obj/item/storage/firstaid/toxin(C)
		if("snacks")
			//you're come so far, you must be in need of refreshment
			var/obj/structure/closet/crate/freezer/C = new(src.loc)
			var/num = rand(2, 6)
			var/new_type = pick(
			/obj/item/reagent_holder/food/drinks/cans/beer, \
			/obj/item/reagent_holder/food/drinks/tea, \
			/obj/item/reagent_holder/food/drinks/dry_ramen, \
			/obj/item/reagent_holder/food/snacks/candiedapple, \
			/obj/item/reagent_holder/food/snacks/chocolatebar, \
			/obj/item/reagent_holder/food/snacks/cookie, \
			/obj/item/reagent_holder/food/snacks/meatball, \
			/obj/item/reagent_holder/food/snacks/plump_pie, \
			)
			for(var/i = 0, i < num, i++)
				new new_type(C)
		if("alien")
			//ancient aliens
			var/obj/structure/closet/acloset/C = new(src.loc)
			if(prob(33))
				//facehuggers
				var/num = rand(1,3)
				for(var/i = 0, i < num, i++)
					new /obj/item/clothing/mask/facehugger(C)
			/*else if(prob(50))
				//something else very much alive and angry
				var/spawn_type = pick(/mob/living/simple/hostile/alien, /mob/living/simple/hostile/alien/drone, /mob/living/simple/hostile/alien/sentinel)
				new spawn_type(C)*/

			//33% chance of nothing

		if("lights")
			//flares, candles, matches
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc)
			var/num = rand(2, 6)
			for(var/i = 0, i < num, i++)
				var/spawn_type = pick(/obj/item/flashlight/flare, /obj/item/trash/candle, /obj/item/candle/, /obj/item/storage/box/matches)
				new spawn_type(C)
		if("engineering")
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc)

			//chance to have any combination of up to two electrical/mechanical toolboxes and one cell
			if(prob(33))
				new /obj/item/storage/toolbox/electrical(C)
			else if(prob(50))
				new /obj/item/storage/toolbox/mechanical(C)

			if(prob(33))
				new /obj/item/storage/toolbox/mechanical(C)
			else if(prob(50))
				new /obj/item/storage/toolbox/electrical(C)

			if(prob(25))
				new /obj/item/cell(C)

		if("coffin")
			new /obj/structure/closet/coffin(src.loc)
			if(prob(33))
				new /obj/effect/decal/remains/human(src)
			else if(prob(50))
				new /obj/effect/decal/remains/xeno(src)
		/*if("mimic")
			//a guardian of the tomb!
			new /mob/living/simple/hostile/mimic/crate(src.loc)*/
		if("viscerator")
			//more tomb guardians!
			var/num = rand(1, 3)
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc)
			for(var/i = 0, i < num, i++)
				new /mob/living/simple/hostile/viscerator(C)

	qdel(src)

/obj/effect/landmark/loot_spawn/low
	name = "low prob loot spawner"
	icon_state = "grabbed"
	low_probability = 1

//********//
// Traps! //
//********//

/obj/effect/step_trigger/trap
	name = "trap"
	icon = 'code/workinprogress/cael_aislinn/jungle/jungle.dmi'
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "trap"
	var/trap_type

/obj/effect/step_trigger/trap/New()
	trap_type = pick(50;"thrower", "sawburst", "poison_dart", "flame_burst", 10;"plasma_gas", 5;"n2_gas")
	if((trap_type == "plasma_gas" || trap_type == "n2_gas") && prob(10))
		new /obj/effect/glowshroom(src.loc)

	//hint that this tile is dangerous
	if(prob(90))
		var/turf/T = GET_TURF(src)
		T.desc = pick("There is a faint sheen of moisture over the top.", "It looks a little unstable.", "Something doesn't seem right.")

/obj/effect/step_trigger/trap/Trigger(atom/A)
	var/mob/living/M = A
	if(!istype(M))
		return

	switch(trap_type)
		if("sawburst")
			to_chat(M, SPAN_DANGER("A sawblade shoots out of the ground and strikes you!"))
			M.apply_damage(rand(5, 10), BRUTE, sharp = 1, edge = 1)

			var/atom/myloc = src.loc
			var/image/flicker = image('code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi', "sawblade")
			myloc.add_overlay(flicker)
			spawn(8)
				myloc.remove_overlay(flicker)
				qdel(flicker)
			//flick("sawblade",src)
		if("poison_dart")
			to_chat(M, SPAN_DANGER("You feel something small and sharp strike you!"))
			M.apply_damage(rand(5, 10), TOX)

			var/atom/myloc = src.loc
			var/image/flicker = image('code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi', "dart[rand(1,3)]")
			myloc.add_overlay(flicker)
			spawn(8)
				myloc.remove_overlay(flicker)
				qdel(flicker)
			//flick("dart[rand(1,3)]",src)
		if("flame_burst")
			to_chat(M, SPAN_DANGER("A jet of fire comes out of nowhere!"))
			M.apply_damage(rand(5, 10), BURN)

			var/atom/myloc = src.loc
			var/image/flicker = image('code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi', "flameburst")
			myloc.add_overlay(flicker)
			spawn(8)
				myloc.remove_overlay(flicker)
				qdel(flicker)
			//flick("flameburst",src)
		if("plasma_gas")
			//spawn a bunch of plasma
		if("n2_gas")
			//spawn a bunch of sleeping gas
		if("thrower")
			//edited version of obj/effect/step_trigger/thrower
			var/throw_dir = pick(1, 2, 4, 8)
			M.visible_message(SPAN_DANGER("The floor under [M] suddenly tips upward!"), SPAN_DANGER("The floor tips upward under you!"))

			var/atom/myloc = src.loc
			var/image/flicker = image('code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi', "throw[throw_dir]")
			myloc.add_overlay(flicker)
			var/turf/my_turf = GET_TURF(src)
			if(!my_turf.density)
				my_turf.density = TRUE
				spawn(8)
					my_turf.density = FALSE
			spawn(8)
				myloc.remove_overlay(flicker)
				qdel(flicker)

			var/dist = rand(1, 5)
			var/curtiles = 0
			while(M)
				if(curtiles >= dist)
					break
				if(M.z != src.z)
					break

				curtiles++
				sleep(1)

				var/predir = M.dir
				step(M, throw_dir)
				M.set_dir(predir)

//gives turf a different description, to try and trick players
/obj/effect/step_trigger/trap/fake
	icon_state = "faketrap"
	name = "fake trap"

/obj/effect/step_trigger/trap/fake/New()
	if(prob(10))
		new /obj/effect/glowshroom(src.loc)
	if(prob(90))
		var/turf/T = GET_TURF(src)
		T.desc = pick("It looks a little dustier than the surrounding tiles.", "It is somewhat ornate.", "It looks a little darker than the surrounding tiles.")
	qdel(src)

//50% chance of being a trap
/obj/effect/step_trigger/trap/fifty
	icon_state = "trap"
	name = "fifty fifty trap"
	icon_state = "fiftytrap"

/obj/effect/step_trigger/trap/fifty/New()
	if(prob(50))
		..()
	else
		if(prob(10))
			new /obj/effect/glowshroom(src.loc)
		qdel(src)
