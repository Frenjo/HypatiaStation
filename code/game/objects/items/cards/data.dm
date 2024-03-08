/*
 * Data Cards
 *
 * Used for the teleporter.
 */
/obj/item/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	item_state = "card-id"

	var/function = "storage"
	var/data = "null"
	var/special = null

/obj/item/card/data/verb/label(t as text)
	set category = PANEL_OBJECT
	set name = "Label Disk"
	set src in usr

	name = t ? "data disk- '[t]'" : "data disk"
	add_fingerprint(usr)

/obj/item/card/data/clown
	name = "\proper the coordinates to clown planet"
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	icon_state = "data"
	item_state = "card-id"
	layer = 3

	level = 2

	function = "teleporter"
	data = "Clown Land"