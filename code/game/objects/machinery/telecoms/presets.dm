// ### Preset machines  ###

// --- Relay ---
/obj/machinery/telecoms/relay/preset
	network = "tcomsat"

// Station
/obj/machinery/telecoms/relay/preset/station
	id = "Station Relay"
	listening_level = 1
	autolinkers = list("s_relay")

// Telecoms
/obj/machinery/telecoms/relay/preset/telecoms
	id = "Telecoms Relay"
	autolinkers = list("relay")

// Mining
/obj/machinery/telecoms/relay/preset/mining
	id = "Mining Relay"
	autolinkers = list("m_relay")

// Ruskie
/obj/machinery/telecoms/relay/preset/ruskie
	id = "Ruskie Relay"
	hide = 1
	toggled = 0
	autolinkers = list("r_relay")

// CentCom
/obj/machinery/telecoms/relay/preset/centcom
	id = "CentCom Relay"
	hide = 1
	toggled = 1
	//anchored = TRUE
	//use_power = 0
	//idle_power_usage = 0
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("c_relay")


// --- HUB ---
/obj/machinery/telecoms/hub/preset
	id = "Hub"
	network = "tcomsat"
	autolinkers = list(
		"hub", "relay", "c_relay", "s_relay", "m_relay", "r_relay", "science", "medical",
		"supply", "mining", "service", "common", "command", "engineering", "security",
		"receiverA", "receiverB", "broadcasterA", "broadcasterB"
	)

// CentCom
/obj/machinery/telecoms/hub/preset_cent
	id = "CentCom Hub"
	network = "tcomsat"
	//heatgen = 0
	operating_temperature = null
	autolinkers = list(
		"hub_cent", "c_relay", "s_relay", "m_relay", "r_relay",
		"centcom", "receiverCent", "broadcasterCent"
	)


// --- Receivers ---
//--PRESET LEFT--//
/obj/machinery/telecoms/receiver/preset_left
	id = "Receiver A"
	network = "tcomsat"
	autolinkers = list("receiverA") // link to relay
	freq_listening = list(FREQUENCY_SCIENCE, FREQUENCY_MEDICAL, FREQUENCY_SUPPLY, FREQUENCY_MINING) // science, medical, supply, mining

//--PRESET RIGHT--//
/obj/machinery/telecoms/receiver/preset_right
	id = "Receiver B"
	network = "tcomsat"
	autolinkers = list("receiverB") // link to relay
	freq_listening = list(FREQUENCY_COMMAND, FREQUENCY_ENGINEERING, FREQUENCY_SECURITY, FREQUENCY_SERVICE) //command, engineering, security, service

//Common and other radio frequencies for people to freely use
/obj/machinery/telecoms/receiver/preset_right/New()
	for(var/i = FREQUENCY_FREE_MINIMUM, i < FREQUENCY_FREE_MAXIMUM, i += 2)
		freq_listening |= i
	return ..()

// CentCom
/obj/machinery/telecoms/receiver/preset_cent
	id = "CentCom Receiver"
	network = "tcomsat"
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("receiverCent")
	freq_listening = list(FREQUENCY_RESPONSETEAM, FREQUENCY_DEATHSQUAD)


// --- Buses ---
// One
/obj/machinery/telecoms/bus/preset_one
	id = "Bus 1"
	network = "tcomsat"
	freq_listening = list(FREQUENCY_SCIENCE, FREQUENCY_MEDICAL)
	autolinkers = list("processor1", "science", "medical")

// Two
/obj/machinery/telecoms/bus/preset_two
	id = "Bus 2"
	network = "tcomsat"
	freq_listening = list(FREQUENCY_SUPPLY, FREQUENCY_MINING)
	autolinkers = list("processor2", "supply", "mining")

// Three
/obj/machinery/telecoms/bus/preset_three
	id = "Bus 3"
	network = "tcomsat"
	freq_listening = list(FREQUENCY_SECURITY, FREQUENCY_COMMAND)
	autolinkers = list("processor3", "security", "command")

// Four
/obj/machinery/telecoms/bus/preset_four
	id = "Bus 4"
	network = "tcomsat"
	freq_listening = list(FREQUENCY_ENGINEERING, FREQUENCY_SERVICE)
	autolinkers = list("processor4", "engineering", "common", "service")

