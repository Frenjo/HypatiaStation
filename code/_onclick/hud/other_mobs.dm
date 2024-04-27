/datum/hud/unplayer

/datum/hud/ghost

/datum/hud/brain/setup(ui_style = 'icons/mob/screen/screen1_Midnight.dmi')
	mymob.blind = new /atom/movable/screen()
	mymob.blind.icon = 'icons/mob/screen/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

/datum/hud/ai

/datum/hud/blob
	// Blob health and power display objects.
	var/atom/movable/screen/blob_health_display
	var/atom/movable/screen/blob_power_display

/datum/hud/blob/setup(ui_style = 'icons/mob/screen/screen1_Midnight.dmi')
	blob_health_display = new /atom/movable/screen()
	blob_health_display.name = "blob health"
	blob_health_display.icon_state = "block"
	blob_health_display.screen_loc = UI_INTERNAL

	blob_power_display = new /atom/movable/screen()
	blob_power_display.name = "blob power"
	blob_power_display.icon_state = "block"
	blob_power_display.screen_loc = UI_HEALTH

	mymob.client.screen.Cut()
	mymob.client.screen.Add(list(blob_health_display, blob_power_display))