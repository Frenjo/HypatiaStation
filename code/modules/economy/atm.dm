/*

TODO:
give money an actual use (QM stuff, vending machines)
send money to people (might be worth attaching money to custom database thing for this, instead of being in the ID)
log transactions

*/

#define NO_SCREEN 0
#define CHANGE_SECURITY_LEVEL 1
#define TRANSFER_FUNDS 2
#define VIEW_TRANSACTION_LOGS 3

/obj/item/card/id/var/money = 2000

/obj/machinery/atm
	name = "\improper NanoTrasen automatic teller machine"
	desc = "For all your monetary needs!"
	icon = 'icons/obj/machines/terminals.dmi'
	icon_state = "atm"
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 10
	)

	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/card/id/held_card
	var/editing_security_level = 0
	var/view_screen = NO_SCREEN
	var/datum/effect/system/spark_spread/spark_system

/obj/machinery/atm/initialise()
	. = ..()
	machine_id = "[station_name()] RT #[global.CTeconomy.num_financial_terminals++]"
	spark_system = new /datum/effect/system/spark_spread(src)
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/machinery/atm/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/obj/machinery/atm/process()
	if(stat & NOPOWER)
		return

	if(ticks_left_timeout > 0)
		ticks_left_timeout--
		if(ticks_left_timeout <= 0)
			authenticated_account = null
	if(ticks_left_locked_down > 0)
		ticks_left_locked_down--
		if(ticks_left_locked_down <= 0)
			number_incorrect_tries = 0

	for(var/obj/item/cash/S in src)
		S.forceMove(loc)
		if(prob(50))
			playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)
		break

/obj/machinery/atm/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	//short out the machine, shoot sparks, spew money!
	emagged = TRUE
	spark_system.start()
	spawn_money(rand(100, 500), loc)
	//we don't want to grief people by locking their id in an emagged ATM
	release_held_id(user)

	//display a message to the user
	var/response = pick("Initiating withdraw. Have a nice day!", "CRITICAL ERROR: Activating cash chamber panic siphon.", "PIN Code accepted! Emptying account balance.", "Jackpot!")
	to_chat(user, SPAN_WARNING("\icon[src] \The [src] beeps: \"[response]\""))
	return TRUE

/obj/machinery/atm/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id))
		if(emagged)
			//prevent inserting id into an emagged ATM
			to_chat(user, SPAN_WARNING("\icon[src] CARD READER ERROR. This system has been compromised!"))
			return

		if(isnull(held_card))
			usr.drop_item()
			I.forceMove(src)
			held_card = I
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
				authenticated_account = null
	else if(authenticated_account)
		if(istype(I, /obj/item/cash))
			//consume the money
			authenticated_account.money += I:worth
			if(prob(50))
				playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
			else
				playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

			//create a transaction log entry
			var/datum/transaction/T = new /datum/transaction()
			T.target_name = authenticated_account.owner_name
			T.purpose = "Credit deposit"
			T.amount = I:worth
			T.source_terminal = machine_id
			T.date = global.CTeconomy.current_date_string
			T.time = worldtime2text()
			authenticated_account.transaction_log.Add(T)

			to_chat(user, SPAN_INFO("You insert [I] into [src]."))
			src.attack_hand(user)
			qdel(I)
	else
		..()

