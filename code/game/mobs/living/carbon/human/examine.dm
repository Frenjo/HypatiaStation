/mob/living/carbon/human/get_examine_header(mob/user)
	. = list()
	. += SPAN_INFO_B("*---------*")

	var/name_line = "This is"
	// Currently commented out pending bugfixes.
	//var/skip_jumpsuit = isnotnull(wear_suit) && HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_JUMPSUIT)
	//var/skip_face = (isnotnull(head) && HAS_INV_FLAGS(head, INV_FLAG_HIDE_FACE)) || (isnotnull(wear_mask) && HAS_INV_FLAGS(wear_mask, INV_FLAG_HIDE_FACE))
	//if(!skip_jumpsuit || !skip_face)
	//	if(icon) // Fucking BYOND: This should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated.
	//		name_line += " [icon2html(src, user)]"
	name_line += " <em>[name]</em>, a <em>[species]</em>!" // Edited this a bit to show species alongside their name.
	. += SPAN_INFO(name_line)

// This solely exists to make the massive lines somewhat shorter.
#define SOME_OR_A(THING) THING.gender == PLURAL ? "some" : "a"
/mob/living/carbon/human/get_examine_text(mob/user)
	. = ..()

	var/skipgloves = FALSE
	var/skipsuitstorage = FALSE
	var/skipjumpsuit = FALSE
	var/skipshoes = FALSE
	var/skipmask = FALSE
	var/skipears = FALSE
	var/skipeyes = FALSE
	var/skipface = FALSE

	//exosuits and helmets obscure our view and stuff.
	if(isnotnull(wear_suit))
		skipgloves = HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_GLOVES)
		skipsuitstorage = HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_SUIT_STORAGE)
		skipjumpsuit = HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_JUMPSUIT)
		skipshoes = HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_SHOES)

	if(isnotnull(head))
		skipmask = HAS_INV_FLAGS(head, INV_FLAG_HIDE_MASK)
		skipeyes = HAS_INV_FLAGS(head, INV_FLAG_HIDE_EYES)
		skipears = HAS_INV_FLAGS(head, INV_FLAG_HIDE_EARS)
		skipface = HAS_INV_FLAGS(head, INV_FLAG_HIDE_FACE)

	if(isnotnull(wear_mask))
		skipface |= HAS_INV_FLAGS(wear_mask, INV_FLAG_HIDE_FACE)

	// crappy hacks because you can't do \his[src] etc. I'm sorry this proc is so unreadable, blame the text macros :<
	var/t_He = "It" //capitalised for use at the start of each line.
	var/t_his = "its"
	var/t_him = "it"
	var/t_has = "has"
	var/t_is = "is"

	if(skipjumpsuit && skipface) //big suits/masks/helmets make it hard to tell their gender
		t_He = "They"
		t_his = "their"
		t_him = "them"
		t_has = "have"
		t_is = "are"
	else
		switch(gender)
			if(MALE)
				t_He = "He"
				t_his = "his"
				t_him = "him"
			if(FEMALE)
				t_He = "She"
				t_his = "her"
				t_him = "her"

	//uniform
	if(!skipjumpsuit && isnotnull(wear_uniform))
		//Ties
		var/tie_msg
		if(isnotnull(wear_uniform.hastie))
			tie_msg += " with [icon2html(wear_uniform.hastie, user)] <em>\a [wear_uniform.hastie]</em>"

		if(wear_uniform.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_is] wearing [icon2html(wear_uniform, user)] <em>[SOME_OR_A(wear_uniform)] blood-stained [wear_uniform.name]</em>[tie_msg]!")
		else
			. += SPAN_INFO("[t_He] [t_is] wearing [icon2html(wear_uniform, user)] <em>\a [wear_uniform]</em>[tie_msg].")

	//head
	if(isnotnull(head))
		if(head.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_is] wearing [icon2html(head, user)] <em>[SOME_OR_A(head)] blood-stained [head.name]</em> on [t_his] head!")
		else
			. += SPAN_INFO("[t_He] [t_is] wearing [icon2html(head, user)] <em>\a [head]</em> on [t_his] head.")

	//suit/armour
	if(isnotnull(wear_suit))
		if(wear_suit.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_is] wearing [icon2html(wear_suit, user)] <em>[SOME_OR_A(wear_suit)] blood-stained [wear_suit.name]</em>!")
		else
			. += SPAN_INFO("[t_He] [t_is] wearing [icon2html(wear_suit, user)] <em>\a [wear_suit]</em>.")

		//suit/armour storage
		if(!skipsuitstorage && isnotnull(suit_store))
			if(suit_store.blood_DNA)
				. += SPAN_WARNING("[t_He] [t_is] carrying [icon2html(suit_store, user)] <em>[SOME_OR_A(suit_store)] blood-stained [suit_store.name]</em> on [t_his] [wear_suit.name]!")
			else
				. += SPAN_INFO("[t_He] [t_is] carrying [icon2html(suit_store, user)] <em>\a [suit_store]</em> on [t_his] [wear_suit.name].")

	//back
	if(isnotnull(back))
		if(back.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_has] [icon2html(back, user)] <em>[SOME_OR_A(back)] blood-stained [back]</em> on [t_his] back.")
		else
			. += SPAN_INFO("[t_He] [t_has] [icon2html(back, user)] <em>\a [back]</em> on [t_his] back.")

	//left hand
	if(isnotnull(l_hand))
		if(l_hand.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_is] holding [icon2html(l_hand, user)] <em>[SOME_OR_A(l_hand)] blood-stained [l_hand.name]</em> in [t_his] left hand!")
		else
			. += SPAN_INFO("[t_He] [t_is] holding [icon2html(l_hand, user)] <em>\a [l_hand]</em> in [t_his] left hand.")

	//right hand
	if(isnotnull(r_hand))
		if(r_hand.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_is] holding [icon2html(r_hand, user)] <em>[SOME_OR_A(r_hand)] blood-stained [r_hand.name]</em> in [t_his] right hand!")
		else
			. += SPAN_INFO("[t_He] [t_is] holding [icon2html(r_hand, user)] <em>\a [r_hand]</em> in [t_his] right hand.")

	//gloves
	if(!skipgloves && isnotnull(gloves))
		if(gloves.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_has] [icon2html(gloves, user)] <em>[SOME_OR_A(gloves)] blood-stained [gloves.name]</em> on [t_his] hands!")
		else
			. += SPAN_INFO("[t_He] [t_has] [icon2html(gloves, user)] <em>\a [gloves]</em> on [t_his] hands.")
	else if(blood_DNA)
		. += SPAN_WARNING("[t_He] [t_has] blood-stained hands!")

	//belt
	if(isnotnull(belt))
		if(belt.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_has] [icon2html(belt, user)] <em>[SOME_OR_A(belt)] blood-stained [belt.name]</em> about [t_his] waist!")
		else
			. += SPAN_INFO("[t_He] [t_has] [icon2html(belt, user)] <em>\a [belt]</em> about [t_his] waist.")

	//shoes
	if(!skipshoes && isnotnull(shoes))
		if(shoes.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_is] wearing [icon2html(shoes, user)] <em>[SOME_OR_A(shoes)] blood-stained [shoes.name]</em> on [t_his] feet!")
		else
			. += SPAN_INFO("[t_He] [t_is] wearing [icon2html(shoes, user)] <em>\a [shoes]</em> on [t_his] feet.")
	else if(feet_blood_DNA)
		. += SPAN_WARNING("[t_He] [t_has] blood-stained feet!")

	//mask
	if(!skipmask && isnotnull(wear_mask))
		if(wear_mask.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_has] [icon2html(wear_mask, user)] <em>[SOME_OR_A(wear_mask)] blood-stained [wear_mask.name]</em> on [t_his] face!")
		else
			. += SPAN_INFO("[t_He] [t_has] [icon2html(wear_mask, user)] <em>\a [wear_mask]</em> on [t_his] face.")

	//eyes
	if(!skipeyes && isnotnull(glasses))
		if(glasses.blood_DNA)
			. += SPAN_WARNING("[t_He] [t_has] [icon2html(glasses, user)] <em>[SOME_OR_A(glasses)] blood-stained [glasses]</em> covering [t_his] eyes!")
		else
			. += SPAN_INFO("[t_He] [t_has] [icon2html(glasses, user)] <em>\a [glasses]</em> covering [t_his] eyes.")

	if(!skipears)
		//left ear
		if(isnotnull(l_ear))
			. += SPAN_INFO("[t_He] [t_has] [icon2html(l_ear, user)] <em>\a [l_ear]</em> on [t_his] left ear.")
		//right ear
		if(isnotnull(r_ear))
			. += SPAN_INFO("[t_He] [t_has] [icon2html(r_ear, user)] <em>\a [r_ear]</em> on [t_his] right ear.")

	//ID
	if(id_store)
		/*var/id
		if(istype(id_store, /obj/item/pda))
			var/obj/item/pda/pda = id_store
			id = pda.owner
		else if(istype(id_store, /obj/item/card/id)) //just in case something other than a PDA/ID card somehow gets in the ID slot :[
			var/obj/item/card/id/idcard = id_store
			id = idcard.registered_name
		if(id && (id != real_name) && in_range(src, user) && prob(10))
			msg += "<span class='warning'>[t_He] [t_is] wearing [icon2html(id_store, user)] \a [id_store] yet something doesn't seem right...</span>"
		else*/
		. += SPAN_INFO("[t_He] [t_is] wearing [icon2html(id_store, user)] <em>\a [id_store]</em>.")

	//handcuffed?
	if(isnotnull(handcuffed))
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			. += SPAN_WARNING("[t_He] [t_is] [icon2html(handcuffed, user)] restrained with cable!")
		else
			. += SPAN_WARNING("[t_He] [t_is] [icon2html(handcuffed, user)] handcuffed!")

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			. += SPAN_DANGER("[t_He] [t_is] convulsing violently!")
		else if(jitteriness >= 200)
			. += SPAN_WARNING("[t_He] [t_is] extremely jittery.")
		else if(jitteriness >= 100)
			. += SPAN_WARNING("[t_He] [t_is] twitching ever so slightly.")

	//splints
	for(var/organ in list("l_leg", "r_leg", "l_arm", "r_arm"))
		var/datum/organ/external/o = get_organ(organ)
		if(o?.status & ORGAN_SPLINTED)
			. += SPAN_WARNING("[t_He] [t_has] a splint on [t_his] [o.display_name]!")

	if(MUTATION_SMALL_SIZE in mutations)
		. += SPAN_INFO("[t_He] [t_is] a small halfling!")

	if(suiciding)
		. += SPAN_WARNING("[t_He] appears to have commited suicide... there is no hope of recovery.")

	// Pulse checking.
	var/distance = get_dist(user, src)
	if(isghost(user) || user.stat == DEAD) // ghosts can see anything
		distance = 1
	if(stat)
		. += SPAN_INFO("[t_He] [t_is]n't responding to anything around [t_him] and seems to be asleep.")
		if((stat == DEAD || losebreath) && distance <= 3)
			. += SPAN_WARNING("[t_He] does not appear to be breathing.")
		if(ishuman(user) && !user.stat && distance <= 1)
			user.visible_message(
				SPAN_INFO("[user] checks [src]'s pulse."),
				SPAN_INFO("You check [src]'s pulse.")
			)
		spawn(1.5 SECONDS)
			if(distance <= 1 && user.stat != 1)
				if(pulse == PULSE_NONE)
					to_chat(user, SPAN_DEADSAY("[t_He] has no pulse[isnotnull(client) ? "" : " and [t_his] soul has departed"]..."))
				else
					to_chat(user, SPAN_DEADSAY("[t_He] has a pulse!"))

	if(fire_stacks)
		. += SPAN_WARNING("[t_He] [t_is] covered in some liquid.")
	if(on_fire)
		. += SPAN_DANGER("[t_He] [t_is] on fire!")

	if(nutrition < 100)
		. += SPAN_WARNING("[t_He] [t_is] severely malnourished.")
	else if(nutrition >= 500)
		/*if(user.nutrition < 100)
			. += SPAN_WARNING("[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy.")
		else*/
		. += SPAN_WARNING("[t_He] [t_is] quite chubby.")

	if(stat == UNCONSCIOUS)
		. += SPAN_INFO("[t_He] [t_is]n't responding to anything around [t_him] and seems to be asleep.")
	else if(getBrainLoss() >= 60)
		. += SPAN_INFO("[t_He] [t_has] a stupid expression on [t_his] face.")

	if(!HAS_SPECIES_FLAGS(species, SPECIES_FLAG_IS_SYNTHETIC))
		if(!(species.has_organ["brain"] || has_brain()) && stat != DEAD)
			. += SPAN_DEADSAY("[t_He] [t_is] totally catatonic. The stresses of life in deep-space must have been too much for [t_him]. Any recovery is unlikely.")
		else if(!client && brain_op_stage != 4 && stat != DEAD)
			. += SPAN_INFO("[t_He] [t_has] suddenly fallen asleep.")

	var/list/wound_flavor_text = list()
	var/list/is_destroyed = list()
	var/list/is_bleeding = list()
	for(var/datum/organ/external/temp in organs)
		if(temp)
			if(temp.status & ORGAN_DESTROYED)
				is_destroyed["[temp.display_name]"] = 1
				wound_flavor_text["[temp.display_name]"] = SPAN_DANGER("[t_He] is missing [t_his] [temp.display_name].")
				continue
			if(temp.status & ORGAN_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					if(!HAS_SPECIES_FLAGS(species, SPECIES_FLAG_IS_SYNTHETIC))
						wound_flavor_text["[temp.display_name]"] = SPAN_WARNING("[t_He] has a robot [temp.display_name]!")
						continue
				else
					wound_flavor_text["[temp.display_name]"] = "[t_He] has a robot [temp.display_name], it has"
				if(temp.brute_dam)
					switch(temp.brute_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += " some dents"
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += pick(" a lot of dents"," severe denting")
				if(temp.brute_dam && temp.burn_dam)
					wound_flavor_text["[temp.display_name]"] += " and"
				if(temp.burn_dam)
					switch(temp.burn_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += " some burns"
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += pick(" a lot of burns"," severe melting")
				if(wound_flavor_text["[temp.display_name]"])
					wound_flavor_text["[temp.display_name]"] += "!"
					wound_flavor_text["[temp.display_name]"] = SPAN_WARNING(wound_flavor_text["[temp.display_name]"])
			else if(length(temp.wounds))
				var/list/wound_descriptors = list()
				for(var/datum/wound/W in temp.wounds)
					if(W.internal && !temp.open) continue // can't see internal wounds
					var/this_wound_desc = W.desc
					if(W.bleeding()) this_wound_desc = "bleeding [this_wound_desc]"
					else if(W.bandaged) this_wound_desc = "bandaged [this_wound_desc]"
					if(W.germ_level > 600) this_wound_desc = "badly infected [this_wound_desc]"
					else if(W.germ_level > 330) this_wound_desc = "lightly infected [this_wound_desc]"
					if(this_wound_desc in wound_descriptors)
						wound_descriptors[this_wound_desc] += W.amount
						continue
					wound_descriptors[this_wound_desc] = W.amount
				if(length(wound_descriptors))
					var/list/flavor_text = list()
					var/list/no_exclude = list(
						"gaping wound", "big gaping wound", "massive wound", "large bruise",
						"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area"
					)
					for(var/wound in wound_descriptors)
						switch(wound_descriptors[wound])
							if(1)
								if(!length(flavor_text))
									flavor_text += "<span class='warning'>[t_He] has[prob(10) && !(wound in no_exclude)  ? " what might be" : ""] a [wound]"
								else
									flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a [wound]"
							if(2)
								if(!length(flavor_text))
									flavor_text += "<span class='warning'>[t_He] has[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s"
								else
									flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s"
							if(3 to 5)
								if(!length(flavor_text))
									flavor_text += "<span class='warning'>[t_He] has several [wound]s"
								else
									flavor_text += " several [wound]s"
							if(6 to INFINITY)
								if(!length(flavor_text))
									flavor_text += "<span class='warning'>[t_He] has a bunch of [wound]s"
								else
									flavor_text += " a ton of [wound]\s"
					var/flavor_text_string = ""
					for(var/text = 1, text <= length(flavor_text), text++)
						if(text == length(flavor_text) && length(flavor_text) > 1)
							flavor_text_string += ", and"
						else if(length(flavor_text) > 1 && text > 1)
							flavor_text_string += ","
						flavor_text_string += flavor_text[text]
					flavor_text_string += " on [t_his] [temp.display_name].</span>"
					wound_flavor_text["[temp.display_name]"] = flavor_text_string
				else
					wound_flavor_text["[temp.display_name]"] = ""
				if(temp.status & ORGAN_BLEEDING)
					is_bleeding["[temp.display_name]"] = 1
			else
				wound_flavor_text["[temp.display_name]"] = ""

	//Handles the text strings being added to the actual description.
	//If they have something that covers the limb, and it is not missing, put flavortext.  If it is covered but bleeding, add other flavortext.
	var/display_chest = 0
	var/display_shoes = 0
	var/display_gloves = 0
	if(wound_flavor_text["head"] && (is_destroyed["head"] || (!skipmask && !(wear_mask && istype(wear_mask, /obj/item/clothing/mask/gas)))))
		. += wound_flavor_text["head"]
	else if(is_bleeding["head"])
		. += SPAN_WARNING("[src] has blood running down [t_his] face!")
	if(wound_flavor_text["chest"] && isnull(wear_uniform) && !skipjumpsuit) //No need.  A missing chest gibs you.
		. += wound_flavor_text["chest"]
	else if(is_bleeding["chest"])
		display_chest = 1
	if(wound_flavor_text["left arm"] && (is_destroyed["left arm"] || (!wear_uniform && !skipjumpsuit)))
		. += wound_flavor_text["left arm"]
	else if(is_bleeding["left arm"])
		display_chest = 1
	if(wound_flavor_text["left hand"] && (is_destroyed["left hand"] || (!gloves && !skipgloves)))
		. += wound_flavor_text["left hand"]
	else if(is_bleeding["left hand"])
		display_gloves = 1
	if(wound_flavor_text["right arm"] && (is_destroyed["right arm"] || (!wear_uniform && !skipjumpsuit)))
		. += wound_flavor_text["right arm"]
	else if(is_bleeding["right arm"])
		display_chest = 1
	if(wound_flavor_text["right hand"] && (is_destroyed["right hand"] || (!gloves && !skipgloves)))
		. += wound_flavor_text["right hand"]
	else if(is_bleeding["right hand"])
		display_gloves = 1
	if(wound_flavor_text["groin"] && (is_destroyed["groin"] || (!wear_uniform && !skipjumpsuit)))
		. += wound_flavor_text["groin"]
	else if(is_bleeding["groin"])
		display_chest = 1
	if(wound_flavor_text["left leg"] && (is_destroyed["left leg"] || (!wear_uniform && !skipjumpsuit)))
		. += wound_flavor_text["left leg"]
	else if(is_bleeding["left leg"])
		display_chest = 1
	if(wound_flavor_text["left foot"]&& (is_destroyed["left foot"] || (!shoes && !skipshoes)))
		. += wound_flavor_text["left foot"]
	else if(is_bleeding["left foot"])
		display_shoes = 1
	if(wound_flavor_text["right leg"] && (is_destroyed["right leg"] || (!wear_uniform && !skipjumpsuit)))
		. += wound_flavor_text["right leg"]
	else if(is_bleeding["right leg"])
		display_chest = 1
	if(wound_flavor_text["right foot"]&& (is_destroyed["right foot"] || (!shoes  && !skipshoes)))
		. += wound_flavor_text["right foot"]
	else if(is_bleeding["right foot"])
		display_shoes = 1
	if(display_chest)
		. += SPAN_DANGER("[t_He] has blood soaking through from under [t_his] clothing!")
	if(display_shoes)
		. += SPAN_DANGER("[t_He] has blood running from [t_his] shoes!")
	if(display_gloves)
		. += SPAN_DANGER("[t_He] has blood running from under [t_his] gloves!")

	for(var/implant in get_visible_implants(1))
		. += SPAN_DANGER("[t_He] has \a [implant] sticking out of their flesh!")
	if(digitalcamo)
		. += SPAN_INFO("[t_He] [t_is] repulsively uncanny!")

	if(hasHUD(user, "security"))
		var/perpname = "wot"
		var/criminal = "None"

		if(isnotnull(id_store))
			var/obj/item/card/id/I = id_store.get_id()
			perpname = isnotnull(I) ? I.registered_name : name
		else
			perpname = name

		if(perpname)
			for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
				if(E.fields["name"] == perpname)
					for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							criminal = R.fields["criminal"]

			. += "<span class = 'deptradio'>Criminal status:</span> <a href='byond://?src=\ref[src];criminal=1'>\[[criminal]\]</a>"
			. += "<span class = 'deptradio'>Security records:</span> <a href='byond://?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='byond://?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>"

	if(hasHUD(user, "medical"))
		var/perpname = "wot"
		var/medical = "None"

		if(id_store)
			if(istype(id_store, /obj/item/card/id))
				perpname = id_store:registered_name
			else if(istype(id_store, /obj/item/pda))
				var/obj/item/pda/tempPda = id_store
				perpname = tempPda.owner
		else
			perpname = name

		for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
			if(E.fields["name"] == perpname)
				for_no_type_check(var/datum/data/record/R, GLOBL.data_core.general)
					if(R.fields["id"] == E.fields["id"])
						medical = R.fields["p_stat"]

		. += "<span class = 'deptradio'>Physical status:</span> <a href='byond://?src=\ref[src];medical=1'>\[[medical]\]</a>"
		. += "<span class = 'deptradio'>Medical records:</span> <a href='byond://?src=\ref[src];medrecord=`'>\[View\]</a> <a href='byond://?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>"

	. += SPAN_INFO_B("*---------*")

	var/flavour_text = print_flavor_text()
	if(flavour_text)
		. += SPAN_INFO(flavour_text)

	if(isnotnull(pose))
		if(findtext(pose, ".", length(pose)) == 0 && findtext(pose, "!", length(pose)) == 0 && findtext(pose, "?", length(pose)) == 0)
			pose = addtext(pose, ".") // Makes sure all emotes end with a period.
		. += "[t_He] is [pose]"
#undef SOME_OR_A

// Helper procedure.
// Called by /mob/living/carbon/human/get_examine_text() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M, hudtype)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
			else
				return 0
	else if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if("security")
				return R.sensor_mode == SILICON_HUD_SECURITY && istype(R.model, /obj/item/robot_model/security)
			if("medical")
				return R.sensor_mode == SILICON_HUD_MEDICAL && istype(R.model, /obj/item/robot_model/medical)
			else
				return 0
	else
		return 0