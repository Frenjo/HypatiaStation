/mob/living/carbon/human/verb/change_ui()
	set category = PANEL_PREFERENCES
	set name = "Change UI"
	set desc = "Configure your user interface."

	var/mob/living/carbon/human/user = usr
	var/datum/hud/human/human_hud = user.hud_used

	var/UI_style_new = input(user, "Select a style, we recommend White for customization.") in list("White", "Midnight", "Orange", "old")
	if(isnull(UI_style_new))
		return

	var/UI_style_alpha_new = input(user, "Select a new alpha(transparency) parameter for UI, between 50 and 255.") as num
	if(isnull(UI_style_alpha_new) || !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50))
		return

	var/UI_style_color_new = input(user, "Choose your UI color, dark colors are not recommended!") as color|null
	if(isnull(UI_style_color_new))
		return

	//update UI
	var/list/icons = human_hud.adding + human_hud.other + human_hud.hotkey_buttons
	icons.Add(user.zone_sel)

	for(var/atom/movable/screen/I in icons)
		if(I.color && I.alpha)
			I.icon = ui_style2icon(UI_style_new)
			I.color = UI_style_color_new
			I.alpha = UI_style_alpha_new

	if(alert("Like it? Save changes?", ,"Yes", "No") == "Yes")
		client.prefs.UI_style = UI_style_new
		client.prefs.UI_style_alpha = UI_style_alpha_new
		client.prefs.UI_style_color = UI_style_color_new
		client.prefs.save_preferences()
		to_chat(user, "UI was saved.")