/obj/machinery/atm/attack_hand(mob/user)
	if(issilicon(user))
		to_chat(user, SPAN_WARNING("\icon[src] Artificial unit recognized. Artificial units do not currently receive monetary compensation, as per NanoTrasen regulation #1005."))
		return
	if(in_range(src, user))
		//js replicated from obj/machinery/computer/card
		var/dat = "<h1>NanoTrasen Automatic Teller Machine</h1>"
		dat += "For all your monetary needs!<br>"
		dat += "<i>This terminal is</i> [machine_id]. <i>Report this code when contacting NanoTrasen IT Support</i><br/>"

		if(emagged > 0)
			dat += "Card: <span style='color: red;'>LOCKED</span><br><br><span style='color: red;'>Unauthorized terminal access detected! This ATM has been locked. Please contact NanoTrasen IT Support.</span>"
		else
			dat += "Card: <a href='byond://?src=\ref[src];choice=insert_card'>[isnotnull(held_card) ? held_card.name : "------"]</a><br><br>"

			if(ticks_left_locked_down > 0)
				dat += SPAN_ALERT("Maximum number of pin attempts exceeded! Access to this ATM has been temporarily disabled.")
			else if(authenticated_account)
				if(authenticated_account.suspended)
					dat += SPAN_DANGER("Access to this account has been suspended, and the funds within frozen.")
				else
					switch(view_screen)
						if(CHANGE_SECURITY_LEVEL)
							dat += "Select a new security level for this account:<br><hr>"
							var/text = "Zero - Either the account number or card is required to access this account. EFTPOS transactions will require a card and ask for a pin, but not verify the pin is correct."
							if(authenticated_account.security_level != 0)
								text = "<A href='byond://?src=\ref[src];choice=change_security_level;new_security_level=0'>[text]</a>"
							dat += "[text]<hr>"
							text = "One - An account number and pin must be manually entered to access this account and process transactions."
							if(authenticated_account.security_level != 1)
								text = "<A href='byond://?src=\ref[src];choice=change_security_level;new_security_level=1'>[text]</a>"
							dat += "[text]<hr>"
							text = "Two - In addition to account number and pin, a card is required to access this account and process transactions."
							if(authenticated_account.security_level != 2)
								text = "<A href='byond://?src=\ref[src];choice=change_security_level;new_security_level=2'>[text]</a>"
							dat += "[text]<hr><br>"
							dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=0'>Back</a>"
						if(VIEW_TRANSACTION_LOGS)
							dat += "<b>Transaction logs</b><br>"
							dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=0'>Back</a>"
							dat += "<table border=1 style='width:100%'>"
							dat += "<tr>"
							dat += "<td><b>Date</b></td>"
							dat += "<td><b>Time</b></td>"
							dat += "<td><b>Target</b></td>"
							dat += "<td><b>Purpose</b></td>"
							dat += "<td><b>Value</b></td>"
							dat += "<td><b>Source terminal ID</b></td>"
							dat += "</tr>"
							for_no_type_check(var/datum/transaction/T, authenticated_account.transaction_log)
								dat += "<tr>"
								dat += "<td>[T.date]</td>"
								dat += "<td>[T.time]</td>"
								dat += "<td>[T.target_name]</td>"
								dat += "<td>[T.purpose]</td>"
								dat += "<td>$[T.amount]</td>"
								dat += "<td>[T.source_terminal]</td>"
								dat += "</tr>"
							dat += "</table>"
							dat += "<A href='byond://?src=\ref[src];choice=print_transaction'>Print</a><br>"
						if(TRANSFER_FUNDS)
							dat += "<b>Account balance:</b> $[authenticated_account.money]<br>"
							dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=0'>Back</a><br><br>"
							dat += "<form name='transfer' action='?src=\ref[src]' method='get'>"
							dat += "<input type='hidden' name='src' value='\ref[src]'>"
							dat += "<input type='hidden' name='choice' value='transfer'>"
							dat += "Target account number: <input type='text' name='target_acc_number' value='' style='width:200px; background-color:white;'><br>"
							dat += "Funds to transfer: <input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><br>"
							dat += "Transaction purpose: <input type='text' name='purpose' value='Funds transfer' style='width:200px; background-color:white;'><br>"
							dat += "<input type='submit' value='Transfer funds'><br>"
							dat += "</form>"
						else
							dat += "Welcome, <b>[authenticated_account.owner_name].</b><br/>"
							dat += "<b>Account balance:</b> $[authenticated_account.money]"
							dat += "<form name='withdrawal' action='?src=\ref[src]' method='get'>"
							dat += "<input type='hidden' name='src' value='\ref[src]'>"
							dat += "<input type='hidden' name='choice' value='withdrawal'>"
							dat += "<input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><input type='submit' value='Withdraw charge card'>"
							dat += "</form>"
							dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=1'>Change account security level</a><br>"
							dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=2'>Make transfer</a><br>"
							dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=3'>View transaction log</a><br>"
							dat += "<A href='byond://?src=\ref[src];choice=balance_statement'>Print balance statement</a><br>"
							dat += "<A href='byond://?src=\ref[src];choice=logout'>Logout</a><br>"
			else
				dat += "<form name='atm_auth' action='?src=\ref[src]' method='get'>"
				dat += "<input type='hidden' name='src' value='\ref[src]'>"
				dat += "<input type='hidden' name='choice' value='attempt_auth'>"
				dat += "<b>Account:</b> <input type='text' id='account_num' name='account_num' style='width:250px; background-color:white;'><br>"
				dat += "<b>PIN:</b> <input type='text' id='account_pin' name='account_pin' style='width:250px; background-color:white;'><br>"
				dat += "<input type='submit' value='Submit'><br>"
				dat += "</form>"

		user << browse(dat,"window=atm;size=550x650")
	else
		user << browse(null,"window=atm")

