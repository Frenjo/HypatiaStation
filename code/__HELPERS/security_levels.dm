GLOBAL_GLOBL_INIT(decl/security_level/security_level, GET_DECL_INSTANCE(/decl/security_level/green))
// For numerical severities, see SEC_LEVEL_X defines in code/__DEFINES/security_levels.dm.

GLOBAL_GLOBL_LIST_NEW(area/station/hallway/contactable_hallway_areas)
GLOBAL_GLOBL_LIST_NEW(turf/open/floor/circuit_grid/blue/contactable_blue_grid_turfs)

/proc/set_security_level(level)
	if(!ispath(level, /decl/security_level))
		return
	var/decl/security_level/new_level = GET_DECL_INSTANCE(level)
	if(isnull(new_level))
		return
	var/decl/security_level/old_level = GLOBL.security_level
	if(isnull(old_level))
		return
	if(new_level.severity == old_level.severity) // We can't change to the level we're already at.
		return

	old_level.on_change_from()
	new_level.on_change_to()

	if(new_level.severity > old_level.severity) // If the level's going up...
		var/title = isnotnull(new_level.text_upto) ? new_level.text_upto : "Attention! Security level elevated to [new_level.name]."
		minor_announce(new_level.desc_upto, title)
		world << sound('sound/vox/dadeda.wav', volume = 34)
		new_level.on_elevate_to()
	else // Otherwise, if the level's going down...
		var/title = isnotnull(new_level.text_downto) ? new_level.text_downto : "Attention! Security level lowered to [new_level.name]."
		minor_announce(new_level.desc_downto, title)
		world << sound('sound/vox/doop.wav', volume = 37)
		new_level.on_lower_to()

	GLOBL.security_level = new_level