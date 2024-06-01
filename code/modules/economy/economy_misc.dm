
// Events
#define RIOTS 1
#define WILD_ANIMAL_ATTACK 2
#define INDUSTRIAL_ACCIDENT 3
#define BIOHAZARD_OUTBREAK 4
#define WARSHIPS_ARRIVE 5
#define PIRATES 6
#define CORPORATE_ATTACK 7
#define ALIEN_RAIDERS 8
#define AI_LIBERATION 9
#define MOURNING 10
#define CULT_CELL_REVEALED 11
#define SECURITY_BREACH 12
#define ANIMAL_RIGHTS_RAID 13
#define FESTIVAL 14

// Mundane Events
#define RESEARCH_BREAKTHROUGH 15
#define BARGAINS 16
#define SONG_DEBUT 17
#define MOVIE_RELEASE 18
#define BIG_GAME_HUNTERS 19
#define ELECTION 20
#define GOSSIP 21
#define TOURISM 22
#define CELEBRITY_DEATH 23
#define RESIGNATION 24

// Location Types?
#define DEFAULT 1

#define ADMINISTRATIVE 2
#define CLOTHING 3
#define SECURITY 4
#define SPECIAL_SECURITY 5

#define FOOD 6
#define ANIMALS 7

#define MINERALS 8

#define EMERGENCY 9
#define GAS 10
#define MAINTENANCE 11
#define ELECTRICAL 12
#define ROBOTICS 13
#define BIOMEDICAL 14

#define GEAR_EVA 15

//---- The following corporations are friendly with NanoTrasen and loosely enable trade and travel:
//Corporation NanoTrasen - Generalised / high tech research and plasma exploitation.
//Corporation Vessel Contracting - Ship and station construction, materials research.
//Corporation Osiris Atmospherics - Atmospherics machinery construction and chemical research.
//Corporation Second Red Cross Society - 26th century Red Cross reborn as a dominating economic force in biomedical science (research and materials).
//Corporation Blue Industries - High tech and high energy research, in particular into the mysteries of bluespace manipulation and power generation.
//Corporation Kusanagi Robotics - Founded by robotics legend Kaito Kusanagi in the 2070s, they have been on the forefront of mechanical augmentation and robotics development ever since.
//Corporation Free traders - Not so much a corporation as a loose coalition of spacers, Free Traders are a roving band of smugglers, traders and fringe elements following a rigid (if informal) code of loyalty and honour. Mistrusted by most corporations, they are tolerated because of their uncanny ability to smell out a profit.

//---- Descriptions of destination types
//Space stations can be purpose built for a number of different things, but generally require regular shipments of essential supplies.
//Corvettes are small, fast warships generally assigned to border patrol or chasing down smugglers.
//Battleships are large, heavy cruisers designed for slugging it out with other heavies or razing planets.
//Yachts are fast civilian craft, often used for pleasure or smuggling.
//Destroyers are medium sized vessels, often used for escorting larger ships but able to go toe-to-toe with them if need be.
//Frigates are medium sized vessels, often used for escorting larger ships. They will rapidly find themselves outclassed if forced to face heavy warships head on.

var/global/current_date_string

GLOBAL_GLOBL_INIT(economy_init, FALSE)
GLOBAL_GLOBL_INIT(datum/money_account/station_account, null)
GLOBAL_GLOBL_INIT(datum/money_account/vendor_account, null)
var/global/num_financial_terminals = 1
var/global/next_account_number = 0
var/global/list/all_money_accounts = list()

/proc/setup_economy()
	if(GLOBL.economy_init)
		return 2

	var/datum/feed_channel/newChannel = new /datum/feed_channel
	newChannel.channel_name = "Tau Ceti Daily"
	newChannel.author = "CentCom Minister of Information"
	newChannel.locked = 1
	newChannel.is_admin_channel = 1
	news_network.network_channels += newChannel

	newChannel = new /datum/feed_channel
	newChannel.channel_name = "The Gibson Gazette"
	newChannel.author = "Editor Mike Hammers"
	newChannel.locked = 1
	newChannel.is_admin_channel = 1
	news_network.network_channels += newChannel

	for(var/loc_type in SUBTYPESOF(/datum/trade_destination))
		var/datum/trade_destination/D = new loc_type
		GLOBL.weighted_randomevent_locations[D] = length(D.viable_random_events)
		GLOBL.weighted_mundaneevent_locations[D] = length(D.viable_mundane_events)

	// Creates the station and vendor accounts.
	GLOBL.station_account = create_special_money_account("[station_name()] Station", 75000)
	GLOBL.vendor_account = create_special_money_account("Vendor", 5000)
	// Creates departmental accounts.
	for(var/department_path in SUBTYPESOF(/decl/department))
		var/decl/department/department = GET_DECL_INSTANCE(department_path)
		department.account = create_special_money_account(department.name, 5000)

	current_date_string = "[num2text(rand(1, 31))] [pick(GLOBL.months)], [GLOBL.game_year]"

	GLOBL.economy_init = TRUE
	return 1

/proc/create_special_money_account(owner_name, starting_money)
	RETURN_TYPE(/datum/money_account)

	next_account_number = rand(111111, 999999)

	var/datum/money_account/account = new /datum/money_account()
	account.owner_name = "[owner_name] Account"
	account.account_number = rand(111111, 999999)
	account.remote_access_pin = rand(1111, 111111)
	account.money = starting_money

	// Creates an entry in the account transaction log for when it was created.
	var/datum/transaction/T = new /datum/transaction()
	T.target_name = account.owner_name
	T.purpose = "Account creation"
	T.amount = starting_money
	T.date = "2nd April, 2555"
	T.time = "11:24"
	T.source_terminal = "Biesel GalaxyNet Terminal #277"

	// Adds the account.
	account.transaction_log.Add(T)
	all_money_accounts.Add(account)

	return account