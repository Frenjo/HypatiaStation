/datum/feed_channel
	var/channel_name = ""
	var/list/datum/feed_message/messages = list()
	//var/message_count = 0
	var/locked = FALSE
	var/author = ""
	var/backup_author = ""
	var/censored = FALSE
	var/is_admin_channel = FALSE
	//var/page = null //For newspapers

/datum/feed_channel/proc/clear()
	channel_name = ""
	messages = list()
	locked = FALSE
	author = ""
	backup_author = ""
	censored = FALSE
	is_admin_channel = FALSE

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