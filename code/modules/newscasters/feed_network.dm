/datum/feed_network
	var/list/datum/feed_channel/channels = list()
	var/datum/feed_message/wanted_issue

/datum/feed_network/proc/submit_message(channel_name, datum/feed_message/message)
	. = FALSE
	for_no_type_check(var/datum/feed_channel/channel, channels)
		if(channel.channel_name == channel_name)
			channel.messages.Add(message)
			. = TRUE
			break

	if(.)
		for_no_type_check(var/obj/machinery/newscaster/caster, GLOBL.all_newscasters)
			caster.newsAlert(channel_name)