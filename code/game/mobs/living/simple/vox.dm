/mob/living/simple/vox/armalis/

	name = "serpentine alien"
	real_name = "serpentine alien"
	desc = "A one-eyed, serpentine creature, half-machine, easily nine feet from tail to beak!"
	icon = 'icons/mob/vox.dmi'
	icon_state = "armalis"
	icon_living = "armalis"
	maxHealth = 500
	health = 500
	response_harm = "slashes at the"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 40
	attacktext = "slammed its enormous claws into"
	speed = -1
	wall_smash = 1
	attack_sound = 'sound/weapons/melee/bladeslice.ogg'
	status_flags = 0
	universal_speak = 1

	var/armour = null
	var/amp = null
	var/quills = 3

/mob/living/simple/vox/armalis/Die()

	living_mob_list -= src
	dead_mob_list += src
	stat = DEAD
	visible_message("\red <B>[src] shudders violently and explodes!</B>","\red <B>You feel your body rupture!</B>")
	explosion(GET_TURF(src), -1, -1, 3, 5)
	src.gib()
	return

/mob/living/simple/vox/armalis/attackby(obj/item/O, mob/user)
	if(O.force)
		if(O.force >= 25)
			var/damage = O.force
			if (O.damtype == HALLOSS)
				damage = 0
			health -= damage
			visible_message(SPAN_DANGER("[src] has been attacked with \the [O] by [user]."))
		else
			visible_message(SPAN_DANGER("\The [O] bounces harmlessly off of [src]."))
	else
		to_chat(user, SPAN_WARNING("This weapon is ineffective, it does no damage."))
		visible_message(SPAN_WARNING("[user] gently taps [src] with \the [O]."))

/mob/living/simple/vox/armalis/verb/fire_quill(mob/target as mob in oview())

	set name = "Fire quill"
	set desc = "Fires a viciously pointed quill at a high speed."
	set category = "Alien"

	if(quills<=0)
		return

	src << "\red You launch a razor-sharp quill at [target]!"
	for(var/mob/O in oviewers())
		if ((O.client && !( O.blinded )))
			O << "\red [src] launches a razor-sharp quill at [target]!"

	var/obj/item/arrow/quill/Q = new(loc)
	Q.fingerprintslast = src.ckey
	Q.throw_at(target,10,30)
	quills--

	spawn(100)
		src << "\red You feel a fresh quill slide into place."
		quills++

/mob/living/simple/vox/armalis/verb/message_mob()
	set category = "Alien"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets
	text = input("What would you like to say?", "Speak to creature", null, null)

	if (!target || !text)
		return

	var/mob/M = targets[target]

	if(isghost(M) || M.stat == DEAD)
		src << "Not even the armalis can speak to the dead."
		return

	M << "\blue Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.species, /datum/species/vox))
			return
		H << "\red Your nose begins to bleed..."
		H.drip(1)

/mob/living/simple/vox/armalis/verb/shriek()
	set category = "Alien"
	set name = "Shriek"
	set desc = "Give voice to a psychic shriek."

/mob/living/simple/vox/armalis/attackby(obj/item/O, mob/user)
	if(istype(O,/obj/item/vox/armalis_armour))
		user.drop_item()
		armour = O
		speed = 1
		maxHealth += 200
		health += 200
		O.forceMove(src)
		visible_message("\blue [src] is quickly outfitted in [O] by [user].","\blue You quickly outfit [src] in [O].")
		regenerate_icons()
		return
	if(istype(O,/obj/item/vox/armalis_amp))
		user.drop_item()
		amp = O
		O.forceMove(src)
		visible_message("\blue [src] is quickly outfitted in [O] by [user].","\blue You quickly outfit [src] in [O].")
		regenerate_icons()
		return
	return ..()

/mob/living/simple/vox/armalis/regenerate_icons()

	overlays = list()
	if(armour)
		var/icon/armour = image('icons/mob/vox.dmi',"armour")
		speed = 1
		add_overlay(armour)
	if(amp)
		var/icon/amp = image('icons/mob/vox.dmi',"amplifier")
		add_overlay(amp)
	return

/obj/item/vox/armalis_armour

	name = "strange armour"
	desc = "Hulking reinforced armour for something huge."
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_state = "armalis_armour"
	item_state = "armalis_armour"

/obj/item/vox/armalis_amp

	name = "strange lenses"
	desc = "A series of metallic lenses and chains."
	icon = 'icons/obj/items/clothing/hats.dmi'
	icon_state = "amp"
	item_state = "amp"