/obj/machinery/atm/Topic(href, href_list)
	if(href_list["choice"])
		switch(href_list["choice"])
			if("transfer")
				if(authenticated_account)
					var/transfer_amount = text2num(href_list["funds_amount"])
					if(transfer_amount <= 0)
						alert("That is not a valid amount.")
					else if(transfer_amount <= authenticated_account.money)
						var/target_account_number = text2num(href_list["target_acc_number"])
						var/transfer_purpose = href_list["purpose"]
						if(charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
							to_chat(usr, SPAN_INFO("\icon[src] Funds transfer successful."))
							authenticated_account.money -= transfer_amount

							//create an entry in the account transaction log
							var/datum/transaction/T = new /datum/transaction()
							T.target_name = "Account #[target_account_number]"
							T.purpose = transfer_purpose
							T.source_terminal = machine_id
							T.date = global.CTeconomy.current_date_string
							T.time = worldtime2text()
							T.amount = "([transfer_amount])"
							authenticated_account.transaction_log.Add(T)
						else
							to_chat(usr, SPAN_WARNING("\icon[src] Funds transfer failed."))

					else
						to_chat(usr, SPAN_WARNING("\icon[src] You don't have enough funds to do that!"))
			if("view_screen")
				view_screen = text2num(href_list["view_screen"])
			if("change_security_level")
				if(authenticated_account)
					var/new_sec_level = max(min(text2num(href_list["new_security_level"]), 2), 0)
					authenticated_account.security_level = new_sec_level
			if("attempt_auth")
				// check if they have low security enabled
				scan_user(usr)

				if(!ticks_left_locked_down && isnotnull(held_card))
					var/tried_account_num = text2num(href_list["account_num"])
					if(!tried_account_num)
						tried_account_num = held_card.associated_account_number
					var/tried_pin = text2num(href_list["account_pin"])

					authenticated_account = attempt_account_access(tried_account_num, tried_pin, held_card?.associated_account_number == tried_account_num ? 2 : 1)
					if(!authenticated_account)
						number_incorrect_tries++
						if(previous_account_number == tried_account_num)
							if(number_incorrect_tries > max_pin_attempts)
								//lock down the atm
								ticks_left_locked_down = 30
								playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)

								//create an entry in the account transaction log
								var/datum/money_account/failed_account = get_account(tried_account_num)
								if(failed_account)
									var/datum/transaction/T = new /datum/transaction()
									T.target_name = failed_account.owner_name
									T.purpose = "Unauthorised login attempt"
									T.source_terminal = machine_id
									T.date = global.CTeconomy.current_date_string
									T.time = worldtime2text()
									failed_account.transaction_log.Add(T)
							else
								to_chat(usr, SPAN_WARNING("\icon[src] Incorrect pin/account combination entered, [max_pin_attempts - number_incorrect_tries] attempts remaining."))
								previous_account_number = tried_account_num
								playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
						else
							to_chat(usr, SPAN_WARNING("\icon[src] incorrect pin/account combination entered."))
							number_incorrect_tries = 0
					else
						playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
						ticks_left_timeout = 120
						view_screen = NO_SCREEN

						//create a transaction log entry
						var/datum/transaction/T = new /datum/transaction()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Remote terminal access"
						T.source_terminal = machine_id
						T.date = global.CTeconomy.current_date_string
						T.time = worldtime2text()
						authenticated_account.transaction_log.Add(T)

						to_chat(usr, SPAN_INFO("\icon[src] Access granted. Welcome user '[authenticated_account.owner_name].'"))

					previous_account_number = tried_account_num
			if("withdrawal")
				var/amount = max(text2num(href_list["funds_amount"]),0)
				if(amount <= 0)
					alert("That is not a valid amount.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//remove the money
						authenticated_account.money -= amount
						//	spawn_money(amount,src.loc)
						spawn_charge_card(amount, loc)

						//create an entry in the account transaction log
						var/datum/transaction/T = new /datum/transaction()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Credit withdrawal"
						T.amount = "([amount])"
						T.source_terminal = machine_id
						T.date = global.CTeconomy.current_date_string
						T.time = worldtime2text()
						authenticated_account.transaction_log.Add(T)
					else
						to_chat(usr, SPAN_WARNING("\icon[src] You don't have enough funds to do that!"))
			if("balance_statement")
				if(authenticated_account)
					var/obj/item/paper/R = new(src.loc)
					R.name = "Account balance: [authenticated_account.owner_name]"
					R.info = "<b>NT Automated Teller Account Statement</b><br><br>"
					R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
					R.info += "<i>Account number:</i> [authenticated_account.account_number]<br>"
					R.info += "<i>Balance:</i> $[authenticated_account.money]<br>"
					R.info += "<i>Date and time:</i> [worldtime2text()], [global.CTeconomy.current_date_string]<br><br>"
					R.info += "<i>Service terminal ID:</i> [machine_id]<br>"

					//stamp the paper
					var/mutable_appearance/stamp_overlay = mutable_appearance('icons/obj/bureaucracy.dmi', "paper_stamp-cent")
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/stamp
					R.add_overlay(stamp_overlay)
					R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

			if("print_transaction")
				if(authenticated_account)
					var/obj/item/paper/R = new(src.loc)
					R.name = "Transaction logs: [authenticated_account.owner_name]"
					R.info = "<b>Transaction logs</b><br>"
					R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
					R.info += "<i>Account number:</i> [authenticated_account.account_number]<br>"
					R.info += "<i>Date and time:</i> [worldtime2text()], [global.CTeconomy.current_date_string]<br><br>"
					R.info += "<i>Service terminal ID:</i> [machine_id]<br>"
					R.info += "<table border=1 style='width:100%'>"
					R.info += "<tr>"
					R.info += "<td><b>Date</b></td>"
					R.info += "<td><b>Time</b></td>"
					R.info += "<td><b>Target</b></td>"
					R.info += "<td><b>Purpose</b></td>"
					R.info += "<td><b>Value</b></td>"
					R.info += "<td><b>Source terminal ID</b></td>"
					R.info += "</tr>"
					for_no_type_check(var/datum/transaction/T, authenticated_account.transaction_log)
						R.info += "<tr>"
						R.info += "<td>[T.date]</td>"
						R.info += "<td>[T.time]</td>"
						R.info += "<td>[T.target_name]</td>"
						R.info += "<td>[T.purpose]</td>"
						R.info += "<td>$[T.amount]</td>"
						R.info += "<td>[T.source_terminal]</td>"
						R.info += "</tr>"
					R.info += "</table>"

					//stamp the paper
					var/mutable_appearance/stamp_overlay = mutable_appearance('icons/obj/bureaucracy.dmi', "paper_stamp-cent")
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/stamp
					R.add_overlay(stamp_overlay)
					R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

			if("insert_card")
				if(isnull(held_card))
					//this might happen if the user had the browser window open when somebody emagged it
					if(emagged > 0)
						to_chat(usr, SPAN_WARNING("\icon[src] The ATM card reader rejected your ID because this machine has been sabotaged!"))
					else
						var/obj/item/I = usr.get_active_hand()
						if(istype(I, /obj/item/card/id))
							usr.drop_item()
							I.forceMove(src)
							held_card = I
				else
					release_held_id(usr)
			if("logout")
				authenticated_account = null
				//usr << browse(null,"window=atm")

	src.attack_hand(usr)

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user)
	if(!authenticated_account)
		if(human_user.id_store)
			var/obj/item/card/id/I
			if(istype(human_user.id_store, /obj/item/card/id))
				I = human_user.id_store
			else if(istype(human_user.id_store, /obj/item/pda))
				var/obj/item/pda/P = human_user.id_store
				I = P.id
			if(I)
				authenticated_account = attempt_account_access(I.associated_account_number)
				if(authenticated_account)
					to_chat(human_user, SPAN_INFO("\icon[src] Access granted. Welcome user '[authenticated_account.owner_name].'"))

					//create a transaction log entry
					var/datum/transaction/T = new /datum/transaction()
					T.target_name = authenticated_account.owner_name
					T.purpose = "Remote terminal access"
					T.source_terminal = machine_id
					T.date = global.CTeconomy.current_date_string
					T.time = worldtime2text()
					authenticated_account.transaction_log.Add(T)

					view_screen = NO_SCREEN

// put the currently held id on the ground or in the hand of the user
/obj/machinery/atm/proc/release_held_id(mob/living/carbon/human/human_user)
	if(isnull(held_card))
		return

	held_card.forceMove(loc)
	authenticated_account = null

	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(held_card)
	held_card = null

/obj/machinery/atm/proc/spawn_charge_card(sum, loc)
	var/obj/item/cash/charge_card/E = new /obj/item/cash/charge_card(loc)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name

#undef NO_SCREEN
#undef CHANGE_SECURITY_LEVEL
#undef TRANSFER_FUNDS
#undef VIEW_TRANSACTION_LOGS