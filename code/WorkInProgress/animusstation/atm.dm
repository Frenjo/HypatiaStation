//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:06

/*

TODO:
give money an actual use (QM stuff, vending machines)
send money to people (might be worth attaching money to custom database thing for this, instead of being in the ID)
log transactions

*/

/obj/machinery/atm
	name = "\improper NanoTrasen Automatic Teller Machine"
	desc = "For all your monetary needs!"
	icon = 'icons/obj/machines/terminals.dmi'
	icon_state = "atm"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 10
	var/obj/item/card/id/card
	var/obj/item/cash/cashes = list()
	var/inserted = 0
	var/accepted = 0
	var/pincode = 0

	attackby(var/obj/A, var/mob/user)
		if(istype(A,/obj/item/cash))
			cashes += A
			user.drop_item()
			A.forceMove(src)
			inserted += A:worth
			return
		if(istype(A,/obj/item/coin))
			if(istype(A,/obj/item/coin/iron))
				cashes += A
				user.drop_item()
				A.forceMove(src)
				inserted += 1
				return
			if(istype(A,/obj/item/coin/silver))
				cashes += A
				user.drop_item()
				A.forceMove(src)
				inserted += 10
				return
			if(istype(A,/obj/item/coin/gold))
				cashes += A
				user.drop_item()
				A.forceMove(src)
				inserted += 50
				return
			if(istype(A,/obj/item/coin/plasma))
				cashes += A
				user.drop_item()
				A.forceMove(src)
				inserted += 2
				return
			if(istype(A,/obj/item/coin/diamond))
				cashes += A
				user.drop_item()
				A.forceMove(src)
				inserted += 300
				return
			user << "You insert your [A.name] in ATM"
		..()

	attack_hand(var/mob/user)
		if(issilicon(user))
			user << "\red Artificial unit recognized. Artificial units do not currently receive monetary compensation, as per NanoTrasen regulation #1005."
			return

		if(!(stat && NOPOWER) && ishuman(user))
			var/dat
			user.machine = src
			if(!accepted)
				if(scan(user))
					pincode = input(usr,"Enter a pin-code") as num
					if(card.checkaccess(pincode,usr))
						accepted = 1
						//SOUND_TO(usr, 'nya.mp3')
			else
				dat = null
				dat += "<h1>NanoTrasen Automatic Teller Machine</h1><br/>"
				dat += "For all your monetary needs!<br/><br/>"
				dat += "Welcome, [card.registered_name]. You have [card.money] credits deposited.<br>"
				dat += "Current inserted item value: [inserted] credits.<br><br>"
				dat += "Please, select action<br>"
				dat += "<a href=\"?src=\ref[src]&with=1\">Withdraw Physical Credits</a><br/>"
				dat += "<a href=\"?src=\ref[src]&eca=1\">Eject Inserted Items</a><br/>"
				dat += "<a href=\"?src=\ref[src]&ins=1\">Convert Inserted Items to Credits</a><br/>"
				dat += "<a href=\"?src=\ref[src]&lock=1\">Lock ATM</a><br/>"
			SHOW_BROWSER(user, dat,"window=atm")
			onclose(user,"close")
	proc
		withdraw(var/mob/user)
			if(accepted)
				var/amount = input("How much would you like to withdraw?", "Amount", 0) in list(1,10,20,50,100,200,500,1000, 0)
				if(amount == 0)
					return
				if(card.money >= amount)
					card.money -= amount
					switch(amount)
						if(1)
							new /obj/item/cash(loc)
						if(10)
							new /obj/item/cash/c10(loc)
						if(20)
							new /obj/item/cash/c20(loc)
						if(50)
							new /obj/item/cash/c50(loc)
						if(100)
							new /obj/item/cash/c100(loc)
						if(200)
							new /obj/item/cash/c200(loc)
						if(500)
							new /obj/item/cash/c500(loc)
						if(1000)
							new /obj/item/cash/c1000(loc)
				else
					user << "\red Error: Insufficient funds."
					return

		scan(var/mob/user)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(H.id_store)
					if(istype(H.id_store, /obj/item/card/id))
						card = H.id_store
						return 1
					if(istype(H.id_store,/obj/item/pda))
						var/obj/item/pda/P = H.id_store
						if(istype(P.id,/obj/item/card/id))
							card = P.id
							return 1
					return 0
				return 0

		insert()
			if(accepted)
				card.money += inserted
				inserted = 0

	Topic(href,href_list)
		if(usr.machine == src && in_range(src, usr) || issilicon(usr))
			if(href_list["eca"])
				if(accepted)
					for(var/obj/item/cash/M in cashes)
						M.forceMove(loc)
					inserted = 0
					if(!cashes)
						cashes = null
			if(href_list["with"] && card)
				withdraw(usr)
			if(href_list["ins"] && card)
				if(accepted)
					card.money += inserted
					inserted = 0
					if(cashes)
						cashes = null
			if(href_list["lock"])
				card = null
				accepted = 0
				usr.machine = null
				CLOSE_BROWSER(usr,"window=atm")
			src.updateUsrDialog()
		else
			usr.machine = null
			CLOSE_BROWSER(usr,"window=atm")


/obj/item/card/id/proc/checkaccess(p,var/mob/user)
	if(p == pin)
		user << "\green Access granted."
		return 1
	FEEDBACK_ACCESS_DENIED(user)
	return 0