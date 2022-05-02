/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys"
	icon_state = "headset"
	item_state = "headset"
	g_amt = 0
	m_amt = 75
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away

	slot_flags = SLOT_EARS
	maxf = 1489

	var/translate_binary = 0
	var/translate_hive = 0
	var/obj/item/device/encryptionkey/keyslot1 = null
	var/obj/item/device/encryptionkey/keyslot2 = null

	var/ks1type = /obj/item/device/encryptionkey
	var/ks2type = null

/obj/item/device/radio/headset/New()
	..()
	if(ks1type)
		keyslot1 = new ks1type(src)
	if(ks2type)
		keyslot2 = new ks2type(src)
	recalculateChannels()

/obj/item/device/radio/headset/Destroy()
	keyslot1 = null
	keyslot2 = null
	qdel(keyslot1)
	qdel(keyslot2)
	return ..()

/obj/item/device/radio/headset/receive_range(freq, level)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.l_ear == src || H.r_ear == src)
			return ..(freq, level)
	return -1

// Syndicate
/obj/item/device/radio/headset/syndicate
	origin_tech = list(RESEARCH_TECH_SYNDICATE = 3)
	syndie = 1
	ks1type = /obj/item/device/encryptionkey/syndicate

// Binary
/obj/item/device/radio/headset/binary
	origin_tech = list(RESEARCH_TECH_SYNDICATE = 3)
	ks1type = /obj/item/device/encryptionkey/binary

// Security
/obj/item/device/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force. To access the security channel, use :s."
	icon_state = "sec_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_sec

// Security Paramedic (MedSec)
/obj/item/device/radio/headset/headset_secpara
	name = "security paramedic radio headset"
	desc = "This is used by the medic for security. Channels are as follows: :s - Security, :m - Medical."
	icon_state = "sec_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_secpara

// Engineering
/obj/item/device/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to chat like girls. To access the engineering channel, use :e. "
	icon_state = "eng_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_eng

// Roboticist (EngSci)
/obj/item/device/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the Roboticists who cannot decide between departments. To access the science channel, use :n. For engineering, use :e."
	icon_state = "rob_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_rob

// Medical
/obj/item/device/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay. To access the medical channel, use :m."
	icon_state = "med_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_med

// MedSci
/obj/item/device/radio/headset/headset_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science. To access the medical channel, use :m. For science, use :n."
	icon_state = "med_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_medsci

// Science
/obj/item/device/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual. To access the science channel, use :n."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_sci

// Xenoarch (MinSci)
/obj/item/device/radio/headset/headset_xenoarch
	name = "xenoarchaeology radio headset"
	desc = "A longer range sciency headset. Unlike usual. To access the science channel, use :n. For mining, use :x."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_xenoarch

// Command
/obj/item/device/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commanding channel. To access the Command channel, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_com

/obj/item/device/radio/headset/heads/captain
	name = "captain's headset"
	desc = "The headset of the boss. Channels are as follows: :c - Command, :s - Security, :e - Engineering, :u - Supply, :v - Service, :m - Medical, :n - Science, :x - Mining."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/captain

/obj/item/device/radio/headset/heads/rd
	name = "Research Director's headset"
	desc = "Headset of the researching God. To access the science channel, use :n. For command, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/rd

/obj/item/device/radio/headset/heads/hos
	name = "head of security's headset"
	desc = "The headset of the man who protects your worthless lives. To access the security channel, use :s. For command, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/heads/ce
	name = "chief engineer's headset"
	desc = "The headset of the guy who is in charge of morons. To access the engineering channel, use :e. For command, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/ce

/obj/item/device/radio/headset/heads/cmo
	name = "chief medical officer's headset"
	desc = "The headset of the highly trained medical chief. To access the medical channel, use :m. For command, use :c."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/cmo

/obj/item/device/radio/headset/heads/hop
	name = "head of personnel's headset"
	desc = "The headset of the guy who will one day be Captain. Channels are as follows: :c - Command, :v - Service, :u - Supply, :x - Mining."
	icon_state = "com_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/hop

