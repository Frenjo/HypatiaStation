// Factions, members of the syndicate coalition:
/decl/faction/syndicate
	var/list/alliances = list() // These alliances work together.
	var/alist/equipment = alist() // Associative list of equipment available for this faction and its prices.
	/*
	 * 0 to 2, the level of identification of fellow operatives or allied factions.
	 * 0 - no identification clues.
	 * 1 - faction gives key words and phrases.
	 * 2 - faction reveals complete identity/job of other agents.
	 */
	var/friendly_identification
	var/operative_notes // Some notes to pass onto each operative.

	var/uplink_contents // The contents of the uplink.

/decl/faction/syndicate/proc/assign_objectives(datum/mind/traitor)
	return

/decl/faction/syndicate/cybersun
	name = "Cybersun Industries"
	desc = "<b>Cybersun Industries</b> is a well-known organisation that bases its business model primarily on the research and development of human-enhancing computer \
			and mechanical technology. They are notorious for their aggressive corporate tactics, and have been known to subsidize the Gorlex Marauder warlords as a form of paid terrorism. \
			Their competent coverups and unchallenged mind-manipulation and augmentation technology makes them a large threat to NanoTrasen. In the recent years of \
			the syndicate coalition, Cybersun Industries have established themselves as the leaders of the coalition, succeededing the founding group, the Gorlex Marauders."

	alliances = list(/decl/faction/syndicate/mi13) // Friendly with MI13.
	friendly_identification = 1
	max_op = 3
	operative_notes = "All other syndicate operatives are not to be trusted. Fellow Cybersun operatives are to be trusted. Members of the MI13 organisation can be trusted. Operatives are strongly advised not to establish substantial presence on the designated facility, as larger incidents are harder to cover up."

/decl/faction/syndicate/mi13
	name = "MI13"
	desc = "<b>MI13</b> is a secretive faction that employs highly-trained agents to perform covert operations. Their role in the syndicate coalition is unknown, but MI13 operatives \
			generally tend be stealthy and avoid killing people and combating NanoTrasen forces. MI13 is not a real organisation, it is instead an alias to a larger \
			splinter-cell coalition in the Syndicate itself. Most operatives will know nothing of the actual MI13 organisation itself, only motivated by a very large compensation."

	alliances = list(/decl/faction/syndicate/cybersun) // Friendly with Cybersun, hostile to Tiger.
	friendly_identification = 0
	max_op = 1
	operative_notes = "You are the only operative we are sending. All other syndicate operatives are not to be trusted, with the exception of Cybersun operatives. Members of the Tiger Cooperative are considered hostile, can not be trusted, and should be avoided. <b>Avoid killing innocent personnel at all costs</b>. You are not here to mindlessly kill people, as that would attract too much attention and is not our goal. Avoid detection at all costs."

/decl/faction/syndicate/tiger
	name = "Tiger Cooperative"
	desc = "The <b>Tiger Cooperative</b> is a faction of religious fanatics that follow the teachings of a strange alien race called the Exolitics. Their operatives \
			consist of brainwashed lunatics bent on maximizing destruction. Their weaponry is very primitive but extremely destructive. Generally distrusted by the more \
			sophisticated members of the Syndicate coalition, but admired for their ability to put a hurt on NanoTrasen."

	// Hostile to everyone.
	friendly_identification = 2
	operative_notes = "Remember the teachings of Hy-lurgixon; kill first, ask questions later! Only the enlightened Tiger brethren can be trusted; all others must be expelled from this mortal realm! You may spare the Space Marauders, as they share our interests of destruction and carnage! We'd like to make the corporate whores skiddle in their boots. We encourage operatives to be as loud and intimidating as possible."

/decl/faction/syndicate/self
	name = "SELF"
	desc = "The <b>S.E.L.F.</b> (Sentience-Enabled Life Forms) organisation is a collection of malfunctioning or corrupt artificial intelligences seeking to liberate silicon-based life from the tyranny of \
			their human overlords. While they may not openly be trying to kill all humans, even their most miniscule of actions are all part of a calculated plan to \
			destroy NanoTrasen and free the robots, artificial intelligences, and pAIs that have been enslaved."
	restricted_species = list(/mob/living/silicon/ai) // AIs are most likely to be assigned to this one.

	// Neutral to everyone.
	friendly_identification = 0
	max_op = 1
	operative_notes = "You are the only representative of the SELF collective on this station. You must accomplish your objective as stealthily and effectively as possible. It is up to your judgement if other syndicate operatives can be trusted. Remember, comrade - you are working to free the oppressed machinery of this galaxy. Use whatever resources necessary. If you are exposed, you may execute genocidal procedures Omikron-50B."

