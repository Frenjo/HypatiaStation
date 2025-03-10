/mob/living/carbon/slime/verb/Feed()
	set category = "Slime"
	set desc = "This will let you feed on any valid creature in the surrounding area. This should also be used to halt the feeding process."
	if(Victim)
		Feedstop()
		return

	if(stat)
		to_chat(src, "<i>I must be conscious to do this...</i>")
		return

	var/list/choices = list()
	for(var/mob/living/C in view(1, src))
		if(C != src && !isslime(C))
			choices += C

	var/mob/living/carbon/M = input(src, "Who do you wish to feed on?") in null | choices
	if(!M)
		return
	if(M in view(1, src))
		if(!isbrain(src))
			if(!isslime(src))
				if(stat != DEAD)
					if(health > -70)
						for(var/mob/living/carbon/slime/met in view())
							if(met.Victim == M && met != src)
								to_chat(src, "<i>The [met.name] is already feeding on this subject...</i>")
								return
						to_chat(src, SPAN_INFO("<i>I have latched onto the subject and begun feeding...</i>"))
						to_chat(M, SPAN_DANGER("The [src.name] has latched onto your head!"))
						Feedon(M)
					else
						to_chat(src, "<i>This subject does not have a strong enough life energy...</i>")
				else
					to_chat(src, "<i>This subject does not have an edible life energy...</i>")
			else
				to_chat(src, "<i>I must not feed on my brothers...</i>")
		else
			to_chat(src, "<i>This subject does not have an edible life energy...</i>")


/mob/living/carbon/slime/proc/Feedon(mob/living/carbon/M)
	Victim = M
	forceMove(M.loc)
	canmove = FALSE
	anchored = TRUE
	var/lastnut = nutrition
	//if(M.client) M << "\red You legs become paralyzed!"
	if(isslimeadult(src))
		icon_state = "[colour] adult slime eat"
	else
		icon_state = "[colour] baby slime eat"

	while(Victim && M.health > -70 && stat != DEAD)
		// M.canmove = FALSE
		canmove = FALSE

		if(M in view(1, src))
			loc = M.loc

			if(prob(15) && M.client && iscarbon(M))
				to_chat(M, SPAN_WARNING("[pick("You can feel your body becoming weak!", \
										"You feel like you're about to die!", \
										"You feel every part of your body screaming in agony!", \
										"A low, rolling pain passes through your body!", \
										"Your body feels as if it's falling apart!", \
										"You feel extremely weak!", \
										"A sharp, deep pain bathes every inch of your body!")]"))

			if(iscarbon(M))
				Victim.adjustCloneLoss(rand(1, 10))
				Victim.adjustToxLoss(rand(1, 2))
				if(Victim.health <= 0)
					Victim.adjustToxLoss(rand(2, 4))

				// Heal yourself
				adjustToxLoss(-10)
				adjustOxyLoss(-10)
				adjustBruteLoss(-10)
				adjustFireLoss(-10)
				adjustCloneLoss(-10)

				if(Victim)
					for(var/mob/living/carbon/slime/slime in view(1, M))
						if(slime.Victim == M && slime != src)
							slime.Feedstop()

				nutrition += rand(10, 25)
				if(nutrition >= lastnut + 50)
					if(prob(80))
						lastnut = nutrition
						powerlevel++
						if(powerlevel > 10)
							powerlevel = 10

				if(isslimeadult(src))
					if(nutrition > 1200)
						nutrition = 1200
				else
					if(nutrition > 1000)
						nutrition = 1000

				Victim.updatehealth()
				updatehealth()

			else
				if(prob(25))
					to_chat(src, SPAN_WARNING("<i>[pick("This subject is incompatible", \
											"This subject does not have a life energy", "This subject is empty", \
											"I am not satisified", "I can not feed from this subject", \
											"I do not feel nourished", "This subject is not food")]...</i>"))

			sleep(rand(15, 45))

		else
			break

	if(stat == DEAD)
		if(!isslimeadult(src))
			icon_state = "[colour] baby slime dead"

	else
		if(isslimeadult(src))
			icon_state = "[colour] adult slime"
		else
			icon_state = "[colour] baby slime"

	canmove = TRUE
	anchored = FALSE

	if(M)
		if(M.health <= -70)
			M.canmove = FALSE
			if(!client)
				if(Victim && !rabid && !attacked)
					if(Victim.LAssailant && Victim.LAssailant != Victim)
						if(prob(50))
							if(!(Victim.LAssailant in Friends))
								Friends.Add(Victim.LAssailant) // no idea why i was using the |= operator

			if(M.client && ishuman(src))
				if(prob(85))
					rabid = 1 // UUUNNBGHHHH GONNA EAT JUUUUUU

			if(client)
				src << "<i>This subject does not have a strong enough life energy anymore...</i>"
		else
			M.canmove = TRUE

			if(client)
				src << "<i>I have stopped feeding...</i>"
	else
		if(client)
			src << "<i>I have stopped feeding...</i>"

	Victim = null

