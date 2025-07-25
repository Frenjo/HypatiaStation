/datum/money_account
	var/owner_name = ""
	var/account_number = 0
	var/remote_access_pin = 0
	var/money = 0
	var/list/transaction_log = list()
	var/suspended = 0
	var/security_level = 0	//0 - auto-identify from worn ID, require only account number
							//1 - require manual login / account number and pin
							//2 - require card and manual login

/datum/transaction
	var/target_name = ""
	var/purpose = ""
	var/amount = 0
	var/date = ""
	var/time = ""
	var/source_terminal = ""

/proc/create_money_account(new_owner_name = "Default user", starting_funds = 0, obj/machinery/account_database/source_db)
	//create a new account
	var/datum/money_account/M = new /datum/money_account()
	M.owner_name = new_owner_name
	M.remote_access_pin = rand(1111, 111111)
	M.money = starting_funds

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new /datum/transaction()
	T.target_name = new_owner_name
	T.purpose = "Account creation"
	T.amount = starting_funds
	if(!source_db)
		//set a random date, time and location some time over the past few decades
		T.date = "[num2text(rand(1, 31))] [pick(GLOBL.months)], 25[rand(10, 56)]"
		T.time = "[rand(0, 24)]:[rand(11, 59)]"
		T.source_terminal = "NTGalaxyNet Terminal #[rand(111,1111)]"

		M.account_number = rand(111111, 999999)
	else
		T.date = global.CTeconomy.current_date_string
		T.time = worldtime2text()
		T.source_terminal = source_db.machine_id

		M.account_number = global.CTeconomy.next_account_number
		global.CTeconomy.next_account_number += rand(1, 25)

		//create a sealed package containing the account details
		var/obj/item/small_delivery/P = new /obj/item/small_delivery(source_db.loc)

		var/obj/item/paper/R = new /obj/item/paper(P)
		P.wrapped = R
		R.name = "Account information: [M.owner_name]"
		R.info = "<b>Account details (confidential)</b><br><hr><br>"
		R.info += "<i>Account holder:</i> [M.owner_name]<br>"
		R.info += "<i>Account number:</i> [M.account_number]<br>"
		R.info += "<i>Account pin:</i> [M.remote_access_pin]<br>"
		R.info += "<i>Starting balance:</i> $[M.money]<br>"
		R.info += "<i>Date and time:</i> [worldtime2text()], [global.CTeconomy.current_date_string]<br><br>"
		R.info += "<i>Creation terminal ID:</i> [source_db.machine_id]<br>"
		R.info += "<i>Authorised NT officer overseeing creation:</i> [source_db.held_card.registered_name]<br>"

		//stamp the paper
		var/mutable_appearance/stamp_overlay = mutable_appearance('icons/obj/bureaucracy.dmi', "paper_stamp-cent")
		if(!R.stamped)
			R.stamped = list()
		R.stamped.Add(/obj/item/stamp)
		R.add_overlay(stamp_overlay)
		R.stamps += "<HR><i>This paper has been stamped by the Accounts Database.</i>"

	//add the account
	M.transaction_log.Add(T)
	global.CTeconomy.all_money_accounts.Add(M)

	return M

/proc/charge_to_account(attempt_account_number, source_name, purpose, terminal_id, amount)
	for_no_type_check(var/datum/money_account/D, global.CTeconomy.all_money_accounts)
		if(D.account_number == attempt_account_number && !D.suspended)
			D.money += amount

			//create a transaction log entry
			var/datum/transaction/T = new /datum/transaction()
			T.target_name = source_name
			T.purpose = purpose
			if(amount < 0)
				T.amount = "([amount])"
			else
				T.amount = "[amount]"
			T.date = global.CTeconomy.current_date_string
			T.time = worldtime2text()
			T.source_terminal = terminal_id
			D.transaction_log.Add(T)

			return 1
		break

	return 0

//this returns the first account datum that matches the supplied accnum/pin combination, it returns null if the combination did not match any account
/proc/attempt_account_access(attempt_account_number, attempt_pin_number, security_level_passed = 0)
	for_no_type_check(var/datum/money_account/D, global.CTeconomy.all_money_accounts)
		if(D.account_number == attempt_account_number)
			if(D.security_level <= security_level_passed && (!D.security_level || D.remote_access_pin == attempt_pin_number))
				return D
			break

/proc/get_account(account_number)
	for_no_type_check(var/datum/money_account/D, global.CTeconomy.all_money_accounts)
		if(D.account_number == account_number)
			return D