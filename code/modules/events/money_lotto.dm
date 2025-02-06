/datum/round_event/money_lotto
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = FALSE

/datum/round_event/money_lotto/start()
	winner_sum = pick(5000, 10000, 50000, 100000, 500000, 1000000, 1500000)
	if(length(global.CTeconomy.all_money_accounts))
		var/datum/money_account/D = pick(global.CTeconomy.all_money_accounts)
		winner_name = D.owner_name
		if(!D.suspended)
			D.money += winner_sum

			var/datum/transaction/T = new /datum/transaction()
			T.target_name = "Tau Ceti Daily Grand Slam -Stellar- Lottery"
			T.purpose = "Winner!"
			T.amount = winner_sum
			T.date = global.CTeconomy.current_date_string
			T.time = worldtime2text()
			T.source_terminal = "Biesel TCD Terminal #[rand(111, 333)]"
			D.transaction_log.Add(T)

			deposit_success = TRUE

/datum/round_event/money_lotto/announce()
	var/datum/feed_message/newMsg = new /datum/feed_message()
	newMsg.author = "NanoTrasen Editor"
	newMsg.is_admin_message = TRUE

	newMsg.body = "TC Daily wishes to congratulate <b>[winner_name]</b> for recieving the Tau Ceti Stellar Slam Lottery, and receiving the out of this world sum of [winner_sum] credits!"
	if(!deposit_success)
		newMsg.body += "<br>Unfortunately, we were unable to verify the account details provided, so we were unable to transfer the money. Send a cheque containing the sum of $500 to TCD 'Stellar Slam' office on Biesel Prime containing updated details, and your winnings'll be resent within the month."

	for_no_type_check(var/datum/feed_channel/FC, global.CTeconomy.news_network.channels)
		if(FC.channel_name == "Tau Ceti Daily")
			FC.messages.Add(newMsg)
			break

	for_no_type_check(var/obj/machinery/newscaster/caster, GLOBL.all_newscasters)
		caster.newsAlert("Tau Ceti Daily")