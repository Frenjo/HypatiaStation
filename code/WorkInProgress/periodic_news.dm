// This system defines news that will be displayed in the course of a round.
// Uses BYOND's type system to put everything into a nice format

/datum/news_announcement
	var/round_time // time of the round at which this should be announced, in seconds
	var/message // body of the message
	var/author = "NanoTrasen Editor"
	var/channel_name
	var/can_be_redacted = 0

/datum/news_announcement/revolution_inciting_event/paycuts_suspicion
	round_time = 60 * 10
	message = {"Reports have leaked that NanoTrasen is planning to put paycuts into
				effect on many of its Research Stations in Tau Ceti. Apparently these research
				stations haven't been able to yield the expected revenue, and thus adjustments
				have to be made."}
	author = "Unauthorized"
	channel_name = /datum/feed_channel/tau_ceti_daily::channel_name

/datum/news_announcement/revolution_inciting_event/paycuts_confirmation
	round_time = 60 * 40
	message = {"Earlier rumours about paycuts on Research Stations in the Tau Ceti system have
				been confirmed. Shockingly, however, the cuts will only affect lower tier
				personnel. Heads of Staff will, according to our sources, not be affected."}
	author = "Unauthorized"
	channel_name = /datum/feed_channel/tau_ceti_daily::channel_name

/datum/news_announcement/revolution_inciting_event/human_experiments
	round_time = 60 * 90
	message = {"Unbelievable reports about human experimentation have reached our ears. According
				to a refugee from one of the Tau Ceti Research Stations, their station, in order
				to increase revenue, has refactored several of their facilities to perform experiments
				on live humans, including virology research, genetic manipulation, and \"feeding them
				to the slimes to see what happens\". Allegedly, these test subjects were neither
				humanified monkeys nor volunteers, but rather unqualified staff that were forced into
				the experiments, and reported to have died in a \"work accident\" by NanoTrasen."}
	author = "Unauthorized"
	channel_name = /datum/feed_channel/tau_ceti_daily::channel_name

/datum/news_announcement/bluespace_research/announcement
	round_time = 60 * 20
	message = {"The new field of research trying to explain several interesting spacetime oddities,
				also known as \"Bluespace Research\", has reached new heights. Of the several
				hundred space stations now orbiting in Tau Ceti, fifteen are now specially equipped
				to experiment with and research Bluespace effects. Rumours have it some of these
				stations even sport functional \"travel gates\" that can instantly move a whole research
				team to an alternate reality."}
	channel_name = /datum/feed_channel/tau_ceti_daily::channel_name

/datum/news_announcement/random_junk/cheesy_honkers
	round_time = 60 * 15
	message = {"Do cheesy honkers increase risk of having a miscarriage? Several health administrations
				say so!"}
	author = "Assistant Editor Carl Ritz"
	channel_name = /datum/feed_channel/gibson_gazette::channel_name

/datum/news_announcement/random_junk/net_block
	round_time = 60 * 50
	message = {"Several corporations banding together to block access to 'wetskrell.nt', site administrators
				claiming violation of net laws."}
	author = "Assistant Editor Carl Ritz"
	channel_name = /datum/feed_channel/gibson_gazette::channel_name

/datum/news_announcement/random_junk/found_ssd
	round_time = 60 * 90
	message = {"Several people have been found unconscious at their terminals. It is thought that it was due
				to a lack of sleep or of simply migraines from staring at the screen too long. Camera footage
				reveals that many of them were playing games instead of working and their pay has been docked
				accordingly."}
	author = "Doctor Eric Hanfield"
	channel_name = /datum/feed_channel/tau_ceti_daily::channel_name

/datum/news_announcement/lotus_tree/explosions
	round_time = 60 * 30
	message = {"The newly-christened civillian transport Lotus Tree suffered two very large explosions near the
				bridge today, and there are unconfirmed reports that the death toll has passed 50. The cause of
				the explosions remain unknown, but there is speculation that it might have something to do with
				the recent change of regulation in the Moore-Lee Corporation, a major funder of the ship, when M-L
				announced that they were officially acknowledging inter-species marriage and providing couples
				with marriage tax-benefits."}
	author = "Reporter Leland H. Howards"
	channel_name = /datum/feed_channel/tau_ceti_daily::channel_name

/datum/news_announcement/food_riots/breaking_news
	round_time = 60 * 10
	message = {"Breaking news: Food riots have broken out throughout the Refuge asteroid colony in the Tenebrae
				Lupus system. This comes only hours after NanoTrasen officials announced they will no longer trade with the
				colony, citing the increased presence of \"hostile factions\" on the colony has made trade too dangerous to
				continue. NanoTrasen officials have not given any details about said factions. More on that at the top of
				the hour."}
	author = "Reporter Ro'kii Ar-Raqis"
	channel_name = /datum/feed_channel/tau_ceti_daily::channel_name

/datum/news_announcement/food_riots/more
	round_time = 60 * 60
	message = {"More on the Refuge food riots: The Refuge Council has condemned NanoTrasen's withdrawal from
				the colony, claiming \"there has been no increase in anti-NanoTrasen activity\", and \"\[the only] reason
				NanoTrasen withdrew was because the \[Tenebrae Lupus] system's Plasma deposits have been completely mined out.
				We have little to trade with them now\". NanoTrasen officials have denied these allegations, calling them
				\"further proof\" of the colony's anti-NanoTrasen stance. Meanwhile, Refuge Security has been unable to quell
				the riots. More on this at 6."}
	author = "Reporter Ro'kii Ar-Raqis"
	channel_name = /datum/feed_channel/tau_ceti_daily::channel_name


GLOBAL_GLOBL_LIST_INIT(newscaster_standard_feeds, list(
	/datum/news_announcement/bluespace_research,
	/datum/news_announcement/lotus_tree,
	/datum/news_announcement/random_junk,
	/datum/news_announcement/food_riots
))

/proc/process_newscaster()
	check_for_newscaster_updates(global.PCticker.mode.newscaster_announcements)

/var/global/tmp/announced_news_types = list()
/proc/check_for_newscaster_updates(type)
	for(var/subtype in SUBTYPESOF(type))
		var/datum/news_announcement/news = new subtype()
		if(news.round_time * 10 <= world.time && !(subtype in announced_news_types))
			announced_news_types += subtype
			announce_newscaster_news(news)

/proc/announce_newscaster_news(datum/news_announcement/news)
	var/datum/feed_message/newMsg = new /datum/feed_message
	newMsg.author = news.author
	newMsg.is_admin_message = !news.can_be_redacted

	newMsg.body = news.message

	var/datum/feed_channel/sendto
	for_no_type_check(var/datum/feed_channel/channel, global.CTeconomy.news_network.channels)
		if(channel.channel_name == news.channel_name)
			sendto = channel
			break

	if(!sendto)
		sendto = new /datum/feed_channel
		sendto.channel_name = news.channel_name
		sendto.author = news.author
		sendto.locked = TRUE
		sendto.is_admin_channel = TRUE
		global.CTeconomy.news_network.channels.Add(sendto)

	sendto.messages.Add(newMsg)

	for_no_type_check(var/obj/machinery/newscaster/caster, GLOBL.all_newscasters)
		caster.newsAlert(news.channel_name)