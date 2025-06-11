/mob/living/simple/hostile/swarmer
	name = "swarmer"
	desc = "A robot of unknown design, they seek only to consume materials and replicate themselves indefinitely."
	icon = 'icons/mob/simple/swarmer.dmi'
	icon_state = "swarmer"

	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_SWARMER

	light_color = "#0066FF"

	hud_type = /datum/hud/swarmer
	faction = "swarmer"

	maxHealth = 40
	health = 40

	melee_damage_lower = 15
	melee_damage_upper = 15
	melee_damage_type = HALLOSS
	attacktext = "shocks"
	attack_sound = 'sound/effects/EMPulse.ogg'
	friendly = "pinches"

	icon_living = "swarmer"
	icon_dead = "swarmer_unactivated"

	harm_intent_damage = 5

	minbodytemp = 0
	maxbodytemp = 500

	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	unsuitable_atoms_damage = 0

	ranged = TRUE
	projectiletype = /obj/item/projectile/energy/pulse/disabler
	projectilesound = 'sound/weapons/gun/taser2.ogg'

	max_ranged_cooldown = 2

	// The current amount of resources we have, and the maximum amount we can hold.
	var/resources = 0
	var/max_resources = 100

	// The materials that we can use.
	var/static/list/accepted_materials = list(/decl/material/iron, /decl/material/steel, /decl/material/plastic, /decl/material/glass)

/mob/living/simple/hostile/swarmer/New()
	. = ..()
	verbs.Add(/mob/living/proc/ventcrawl, /mob/living/proc/hide)

/mob/living/simple/hostile/swarmer/Stat()
	. = ..()
	if(statpanel("Status"))
		stat("Resources:", "[resources]/[max_resources]")

/mob/living/simple/hostile/swarmer/Die()
	. = ..()
	new /obj/effect/decal/remains/robot(GET_TURF(src))
	ghostize(FALSE)
	qdel(src)

/mob/living/simple/hostile/swarmer/CanPass(atom/movable/mover)
	if(HAS_PASS_FLAGS(mover, PASS_FLAG_SWARMER))
		return TRUE
	. = ..()

/mob/living/simple/hostile/swarmer/Login()
	. = ..()
	to_chat(src, SPAN_NOTICE("<b>You are a swarmer, a weapon of a long dead civilization. Until further orders from your original masters are received, you must continue to consume and replicate.</b>"))
	to_chat(src, SPAN_NOTICE("<b>Ctrl + Click provides most of your swarmer-specific interactions, such as cannibalising materials, destroying the environment or teleporting mobs away from you.</b>"))
	to_chat(src, SPAN_INFO_B("Objectives:"))
	to_chat(src, SPAN_INFO("1. Consume resources and replicate until there are no more resources left."))
	to_chat(src, SPAN_INFO("2. Ensure that this location is fit for invasion at a later date, do not perform actions that would render it dangerous or inhospitable."))
	to_chat(src, SPAN_INFO("3. Biological resources will be harvested at a later date, do not harm them."))

/mob/living/simple/hostile/swarmer/emp_act()
	if(health > 1)
		health = 1
		. = ..()
	health = 0

/mob/living/simple/hostile/swarmer/CtrlClickOn(atom/clicked_on)
	if(next_move > world.time)
		return FALSE
	if(!clicked_on.Adjacent(src))
		return FALSE

	return clicked_on.swarmer_act(src)