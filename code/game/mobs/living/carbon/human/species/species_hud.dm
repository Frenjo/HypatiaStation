/datum/hud_data
	var/icon	// If set, overrides ui_style.
	var/has_a_intent = TRUE		// Set to draw intent box.
	var/has_m_intent = TRUE		// Set to draw move intent box.
	var/has_warnings = TRUE		// Set to draw environment warnings.
	var/has_pressure = TRUE		// Draw the pressure indicator.
	var/has_nutrition = TRUE	// Draw the nutrition indicator.
	var/has_bodytemp = TRUE		// Draw the bodytemp indicator.
	var/has_hands = TRUE		// Set to draw shand.
	var/has_drop = TRUE			// Set to draw drop button.
	var/has_throw = TRUE		// Set to draw throw button.
	var/has_resist = TRUE		// Set to draw resist button.
	var/has_internals = TRUE	// Set to draw the internals toggle button.

	// Contains information on the position and tag for all inventory slots
	// to be drawn for the mob. This is fairly delicate, try to avoid messing with it
	// unless you know exactly what it does.
	var/list/gear = list(
		"i_clothing" =		list("loc" = UI_ICLOTHING,	"slot" = SLOT_ID_WEAR_UNIFORM,	"state" = "center",		"toggle" = 1,	"dir" = SOUTH),
		"o_clothing" =		list("loc" = UI_OCLOTHING,	"slot" = SLOT_ID_WEAR_SUIT,		"state" = "equip",		"toggle" = 1,	"dir" = SOUTH),
		"mask" =			list("loc" = UI_MASK,		"slot" = SLOT_ID_WEAR_MASK,		"state" = "equip",		"toggle" = 1,	"dir" = NORTH),
		"gloves" =			list("loc" = UI_GLOVES,		"slot" = SLOT_ID_GLOVES,		"state" = "gloves",		"toggle" = 1),
		"eyes" =			list("loc" = UI_GLASSES,	"slot" = SLOT_ID_GLASSES,		"state" = "glasses",	"toggle" = 1),
		"l_ear" =			list("loc" = UI_L_EAR,		"slot" = SLOT_ID_L_EAR,			"state" = "ears",		"toggle" = 1),
		"r_ear" =			list("loc" = UI_R_EAR,		"slot" = SLOT_ID_R_EAR,			"state" = "ears",		"toggle" = 1),
		"head" =			list("loc" = UI_HEAD,		"slot" = SLOT_ID_HEAD,			"state" = "hair",		"toggle" = 1),
		"shoes" =			list("loc" = UI_SHOES,		"slot" = SLOT_ID_SHOES,			"state" = "shoes",		"toggle" = 1),
		"suit storage" =	list("loc" = UI_SSTORE1,	"slot" = SLOT_ID_SUIT_STORE,	"state" = "belt",		"dir" = 8),
		"back" =			list("loc" = UI_BACK,		"slot" = SLOT_ID_BACK,			"state" = "back",		"dir" = NORTH),
		"id" =				list("loc" = UI_ID_STORE,	"slot" = SLOT_ID_ID_STORE,		"state" = "id",			"dir" = NORTH),
		"storage1" =		list("loc" = UI_STORAGE1,	"slot" = SLOT_ID_L_POCKET,		"state" = "pocket"),
		"storage2" =		list("loc" = UI_STORAGE2,	"slot" = SLOT_ID_R_POCKET,		"state" = "pocket"),
		"belt" =			list("loc" = UI_BELT, 		"slot" = SLOT_ID_BELT,			"state" = "belt")
	)