/obj/machinery/telecoms/bus/preset_four/New()
	for(var/i = FREQUENCY_FREE_MINIMUM, i < FREQUENCY_FREE_MAXIMUM, i += 2)
		freq_listening |= i
	return ..()

// CentCom
/obj/machinery/telecoms/bus/preset_cent
	id = "CentCom Bus"
	network = "tcomsat"
	freq_listening = list(FREQUENCY_RESPONSETEAM, FREQUENCY_DEATHSQUAD)
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("processorCent", "centcom")


// --- Processors ---
// One
/obj/machinery/telecoms/processor/preset_one
	id = "Processor 1"
	network = "tcomsat"
	autolinkers = list("processor1") // processors are sort of isolated; they don't need backward links

// Two
/obj/machinery/telecoms/processor/preset_two
	id = "Processor 2"
	network = "tcomsat"
	autolinkers = list("processor2")

// Three
/obj/machinery/telecoms/processor/preset_three
	id = "Processor 3"
	network = "tcomsat"
	autolinkers = list("processor3")

// Four
/obj/machinery/telecoms/processor/preset_four
	id = "Processor 4"
	network = "tcomsat"
	autolinkers = list("processor4")

// CentCom
/obj/machinery/telecoms/processor/preset_cent
	id = "CentCom Processor"
	network = "tcomsat"
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("processorCent")


// --- Servers ---
/obj/machinery/telecoms/server/presets
	network = "tcomsat"

// Science
/obj/machinery/telecoms/server/presets/science
	id = "Science Server"
	freq_listening = list(FREQUENCY_SCIENCE)
	autolinkers = list("science")

// Medical
/obj/machinery/telecoms/server/presets/medical
	id = "Medical Server"
	freq_listening = list(FREQUENCY_MEDICAL)
	autolinkers = list("medical")

// Supply
/obj/machinery/telecoms/server/presets/supply
	id = "Supply Server"
	freq_listening = list(FREQUENCY_SUPPLY)
	autolinkers = list("supply")

// Mining
/obj/machinery/telecoms/server/presets/mining
	id = "Mining Server"
	freq_listening = list(FREQUENCY_MINING)
	autolinkers = list("mining")

// Service
/obj/machinery/telecoms/server/presets/service
	id = "Service Server"
	freq_listening = list(FREQUENCY_SERVICE)
	autolinkers = list("service")

// Common
/obj/machinery/telecoms/server/presets/common
	id = "Common Server"
	freq_listening = list()
	autolinkers = list("common")

// Common and other radio frequencies for people to freely use
// By default, 1441 to 1489
/obj/machinery/telecoms/server/presets/common/New()
	for(var/i = FREQUENCY_FREE_MINIMUM, i < FREQUENCY_FREE_MAXIMUM, i += 2)
		freq_listening |= i
	return ..()

// Command
/obj/machinery/telecoms/server/presets/command
	id = "Command Server"
	freq_listening = list(FREQUENCY_COMMAND)
	autolinkers = list("command")

// Engineering
/obj/machinery/telecoms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(FREQUENCY_ENGINEERING)
	autolinkers = list("engineering")

// Security
/obj/machinery/telecoms/server/presets/security
	id = "Security Server"
	freq_listening = list(FREQUENCY_SECURITY)
	autolinkers = list("security")

// CentCom
/obj/machinery/telecoms/server/presets/centcom
	id = "CentCom Server"
	freq_listening = list(FREQUENCY_RESPONSETEAM, FREQUENCY_DEATHSQUAD)
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("centcom")


// --- Broadcasters ---
//--PRESET LEFT--//
/obj/machinery/telecoms/broadcaster/preset_left
	id = "Broadcaster A"
	network = "tcomsat"
	autolinkers = list("broadcasterA")

//--PRESET RIGHT--//
/obj/machinery/telecoms/broadcaster/preset_right
	id = "Broadcaster B"
	network = "tcomsat"
	autolinkers = list("broadcasterB")

// CentCom
/obj/machinery/telecoms/broadcaster/preset_cent
	id = "CentCom Broadcaster"
	network = "tcomsat"
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("broadcasterCent")