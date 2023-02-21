// **********************
// Other harvested materials from plants (that are not food)
// **********************

/obj/item/weapon/grown // Grown weapons
	name = "grown_weapon"
	icon = 'icons/obj/weapons.dmi'
	var/seed
	var/plantname = ""
	var/productname
	var/species = ""
	var/lifespan = 20
	var/endurance = 15
	var/maturation = 7
	var/production = 7
	var/yield = 2
	var/potency = 1
	var/plant_type = 0
	
/obj/item/weapon/grown/New()
	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src

/obj/item/weapon/grown/proc/changePotency(newValue) //-QualityVan
	potency = newValue

/*
 * Plastellium
 */
/obj/item/weapon/reagent_containers/food/snacks/grown/plastellium
	seed = /obj/item/seeds/plastiseed
	name = "clump of plastellium"
	desc = "Hmm, needs some processing"
	icon_state = "plastellium"
	filling_color = "#C4C4C4"
	
/obj/item/weapon/reagent_containers/food/snacks/grown/plastellium/initialize()
	. = ..()
	reagents.add_reagent("plasticide", 1 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Tower Cap
 */
/obj/item/weapon/grown/log
	name = "tower-cap log"
	desc = "It's better than bad, it's good!"
	icon = 'icons/obj/harvest.dmi'
	icon_state = "logs"
	force = 5
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3
	plant_type = 2
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1)
	seed = /obj/item/seeds/towermycelium
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/grown/log/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/circular_saw) || istype(W, /obj/item/weapon/hatchet) \
	|| (istype(W, /obj/item/weapon/twohanded/fireaxe) && W:wielded) \
	|| istype(W, /obj/item/weapon/melee/energy))
		user.show_message(SPAN_NOTICE("You make planks out of \the [src]!"), 1)
		for(var/i = 0, i < 2, i++)
			var/obj/item/stack/sheet/wood/NG = new(user.loc)
			for(var/obj/item/stack/sheet/wood/G in user.loc)
				if(G == NG)
					continue
				if(G.amount >= G.max_amount)
					continue
				G.attackby(NG, user)
				to_chat(usr, "You add the newly-formed wood to the stack. It now contains [NG.amount] planks.")
		qdel(src)
		return

/*
 * Kudzu
 */
/obj/item/weapon/reagent_containers/food/snacks/grown/kudzupod
	seed = /obj/item/seeds/kudzuseed
	name = "kudzu pod"
	desc = "<I>Pueraria Virallis</I>: An invasive species with vines that rapidly creep and wrap around whatever they contact."
	icon_state = "kudzupod"
	filling_color = "#59691B"
	
/obj/item/weapon/reagent_containers/food/snacks/grown/kudzupod/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 50), 1))
	reagents.add_reagent("anti_toxin", 1 + round((potency / 25), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Nettle
 */
/obj/item/weapon/grown/nettle // -- Skie
	desc = "It's probably <B>not</B> wise to touch it with bare hands..."
	icon = 'icons/obj/weapons.dmi'
	name = "nettle"
	icon_state = "nettle"
	damtype = "fire"
	force = 15
	throwforce = 1
	w_class = 1.0
	throw_speed = 1
	throw_range = 3
	plant_type = 1
	origin_tech = list(RESEARCH_TECH_COMBAT = 1)
	seed = /obj/item/seeds/nettleseed

//So potency can be set in the proc that creates these crops
/obj/item/weapon/grown/nettle/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 50), 1))
	reagents.add_reagent("sacid", round(potency, 1))
	force = round((5 + potency / 5), 1)

/obj/item/weapon/grown/nettle/pickup(mob/living/carbon/human/user as mob)
	if(!user.gloves)
		to_chat(user, SPAN_WARNING("The nettle burns your bare hand!"))
		if(ishuman(user))
			var/organ = ((user.hand ? "l_":"r_") + "arm")
			var/datum/organ/external/affecting = user.get_organ(organ)
			if(affecting.take_damage(0, force))
				user.UpdateDamageIcon()
		else
			user.take_organ_damage(0, force)

/obj/item/weapon/grown/nettle/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(force > 0)
		force -= rand(1, (force / 3) + 1) // When you whack someone with it, leaves fall off
		playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	else
		to_chat(user, "All the leaves have fallen off the nettle from violent whacking.")
		qdel(src)

/obj/item/weapon/grown/nettle/changePotency(newValue) //-QualityVan
	potency = newValue
	force = round((5 + potency / 5), 1)

/*
 * Deathnettle
 */
/obj/item/weapon/grown/deathnettle // -- Skie
	desc = "The \red glowing \black nettle incites \red<B>rage</B>\black in you just from looking at it!"
	icon = 'icons/obj/weapons.dmi'
	name = "deathnettle"
	icon_state = "deathnettle"
	damtype = "fire"
	force = 30
	throwforce = 1
	w_class = 1.0
	throw_speed = 1
	throw_range = 3
	plant_type = 1
	seed = /obj/item/seeds/deathnettleseed
	origin_tech = list(RESEARCH_TECH_COMBAT = 3)
	attack_verb = list("stung")