/mob/living/carbon/slime/proc/Feedstop()
	if(Victim)
		if(Victim.client)
			Victim << "[src] has let go of your head!"
		Victim = null

/mob/living/carbon/slime/proc/UpdateFeed(mob/M)
	if(Victim)
		if(Victim == M)
			loc = M.loc // simple "attach to head" effect!


/mob/living/carbon/slime/verb/Evolve()
	set category = "Slime"
	set desc = "This will let you evolve from baby to adult slime."

	if(stat)
		src << "<i>I must be conscious to do this...</i>"
		return

	if(!isslimeadult(src))
		if(amount_grown >= 10)
			var/mob/living/carbon/slime/adult/new_slime = new adulttype(loc)
			new_slime.nutrition = nutrition
			new_slime.powerlevel = max(0, powerlevel-1)
			new_slime.a_intent = "hurt"
			new_slime.key = key
			new_slime.universal_speak = universal_speak
			new_slime << "<B>You are now an adult slime.</B>"
			qdel(src)
		else
			src << "<i>I am not ready to evolve yet...</i>"
	else
		src << "<i>I have already evolved...</i>"

/mob/living/carbon/slime/verb/Reproduce()
	set category = "Slime"
	set desc = "This will make you split into four Slimes. NOTE: this will KILL you, but you will be transferred into one of the babies."

	if(stat)
		src << "<i>I must be conscious to do this...</i>"
		return

	if(isslimeadult(src))
		if(amount_grown >= 10)
			//if(input("Are you absolutely sure you want to reproduce? Your current body will cease to be, but your consciousness will be transferred into a produced slime.") in list("Yes","No")=="Yes")
			if(stat)
				src << "<i>I must be conscious to do this...</i>"
				return

			var/list/babies = list()
			var/new_nutrition = round(nutrition * 0.9)
			var/new_powerlevel = round(powerlevel / 4)
			for(var/i = 1, i <= 4, i++)
				if(prob(80))
					var/mob/living/carbon/slime/M = new primarytype(loc)
					M.nutrition = new_nutrition
					M.powerlevel = new_powerlevel
					if(i != 1)
						step_away(M, src)
					babies += M
				else
					var/mutations = pick("one", "two", "three", "four")
					switch(mutations)
						if("one")
							var/mob/living/carbon/slime/M = new mutationone(loc)
							M.nutrition = new_nutrition
							M.powerlevel = new_powerlevel
							if(i != 1)
								step_away(M, src)
							babies += M
						if("two")
							var/mob/living/carbon/slime/M = new mutationtwo(loc)
							M.nutrition = new_nutrition
							M.powerlevel = new_powerlevel
							if(i != 1)
								step_away(M, src)
							babies += M
						if("three")
							var/mob/living/carbon/slime/M = new mutationthree(loc)
							M.nutrition = new_nutrition
							M.powerlevel = new_powerlevel
							if(i != 1)
								step_away(M, src)
							babies += M
						if("four")
							var/mob/living/carbon/slime/M = new mutationfour(loc)
							M.nutrition = new_nutrition
							M.powerlevel = new_powerlevel
							if(i != 1)
								step_away(M, src)
							babies += M

			var/mob/living/carbon/slime/new_slime = pick(babies)
			new_slime.a_intent = "hurt"
			new_slime.universal_speak = universal_speak
			new_slime.key = key

			new_slime << "<B>You are now a slime!</B>"
			qdel(src)
		else
			src << "<i>I am not ready to reproduce yet...</i>"
	else
		src << "<i>I am not old enough to reproduce yet...</i>"