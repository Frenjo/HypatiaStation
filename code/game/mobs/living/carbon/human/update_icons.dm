/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
	TODO: Proper documentation
	icon_key is [species.race_key][g][husk][fat][hulk][skeleton][s_tone]
*/
GLOBAL_BYOND_LIST_NEW(human_icon_cache)

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/*
Calling this  a system is perhaps a bit trumped up. It is essentially update_clothing dismantled into its
core parts. The key difference is that when we generate overlays we do not generate either lying or standing
versions. Instead, we generate both and store them in two fixed-length lists, both using the same list-index
(The indexes are in update_icons.dm): Each list for humans is (at the time of writing) of length 19.
This will hopefully be reduced as the system is refined.

	var/overlays_standing[19]		//For the standing stance

When we call update_icons, the 'lying' variable is checked and then the appropriate list is assigned to our overlays!
That in itself uses a tiny bit more memory (no more than all the ridiculous lists the game has already mind you).

On the other-hand, it should be very CPU cheap in comparison to the old system.
In the old system, we updated all our overlays every life() call, even if we were standing still inside a crate!
or dead!. 25ish overlays, all generated from scratch every second for every xeno/human/monkey and then applied.
More often than not update_clothing was being called a few times in addition to that! CPU was not the only issue,
all those icons had to be sent to every client. So really the cost was extremely cumulative. To the point where
update_clothing would frequently appear in the top 10 most CPU intensive procs during profiling.

Another feature of this new system is that our lists are indexed. This means we can update specific overlays!
So we only regenerate icons when we need them to be updated! This is the main saving for this system.

In practice this means that:
	everytime you fall over, we just switch between precompiled lists. Which is fast and cheap.
	Everytime you do something minor like take a pen out of your pocket, we only update the in-hand overlay
	etc...


There are several things that need to be remembered:

>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src) )
	You will need to call the relevant update_inv_* proc:
		update_inv_head()
		update_inv_wear_suit()
		update_inv_gloves()
		update_inv_shoes()
		update_inv_wear_uniform()
		update_inv_glasse()
		update_inv_l_hand()
		update_inv_r_hand()
		update_inv_belt()
		update_inv_id_store()
		update_inv_ears()
		update_inv_suit_store()
		update_inv_pockets()
		update_inv_back()
		update_inv_handcuffed()
		update_inv_wear_mask()

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_id_store() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.


>	There are also these special cases:
		update_mutations()	//handles updating your appearance for certain mutations.  e.g TK head-glows
		update_mutantrace()	//handles updating your appearance after setting the mutantrace var
		UpdateDamageIcon()	//handles damage overlays for brute/burn damage //(will rename this when I geta round to it)
		update_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
		update_hair()	//Handles updating your hair overlay (used to be update_face, but mouth and
																			...eyes were merged into update_body)
		update_targeted() // Updates the target overlay when someone points a gun at you

>	All of these procs update our overlays_lying and overlays_standing, and then call update_icons() by default.
	If you wish to update several overlays at once, you can set the argument to 0 to disable the update and call
	it manually:
		e.g.
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand()		//<---calls update_icons()

	or equivillantly:
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand(0)
		update_icons()

>	If you need to update all overlays you can use regenerate_icons(). it works exactly like update_clothing used to.

>	I reimplimented an old unused variable which was in the code called (coincidentally) var/update_icon
	It can be used as another method of triggering regenerate_icons(). It's basically a flag that when set to non-zero
	will call regenerate_icons() at the next life() call and then reset itself to 0.
	The idea behind it is icons are regenerated only once, even if multiple events requested it.

This system is confusing and is still a WIP. It's primary goal is speeding up the controls of the game whilst
reducing processing costs. So please bear with me while I iron out the kinks. It will be worth it, I promise.
If I can eventually free var/lying stuff from the life() process altogether, stuns/death/status stuff
will become less affected by lag-spikes and will be instantaneous! :3

If you have any questions/constructive-comments/bugs-to-report/or have a massivly devestated butt...
Please contact me on #coderbus IRC. ~Carn x
*/

//Human Overlays Indexes/////////
#define MUTANTRACE_LAYER		1		//TODO: make part of body?
#define MUTATIONS_LAYER			2
#define DAMAGE_LAYER			3
#define UNIFORM_LAYER			4
#define ID_LAYER				5
#define SHOES_LAYER				6
#define GLOVES_LAYER			7
#define EARS_LAYER				8
#define SUIT_LAYER				9
#define TAIL_LAYER				10		//bs12 specific. this hack is probably gonna come back to haunt me
#define GLASSES_LAYER			11
#define BELT_LAYER				12		//Possible make this an overlay of somethign required to wear a belt?
#define SUIT_STORE_LAYER		13
#define BACK_LAYER				14
#define HAIR_LAYER				15		//TODO: make part of head layer?
#define FACEMASK_LAYER			16
#define HEAD_LAYER				17
#define COLLAR_LAYER			18
#define HANDCUFF_LAYER			19
#define LEGCUFF_LAYER			20
#define L_HAND_LAYER			21
#define R_HAND_LAYER			22
#define FIRE_LAYER				23
#define TARGETED_LAYER			24		//BS12: Layer for the target overlay from weapon targeting system
#define TOTAL_LAYERS			24
//////////////////////////////////

/mob/living/carbon/human
	var/list/overlays_standing[TOTAL_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed
	var/icon/race_icon
	var/icon/deform_icon

//UPDATES OVERLAYS FROM OVERLAYS_LYING/OVERLAYS_STANDING
//this proc is messy as I was forced to include some old laggy cloaking code to it so that I don't break cloakers
//I'll work on removing that stuff by rewriting some of the cloaking stuff at a later date.
/mob/living/carbon/human/update_icons()
	lying_prev = lying	//so we don't update overlays for lying/standing unless our stance changes again
	update_hud()		//TODO: remove the need for this
	cut_overlays()

	//cloaking devices. //TODO: get rid of this :<
	for(var/obj/item/cloaking_device/S in list(l_hand, r_hand, belt, l_pocket, r_pocket))
		if(S.active)
			stealth = 1
			break
	if(stealth)
		icon = 'icons/mob/human.dmi'
		icon_state = "body_cloaked"
		var/image/I = overlays_standing[L_HAND_LAYER]
		if(istype(I))
			add_overlay(I)
		I = overlays_standing[R_HAND_LAYER]
		if(istype(I))
			add_overlay(I)
	else if(icon_update)
		icon = stand_icon
		for(var/image/I in overlays_standing)
			add_overlay(I)

	if(lying)
		var/matrix/M = matrix()
		M.Turn(90)
		M.Scale(size_multiplier)
		M.Translate(1, -6)
		src.transform = M
	else
		var/matrix/M = matrix()
		M.Scale(size_multiplier)
		M.Translate(0, 16 * (size_multiplier - 1))
		src.transform = M

GLOBAL_BYOND_LIST_NEW(damage_icon_parts)
/proc/get_damage_icon_part(damage_state, body_part)
	if(global.damage_icon_parts["[damage_state]/[body_part]"] == null)
		var/icon/DI = new /icon('icons/mob/dam_human.dmi', damage_state)			// the damage icon for whole human
		DI.Blend(new /icon('icons/mob/dam_mask.dmi', body_part), ICON_MULTIPLY)		// mask with this organ's pixels
		global.damage_icon_parts["[damage_state]/[body_part]"] = DI
		return DI
	else
		return global.damage_icon_parts["[damage_state]/[body_part]"]

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/UpdateDamageIcon(update_icons = 1)
	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	for(var/datum/organ/external/O in organs)
		if(O.status & ORGAN_DESTROYED)
			damage_appearance += "d"
		else
			damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	previous_damage_appearance = damage_appearance

	var/icon/standing = new /icon('icons/mob/dam_human.dmi', "00")

	var/image/standing_image = new /image("icon" = standing)

	// blend the individual damage states with our icons
	for(var/datum/organ/external/O in organs)
		if(!(O.status & ORGAN_DESTROYED))
			O.update_icon()
			if(O.damage_state == "00")
				continue

			var/icon/DI = get_damage_icon_part(O.damage_state, O.icon_name)

			standing_image.add_overlay(DI)

	overlays_standing[DAMAGE_LAYER]	= standing_image

	if(update_icons)
		update_icons()

//BASE MOB SPRITE
/mob/living/carbon/human/proc/update_body(update_icons = 1)
	if(stand_icon)
		qdel(stand_icon)

	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)
	var/necrosis_color_mod = rgb(10,50,0)

	var/husk = (MUTATION_HUSK in src.mutations)
	var/fat = (MUTATION_FAT in src.mutations)
	var/hulk = (MUTATION_HULK in src.mutations)
	var/skeleton = (MUTATION_SKELETON in src.mutations)

	var/g = (gender == FEMALE ? "f" : "m")
	var/has_head = 0

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	if(stand_icon)
		qdel(stand_icon)

	stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi',"blank")

	var/icon_key = "[species.race_key][g][s_tone]"
	for(var/datum/organ/external/part in organs)
		if(istype(part, /datum/organ/external/head) && !(part.status & ORGAN_DESTROYED))
			has_head = 1

		if(part.status & ORGAN_DESTROYED)
			icon_key = "[icon_key]0"
		else if(part.status & ORGAN_ROBOT)
			icon_key = "[icon_key]2"
		else if(part.status & ORGAN_DEAD) //Do we even have necrosis in our current code? ~Z
			icon_key = "[icon_key]3"
		else
			icon_key = "[icon_key]1"

	icon_key = "[icon_key][husk ? 1 : 0][fat ? 1 : 0][hulk ? 1 : 0][skeleton ? 1 : 0][s_tone]"

	var/icon/base_icon
	if(global.human_icon_cache[icon_key])
		//Icon is cached, use existing icon.
		base_icon = global.human_icon_cache[icon_key]
	else

	//BEGIN CACHED ICON GENERATION.

		//Icon is not cached, generate and store it.
		//Robotic limbs are handled in get_icon() so all we worry about are missing or dead limbs.
		//No icon stored, so we need to start with a basic one.
		var/datum/organ/external/chest = get_organ("chest")
		base_icon = chest.get_icon(g)

		for(var/datum/organ/external/part in organs)
			var/icon/temp //Hold the bodypart icon for processing.

			if(part.status & ORGAN_DESTROYED)
				continue

			if(istype(part, /datum/organ/external/groin) || istype(part, /datum/organ/external/head))
				temp = part.get_icon(g)
			else
				temp = part.get_icon()

			if(part.status & ORGAN_DEAD)
				temp.ColorTone(necrosis_color_mod)
				temp.SetIntensity(0.7)

			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position&(LEFT|RIGHT))
				var/icon/temp2 = new('icons/mob/human.dmi', "blank")
				temp2.Insert(new/icon(temp, dir = NORTH), dir = NORTH)
				temp2.Insert(new/icon(temp, dir = SOUTH), dir = SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new/icon(temp, dir = EAST), dir = EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new/icon(temp, dir = WEST), dir = WEST)
				base_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new/icon(temp, dir = EAST), dir = EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new/icon(temp, dir = WEST), dir = WEST)
				base_icon.Blend(temp2, ICON_UNDERLAY)
			else
				base_icon.Blend(temp, ICON_OVERLAY)

		if(!skeleton)
			if(husk)
				base_icon.ColorTone(husk_color_mod)
			else if(hulk)
				var/list/tone = ReadRGB(hulk_color_mod)
				base_icon.MapColors(rgb(tone[1], 0, 0), rgb(0, tone[2], 0), rgb(0, 0, tone[3]))

		//Handle husk overlay.
		if(husk)
			var/icon/mask = new(base_icon)
			var/icon/husk_over = new(race_icon, "overlay_husk")
			mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
			husk_over.Blend(mask, ICON_ADD)
			base_icon.Blend(husk_over, ICON_OVERLAY)

		//Skin tone.
		if(!husk && !hulk)
			if(HAS_SPECIES_FLAGS(species, SPECIES_FLAG_HAS_SKIN_TONE))
				if(s_tone >= 0)
					base_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
				else
					base_icon.Blend(rgb(-s_tone, -s_tone, -s_tone), ICON_SUBTRACT)

		global.human_icon_cache[icon_key] = base_icon

	//END CACHED ICON GENERATION.

	stand_icon.Blend(base_icon, ICON_OVERLAY)

	//Skin colour. Not in cache because highly variable (and relatively benign).
	if(HAS_SPECIES_FLAGS(species, SPECIES_FLAG_HAS_SKIN_COLOUR))
		stand_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)

	if(has_head)
		//Eyes
		if(!skeleton)
			var/icon/eyes = new/icon('icons/mob/on_mob/human_face.dmi', species.eyes)
			if(HAS_SPECIES_FLAGS(species, SPECIES_FLAG_HAS_EYE_COLOUR))
				eyes.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)
			stand_icon.Blend(eyes, ICON_OVERLAY)

		//Mouth	(lipstick!)
		//skeletons are allowed to wear lipstick no matter what you think, agouri.
		if(lip_style && (isnotnull(species) && HAS_SPECIES_FLAGS(species, SPECIES_FLAG_HAS_LIPS)))
			stand_icon.Blend(new/icon('icons/mob/on_mob/human_face.dmi', "lips_[lip_style]_s"), ICON_OVERLAY)

	//Underwear
	if(underwear > 0 && underwear < 12 && HAS_SPECIES_FLAGS(species, SPECIES_FLAG_HAS_UNDERWEAR))
		if(!fat && !skeleton)
			stand_icon.Blend(new /icon('icons/mob/human.dmi', "underwear[underwear]_[g]_s"), ICON_OVERLAY)

	if(update_icons)
		update_icons()

	//tail
	update_tail_showing(0)


