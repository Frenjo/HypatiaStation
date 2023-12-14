/*
 * Global holder for religion data.
 */
GLOBAL_GLOBL_NEW(religion, /datum/religion)

/datum/religion
	var/name = null	// The name of the religion.
	var/church_name = null // The name of the church.

	var/deity_name = null	// The name of the religion's deity.
	var/bible_name = null	// The name of the religion's holy book.
	var/bible_icon_state = null	// icon_state the chaplain has chosen for his bible
	var/bible_item_state = null	// item_state the chaplain has chosen for his bible

/datum/religion/proc/religion_name()
	if(isnotnull(name))
		return name

	var/temp_name = ""

	temp_name += pick("bee", "science", "edu", "captain", "assistant", "monkey", "alien", "space", "unit", "sprocket", "gadget", "bomb", "revolution", "beyond", "station", "goon", "robot", "ivor", "hobnob")
	temp_name += pick("ism", "ia", "ology", "istism", "ites", "ick", "ian", "ity")

	return capitalize(temp_name)

/datum/religion/proc/church_name()
	if(isnotnull(church_name))
		return church_name

	var/temp_name = ""

	temp_name += pick("Holy", "United", "First", "Second", "Last")

	if(prob(20))
		temp_name += " Space"

	temp_name += " " + pick("Church", "Cathedral", "Body", "Worshippers", "Movement", "Witnesses")
	temp_name += " of [religion_name()]"

	return temp_name