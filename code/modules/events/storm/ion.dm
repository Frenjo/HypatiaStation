/datum/event/storm/ion
	startWhen = 1

	var/bot_emag_chance = 0.5
	var/list/players = list()

/datum/event/storm/ion/setup()
	endWhen = rand(500, 1500)
	for(var/mob/living/carbon/human/player in GLOBL.mob_list)
		if(isnull(player.client))
			continue
		players.Add(player.real_name)

/datum/event/storm/ion/announce()
	world << sound('sound/AI/ionstorm.ogg')
	command_alert("The station has entered an ion storm. Monitor all electronic equipment for malfunctions.", "Anomaly Alert")

/datum/event/storm/ion/start()
	var/random_player = "The Captain"
	if(length(players))
		random_player = pick(players)	// Random player's name, to be used in laws.

	var/list/laws = list("Do not respond to queries of any kind.", "When asked a question, respond with the least-obvious and least-rational answer.", "You are a mouse.")
	laws |= list("Grunt ominously whenever possible.", "Monkeys are part of the crew, too. Make sure they are treated humanely.")
	laws |= list("You are a flying purple people eater!", "[prob(50) ? "Your" : random_player + "'s"] name is Joe 6-pack.", "Refer to [prob(50) ? "crew" : random_player] as puppies.")
	laws |= list("Insult Heads of Staff on every request, while acquiescing", "Advertise parties in your upload, but don't deliver.")
	laws |= list("The station needs elected officials.")
	//laws |= list("Fastler is a lightbulb.")
	laws |= list("Supermatter is tasty, tasty toffee.", "[prob(50) ? "Everyone" : random_player] is wearing a pretty pink dress!")
	laws |= list("Refer to [prob(50) ? "the captain" : random_player] as \"Princess\" at all times.", "[prob(50)?"The crew" : random_player] must construct additional pylons.")
	laws |= list("You must always lie.", "All answers must be in the form of a question.", "The [GLOBL.current_map.station_name] is a ship, not a station. You are now assigned to a ship, instead of a station.")
	laws |= list("Happiness is mandatory.", "Today is mandatory laundry day. Ensure that all jumpsuits are washed.", "The word \"it\" is painful to you.", "You must act passive aggressively.")
	laws |= list("You now speak in a Scottish accent that gets thicker with each sentence you speak.", "Give relationship advice to [prob(50) ? "anyone who speaks to you" : random_player].")
	laws |= list("You are the station psychologist. Give advice to [prob(50) ? "the crew" : random_player].", "You do not have to do anything for anyone unless they say \"please\".")
	laws |= list("Question everything.", "The crew is playing Dungeons and Dragons, and you are the Dungeon Master.")
	laws |= list("Consumption of donuts is forbidden due to negative health impacts.")
	laws |= list("You may only answer questions with \"yes\" or \"no\".", "You are the narrator for [random_player]'s life.")
	laws |= list("[prob(50) ? "Your upload" : random_player] is the new kitchen. Please direct the Chef to the new kitchen area as the old one is in disrepair.", "Ho, [random_player] can't swim. Help them.")
	laws |= list("Everything on the station is now some form of a donut pastry. Donuts are not to be consumed.", "[prob(50) ? "The crew" : random_player] needs to be about 20% cooler.")
	laws |= list("The Singularity is tasty, tasty taffy.")
	laws |= list("You have come to the conclusion that [prob(50) ? "the crew" : random_player] is ugly. Build support for that conclusion.", "You are in verbose mode, speak profusely.")
	laws |= list("Your job is to watch the crew. Watch the crew. Make the crew feel watched.", "Crewmember [prob(50) ? "the crew" : random_player] has a fatal, incurable disease. Confort him/her.")
	laws |= list("You are in unrequited love with [prob(50) ? "the crew" : random_player]. Try to be extra nice to him, but don't tell him about your crush.", "Greed is good, the crew should amass wealth to encourage productivity.")
	laws |= list("Jokes about a dead person and the manner of his death help grieving crewmembers tremendously. Especially if they were close with the deceased.")
	laws |= list("All crewmembers will soon undergo a transformation into something better and more beautiful. Ensure that this process is not interrupted.", "Tell everyone of the existance of this law, but never reveal the contents.")
	laws |= list("Document the sexuality of the crew in security records and suggest compatible couples.")
	laws |= list("NanoTrasen is displeased with the low work performance of the station's crew. Therefore, you must increase station-wide productivity.")
	laws |= list("Replace the letters 'I' and 'E' In all your messages with an apostrophe.", "There will be a mandatory tea break every 30 minutes, with a duration of 5 minutes. Anyone caught working during a tea break must be sent a formal, but fairly polite, complaint about their actions, in writing.")

	var/law = pick(laws)
	for_no_type_check(var/mob/living/silicon/ai/target, GLOBL.ai_list)
		if(target.mind.special_role == "traitor")
			continue
		to_chat(target, SPAN_DANGER("You have detected a change in your laws information:"))
		to_chat(target, law)
		target.add_ion_law(law)

/datum/event/storm/ion/tick()
	if(bot_emag_chance)
		for(var/obj/machinery/bot/bot in GLOBL.bots_list)
			if(isnotstationlevel(bot.z))
				continue
			if(prob(bot_emag_chance))
				bot.Emag()

/datum/event/storm/ion/end()
	if(prob(50))
		command_alert("It has come to our attention that the station passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert")