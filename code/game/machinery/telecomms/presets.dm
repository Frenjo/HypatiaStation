// ### Preset machines  ###

//Relay

/obj/machinery/telecomms/relay/preset
	network = "tcommsat"

/obj/machinery/telecomms/relay/preset/station
	id = "Station Relay"
	listening_level = 1
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/telecomms
	id = "Telecomms Relay"
	autolinkers = list("relay")

/obj/machinery/telecomms/relay/preset/mining
	id = "Mining Relay"
	autolinkers = list("m_relay")

/obj/machinery/telecomms/relay/preset/ruskie
	id = "Ruskie Relay"
	hide = 1
	toggled = 0
	autolinkers = list("r_relay")

/obj/machinery/telecomms/relay/preset/centcom
	id = "Centcom Relay"
	hide = 1
	toggled = 1
	//anchored = 1
	//use_power = 0
	//idle_power_usage = 0
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("c_relay")

//HUB

/obj/machinery/telecomms/hub/preset
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub", "relay", "c_relay", "s_relay", "m_relay", "r_relay", "science", "medical",
	"supply", "mining", "common", "command", "engineering", "security",
	"receiverA", "receiverB", "broadcasterA", "broadcasterB")

/obj/machinery/telecomms/hub/preset_cent
	id = "CentComm Hub"
	network = "tcommsat"
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("hub_cent", "c_relay", "s_relay", "m_relay", "r_relay",
	 "centcomm", "receiverCent", "broadcasterCent")

//Receivers

//--PRESET LEFT--//

/obj/machinery/telecomms/receiver/preset_left
	id = "Receiver A"
	network = "tcommsat"
	autolinkers = list("receiverA") // link to relay
	freq_listening = list(FREQUENCY_SCIENCE, FREQUENCY_MEDICAL, FREQUENCY_SUPPLY) // science, medical, supply


//--PRESET RIGHT--//

/obj/machinery/telecomms/receiver/preset_right
	id = "Receiver B"
	network = "tcommsat"
	autolinkers = list("receiverB") // link to relay
	freq_listening = list(FREQUENCY_COMMAND, FREQUENCY_ENGINEERING, FREQUENCY_SECURITY) //command, engineering, security

	//Common and other radio frequencies for people to freely use
	New()
		for(var/i = 1441, i < 1489, i += 2)
			freq_listening |= i
		..()

/obj/machinery/telecomms/receiver/preset_cent
	id = "CentComm Receiver"
	network = "tcommsat"
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("receiverCent")
	freq_listening = list(FREQUENCY_RESPONSETEAM, FREQUENCY_DEATHSQUAD)


//Buses

/obj/machinery/telecomms/bus/preset_one
	id = "Bus 1"
	network = "tcommsat"
	freq_listening = list(FREQUENCY_SCIENCE, FREQUENCY_MEDICAL)
	autolinkers = list("processor1", "science", "medical")

/obj/machinery/telecomms/bus/preset_two
	id = "Bus 2"
	network = "tcommsat"
	freq_listening = list(FREQUENCY_SUPPLY, FREQUENCY_MINING)
	autolinkers = list("processor2", "supply", "mining")

/obj/machinery/telecomms/bus/preset_three
	id = "Bus 3"
	network = "tcommsat"
	freq_listening = list(FREQUENCY_SECURITY, FREQUENCY_COMMAND)
	autolinkers = list("processor3", "security", "command")

/obj/machinery/telecomms/bus/preset_four
	id = "Bus 4"
	network = "tcommsat"
	freq_listening = list(FREQUENCY_ENGINEERING)
	autolinkers = list("processor4", "engineering", "common")

/obj/machinery/telecomms/bus/preset_four/New()
	for(var/i = 1441, i < 1489, i += 2)
		freq_listening |= i
	..()

/obj/machinery/telecomms/bus/preset_cent
	id = "CentComm Bus"
	network = "tcommsat"
	freq_listening = list(FREQUENCY_RESPONSETEAM, FREQUENCY_DEATHSQUAD)
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("processorCent", "centcomm")

//Processors

/obj/machinery/telecomms/processor/preset_one
	id = "Processor 1"
	network = "tcommsat"
	autolinkers = list("processor1") // processors are sort of isolated; they don't need backward links

/obj/machinery/telecomms/processor/preset_two
	id = "Processor 2"
	network = "tcommsat"
	autolinkers = list("processor2")

/obj/machinery/telecomms/processor/preset_three
	id = "Processor 3"
	network = "tcommsat"
	autolinkers = list("processor3")

/obj/machinery/telecomms/processor/preset_four
	id = "Processor 4"
	network = "tcommsat"
	autolinkers = list("processor4")

/obj/machinery/telecomms/processor/preset_cent
	id = "CentComm Processor"
	network = "tcommsat"
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("processorCent")

//Servers

/obj/machinery/telecomms/server/presets

	network = "tcommsat"

/obj/machinery/telecomms/server/presets/science
	id = "Science Server"
	freq_listening = list(FREQUENCY_SCIENCE)
	autolinkers = list("science")

/obj/machinery/telecomms/server/presets/medical
	id = "Medical Server"
	freq_listening = list(FREQUENCY_MEDICAL)
	autolinkers = list("medical")

/obj/machinery/telecomms/server/presets/supply
	id = "Supply Server"
	freq_listening = list(FREQUENCY_SUPPLY)
	autolinkers = list("supply")

/obj/machinery/telecomms/server/presets/mining
	id = "Mining Server"
	freq_listening = list(FREQUENCY_MINING)
	autolinkers = list("mining")

/obj/machinery/telecomms/server/presets/common
	id = "Common Server"
	freq_listening = list()
	autolinkers = list("common")

//Common and other radio frequencies for people to freely use
// 1441 to 1489
/obj/machinery/telecomms/server/presets/common/New()
	for(var/i = 1441, i < 1489, i += 2)
		freq_listening |= i
	..()

/obj/machinery/telecomms/server/presets/command
	id = "Command Server"
	freq_listening = list(FREQUENCY_COMMAND)
	autolinkers = list("command")

/obj/machinery/telecomms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(FREQUENCY_ENGINEERING)
	autolinkers = list("engineering")

/obj/machinery/telecomms/server/presets/security
	id = "Security Server"
	freq_listening = list(FREQUENCY_SECURITY)
	autolinkers = list("security")

/obj/machinery/telecomms/server/presets/centcomm
	id = "CentComm Server"
	freq_listening = list(FREQUENCY_RESPONSETEAM, FREQUENCY_DEATHSQUAD)
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("centcomm")


//Broadcasters

//--PRESET LEFT--//

/obj/machinery/telecomms/broadcaster/preset_left
	id = "Broadcaster A"
	network = "tcommsat"
	autolinkers = list("broadcasterA")

//--PRESET RIGHT--//

/obj/machinery/telecomms/broadcaster/preset_right
	id = "Broadcaster B"
	network = "tcommsat"
	autolinkers = list("broadcasterB")

/obj/machinery/telecomms/broadcaster/preset_cent
	id = "CentComm Broadcaster"
	network = "tcommsat"
	//heatgen = 0
	operating_temperature = null
	autolinkers = list("broadcasterCent")