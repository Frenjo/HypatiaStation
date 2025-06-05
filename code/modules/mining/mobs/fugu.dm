/mob/living/simple/hostile/asteroid/fugu
	name = "wumborian fugu"
	desc = "The wumborian fugu rapidly increases its body mass in order to ward off its prey. Great care should be taken to avoid it while it's in this state as it is nearly invincible, but it cannot maintain its form forever."

	icon_state = "fugu"
	icon_living = "fugu"
	icon_dead = "fugu_dead"

	move_to_delay = 5
	friendly = "floats near"
	vision_range = 5
	speed = 0

	maxHealth = 50
	health = 50

	harm_intent_damage = 5
	melee_damage_lower = 0
	melee_damage_lower = 0
	attacktext = "chomps"
	attack_sound = 'sound/weapons/melee/bite.ogg'

	aggro_vision_range = 9
	idle_vision_range = 5
	icon_aggro = "fugu_big"
	throw_message = "is avoided by the"

	var/wumbo = FALSE
	var/inflate_cooldown = 0

/mob/living/simple/hostile/asteroid/fugu/Life()
	if(!wumbo)
		inflate_cooldown = max((inflate_cooldown - 1), 0)
	. = ..()

/mob/living/simple/hostile/asteroid/fugu/adjustBruteLoss(damage)
	if(wumbo)
		return
	. = ..()

/mob/living/simple/hostile/asteroid/fugu/aggro()
	. = ..()
	inflate()

/mob/living/simple/hostile/asteroid/fugu/Die()
	deflate()
	new /obj/item/fugu_gland(loc) // Drops a fugu gland on death.
	. = ..()

/mob/living/simple/hostile/asteroid/fugu/verb/inflate()
	set category = "Fugu"
	set name = "Inflate"
	set desc = "Temporarily increases our size, and makes us significantly tougher and more dangerous."

	if(wumbo)
		to_chat(src, SPAN_NOTICE("We are already inflated."))
		return
	if(inflate_cooldown)
		to_chat(src, SPAN_NOTICE("We need time to gather our strength."))
		return
	if(buffed)
		to_chat(src, SPAN_NOTICE("Something is interfering with our growth."))
		return

	icon_state = "fugu_big"

	update_transform(RESIZE_DOUBLE_SIZE)

	move_to_delay = 6
	speed = 1

	harm_intent_damage = 0
	melee_damage_lower = 15
	melee_damage_upper = 20
	throw_message = "is absorbed by the girth of the"

	wumbo = TRUE
	spawn(10 SECONDS)
		deflate()

/mob/living/simple/hostile/asteroid/fugu/proc/deflate()
	if(!wumbo)
		return

	walk(src, 0)

	icon_state = initial(icon_state)

	update_transform(RESIZE_HALF_SIZE)

	move_to_delay = initial(move_to_delay)
	speed = initial(speed)

	harm_intent_damage = initial(harm_intent_damage)
	melee_damage_lower = initial(melee_damage_lower)
	throw_message = initial(throw_message)

	wumbo = FALSE
	inflate_cooldown = 4 // This is in increments of 2 seconds (so 4 = 8 seconds total) due to the way mob/Life() ticks work.

// Fugu Gland
/obj/item/fugu_gland
	name = "wumborian fugu gland"
	desc = "The key to the wumborian fugu's ability to increase its mass arbitrarily, this disgusting remnant can apply the same effect to other creatures, giving them great strength."
	icon = 'icons/mob/simple/mining.dmi'
	icon_state = "fugu_gland"

	item_flags = ITEM_FLAG_NO_BLUDGEON

	origin_tech = alist(/decl/tech/biotech = 6)

	var/static/list/banned_mobs = list()

/obj/item/fugu_gland/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag || !issimple(target))
		return
	var/mob/living/simple/simple_target = target
	if(simple_target.buffed || (simple_target.type in banned_mobs) || simple_target.stat)
		to_chat(user, SPAN_WARNING("Something is interfering with \the [src]'s effects. It's no use."))
		return

	simple_target.update_transform(RESIZE_DOUBLE_SIZE)

	simple_target.maxHealth *= 1.5
	simple_target.health = min(simple_target.maxHealth, simple_target.health * 1.5)

	simple_target.melee_damage_lower = max((simple_target.melee_damage_lower * 2), 10)
	simple_target.melee_damage_upper = max((simple_target.melee_damage_lower * 2), 10)

	simple_target.buffed++

	to_chat(user, SPAN_INFO("You increase the size of \the [simple_target], giving it a surge of strength!"))
	qdel(src)