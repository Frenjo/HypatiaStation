/proc/create_chat_tag_icon(icon_name, client/target)
	var/image/tag_image = image('icons/misc/chat_tags.dmi', icon_name)
	return icon2html(tag_image, target, realsize = TRUE)