//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair(update_icons = 1)
	//Reset our hair
	overlays_standing[HAIR_LAYER] = null

	var/datum/organ/external/head/head_organ = get_organ("head")
	if(!head_organ || (head_organ.status & ORGAN_DESTROYED))
		if(update_icons)
			update_icons()
		return

	//masks and helmets can obscure our hair.
	if((isnotnull(head) && HAS_ATOM_FLAGS(head, INV_FLAG_BLOCK_HAIR)) || (isnotnull(wear_mask) && HAS_ATOM_FLAGS(wear_mask, INV_FLAG_BLOCK_HAIR)))
		if(update_icons)
			update_icons()
		return

	//base icons
	var/icon/face_standing	= new /icon('icons/mob/on_mob/human_face.dmi', "bald_s")

	if(f_style)
		var/datum/sprite_accessory/facial_hair_style = GLOBL.facial_hair_styles_list[f_style]
		if(facial_hair_style && (src.species.name in facial_hair_style.species_allowed))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)

			face_standing.Blend(facial_s, ICON_OVERLAY)

	if(h_style && !(isnotnull(head) && HAS_ATOM_FLAGS(head, INV_FLAG_BLOCK_HEAD_HAIR)))
		var/datum/sprite_accessory/hair_style = GLOBL.hair_styles_list[h_style]
		if(hair_style && (src.species.name in hair_style.species_allowed))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)

			face_standing.Blend(hair_s, ICON_OVERLAY)

	overlays_standing[HAIR_LAYER] = image(face_standing)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_mutations(update_icons = 1)
	var/fat
	if(MUTATION_FAT in mutations)
		fat = "fat"

	var/image/standing	= image("icon" = 'icons/effects/genetics.dmi')
	var/add_image = 0
	var/g = "m"
	if(gender == FEMALE)
		g = "f"
	// DNA2 - Drawing underlays.
	for_no_type_check(var/decl/gene/gene, GET_DECL_SUBTYPE_INSTANCES(/decl/gene))
		if(!gene.block)
			continue
		if(gene.is_active(src))
			var/underlay = gene.OnDrawUnderlays(src, g, fat)
			if(isnotnull(underlay))
				standing.underlays.Add(underlay)
				add_image = 1
	for(var/mut in mutations)
		switch(mut)
			/*
			if(MUTATION_HULK)
				if(fat)
					standing.underlays	+= "hulk_[fat]_s"
				else
					standing.underlays	+= "hulk_[g]_s"
				add_image = 1
			if(MUTATION_COLD_RESISTANCE)
				standing.underlays	+= "fire[fat]_s"
				add_image = 1
			if(MUTATION_TELEKINESIS)
				standing.underlays	+= "telekinesishead[fat]_s"
				add_image = 1
			*/
			if(LASER)
				standing.add_overlay("lasereyes_s")
				add_image = 1
	if(add_image)
		overlays_standing[MUTATIONS_LAYER]	= standing
	else
		overlays_standing[MUTATIONS_LAYER]	= null
	if(update_icons)
		update_icons()


