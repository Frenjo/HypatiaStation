/mob/living/simple/hostile/asteroid/gutlunch
	name = "gutlunch"
	desc = "A scavenger that eats raw meat and ores, often kept as pets by miners. Produces a thick, nutritious milk."
	gender = NEUTER
	icon_state = "gutlunch"

	a_intent = "help"
	faction = "neutral" // TODO: Make this into a list and have it be list("neutral", "mining")

	friendly = "pinches"

	icon_living = "gutlunch"
	icon_dead = "gutlunch"

	speak_emote = list("warbles", "quavers")
	speak_chance = 1
	emote_hear = list("trills.")
	emote_see = list("sniffs.", "burps.")

	turns_per_move = 8

	meat_type = /obj/item/reagent_holder/food/snacks/meat
	meat_amount = 2

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "squishes the"

	stop_automated_movement = FALSE
	stop_automated_movement_when_pulled = TRUE

	move_to_delay = 15
	break_stuff_probability = 0
	destroy_surroundings = FALSE

	var/obj/item/udder/gutlunch/nutrient_sac = null
	var/mutable_appearance/full_udder = null

/mob/living/simple/hostile/asteroid/gutlunch/New()
	. = ..()
	nutrient_sac = new /obj/item/udder/gutlunch(src)
	full_udder = new /mutable_appearance()
	full_udder.icon = icon
	full_udder.icon_state = "gutlunch_full"
	full_udder.color = COLOR_WHITE

/mob/living/simple/hostile/asteroid/gutlunch/Destroy()
	QDEL_NULL(nutrient_sac)
	return ..()

/mob/living/simple/hostile/asteroid/gutlunch/Die()
	visible_message("<b>\The [src]</b> is pulped into bugmash.")
	. = ..()
	qdel(src)

/mob/living/simple/hostile/asteroid/gutlunch/regenerate_icons()
	overlays.Cut()
	if(nutrient_sac.reagents.total_volume == nutrient_sac.reagents.maximum_volume)
		if(full_udder.color == COLOR_WHITE)
			full_udder.color = color
		overlays.Add(full_udder)
	. = ..()

/mob/living/simple/hostile/asteroid/gutlunch/Life()
	. = ..()
	if(stat == CONSCIOUS)
		nutrient_sac.generate_milk()

/mob/living/simple/hostile/asteroid/gutlunch/attack_by(obj/item/I, mob/user)
	if(stat == CONSCIOUS && istype(I, /obj/item/reagent_holder/glass))
		nutrient_sac.milk_animal(I, user)
		return TRUE
	return ..()

// Male gutlunch (gubbuck), they're smaller and are coloured shades of pink.
/mob/living/simple/hostile/asteroid/gutlunch/gubbuck
	name = "gubbuck"
	gender = MALE

/mob/living/simple/hostile/asteroid/gutlunch/gubbuck/New()
	. = ..()
	color = pick("#E39FBB", "#D97D64", "#CF8C4A")
	update_transform(0.85)

// Lady gutlunch (guthen), they make the babby and are coloured shades of blue.
/mob/living/simple/hostile/asteroid/gutlunch/guthen
	name = "guthen"
	gender = FEMALE

/mob/living/simple/hostile/asteroid/gutlunch/guthen/New()
	. = ..()
	color = pick("#6d77ff","#8578e4","#97b6f6")

// Gutlunch nutrient sac
/obj/item/udder/gutlunch
	name = "gutlunch nutrient sac"

/obj/item/udder/gutlunch/generate_milk()
	if(prob(60))
		reagents.add_reagent("cream", rand(2, 5))
	if(prob(45))
		reagents.add_reagent("nutriment", rand(2, 5))
	owner.regenerate_icons()

/obj/item/udder/gutlunch/milk_animal(obj/item/I, mob/user)
	. = ..()
	owner.regenerate_icons()