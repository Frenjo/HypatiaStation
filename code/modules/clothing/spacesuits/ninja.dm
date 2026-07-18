/obj/item/clothing/head/helmet/space/space_ninja
	name = "ninja hood"
	desc = "What may appear to be a simple black garment is in fact a highly sophisticated nano-weave helmet. Standard issue ninja gear."
	icon_state = "s-ninja"
	item_state = "s-ninja_mask"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 25)
	siemens_coefficient = 0.2
	species_restricted = null

/obj/item/clothing/suit/space/space_ninja
	name = "ninja suit"
	desc = "A unique, vaccum-proof suit of nano-enhanced armor designed specifically for Spider Clan assassins."
	icon_state = "s-ninja"
	item_state = "s-ninja_suit"
	can_store = list(
		/obj/item/gun, /obj/item/ammo_magazine, /obj/item/ammo_casing,
		/obj/item/melee/baton, /obj/item/handcuffs, /obj/item/tank,
		/obj/item/cell, /obj/item/suit_cooling_unit
	)
	slowdown = 0
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0.2
	species_restricted = null //Workaround for spawning alien ninja without internals.

		//Important parts of the suit.
	var/mob/living/carbon/affecting = null 				//The wearer.
	var/obj/item/cell/cell						//Starts out with a high-capacity cell using New().
	var/datum/effect/system/spark_spread/spark_system	//To create sparks.
	var/list/reagent_list = list(							//The reagents ids which are added to the suit at New().
		"tricordrazine", "dexalinp", "spaceacillin",
		"dylovene", "nutriment", "radium", "hyronalin"
	)

	var/list/stored_research = list()			// For stealing station research.
	var/obj/item/disk/tech/t_disk 	//To copy design onto disk.

		//Other articles of ninja gear worn together, used to easily reference them after initializing.
	var/obj/item/clothing/head/helmet/space/space_ninja/n_hood
	var/obj/item/clothing/shoes/space_ninja/n_shoes
	var/obj/item/clothing/gloves/space_ninja/n_gloves

		//Main function variables.
	/// Is the suit on or off, simple
	var/is_suit_initialized = FALSE
	/// If the suit is on cooldown (tracked in number of ticks).
	/// Can be used to attach different cooldowns to abilities.
	/// Ticks down every second based on suit ntick().
	var/suit_cooldown = 0
	/// Base energy cost each ntick.
	var/passive_energy_drain = 5.0
	/// Additional cost for additional powers active.
	var/active_energy_drain = 25.0
	/// Kamikaze energy cost each ntick.
	var/kamikaze_energy_drain = 200.0
	/// Brute damage potentially done by Kamikaze each ntick.
	var/kamikaze_passive_damage = 1.0
	/// How fast the suit does certain things, lower is faster.
	/// Can be overridden in specific procs. Also determines adverse probability.
	var/suit_action_delay = 40.0
	/// How much reagent is transferred when injecting.
	var/adrenaline_inject_volume = 20.0
	/// How much reagent in total there is.
	var/adrenaline_max_volume = 80.00

		//Support function variables.
	/// Mode of SpiderOS.
	/// This can change so I won't bother listing the modes here (0 is hub).
	/// Check ninja_equipment.dm for how it all works.
	var/spideros = 0
	/// If stealth mode is on or off
	var/stealth_mode = FALSE
	/// Is the suit busy with a process? Like AI hacking. Used for safety functions.
	var/suit_busy = FALSE
	/// Kamikaze on or off.
	var/kamikaze = FALSE
	/// Some value that increments until it hits [NINJA_KAMIKAZE_UNLOCK] and then allows the user to use Kamikaze.
	var/kamikaze_unlock_tracker = 0

		//Ability function variables.
	/// Number of starting ninja smoke bombs.
	var/smoke_bombs = 10.0
	/// Number of adrenaline boosters.
	var/adrenaline_boosts = 3.0

		//Onboard AI related variables.
	var/mob/living/silicon/ai/AI	//If there is an AI inside the suit.
	var/obj/item/paicard/pai	//A slot for a pAI device
	var/obj/effect/overlay/hologram	//Is the AI hologram on or off? Visible only to the wearer of the suit. This works by attaching an image to a blank overlay.
	var/flush = 0					//If an AI purge is in progress.
	/// Tracks who is in control of the suit
	var/controller = NINJA_WEARER_CONTROL