/mob/living/carbon/human/proc/update_mutantrace(update_icons = 1)
	var/fat
	if(MUTATION_FAT in mutations)
		fat = "fat"
//	var/g = "m"
//	if (gender == FEMALE)	g = "f"
//BS12 EDIT
	var/skeleton = (MUTATION_SKELETON in src.mutations)
	if(skeleton)
		race_icon = 'icons/mob/human_races/r_skeleton.dmi'
	else
		//Icon data is kept in species datums within the mob.
		race_icon = species.icobase
		deform_icon = species.deform

	if(dna)
		switch(dna.mutantrace)
			if("golem", "slime", "shadow", "adamantine")
				overlays_standing[MUTANTRACE_LAYER] = image("icon" = 'icons/effects/genetics.dmi', "icon_state" = "[dna.mutantrace][fat]_[gender]_s")
			else
				overlays_standing[MUTANTRACE_LAYER] = null

	if(!dna || !(dna.mutantrace in list("golem", "metroid")))
		update_body(0)

	update_hair(0)
	if(update_icons)
		update_icons()

//Call when target overlay should be added/removed
/mob/living/carbon/human/update_targeted(update_icons = 1)
	if(targeted_by && target_locked)
		overlays_standing[TARGETED_LAYER] = target_locked
	else if(!targeted_by && target_locked)
		qdel(target_locked)
	if(!targeted_by)
		overlays_standing[TARGETED_LAYER] = null
	if(update_icons)
		update_icons()


