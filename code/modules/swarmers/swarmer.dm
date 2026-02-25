/mob/living/simple/hostile/swarmer
	name = "swarmer"
	desc = "A robot of unknown design, they seek only to consume materials and replicate themselves indefinitely."
	icon = 'icons/mob/simple/swarmer.dmi'
	icon_state = "standard"

	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_SWARMER

	light_color = "#0066FF"

	hud_type = /datum/hud/swarmer
	factions = list("swarmer")

	maxHealth = 40
	health = 40

	melee_damage_lower = 15
	melee_damage_upper = 15
	melee_damage_type = HALLOSS
	attacktext = "shocks"
	attack_sound = 'sound/effects/EMPulse.ogg'
	friendly = "pinches"

	icon_living = "standard"
	icon_dead = "unactivated"

	harm_intent_damage = 5

	minbodytemp = 0
	maxbodytemp = 500

	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	unsuitable_atoms_damage = 0

	ranged = TRUE
	projectiletype = /obj/projectile/energy/pulse/disabler
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
	var/turf/T = GET_TURF(src)
	new /obj/effect/decal/remains/robot(T)
	new /obj/item/bluespace_crystal/artificial(T) // Need to ask Ergovisavi whether this should be regular or artificial.
	ghostize(FALSE)
	qdel(src)

/mob/living/simple/hostile/swarmer/CanPass(atom/movable/mover)
	if(HAS_PASS_FLAGS(mover, PASS_FLAG_SWARMER))
		return TRUE
	. = ..()

/mob/living/simple/hostile/swarmer/Login()
	. = ..()
	var/list/output = list()
	output += SPAN_NOTICE("<b>You are a swarmer, a weapon of a long dead civilization. Until further orders from your original masters are received, you must continue to consume and replicate.</b>")
	output += SPAN_NOTICE("<b>Ctrl + Click provides most of your swarmer-specific interactions, such as cannibalising materials, destroying the environment or teleporting mobs away from you.</b>")
	output += SPAN_INFO_B("Objectives:")
	output += SPAN_INFO("1. Consume resources and replicate until there are no more resources left.")
	output += SPAN_INFO("2. Ensure that this location is fit for invasion at a later date, do not perform actions that would render it dangerous or inhospitable.")
	output += SPAN_INFO("3. Biological resources will be harvested at a later date, do not harm them.")
	to_chat(src, jointext(output, "<br>"))

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

// Ranged (laser) variant
/mob/living/simple/hostile/swarmer/ranged
	icon_state = "ranged"

	icon_living = "ranged"

	projectiletype = /obj/projectile/energy/pulse/laser
	projectilesound = 'sound/weapons/gun/laser.ogg'

	max_ranged_cooldown = 3

// Melee (stunner) variant
/mob/living/simple/hostile/swarmer/melee
	icon_state = "melee"

	maxHealth = 60
	health = 60

	melee_damage_lower = 25
	melee_damage_upper = 25

	icon_living = "melee"

	ranged = FALSE