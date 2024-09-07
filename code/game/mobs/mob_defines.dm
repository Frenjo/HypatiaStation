/mob
	density = TRUE
	layer = 4.0
	animate_movement = 2
//	flags = NOREACT
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	// The mind attached to this mob.
	var/datum/mind/mind = null

	// Whether this mob is conscious, unconscious or dead.
	var/stat = CONSCIOUS // TODO: Move this to living - Nodrak

	//Not in use yet
	var/obj/effect/organstructure/organStructure = null

	var/atom/movable/screen/hands = null
	var/atom/movable/screen/internals = null
	var/atom/movable/screen/i_select = null
	var/atom/movable/screen/m_select = null

	// Actions
	var/atom/movable/screen/action/throw_icon/throw_icon = null
	var/atom/movable/screen/action/pull/pullin = null

	// Warnings
	var/atom/movable/screen/oxygen = null
	var/atom/movable/screen/toxin = null
	var/atom/movable/screen/fire = null
	var/atom/movable/screen/healths = null

	var/atom/movable/screen/pressure = null

	var/atom/movable/screen/bodytemp = null

	var/atom/movable/screen/nutrition_icon = null

	// Guns
	var/atom/movable/screen/gun/item/item_use_icon = null
	var/atom/movable/screen/gun/move/gun_move_icon = null
	var/atom/movable/screen/gun/run/gun_run_icon = null
	var/atom/movable/screen/gun/mode/gun_setting_icon = null

	// Fullscreen
	var/atom/movable/screen/blind = null
	var/atom/movable/screen/damageoverlay = null
	var/atom/movable/screen/flash = null
	var/atom/movable/screen/pain = null

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/atom/movable/screen/zone_sel/zone_sel = null

	var/use_me = 1 //Allows all mobs to use the me verb by default, will have to manually specify they cannot

	var/computer_id = null
	var/lastattacker = null
	var/lastattacked = null
	var/attack_log = list()

	var/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""

	var/sdisabilities = 0	//Carbon
	var/disabilities = 0	//Carbon
	var/atom/movable/pulling = null
	var/next_move = null
	var/monkeyizing = null	//Carbon

	var/hand = null

	var/ear_deaf = null		//Carbon

	var/stuttering = null	//Carbon
	var/slurring = null		//Carbon
	var/real_name = null
	var/flavor_text = ""

	var/blinded = null

	var/druggy = 0			//Carbon
	var/confused = 0		//Carbon

	var/sleeping = 0		//Carbon
	var/resting = 0			//Carbon
	var/lying = 0
	var/lying_prev = 0
	var/canmove = TRUE
	var/lastpuke = 0
	var/unacidable = 0
	var/small = 0
	var/list/pinned = list()			// List of things pinning this creature to walls (see living_defense.dm)
	var/list/embedded = list()			// Embedded items, since simple mobs don't have organs.
	var/list/languages = list()			// For speaking/listening.
	var/list/abilities = list()			// For species-derived or admin-given powers.
	var/list/speak_emote = list("says")	// Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/emote_type = 1		// Define emote default type, 1 for seen emotes, 2 for heard emotes

	var/name_archive //For admin things like possession

	var/timeofdeath = 0.0//Living

	var/bodytemperature = 310.055	//98.7 F
	var/drowsyness = 0.0//Carbon

	var/paralysis = 0.0
	var/stunned = 0.0
	var/weakened = 0.0
	var/losebreath = 0.0	//Carbon

	var/shakecamera = 0
	var/a_intent = "help"	//Living

	var/decl/move_intent/move_intent	//Living
	var/list/move_intents = list(
		/decl/move_intent/run,
		/decl/move_intent/walk
	)

	var/lastKnownIP = null
	var/obj/structure/stool/bed/buckled = null	//Living
	var/obj/item/tank/internal = null	//Human/Monkey
	var/obj/item/storage/s_active = null	//Carbon

	// The typepath of the HUD used by the mob.
	// Must be a subtype of /datum/hud.
	var/hud_type = null

	/*
	 * Equipment Slots
	 */
	var/obj/item/l_hand = null // Living
	var/obj/item/r_hand = null // Living
	var/obj/item/back = null // Human/Monkey
	var/obj/item/clothing/mask/wear_mask = null // Carbon

	var/datum/hud/hud_used = null

	var/list/grabbed_by = list()
	var/list/requests = list()

	var/list/mapobjs = list()

	var/in_throw_mode = 0

	var/coughedtime = null

	var/inertia_dir = 0

	var/datum/dna/dna = null	//Carbon
	var/radiation = 0.0			//Carbon

	var/list/mutations = list() //Carbon -- Doohl
	//see: setup.dm for list of mutations

	var/voice_name = "unidentifiable voice"

	var/faction = "neutral" //Used for checking whether hostile simple animals will attack you, possibly more stuff later
	var/captured = 0 //Functionally, should give the same effect as being buckled into a chair when true.

//Generic list for proc holders. Only way I can see to enable certain verbs/procs. Should be modified if needed.
	var/list/proc_holder_list = list() // Right now unused.
	//Also unlike the spell list, this would only store the object in contents, not an object in itself.

	/* Add this line to whatever stat module you need in order to use the proc holder list.
	Unlike the object spell system, it's also possible to attach verb procs from these objects to right-click menus.
	This requires creating a verb for the object proc holder.

	if(length(proc_holder_list)) //Generic list for proc_holder objects.
		for(var/obj/effect/proc_holder/P in proc_holder_list)
			statpanel("[P.panel]","",P)
	*/

//The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/mob/living/carbon/LAssailant = null

//Wizard mode, but can be used in other modes thanks to the brand new "Give Spell" badmin button
	var/list/spell_list = list()

//Changlings, but can be used in other modes
//	var/obj/effect/proc_holder/changpower/list/power_list = list()

//List of active diseases

	var/list/datum/disease/viruses = list() // replaces var/datum/disease/virus

//Monkey/infected mode
	var/list/resistances = list()
	var/datum/disease/virus = null

	var/update_icon = 1 //Set to 1 to trigger update_icons() at the next life() call

	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH	//bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)

	var/area/lastarea = null

	var/obj/control_object //Used by admins to possess objects. All mobs should have this var

	//Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/universal_speak = 0 // Set to 1 to enable the mob to speak to everyone -- TLE
	var/universal_understand = 0 // Set to 1 to enable the mob to understand everyone, not necessarily speak
	var/robot_talk_understand = 0
	var/alien_talk_understand = 0

	var/has_limbs = 1 //Whether this mob have any limbs he can move with
	var/can_stand = 1 //Whether this mob have ability to stand

	var/turf/listed_turf = null  //the current turf being examined in the stat panel

	var/list/active_genes = list()