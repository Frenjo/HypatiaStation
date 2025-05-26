/datum/feed_message
	var/author = ""
	var/body = ""
	//var/parent_channel
	var/backup_body = ""
	var/backup_author = ""
	var/is_admin_message = FALSE
	var/icon/img = null
	var/icon/backup_img

/datum/feed_message/proc/clear()
	author = ""
	body = ""
	backup_body = ""
	backup_author = ""
	img = null
	backup_img = null