//So potency can be set in the proc that creates these crops
/obj/item/weapon/grown/deathnettle/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 50), 1))
	reagents.add_reagent("pacid", round(potency, 1))
	force = round((5 + potency / 2.5), 1)

/obj/item/weapon/grown/deathnettle/suicide_act(mob/user)
	to_chat(viewers(user), SPAN_DANGER("[user] is eating some of the [src.name]! It looks like \he's trying to commit suicide."))
	return (BRUTELOSS|TOXLOSS)

/obj/item/weapon/grown/deathnettle/pickup(mob/living/carbon/human/user as mob)
	if(!user.gloves)
		if(ishuman(user))
			var/organ = ((user.hand ? "l_":"r_") + "arm")
			var/datum/organ/external/affecting = user.get_organ(organ)
			if(affecting.take_damage(0, force))
				user.UpdateDamageIcon()
		else
			user.take_organ_damage(0, force)
		if(prob(50))
			user.Paralyse(5)
			to_chat(user, SPAN_WARNING("You are stunned by the Deathnettle when you try picking it up!"))

/obj/item/weapon/grown/deathnettle/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(!..())
		return
	if(isliving(M))
		to_chat(M, SPAN_WARNING("You are stunned by the powerful acid of the Deathnettle!"))

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had the [src.name] used on them by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] on [M.name] ([M.ckey])</font>")
		msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] on [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)

		M.eye_blurry += force / 7
		if(prob(20))
			M.Paralyse(force / 6)
			M.Weaken(force / 15)
		M.drop_item()

/obj/item/weapon/grown/deathnettle/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(force > 0)
		force -= rand(1, (force / 3) + 1) // When you whack someone with it, leaves fall off

	else
		to_chat(user, "All the leaves have fallen off the deathnettle from violent whacking.")
		qdel(src)

/obj/item/weapon/grown/deathnettle/changePotency(newValue) //-QualityVan
	potency = newValue
	force = round((5 + potency / 2.5), 1)

/*
 * Sugarcane
 */
// This isn't a fruit or a vegetable, so I wasn't sure where to put it.
// But I went off the idea that you don't usually just pick up sugarcane and start munching on it.
// Therefore this is the best place by that logic. -Frenjo
/obj/item/weapon/reagent_containers/food/snacks/grown/sugarcane
	seed = /obj/item/seeds/sugarcaneseed
	name = "sugarcane"
	desc = "Sickly sweet."
	icon_state = "sugarcane"
	potency = 50
	filling_color = "#C0C9AD"
	
/obj/item/weapon/reagent_containers/food/snacks/grown/sugarcane/initialize()
	. = ..()
	reagents.add_reagent("sugar", 4 + round((potency / 5), 1))

// *************************************
// Complex Grown Object Defines -
// Putting these at the bottom so they don't clutter the list up. -Cheridan
// *************************************

/*
 * "Cash" Money Tree
 */
//This object is just a transition object. All it does is make dosh and delete itself. -Cheridan
/obj/item/weapon/reagent_containers/food/snacks/grown/money
	seed = /obj/item/seeds/cashseed
	name = "dosh"
	desc = "Green and lush."
	icon_state = "spawner"
	potency = 10
	
/obj/item/weapon/reagent_containers/food/snacks/grown/money/New()
	switch(rand(1, 100))//(potency) //It wants to use the default potency instead of the new, so it was always 10. Will try to come back to this later - Cheridan
		if(0 to 10)
			new /obj/item/weapon/spacecash/(src.loc)
		if(11 to 20)
			new /obj/item/weapon/spacecash/c10(src.loc)
		if(21 to 30)
			new /obj/item/weapon/spacecash/c20(src.loc)
		if(31 to 40)
			new /obj/item/weapon/spacecash/c50(src.loc)
		if(41 to 50)
			new /obj/item/weapon/spacecash/c100(src.loc)
		if(51 to 60)
			new /obj/item/weapon/spacecash/c200(src.loc)
		if(61 to 80)
			new /obj/item/weapon/spacecash/c500(src.loc)
		else
			new /obj/item/weapon/spacecash/c1000(src.loc)

//Workaround to keep harvesting from working weirdly.
/obj/item/weapon/reagent_containers/food/snacks/grown/money/initialize()
	. = ..()
	qdel(src)

/*
 * Grass
 */
/*
//This object is just a transition object. All it does is make a grass tile and delete itself.
/obj/item/weapon/reagent_containers/food/snacks/grown/grass
	seed = /obj/item/seeds/grassseed
	name = "grass"
	desc = "Green and lush."
	icon_state = "spawner"
	potency = 20

/obj/item/weapon/reagent_containers/food/snacks/grown/grass/New()
	new/obj/item/stack/tile/grass(src.loc)

//Workaround to keep harvesting from working weirdly.
/obj/item/weapon/reagent_containers/food/snacks/grown/grass/initialize()
	..()
	qdel(src)
*/