/mob/living/carbon/human
	hud_type = /datum/hud/human

	mob_bump_flag = HUMAN
	mob_push_flags = ALLMOBS
	mob_swap_flags = ALLMOBS

	//Hair colour and style
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/h_style = "Bald"

	//Facial hair colour and style
	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0
	var/f_style = "Shaved"

	//Eye colour
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0

	var/s_tone = 0	//Skin tone

	//Skin colour
	var/r_skin = 0
	var/g_skin = 0
	var/b_skin = 0

	var/size_multiplier = 1 //multiplier for the mob's icon size
	var/icon_update = 1 	//whether icon updating shall take place

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup

	var/age = 30		//Player's age (pure fluff)
	var/b_type = "A+"	//Player's bloodtype

	var/underwear = 1	//Which underwear the player wants
	var/backbag = 2		//Which backpack type the player has chosen. Nothing, Satchel or Backpack.

	/*
	 * Equipment Slots
	 *
	 * Related slots are grouped together.
	 * Hands, backpack and mask are defined by /mob.
	 */
	// Head
	var/obj/item/clothing/head/head = null
	var/obj/item/clothing/glasses/glasses = null
	var/obj/item/clothing/ears/l_ear = null
	var/obj/item/clothing/ears/r_ear = null
	// Uniform
	var/obj/item/clothing/under/wear_uniform = null
	var/obj/item/id_store = null
	var/obj/item/l_pocket = null
	var/obj/item/r_pocket = null
	// Suit
	var/obj/item/clothing/suit/wear_suit = null
	var/obj/item/suit_store = null
	// Other
	var/obj/item/clothing/gloves/gloves = null
	var/obj/item/belt = null
	var/obj/item/clothing/shoes/shoes = null

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = null

	var/icon/stand_icon = null
	var/icon/lying_icon = null

	var/voice = ""	//Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()

	var/speech_problem_flag = 0

	var/miming = FALSE //Toggle for the mime's abilities.
	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/failed_last_breath = FALSE //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.

	var/last_dam = -1	//Used for determining if we need to process all organs or just some or even none.
	var/list/bad_external_organs = list()// organs we check until they are good.

	var/xylophone = 0 //For the spoooooooky xylophone cooldown

	var/mob/remoteview_target = null
	var/hand_blood_color

	/*
	 * All below were moved from /mob.
	 * These need to be sorted eventually.
	 */
	var/damageoverlaytemp = 0
	var/lastpuke = 0