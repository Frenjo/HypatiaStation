/proc/istool(obj/item/I)
	return isnotnull(I) && istype(I) && isnotnull(I.tool_flags) // If it has any sort of non-null tool_flags value then it's a tool of some kind.

/proc/iswrench(obj/item/I)
	return isnotnull(I) && istype(I) && HAS_TOOL_FLAGS(I, TOOL_FLAG_WRENCH)

/proc/isscrewdriver(obj/item/I)
	return isnotnull(I) && istype(I) && HAS_TOOL_FLAGS(I, TOOL_FLAG_SCREWDRIVER)

/proc/iscrowbar(obj/item/I)
	return isnotnull(I) && istype(I) && HAS_TOOL_FLAGS(I, TOOL_FLAG_CROWBAR)

/proc/iswirecutter(obj/item/I)
	return isnotnull(I) && istype(I) && HAS_TOOL_FLAGS(I, TOOL_FLAG_WIRECUTTER)

/proc/iswelder(obj/item/I)
	return isnotnull(I) && istype(I) && HAS_TOOL_FLAGS(I, TOOL_FLAG_WELDER)

/proc/ismultitool(obj/item/I)
	return isnotnull(I) && istype(I) && HAS_TOOL_FLAGS(I, TOOL_FLAG_MULTITOOL)

/proc/iscable(obj/item/I)
	return isnotnull(I) && istype(I) && HAS_TOOL_FLAGS(I, TOOL_FLAG_CABLE_COIL)