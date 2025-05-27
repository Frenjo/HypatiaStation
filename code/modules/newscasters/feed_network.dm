/datum/feed_network
	var/list/datum/feed_channel/channels = list()
	var/datum/feed_message/wanted_issue

/datum/feed_network/New()
	. = ..()
	// Creates the default newscaster feed channels.
	channels.Add(new /datum/feed_channel/command_updates())
	channels.Add(new /datum/feed_channel/station_announcements())
	channels.Add(new /datum/feed_channel/tau_ceti_daily())
	channels.Add(new /datum/feed_channel/gibson_gazette())

/datum/feed_network/proc/submit_message(author, message, channel_name, obj/item/photo/photo = null, is_admin_message = FALSE)
	. = FALSE
	// Creates the feed message.
	var/datum/feed_message/new_message = new /datum/feed_message()
	new_message.author = author
	new_message.body = message
	if(isnotnull(photo))
		new_message.img = photo.img
	new_message.is_admin_message = is_admin_message

	// Sends it to the corresponding channel.
	for_no_type_check(var/datum/feed_channel/channel, channels)
		if(channel.channel_name == channel_name)
			channel.messages.Add(new_message)
			. = TRUE
			break

	if(.)
		// If the message was sent, bleeps all newscasters.
		for_no_type_check(var/obj/machinery/newscaster/caster, GLOBL.all_newscasters)
			caster.newsAlert(channel_name)

/datum/feed_network/proc/submit_wanted_issue(author, message, backup_author, obj/item/photo/photo = null, is_admin_message = FALSE)
	// Creates the wanted issue feed message.
	var/datum/feed_message/new_wanted = new /datum/feed_message()
	new_wanted.author = author
	new_wanted.body = message
	new_wanted.backup_author = backup_author
	if(isnotnull(photo))
		new_wanted.img = photo.img
	new_wanted.is_admin_message = is_admin_message

	// Sets the wanted issue.
	wanted_issue = new_wanted

	// Bleeps all newscasters.
	for_no_type_check(var/obj/machinery/newscaster/caster, GLOBL.all_newscasters)
		caster.newsAlert()
		caster.update_icon()
	return TRUE