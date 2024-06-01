/*
 * Economy Controller
 *
 * Handles newscaster feed channels, money accounts, and related variables.
 */
CONTROLLER_DEF(economy)
	name = "Economy"

	/*
	 * Newscasters
	 */
	// The global news network.
	var/datum/feed_network/news_network = new /datum/feed_network()

	/*
	 * Money Accounts
	 */
	// The current date string used for economy things.
	// This actually seems to pick a random day and month within the defined game year so it's not current, is it???
	var/current_date_string = null
	// The next account number to use when creating an account.
	var/next_account_number = 0
	// The number of financial terminals on the station.
	var/num_financial_terminals = 0

	// The station, vendor and list of all money accounts.
	var/datum/money_account/station_account = null
	var/datum/money_account/vendor_account = null
	var/list/datum/money_account/all_money_accounts = list()

/datum/controller/economy/New()
	. = ..()

	// Creates newscaster feed channels.
	var/datum/feed_channel/channel = new /datum/feed_channel()
	channel.channel_name = "Tau Ceti Daily"
	channel.author = "CentCom Minister of Information"
	channel.locked = TRUE
	channel.is_admin_channel = TRUE
	news_network.channels.Add(channel)

	channel = new /datum/feed_channel()
	channel.channel_name = "The Gibson Gazette"
	channel.author = "Editor Mike Hammers"
	channel.locked = TRUE
	channel.is_admin_channel = TRUE
	news_network.channels.Add(channel)

	// Sets the current date string.
	current_date_string = "[num2text(rand(1, 31))] [pick(GLOBL.months)], [GLOBL.game_year]"

	// Sets up trade destinations.
	for(var/location_type in SUBTYPESOF(/datum/trade_destination))
		var/datum/trade_destination/D = new location_type()
		GLOBL.weighted_randomevent_locations[D] = length(D.viable_random_events)
		GLOBL.weighted_mundaneevent_locations[D] = length(D.viable_mundane_events)

	// Creates the station and vendor accounts.
	station_account = create_special_money_account("[station_name()] Station", 75000)
	vendor_account = create_special_money_account("Vendor", 5000)
	// Creates departmental accounts.
	for(var/department_path in SUBTYPESOF(/decl/department))
		var/decl/department/department = GET_DECL_INSTANCE(department_path)
		department.account = create_special_money_account(department.name, 5000)

/datum/controller/economy/proc/create_special_money_account(owner_name, starting_money = 0)
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