/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()
	..()
	if(monkeyizing)
		return
	update_mutations(0)
	update_mutantrace(0)
	update_inv_wear_uniform(0)
	update_inv_id_store(0)
	update_inv_gloves(0)
	update_inv_glasses(0)
	update_inv_ears(0)
	update_inv_shoes(0)
	update_inv_suit_store(0)
	update_inv_wear_mask(0)
	update_inv_head(0)
	update_inv_belt(0)
	update_inv_back(0)
	update_inv_wear_suit(0)
	update_inv_r_hand(0)
	update_inv_l_hand(0)
	update_inv_handcuffed(0)
	update_inv_legcuffed(0)
	update_inv_pockets(0)
	update_fire(0)
	UpdateDamageIcon()
	update_icons()
	//Hud Stuff
	update_hud()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_wear_uniform(update_icons = 1)
	if(wear_uniform && istype(wear_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/uniform = wear_uniform
		uniform.screen_loc = UI_ICLOTHING
		var/t_color = uniform.item_color
		if(!t_color)
			t_color = icon_state

		var/image/standing = image("icon_state" = "[t_color]_s")

		if(uniform.icon_override)
			standing.icon = uniform.icon_override
		else if(uniform.sprite_sheets && uniform.sprite_sheets[species.name])
			standing.icon = uniform.sprite_sheets[species.name]
		else
			standing.icon = 'icons/mob/on_mob/uniform.dmi'

		if(uniform.blood_DNA)
			var/image/bloodsies = image("icon" = 'icons/effects/decals/blood.dmi', "icon_state" = "uniformblood")
			bloodsies.color = uniform.blood_color
			standing.add_overlay(bloodsies)

		if(uniform.hastie)
			var/tie_color = uniform.hastie.item_color
			if(!tie_color) tie_color = uniform.hastie.icon_state
			standing.add_overlay(image("icon" = 'icons/mob/on_mob/ties.dmi', "icon_state" = "[tie_color]"))

		overlays_standing[UNIFORM_LAYER] = standing
	else
		overlays_standing[UNIFORM_LAYER] = null
		// This really, really seems like it should not be mixed in the middle of display code...
		// Automatically drop anything in store / id / belt if you're not wearing a uniform.	//CHECK IF NECESARRY
		for(var/obj/item/thing in list(r_pocket, l_pocket, id_store, belt))						//
			if(thing)																			//
				u_equip(thing)																	//
				if(client)																		//
					client.screen -= thing														//
																								//
				if(thing)																		//
					thing.forceMove(loc)														//
					thing.dropped(src)															//
					thing.reset_plane_and_layer()
	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_id_store(update_icons = 1)
	if(isnotnull(id_store))
		id_store.screen_loc = UI_ID_STORE	//TODO
		if(wear_uniform && wear_uniform:displays_id)
			overlays_standing[ID_LAYER]	= image("icon" = 'icons/mob/mob.dmi', "icon_state" = "id")
		else
			overlays_standing[ID_LAYER]	= null
	else
		overlays_standing[ID_LAYER]	= null

	BITSET(hud_updateflag, ID_HUD)
	BITSET(hud_updateflag, WANTED_HUD)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_gloves(update_icons = 1)
	if(isnotnull(gloves))
		var/t_state = gloves.item_state
		if(!t_state)
			t_state = gloves.icon_state

		var/image/standing
		if(gloves.icon_override)
			standing = image("icon" = gloves.icon_override, "icon_state" = "[t_state]")
		else if(gloves.sprite_sheets && gloves.sprite_sheets[species.name])
			standing = image("icon" = gloves.sprite_sheets[species.name], "icon_state" = "[t_state]")
		else
			standing = image("icon" = 'icons/mob/on_mob/hands.dmi', "icon_state" = "[t_state]")

		if(gloves.blood_DNA)
			var/image/bloodsies	= image("icon" = 'icons/effects/decals/blood.dmi', "icon_state" = "bloodyhands")
			bloodsies.color = gloves.blood_color
			standing.overlays	+= bloodsies
		gloves.screen_loc = UI_GLOVES

		overlays_standing[GLOVES_LAYER] = standing

	else
		if(blood_DNA)
			var/image/bloodsies	= image("icon" = 'icons/effects/decals/blood.dmi', "icon_state" = "bloodyhands")
			bloodsies.color = hand_blood_color
			overlays_standing[GLOVES_LAYER] = bloodsies
		else
			overlays_standing[GLOVES_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_glasses(update_icons = 1)
	if(isnotnull(glasses))
		overlays_standing[GLASSES_LAYER] = image("icon" = ((glasses.icon_override) ? glasses.icon_override : 'icons/mob/on_mob/eyes.dmi'), "icon_state" = "[glasses.icon_state]")
	else
		overlays_standing[GLASSES_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_ears(update_icons = 1)
	if(isnotnull(l_ear) || isnotnull(r_ear))
		if(isnotnull(l_ear))
			var/t_type = l_ear.icon_state
			if(l_ear.icon_override)
				t_type = "[t_type]_l"
				overlays_standing[EARS_LAYER] = image("icon" = l_ear.icon_override, "icon_state" = "[t_type]")
			else if(l_ear.sprite_sheets && l_ear.sprite_sheets[species.name])
				t_type = "[t_type]_l"
				overlays_standing[EARS_LAYER] = image("icon" = l_ear.sprite_sheets[species.name], "icon_state" = "[t_type]")
			else
				overlays_standing[EARS_LAYER] = image("icon" = 'icons/mob/on_mob/ears.dmi', "icon_state" = "[t_type]")

		if(isnotnull(r_ear))
			var/t_type = r_ear.icon_state
			if(r_ear.icon_override)
				t_type = "[t_type]_r"
				overlays_standing[EARS_LAYER] = image("icon" = r_ear.icon_override, "icon_state" = "[t_type]")
			else if(r_ear.sprite_sheets && r_ear.sprite_sheets[species.name])
				t_type = "[t_type]_r"
				overlays_standing[EARS_LAYER] = image("icon" = r_ear.sprite_sheets[species.name], "icon_state" = "[t_type]")
			else
				overlays_standing[EARS_LAYER] = image("icon" = 'icons/mob/on_mob/ears.dmi', "icon_state" = "[t_type]")
	else
		overlays_standing[EARS_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_shoes(update_icons = 1)
	if(isnotnull(shoes) && !(wear_suit && HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_SHOES)))
		var/image/standing
		if(shoes.icon_override)
			standing = image("icon" = shoes.icon_override, "icon_state" = "[shoes.icon_state]")
		else if(shoes.sprite_sheets && shoes.sprite_sheets[species.name])
			standing = image("icon" = shoes.sprite_sheets[species.name], "icon_state" = "[shoes.icon_state]")
		else
			standing = image("icon" = 'icons/mob/on_mob/feet.dmi', "icon_state" = "[shoes.icon_state]")

		if(shoes.blood_DNA)
			var/image/bloodsies = image("icon" = 'icons/effects/decals/blood.dmi', "icon_state" = "shoeblood")
			bloodsies.color = shoes.blood_color
			standing.add_overlay(bloodsies)

		overlays_standing[SHOES_LAYER] = standing

	else
		if(feet_blood_DNA)
			var/image/bloodsies = image("icon" = 'icons/effects/decals/blood.dmi', "icon_state" = "shoeblood")
			bloodsies.color = feet_blood_color
			overlays_standing[SHOES_LAYER] = bloodsies
		else
			overlays_standing[SHOES_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_suit_store(update_icons = 1)
	if(isnotnull(suit_store))
		var/t_state = suit_store.item_state
		if(!t_state)
			t_state = suit_store.icon_state
		overlays_standing[SUIT_STORE_LAYER] = image("icon" = 'icons/mob/on_mob/belt_mirror.dmi', "icon_state" = "[t_state]")
		suit_store.screen_loc = UI_SSTORE1		//TODO
	else
		overlays_standing[SUIT_STORE_LAYER] = null
	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_head(update_icons = 1)
	if(isnotnull(head))
		head.screen_loc = UI_HEAD		//TODO

		var/image/standing
		if(istype(head, /obj/item/clothing/head/kitty))
			standing = image("icon" = head:mob)
		else
			if(head.icon_override)
				standing = image("icon" = head.icon_override, "icon_state" = "[head.icon_state]")
			else if(head.sprite_sheets && head.sprite_sheets[species.name])
				standing = image("icon" = head.sprite_sheets[species.name], "icon_state" = "[head.icon_state]")
			else
				standing = image("icon" = 'icons/mob/on_mob/head.dmi', "icon_state" = "[head.icon_state]")

		if(head.blood_DNA)
			var/image/bloodsies = image("icon" = 'icons/effects/decals/blood.dmi', "icon_state" = "helmetblood")
			bloodsies.color = head.blood_color
			standing.add_overlay(bloodsies)

		overlays_standing[HEAD_LAYER] = standing

	else
		overlays_standing[HEAD_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_belt(update_icons = 1)
	if(isnotnull(belt))
		belt.screen_loc = UI_BELT	//TODO
		var/t_state = belt.item_state
		if(!t_state)
			t_state = belt.icon_state

		if(belt.icon_override)
			overlays_standing[BELT_LAYER] = image("icon" = belt.icon_override, "icon_state" = "[t_state]")
		else if(belt.sprite_sheets && belt.sprite_sheets[species.name])
			overlays_standing[BELT_LAYER] = image("icon" = belt.sprite_sheets[species.name], "icon_state" = "[t_state]")
		else
			overlays_standing[BELT_LAYER] = image("icon" = 'icons/mob/on_mob/belt.dmi', "icon_state" = "[t_state]")
	else
		overlays_standing[BELT_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_wear_suit(update_icons = 1)
	if(isnotnull(wear_suit))	//TODO check this
		wear_suit.screen_loc = UI_OCLOTHING	//TODO

		var/image/standing
		if(wear_suit.icon_override)
			standing = image("icon" = wear_suit.icon_override, "icon_state" = "[wear_suit.icon_state]")
		else if(wear_suit.sprite_sheets && wear_suit.sprite_sheets[species.name])
			standing = image("icon" = wear_suit.sprite_sheets[species.name], "icon_state" = "[wear_suit.icon_state]")
		else
			standing = image("icon" = 'icons/mob/on_mob/suit.dmi', "icon_state" = "[wear_suit.icon_state]")

		if(istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
			drop_from_inventory(handcuffed)
			drop_l_hand()
			drop_r_hand()

		if(wear_suit.blood_DNA)
			var/obj/item/clothing/suit/S = wear_suit
			var/image/bloodsies = image("icon" = 'icons/effects/decals/blood.dmi', "icon_state" = "[S.blood_overlay_type]blood")
			bloodsies.color = wear_suit.blood_color
			standing.add_overlay(bloodsies)

		overlays_standing[SUIT_LAYER] = standing
		update_tail_showing(0)

	else
		overlays_standing[SUIT_LAYER] = null
		update_tail_showing(0)

	update_collar(0)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_pockets( update_icons = 1)
	if(isnotnull(l_pocket))
		l_pocket.screen_loc = UI_STORAGE1	//TODO
	if(isnotnull(r_pocket))
		r_pocket.screen_loc = UI_STORAGE2	//TODO
	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_wear_mask(update_icons = 1)
	if(isnotnull(wear_mask) && !(head && HAS_INV_FLAGS(head, INV_FLAG_HIDE_MASK)))
		wear_mask.screen_loc = UI_MASK	//TODO

		var/image/standing
		if(wear_mask.icon_override)
			standing = image("icon" = wear_mask.icon_override, "icon_state" = "[wear_mask.icon_state]")
		else if(wear_mask.sprite_sheets && wear_mask.sprite_sheets[species.name])
			standing = image("icon" = wear_mask.sprite_sheets[species.name], "icon_state" = "[wear_mask.icon_state]")
		else
			standing = image("icon" = 'icons/mob/on_mob/mask.dmi', "icon_state" = "[wear_mask.icon_state]")

		if(!istype(wear_mask, /obj/item/clothing/mask/cigarette) && wear_mask.blood_DNA)
			var/image/bloodsies = image("icon" = 'icons/effects/decals/blood.dmi', "icon_state" = "maskblood")
			bloodsies.color = wear_mask.blood_color
			standing.add_overlay(bloodsies)

		overlays_standing[FACEMASK_LAYER] = standing

	else
		overlays_standing[FACEMASK_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_back(update_icons = 1)
	if(isnotnull(back))
		back.screen_loc = UI_BACK	//TODO

		if(back.icon_override)
			overlays_standing[BACK_LAYER] = image("icon" = back.icon_override, "icon_state" = "[back.icon_state]")
		else if(back.sprite_sheets && back.sprite_sheets[species.name])
			overlays_standing[BACK_LAYER] = image("icon" = back.sprite_sheets[species.name], "icon_state" = "[back.icon_state]")
		else
			overlays_standing[BACK_LAYER] = image("icon" = 'icons/mob/on_mob/back.dmi', "icon_state" = "[back.icon_state]")
	else
		overlays_standing[BACK_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(isnotnull(client))
		client.screen |= contents
		hud_used?.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar

/mob/living/carbon/human/update_inv_handcuffed(update_icons = 1)
	if(isnotnull(handcuffed))
		drop_r_hand()
		drop_l_hand()
		stop_pulling()	//TODO: should be handled elsewhere
		overlays_standing[HANDCUFF_LAYER] = image("icon" = 'icons/mob/mob.dmi', "icon_state" = "handcuff1")
	else
		overlays_standing[HANDCUFF_LAYER] = null
	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_legcuffed(update_icons = 1)
	if(isnotnull(legcuffed))
		overlays_standing[LEGCUFF_LAYER] = image("icon" = 'icons/mob/mob.dmi', "icon_state" = "legcuff1")
		if(!IS_WALKING(src))
			src.set_move_intent(/decl/move_intent/walk)
	else
		overlays_standing[LEGCUFF_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_r_hand(update_icons = 1)
	if(isnotnull(r_hand))
		r_hand.screen_loc = UI_RHAND	//TODO
		var/t_state = r_hand.item_state
		if(!t_state)
			t_state = r_hand.icon_state

		if(r_hand.icon_override)
			t_state = "[t_state]_r"
			overlays_standing[R_HAND_LAYER] = image("icon" = r_hand.icon_override, "icon_state" = "[t_state]")
		else if(r_hand.sprite_sheets && r_hand.sprite_sheets[species.name])
			t_state = "[t_state]_r"
			overlays_standing[R_HAND_LAYER] = image("icon" = r_hand.sprite_sheets[species.name], "icon_state" = "[t_state]")
		else
			overlays_standing[R_HAND_LAYER] = image("icon" = 'icons/mob/on_mob/items_righthand.dmi', "icon_state" = "[t_state]")

		if(handcuffed)
			drop_r_hand()
	else
		overlays_standing[R_HAND_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_l_hand(update_icons = 1)
	if(isnotnull(l_hand))
		l_hand.screen_loc = UI_LHAND	//TODO
		var/t_state = l_hand.item_state
		if(!t_state)
			t_state = l_hand.icon_state

		if(l_hand.icon_override)
			t_state = "[t_state]_l"
			overlays_standing[L_HAND_LAYER] = image("icon" = l_hand.icon_override, "icon_state" = "[t_state]")
		else if(l_hand.sprite_sheets && l_hand.sprite_sheets[species.name])
			t_state = "[t_state]_l"
			overlays_standing[L_HAND_LAYER] = image("icon" = l_hand.sprite_sheets[species.name], "icon_state" = "[t_state]")
		else
			overlays_standing[L_HAND_LAYER] = image("icon" = 'icons/mob/on_mob/items_lefthand.dmi', "icon_state" = "[t_state]")

		if(handcuffed)
			drop_l_hand()
	else
		overlays_standing[L_HAND_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/update_tail_showing(update_icons = 1)
	overlays_standing[TAIL_LAYER] = null

	if(isnotnull(species.tail) && HAS_SPECIES_FLAGS(species, SPECIES_FLAG_HAS_TAIL))
		if(!wear_suit || !HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_TAIL) && !istype(wear_suit, /obj/item/clothing/suit/space))
			var/icon/tail_s = new/icon("icon" = 'icons/effects/species.dmi', "icon_state" = "[species.tail]_s")
			tail_s.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
			overlays_standing[TAIL_LAYER] = image(tail_s)

	if(update_icons)
		update_icons()

//Adds a collar overlay above the helmet layer if the suit has one
//	Suit needs an identically named sprite in icons/mob/on_mob/collar.dmi
/mob/living/carbon/human/proc/update_collar(update_icons = 1)
	var/icon/C = new('icons/mob/on_mob/collar.dmi')
	var/image/standing = null

	if(isnotnull(wear_suit))
		if(wear_suit.icon_state in C.IconStates())
			standing = image("icon" = C, "icon_state" = "[wear_suit.icon_state]")

	overlays_standing[COLLAR_LAYER]	= standing

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_fire(update_icons = 1)
	overlays_standing[FIRE_LAYER] = null
	if(on_fire)
		overlays_standing[FIRE_LAYER] = mutable_appearance('icons/mob/on_fire.dmi', "standing", layer = FIRE_LAYER)

	if(update_icons)
		update_icons()

// Used mostly for creating head items
/mob/living/carbon/human/proc/generate_head_icon()
//gender no longer matters for the mouth, although there should probably be seperate base head icons.
//	var/g = "m"
//	if (gender == FEMALE)	g = "f"

	//base icons
	var/icon/face_lying = new /icon('icons/mob/on_mob/human_face.dmi',"bald_l")

	if(f_style)
		var/datum/sprite_accessory/facial_hair_style = GLOBL.facial_hair_styles_list[f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (src.species.name in facial_hair_style.species_allowed))
			var/icon/facial_l = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_l")
			facial_l.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)
			face_lying.Blend(facial_l, ICON_OVERLAY)

	if(h_style)
		var/datum/sprite_accessory/hair_style = GLOBL.hair_styles_list[h_style]
		if(hair_style)
			var/icon/hair_l = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_l")
			hair_l.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			face_lying.Blend(hair_l, ICON_OVERLAY)

	//Eyes
	// Note: These used to be in update_face(), and the fact they're here will make it difficult to create a disembodied head
	var/icon/eyes_l = new/icon('icons/mob/on_mob/human_face.dmi', "eyes_l")
	eyes_l.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)
	face_lying.Blend(eyes_l, ICON_OVERLAY)

	if(lip_style)
		face_lying.Blend(new/icon('icons/mob/on_mob/human_face.dmi', "lips_[lip_style]_l"), ICON_OVERLAY)

	var/image/face_lying_image = new /image(icon = face_lying)
	return face_lying_image

//Human Overlays Indexes/////////
#undef MUTANTRACE_LAYER
#undef MUTATIONS_LAYER
#undef DAMAGE_LAYER
#undef UNIFORM_LAYER
#undef ID_LAYER
#undef SHOES_LAYER
#undef GLOVES_LAYER
#undef EARS_LAYER
#undef SUIT_LAYER
#undef TAIL_LAYER
#undef GLASSES_LAYER
#undef FACEMASK_LAYER
#undef BELT_LAYER
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
#undef HAIR_LAYER
#undef HEAD_LAYER
#undef COLLAR_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef L_HAND_LAYER
#undef R_HAND_LAYER
#undef FIRE_LAYER
#undef TARGETED_LAYER
#undef TOTAL_LAYERS