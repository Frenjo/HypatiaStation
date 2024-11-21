/datum/round_event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.
	oneShot			= TRUE

	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedVendingMachines = list()
	var/obj/machinery/vending/originMachine = null

/datum/round_event/brand_intelligence/announce()
	command_alert("Rampant brand intelligence has been detected aboard [station_name()], please stand-by.", "Machine Learning Alert")

/datum/round_event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in GLOBL.machines)
		if(isnotstationlevel(V.z))
			continue
		vendingMachines.Add(V)

	if(!length(vendingMachines))
		kill()
		return

	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	originMachine.shut_up = FALSE
	originMachine.shoot_inventory = TRUE

/datum/round_event/brand_intelligence/tick()
	if(!length(vendingMachines) || isnull(originMachine) || originMachine.shut_up)	//if every machine is infected, or if the original vending machine is missing or has it's voice switch flipped
		end()
		kill()
		return

	if(IsMultiple(activeFor, 5))
		if(prob(15))
			var/obj/machinery/vending/infectedMachine = pick(vendingMachines)
			vendingMachines.Remove(infectedMachine)
			infectedVendingMachines.Add(infectedMachine)
			infectedMachine.shut_up = FALSE
			infectedMachine.shoot_inventory = TRUE

			if(IsMultiple(activeFor, 12))
				originMachine.speak(pick("Try our aggressive new marketing strategies!", \
					"You should buy products to feed your lifestyle obsession!", \
					"Consume!", \
					"Your money can buy happiness!", \
					"Engage direct marketing!", \
					"Advertising is legalized lying! But don't let that put you off our great deals!", \
					"You don't want to buy anything? Yeah, well I didn't want to buy your mom either."))

/datum/round_event/brand_intelligence/end()
	for_no_type_check(var/obj/machinery/vending/infectedMachine, infectedVendingMachines)
		infectedMachine.shut_up = TRUE
		infectedMachine.shoot_inventory = FALSE