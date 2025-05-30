 // This file contains all Nano procs/definitions for external classes/objects

 // Associative list of /datum/nanoui UIs opened on this object, indexed by ui_key.
/datum/var/tmp/alist/open_uis = null
// Used by the NanoUI Process (/datum/process/nanoui) to track UIs opened by this mob.
/mob/var/list/datum/nanoui/opened_uis = list()

 /**
  * Called when a Nano UI window is closed
  * This is how Nano handles closed windows
  * It must be a verb so that it can be called using winset
  *
  * @return nothing
  */
/client/verb/nanoclose(uiref as text)
	set hidden = TRUE	// hide this verb from the user's panel
	set name = "nanoclose"

	var/datum/nanoui/ui = locate(uiref)

	if(istype(ui))
		ui.close()

		if(isnotnull(ui.ref))
			var/href = "close=1"
			src.Topic(href, params2list(href), ui.ref)	// this will direct to the atom's Topic() proc via client.Topic()
		else if(ui.on_close_logic)
			// no atomref specified (or not found)
			// so just reset the user mob's machine var
			if(src?.mob)
				src.mob.unset_machine()

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  * @param ui /datum/nanoui This parameter is passed by the nanoui process() proc when updating an open ui
  *
  * @return nothing
  */
/atom/movable/proc/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	return