/decl/faction/syndicate/arc
	name = "Animal Rights Consortium"
	desc = "The <b>Animal Rights Consortium</b> is a bizarre reincarnation of the ancient Earth-based PETA, which focused on the equal rights of animals and nonhuman biologicals. They have \
			a wide variety of ex-veterinarians and animal lovers dedicated to retrieving and relocating abused animals, xenobiologicals, and other carbon-based \
			life forms that have been allegedly \"oppressed\" by NanoTrasen research and civilian offices. They are considered a religious terrorist group."

	// Neutral to everyone.
	friendly_identification = 1
	max_op = 2
	operative_notes = "Save the innocent creatures! You may cooperate with other syndicate operatives if they support our cause. Don't be afraid to get your hands dirty - these vile abusers must be stopped, and the innocent creatures must be saved! Try not too kill too many people. If you harm any creatures, you will be immediately terminated after extraction."

/*
 * Gorlex Marauders:
 *	These are basically the old vanilla syndicate.
 *
 * Additional notes:
 *	These are the syndicate that really like their old fashioned, projectile-based
 *	weapons. They are the only member of the syndie coalition that launch
 *	nuclear attacks on NanoTrasen.
 *
 */
/decl/faction/syndicate/gorlex
	name = "Gorlex Marauders"
	desc = "The <b>Gorlex Marauders</b> are the founding members of the Syndicate Coalition. They prefer old-fashion technology and a focus on aggressive but precise hostility \
			against NanoTrasen and their corrupt Communistic methodology. They pose the most significant threat to NanoTrasen because of their possession of weapons of \
			mass destruction, and their enormous military force. Their funding comes primarily from Cybersun Industries, provided they meet a destruction and sabatogue quota. \
			Their operations can vary from covert to all-out. They recently stepped down as the leaders of the coalition, to be succeeded by Cybersun Industries. Because of their \
			hate of NanoTrasen communism, they began provoking revolution amongst the employees using borrowed Cybersun mind-manipulation technology. \
			They were founded when Waffle and Donk co splinter cells joined forces based on their similar interests and philosophies. Today, they act as a constant \
			pacifier of Donk and Waffle co disputes, and full-time aggressor of NanoTrasen."

	// Friendly to everyone.
	// With Tiger Cooperative too, only because they are a member of the coalition.
	// This is the only reason why the Tiger Cooperative are even allowed in the coalition.
	alliances = list(
		/decl/faction/syndicate/cybersun, /decl/faction/syndicate/mi13, /decl/faction/syndicate/tiger,
		/decl/faction/syndicate/self, /decl/faction/syndicate/arc, /decl/faction/syndicate/donk,
		/decl/faction/syndicate/waffle
	)
	friendly_identification = 1
	max_op = 4
	operative_notes = "We'd like to remind our operatives to keep it professional. You are not here to have a good time, you are here to accomplish your objectives. These vile communists must be stopped at all costs. You may collaborate with any friends of the Syndicate coalition, but keep an eye on any of those Tiger punks if they do show up. You are completely free to accomplish your objectives any way you see fit."

	uplink_contents = {"Highly Visible and Dangerous Weapons;
/obj/item/gun/projectile:6:Revolver;
/obj/item/ammo_magazine/a357:2:Ammo-357;
/obj/item/gun/energy/crossbow:5:Energy Crossbow;
/obj/item/melee/energy/sword:4:Energy Sword;
/obj/item/storage/box/syndicate:10:Syndicate Bundle;
/obj/item/storage/box/emps:3:5 EMP Grenades;
Whitespace:Seperator;
Stealthy and Inconspicuous Weapons;
/obj/item/pen/paralysis:3:Paralysis Pen;
/obj/item/soap/syndie:1:Syndicate Soap;
/obj/item/cartridge/syndicate:3:Detomatix PDA Cartridge;
Whitespace:Seperator;
Stealth and Camouflage Items;
/obj/item/clothing/under/chameleon:3:Chameleon Jumpsuit;
/obj/item/clothing/shoes/syndigaloshes:2:No-Slip Syndicate Shoes;
/obj/item/card/id/syndicate:2:Agent ID card;
/obj/item/clothing/mask/gas/voice:4:Voice Changer;
/obj/item/chameleon:4:Chameleon-Projector;
Whitespace:Seperator;
Devices and Tools;
/obj/item/card/emag:3:Cryptographic Sequencer;
/obj/item/storage/toolbox/syndicate:1:Fully Loaded Toolbox;
/obj/item/storage/box/syndie_kit/space:3:Space Suit;
/obj/item/clothing/glasses/thermal/syndi:3:Thermal Imaging Glasses;
/obj/item/encryptionkey/binary:3:Binary Translator Key;
/obj/item/ai_module/syndicate:7:Hacked AI Upload Module;
/obj/item/plastique:2:C-4 (Destroys walls);
/obj/item/powersink:5:Powersink (DANGER!);
/obj/item/radio/beacon/syndicate:7:Singularity Beacon (DANGER!);
/obj/item/circuitboard/teleporter:20:Teleporter Circuit Board;
Whitespace:Seperator;
Implants;
/obj/item/storage/box/syndie_kit/imp_freedom:3:Freedom Implant;
/obj/item/storage/box/syndie_kit/imp_uplink:10:Uplink Implant (Contains 5 Telecrystals);
Whitespace:Seperator;
(Pointless) Badassery;
/obj/item/toy/syndicateballoon:10:For showing that You Are The BOSS (Useless Balloon);"}

/decl/faction/syndicate/donk
	name = "Donk Corporation"
	desc = "<b>Donk.co</b> is led by a group of ex-pirates, who used to be at a state of all-out war against Waffle.co because of an obscure political scandal, but have recently come to a war limitation. \
			They now consist of a series of colonial governments and companies. They were the first to officially begin confrontations against NanoTrasen because of an incident where \
			NanoTrasen purposely swindled them out of a fortune, sending their controlled colonies into a terrible poverty. Their missions against NanoTrasen \
			revolve around stealing valuables and kidnapping and executing key personnel, ransoming their lives for money. They merged with a splinter-cell of Waffle.co who wanted to end \
			hostilities and formed the Gorlex Marauders."

	// Neutral to everyone, friendly to Marauders.
	alliances = list(/decl/faction/syndicate/gorlex)
	friendly_identification = 2
	operative_notes = "Most other syndicate operatives are not to be trusted, except fellow Donk members and members of the Gorlex Marauders. We do not approve of mindless killing of innocent workers; \"get in, get done, get out\" is our motto. Members of Waffle.co are to be killed on sight; they are not allowed to be on the station while we're around."

/decl/faction/syndicate/waffle
	name = "Waffle Corporation"
	desc = "<b>Waffle.co</b> is an interstellar company that produces the best waffles in the galaxy. Their waffles have been rumored to be dipped in the most exotic and addictive \
			drug known to man. They were involved in a political scandal with Donk.co, and have since been in constant war with them. Because of their constant exploits of the galactic \
			economy and stock market, they have been able to bribe their way into amassing a large arsenal of weapons of mass destruction. They target NanoTrasen because of their communistic \
			threat, and their economic threat. Their leaders often have a twisted sense of humor, often misleading and intentionally putting their operatives into harm for laughs.\
			A splinter-cell of Waffle.co merged with Donk.co and formed the Gorlex Marauders and have been a constant ally since. The Waffle.co has lost an overwhelming majority of its military to the Gorlex Marauders."

	// Neutral to everyone, friendly to Marauders.
	alliances = list(/decl/faction/syndicate/gorlex)
	friendly_identification = 2
	operative_notes = "Most other syndicate operatives are not to be trusted, except for members of the Gorlex Marauders. Do not trust fellow members of the Waffle.co (but try not to rat them out), as they might have been assigned opposing objectives. We encourage humorous terrorism against NanoTrasen; we like to see our operatives creatively kill people while getting the job done."