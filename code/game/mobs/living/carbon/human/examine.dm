/mob/living/carbon/human/examine()
	set src in view()

	if(!usr || !src)
		return
	if(usr.sdisabilities & BLIND || usr.blinded || usr.stat == UNCONSCIOUS)
		to_chat(usr, SPAN_NOTICE("Something is there but you can't see it."))
		return

	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipgloves = HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_GLOVES)
		skipsuitstorage = HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_SUIT_STORAGE)
		skipjumpsuit = HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_JUMPSUIT)
		skipshoes = HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_SHOES)

	if(head)
		skipmask = HAS_INV_FLAGS(head, INV_FLAG_HIDE_MASK)
		skipeyes = HAS_INV_FLAGS(head, INV_FLAG_HIDE_EYES)
		skipears = HAS_INV_FLAGS(head, INV_FLAG_HIDE_EARS)
		skipface = HAS_INV_FLAGS(head, INV_FLAG_HIDE_FACE)

	if(wear_mask)
		skipface |= HAS_INV_FLAGS(wear_mask, INV_FLAG_HIDE_FACE)

	// crappy hacks because you can't do \his[src] etc. I'm sorry this proc is so unreadable, blame the text macros :<
	var/t_He = "It" //capitalised for use at the start of each line.
	var/t_his = "its"
	var/t_him = "it"
	var/t_has = "has"
	var/t_is = "is"

	var/msg = "<span class='info'>*---------*\nThis is "

	if(skipjumpsuit && skipface) //big suits/masks/helmets make it hard to tell their gender
		t_He = "They"
		t_his = "their"
		t_him = "them"
		t_has = "have"
		t_is = "are"
	else
		if(icon)
			msg += "\icon[icon] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated
		switch(gender)
			if(MALE)
				t_He = "He"
				t_his = "his"
				t_him = "him"
			if(FEMALE)
				t_He = "She"
				t_his = "her"
				t_him = "her"

	msg += "</EM>[src.name]</EM>, a </EM>[src.species]</EM>!\n" // Edited this a bit to show species alongside their name.

	//uniform
	if(wear_uniform && !skipjumpsuit)
		//Ties
		var/tie_msg
		if(istype(wear_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = wear_uniform
			if(U.hastie)
				tie_msg += " with \icon[U.hastie] \a [U.hastie]"

		if(wear_uniform.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_is] wearing \icon[wear_uniform] [wear_uniform.gender == PLURAL ? "some" : "a"] blood-stained [wear_uniform.name][tie_msg]!")]\n"
		else
			msg += "[t_He] [t_is] wearing \icon[wear_uniform] \a [wear_uniform][tie_msg].\n"

	//head
	if(head)
		if(head.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_is] wearing \icon[head] [head.gender == PLURAL ? "some" : "a"] blood-stained [head.name] on [t_his] head!")]\n"
		else
			msg += "[t_He] [t_is] wearing \icon[head] \a [head] on [t_his] head.\n"

	//suit/armour
	if(wear_suit)
		if(wear_suit.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_is] wearing \icon[wear_suit] [wear_suit.gender == PLURAL ? "some" : "a"] blood-stained [wear_suit.name]!")]\n"
		else
			msg += "[t_He] [t_is] wearing \icon[wear_suit] \a [wear_suit].\n"

		//suit/armour storage
		if(suit_store && !skipsuitstorage)
			if(suit_store.blood_DNA)
				msg += "[SPAN_WARNING("[t_He] [t_is] carrying \icon[suit_store] [suit_store.gender == PLURAL ? "some" : "a"] blood-stained [suit_store.name] on [t_his] [wear_suit.name]!")]\n"
			else
				msg += "[t_He] [t_is] carrying \icon[suit_store] \a [suit_store] on [t_his] [wear_suit.name].\n"

	//back
	if(back)
		if(back.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_has] \icon[back] [back.gender == PLURAL ? "some" : "a"] blood-stained [back] on [t_his] back.")]\n"
		else
			msg += "[t_He] [t_has] \icon[back] \a [back] on [t_his] back.\n"

	//left hand
	if(l_hand)
		if(l_hand.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_is] holding \icon[l_hand] [l_hand.gender == PLURAL ? "some" : "a"] blood-stained [l_hand.name] in [t_his] left hand!")]\n"
		else
			msg += "[t_He] [t_is] holding \icon[l_hand] \a [l_hand] in [t_his] left hand.\n"

	//right hand
	if(r_hand)
		if(r_hand.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_is] holding \icon[r_hand] [r_hand.gender == PLURAL ? "some" : "a"] blood-stained [r_hand.name] in [t_his] right hand!")]\n"
		else
			msg += "[t_He] [t_is] holding \icon[r_hand] \a [r_hand] in [t_his] right hand.\n"

	//gloves
	if(gloves && !skipgloves)
		if(gloves.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_has] \icon[gloves] [gloves.gender == PLURAL ? "some" : "a"] blood-stained [gloves.name] on [t_his] hands!")]\n"
		else
			msg += "[t_He] [t_has] \icon[gloves] \a [gloves] on [t_his] hands.\n"
	else if(blood_DNA)
		msg += "[SPAN_WARNING("[t_He] [t_has] blood-stained hands!")]\n"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			msg += "[SPAN_WARNING("[t_He] [t_is] \icon[handcuffed] restrained with cable!")]\n"
		else
			msg += "[SPAN_WARNING("[t_He] [t_is] \icon[handcuffed] handcuffed!")]\n"

	//belt
	if(belt)
		if(belt.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_has] \icon[belt] [belt.gender == PLURAL ? "some" : "a"] blood-stained [belt.name] about [t_his] waist!")]\n"
		else
			msg += "[t_He] [t_has] \icon[belt] \a [belt] about [t_his] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		if(shoes.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_is] wearing \icon[shoes] [shoes.gender == PLURAL ? "some" : "a"] blood-stained [shoes.name] on [t_his] feet!")]\n"
		else
			msg += "[t_He] [t_is] wearing \icon[shoes] \a [shoes] on [t_his] feet.\n"
	else if(feet_blood_DNA)
		msg += "[SPAN_WARNING("[t_He] [t_has] blood-stained feet!")]\n"

	//mask
	if(wear_mask && !skipmask)
		if(wear_mask.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_has] \icon[wear_mask] [wear_mask.gender == PLURAL ? "some" : "a"] blood-stained [wear_mask.name] on [t_his] face!")]\n"
		else
			msg += "[t_He] [t_has] \icon[wear_mask] \a [wear_mask] on [t_his] face.\n"

	//eyes
	if(glasses && !skipeyes)
		if(glasses.blood_DNA)
			msg += "[SPAN_WARNING("[t_He] [t_has] \icon[glasses] [glasses.gender == PLURAL ? "some" : "a"] blood-stained [glasses] covering [t_his] eyes!")]\n"
		else
			msg += "[t_He] [t_has] \icon[glasses] \a [glasses] covering [t_his] eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "[t_He] [t_has] \icon[l_ear] \a [l_ear] on [t_his] left ear.\n"

	//right ear
	if(r_ear && !skipears)
		msg += "[t_He] [t_has] \icon[r_ear] \a [r_ear] on [t_his] right ear.\n"

	//ID
	if(id_store)
		/*var/id
		if(istype(id_store, /obj/item/pda))
			var/obj/item/pda/pda = id_store
			id = pda.owner
		else if(istype(id_store, /obj/item/card/id)) //just in case something other than a PDA/ID card somehow gets in the ID slot :[
			var/obj/item/card/id/idcard = id_store
			id = idcard.registered_name
		if(id && (id != real_name) && in_range(src, usr) && prob(10))
			msg += "<span class='warning'>[t_He] [t_is] wearing \icon[id_store] \a [id_store] yet something doesn't seem right...</span>\n"
		else*/
		msg += "[t_He] [t_is] wearing \icon[id_store] \a [id_store].\n"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "[SPAN_DANGER("[t_He] [t_is] convulsing violently!")]\n"
		else if(jitteriness >= 200)
			msg += "[SPAN_WARNING("[t_He] [t_is] extremely jittery.")]\n"
		else if(jitteriness >= 100)
			msg += "[SPAN_WARNING("[t_He] [t_is] twitching ever so slightly.")]\n"

	//splints
	for(var/organ in list("l_leg","r_leg","l_arm","r_arm"))
		var/datum/organ/external/o = get_organ(organ)
		if(o && o.status & ORGAN_SPLINTED)
			msg += "[SPAN_WARNING("[t_He] [t_has] a splint on [t_his] [o.display_name]!")]\n"

	if(suiciding)
		msg += "[SPAN_WARNING("[t_He] appears to have commited suicide... there is no hope of recovery.")]\n"

	if(mSmallsize in mutations)
		msg += "[t_He] [t_is] small halfling!\n"

	var/distance = get_dist(usr, src)
	if(isobserver(usr) || usr.stat == DEAD) // ghosts can see anything
		distance = 1
	if(src.stat)
		msg += "[SPAN_WARNING("[t_He] [t_is]n't responding to anything around [t_him] and seems to be asleep.")]\n"
		if((stat == DEAD || src.losebreath) && distance <= 3)
			msg += "[SPAN_WARNING("[t_He] does not appear to be breathing.")]\n"
		if(ishuman(usr) && !usr.stat && distance <= 1)
			visible_message("[usr] checks [src]'s pulse.")
		spawn(15)
			if(distance <= 1 && usr.stat != 1)
				if(pulse == PULSE_NONE)
					usr << "<span class='deadsay'>[t_He] has no pulse[src.client ? "" : " and [t_his] soul has departed"]...</span>"
				else
					usr << "<span class='deadsay'>[t_He] has a pulse!</span>"

	if(fire_stacks)
		msg += "[t_He] [t_is] covered in some liquid.\n"
	if(on_fire)
		msg += "[SPAN_WARNING("[t_He] [t_is] on fire!")]\n"

	msg += "<span class='warning'>"

	if(nutrition < 100)
		msg += "[t_He] [t_is] severely malnourished.\n"
	else if(nutrition >= 500)
		/*if(usr.nutrition < 100)
			msg += "[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy.\n"
		else*/
		msg += "[t_He] [t_is] quite chubby.\n"

	msg += "</span>"

	if(stat == UNCONSCIOUS)
		msg += "[t_He] [t_is]n't responding to anything around [t_him] and seems to be asleep.\n"
	else if(getBrainLoss() >= 60)
		msg += "[t_He] [t_has] a stupid expression on [t_his] face.\n"

	if(!HAS_SPECIES_FLAGS(species, SPECIES_FLAG_IS_SYNTHETIC))
		if(!(species.has_organ["brain"] || has_brain()) && stat != DEAD)
			msg += "<span class='deadsay'>[t_He] [t_is] totally catatonic. The stresses of life in deep-space must have been too much for [t_him]. Any recovery is unlikely.</span>\n"
		else if(!client && brain_op_stage != 4 && stat != DEAD)
			msg += "[t_He] [t_has] suddenly fallen asleep.\n"

	var/list/wound_flavor_text = list()
	var/list/is_destroyed = list()
	var/list/is_bleeding = list()
	for(var/datum/organ/external/temp in organs)
		if(temp)
			if(temp.status & ORGAN_DESTROYED)
				is_destroyed["[temp.display_name]"] = 1
				wound_flavor_text["[temp.display_name]"] = "[SPAN_DANGER("[t_He] is missing [t_his] [temp.display_name].")]\n"
				continue
			if(temp.status & ORGAN_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					if(!HAS_SPECIES_FLAGS(species, SPECIES_FLAG_IS_SYNTHETIC))
						wound_flavor_text["[temp.display_name]"] = "[SPAN_WARNING("[t_He] has a robot [temp.display_name]!")]\n"
						continue
				else
					wound_flavor_text["[temp.display_name]"] = "<span class='warning'>[t_He] has a robot [temp.display_name], it has"
				if(temp.brute_dam) switch(temp.brute_dam)
					if(0 to 20)
						wound_flavor_text["[temp.display_name]"] += " some dents"
					if(21 to INFINITY)
						wound_flavor_text["[temp.display_name]"] += pick(" a lot of dents"," severe denting")
				if(temp.brute_dam && temp.burn_dam)
					wound_flavor_text["[temp.display_name]"] += " and"
				if(temp.burn_dam) switch(temp.burn_dam)
					if(0 to 20)
						wound_flavor_text["[temp.display_name]"] += " some burns"
					if(21 to INFINITY)
						wound_flavor_text["[temp.display_name]"] += pick(" a lot of burns"," severe melting")
				if(wound_flavor_text["[temp.display_name]"])
					wound_flavor_text["[temp.display_name]"] += "!</span>\n"
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
					var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
					"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area")
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
					flavor_text_string += " on [t_his] [temp.display_name].</span><br>"
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
		msg += wound_flavor_text["head"]
	else if(is_bleeding["head"])
		msg += "[SPAN_WARNING("[src] has blood running down [t_his] face!")]\n"
	if(wound_flavor_text["chest"] && !wear_uniform && !skipjumpsuit) //No need.  A missing chest gibs you.
		msg += wound_flavor_text["chest"]
	else if(is_bleeding["chest"])
		display_chest = 1
	if(wound_flavor_text["left arm"] && (is_destroyed["left arm"] || (!wear_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["left arm"]
	else if(is_bleeding["left arm"])
		display_chest = 1
	if(wound_flavor_text["left hand"] && (is_destroyed["left hand"] || (!gloves && !skipgloves)))
		msg += wound_flavor_text["left hand"]
	else if(is_bleeding["left hand"])
		display_gloves = 1
	if(wound_flavor_text["right arm"] && (is_destroyed["right arm"] || (!wear_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["right arm"]
	else if(is_bleeding["right arm"])
		display_chest = 1
	if(wound_flavor_text["right hand"] && (is_destroyed["right hand"] || (!gloves && !skipgloves)))
		msg += wound_flavor_text["right hand"]
	else if(is_bleeding["right hand"])
		display_gloves = 1
	if(wound_flavor_text["groin"] && (is_destroyed["groin"] || (!wear_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["groin"]
	else if(is_bleeding["groin"])
		display_chest = 1
	if(wound_flavor_text["left leg"] && (is_destroyed["left leg"] || (!wear_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["left leg"]
	else if(is_bleeding["left leg"])
		display_chest = 1
	if(wound_flavor_text["left foot"]&& (is_destroyed["left foot"] || (!shoes && !skipshoes)))
		msg += wound_flavor_text["left foot"]
	else if(is_bleeding["left foot"])
		display_shoes = 1
	if(wound_flavor_text["right leg"] && (is_destroyed["right leg"] || (!wear_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["right leg"]
	else if(is_bleeding["right leg"])
		display_chest = 1
	if(wound_flavor_text["right foot"]&& (is_destroyed["right foot"] || (!shoes  && !skipshoes)))
		msg += wound_flavor_text["right foot"]
	else if(is_bleeding["right foot"])
		display_shoes = 1
	if(display_chest)
		msg += "[SPAN_DANGER("[src] has blood soaking through from under [t_his] clothing!")]\n"
	if(display_shoes)
		msg += "[SPAN_DANGER("[src] has blood running from [t_his] shoes!")]\n"
	if(display_gloves)
		msg += "[SPAN_DANGER("[src] has blood running from under [t_his] gloves!")]\n"

	for(var/implant in get_visible_implants(1))
		msg += "[SPAN_DANGER("[src] has \a [implant] sticking out of their flesh!")]\n"
	if(digitalcamo)
		msg += "[t_He] [t_is] repulsively uncanny!\n"


	if(hasHUD(usr,"security"))
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

			msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
			msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>\n"

	if(hasHUD(usr,"medical"))
		var/perpname = "wot"
		var/medical = "None"

		if(id_store)
			if(istype(id_store,/obj/item/card/id))
				perpname = id_store:registered_name
			else if(istype(id_store,/obj/item/pda))
				var/obj/item/pda/tempPda = id_store
				perpname = tempPda.owner
		else
			perpname = src.name

		for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)
			if(E.fields["name"] == perpname)
				for_no_type_check(var/datum/data/record/R, GLOBL.data_core.general)
					if(R.fields["id"] == E.fields["id"])
						medical = R.fields["p_stat"]

		msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
		msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>\n"


	if(print_flavor_text()) msg += "[print_flavor_text()]\n"

	msg += "*---------*</span>"
	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[t_He] is [pose]"

	to_chat(usr, msg)

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
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
				return istype(R.module_state_1, /obj/item/borg/sight/hud/sec) || istype(R.module_state_2, /obj/item/borg/sight/hud/sec) || istype(R.module_state_3, /obj/item/borg/sight/hud/sec)
			if("medical")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/med) || istype(R.module_state_2, /obj/item/borg/sight/hud/med) || istype(R.module_state_3, /obj/item/borg/sight/hud/med)
			else
				return 0
	else
		return 0