// Mining
/obj/item/device/radio/headset/headset_mine
	name = "mining radio headset"
	desc = "Headset used by miners. How useless. To access the mining channel, use :x."
	icon_state = "mine_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_mine

/obj/item/device/radio/headset/headset_mineforeman
	name = "mining foreman's radio headset"
	desc = "Headset used by the Mining Foreman. How slightly less useless. To access the mining channel, use :x. For supply, use :u."
	icon_state = "mine_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_mineforeman

// Cargo
/obj/item/device/radio/headset/headset_qm
	name = "quartermaster's headset"
	desc = "The headset of the man who controls your toilet paper supply. To access the mining channel, use :x. For supply, use :u."
	icon_state = "cargo_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_qm

/obj/item/device/radio/headset/headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the QM and his slaves. To access the supply channel, use :u."
	icon_state = "cargo_headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_cargo

// Service
/obj/item/device/radio/headset/headset_service
	name = "service radio headset"
	desc = "A headset used by the servants of the Head of Personnel. To access the service channel, use :v."
	icon_state = "headset"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/headset_service

// Response Team
/obj/item/device/radio/headset/ert
	name = "CentCom Response Team headset"
	desc = "The headset of the boss's boss. Channels are as follows: :h - Response Team :c - Command, :s - Security, :e - Engineering, :x - Mining, :u - Supply, :v - Service, :m - Medical, :n - Science."
	icon_state = "com_headset"
	item_state = "headset"
	freerange = 1
	ks2type = /obj/item/device/encryptionkey/ert

/obj/item/device/radio/headset/attackby(obj/item/weapon/W as obj, mob/user as mob)
//	..()
	user.set_machine(src)
	if(!(istype(W, /obj/item/weapon/screwdriver) || istype(W, /obj/item/device/encryptionkey)))
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		if(keyslot1 || keyslot2)
			for(var/ch_name in channels)
				radio_controller.remove_object(src, global.radiochannels[ch_name])
				secure_radio_connections[ch_name] = null

			if(keyslot1)
				var/turf/T = get_turf(user)
				if(T)
					keyslot1.loc = T
					keyslot1 = null

			if(keyslot2)
				var/turf/T = get_turf(user)
				if(T)
					keyslot2.loc = T
					keyslot2 = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption keys in the headset!")

		else
			to_chat(user, "This headset doesn't have any encryption keys! How useless...")

	if(istype(W, /obj/item/device/encryptionkey))
		if(keyslot1 && keyslot2)
			to_chat(user, "The headset can't hold another key!")
			return

		if(!keyslot1)
			user.drop_item()
			W.loc = src
			keyslot1 = W

		else
			user.drop_item()
			W.loc = src
			keyslot2 = W

		recalculateChannels()
	return

/obj/item/device/radio/headset/proc/recalculateChannels()
	src.channels = list()
	src.translate_binary = 0
	src.translate_hive = 0
	src.syndie = 0

	if(keyslot1)
		for(var/ch_name in keyslot1.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] = keyslot1.channels[ch_name]

		if(keyslot1.translate_binary)
			src.translate_binary = 1

		if(keyslot1.translate_hive)
			src.translate_hive = 1

		if(keyslot1.syndie)
			src.syndie = 1

	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] = keyslot2.channels[ch_name]

		if(keyslot2.translate_binary)
			src.translate_binary = 1

		if(keyslot2.translate_hive)
			src.translate_hive = 1

		if(keyslot2.syndie)
			src.syndie = 1

	for(var/ch_name in channels)
		if(!radio_controller)
			sleep(30) // Waiting for the radio_controller to be created.
		if(!radio_controller)
			src.name = "broken radio headset"
			return

		secure_radio_connections[ch_name] = radio_controller.add_object(src, global.radiochannels[ch_name], RADIO_CHAT)

	return