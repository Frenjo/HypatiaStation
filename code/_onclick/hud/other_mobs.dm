/datum/hud/ghost

/datum/hud/brain/setup(ui_style = 'icons/mob/screen/screen1_Midnight.dmi')
	var/mob/living/brain/B = owner

	B.blind = new /atom/movable/screen()
	B.blind.icon = 'icons/mob/screen/screen1_full.dmi'
	B.blind.icon_state = "blackimageoverlay"
	B.blind.name = ""
	B.blind.screen_loc = "WEST,SOUTH"
	B.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

/datum/hud/ai

/datum/hud/blob
	// Blob health and power display objects.
	var/atom/movable/screen/blob_health_display
	var/atom/movable/screen/blob_power_display

/datum/hud/blob/setup(ui_style = 'icons/mob/screen/screen1_Midnight.dmi')
	blob_health_display = setup_screen_object("blob health", ui_style, "block", UI_INTERNAL)
	blob_power_display = setup_screen_object("blob power", ui_style, "block", UI_HEALTH)

	owner.client.screen.Cut()
	owner.client.screen.Add(list(blob_health_display, blob_power_display))