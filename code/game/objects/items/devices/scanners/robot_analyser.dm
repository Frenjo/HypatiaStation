/*
 * Robotic Component Analyser, basically a health analyser for robots
 */
/obj/item/robot_analyser
	name = "cyborg analyser"
	desc = "A handheld scanner able to diagnose robotic injuries."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "robot"
	item_state = "analyser"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 1.0
	throw_speed = 5
	throw_range = 10
	matter_amounts = list(MATERIAL_METAL = 200)
	origin_tech = list(RESEARCH_TECH_MAGNETS = 1, RESEARCH_TECH_BIOTECH = 1)

	var/mode = 1

/obj/item/robot_analyser/attack(mob/living/M as mob, mob/living/user as mob)
	if(((CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))
		user << "\red You try to analyse the floor's vitals!"
		for(var/mob/O in viewers(M, null))
			O.show_message("\red [user] has analysed the floor's vitals!", 1)
		user.show_message("\blue Analyzing Results for The floor:\n\t Overall Status: Healthy", 1)
		user.show_message("\blue \t Damage Specifics: [0]-[0]-[0]-[0]", 1)
		user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
		user.show_message("\blue Body Temperature: ???", 1)
		return
	if(!(ishuman(user) || global.CTticker) && global.CTticker.mode.name != "monkey")
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return
	if(!isrobot(M))
		user << "\red You can't analyse non-robotic things!"
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!(H.species.flags & IS_SYNTHETIC))
			to_chat(user, SPAN_WARNING("You can't analyse non-robotic things!"))
			return

	user.visible_message("<span class='notice'> [user] has analysed [M]'s components.","<span class='notice'> You have analysed [M]'s components.")
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	user.show_message("\blue Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.halloss]% functional"]")
	user.show_message("\t Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>", 1)
	user.show_message("\t Damage Specifics: <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>")
	if(M.tod && M.stat == DEAD)
		user.show_message("\blue Time of Disable: [M.tod]")

	if(isrobot(M))
		var/mob/living/silicon/robot/H = M
		var/list/damaged = H.get_damaged_components(1, 1, 1)
		user.show_message("\blue Localized Damage:",1)
		if(length(damaged)>0)
			for(var/datum/robot_component/org in damaged)
				user.show_message(text("\blue \t []: [][] - [] - [] - []",	\
				capitalize(org.name),					\
				(org.installed == -1)	?	"<font color='red'><b>DESTROYED</b></font> "							:"",\
				(org.electronics_damage > 0)	?	"<font color='#FFA500'>[org.electronics_damage]</font>"	:0,	\
				(org.brute_damage > 0)	?	"<font color='red'>[org.brute_damage]</font>"							:0,		\
				(org.toggled)	?	"Toggled ON"	:	"<font color='red'>Toggled OFF</font>",\
				(org.powered)	?	"Power ON"		:	"<font color='red'>Power OFF</font>"),1)
		else
			user.show_message("\blue \t Components are OK.",1)
		if(H.emagged && prob(5))
			user.show_message("\red \t ERROR: INTERNAL SYSTEMS COMPROMISED",1)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!(H.species.flags & IS_SYNTHETIC))
			return
		var/list/damaged = H.get_damaged_organs(1, 1)
		user.show_message("\blue Localized Damage, Brute/Electronics:",1)
		if(length(damaged) > 0)
			for(var/datum/organ/external/org in damaged)
				user.show_message(text("\blue \t []: [] - []",	\
				capitalize(org.display_name),					\
				(org.brute_dam > 0)	?	"\red [org.brute_dam]"							:0,		\
				(org.burn_dam > 0)	?	"<font color='#FFA500'>[org.burn_dam]</font>"	:0),1)
		else
			user.show_message("\blue \t Components are OK.",1)

	user.show_message("\blue Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)", 1)
	src.add_fingerprint(user)
	return