//NASA Voidsuit
/obj/item/clothing/head/helmet/space/nasavoid
	name = "NASA Void Helmet"
	desc = "A high tech, NASA Centcom branch designed, dark red space suit helmet. Used for AI satellite maintenance."
	icon_state = "void"
	item_state = "void"

/obj/item/clothing/suit/space/nasavoid
	name = "NASA Voidsuit"
	icon_state = "void"
	item_state = "void"
	desc = "A high tech, NASA Centcom branch designed, dark red Space suit. Used for AI satellite maintenance."
	slowdown = 1

// Added spacesuit for mailman with custom sprite, literally a renamed copy of the anomaly suits.
// Can survive disposals if wearing both suit and helmet. -Frenjo
/obj/item/clothing/suit/space/mailmanvoid
	name = "Mailman's Voidsuit"
	desc = "A pressure resistant voidsuit in the colours of the mailman, designed to allow them to traverse the disposal system safely."
	icon_state = "mailspace_suit"
	item_state = "mailspace_suit"
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank)
	slowdown = 1

/obj/item/clothing/head/helmet/space/mailmanvoid
	name = "Mailman's Void Helmet"
	desc = "A pressure resistant voidsuit helmet in the colours of the mailman, designed to allow them to traverse the disposal system safely."
	icon_state = "mailspace_helmet"
	item_state = "mailspace_helmet"