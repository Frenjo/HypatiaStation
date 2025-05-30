/datum/feed_channel
	var/channel_name = ""
	var/list/datum/feed_message/messages = list()
	var/locked = FALSE
	var/author = ""
	var/backup_author = ""
	var/censored = FALSE
	var/is_admin_channel = FALSE

/datum/feed_channel/proc/clear()
	channel_name = ""
	messages = list()
	locked = FALSE
	author = ""
	backup_author = ""
	censored = FALSE
	is_admin_channel = FALSE

/datum/feed_channel/command_updates
	channel_name = "Central Command Updates"
	author = "Automated Announcement System"
	locked = TRUE

/datum/feed_channel/station_announcements
	channel_name = "Station Announcements"
	author = "Automated Announcement System"
	locked = TRUE

/datum/feed_channel/tau_ceti_daily
	channel_name = "Tau Ceti Daily"
	author = "CentCom Minister of Information"
	locked = TRUE
	is_admin_channel = TRUE

/datum/feed_channel/gibson_gazette
	channel_name = "The Gibson Gazette"
	author = "Editor Mike Hammers"
	locked = TRUE
	is_admin_channel = TRUE