/mob/living/silicon/ai/Login()	//ThisIsDumb(TM) TODO: tidy this up �_� ~Carn
	. = ..()

	for(var/obj/effect/rune/rune in GLOBL.movable_atom_list)
		var/image/blood = image(loc = rune)
		blood.override = 1
		client.images.Add(blood)
	regenerate_icons()
	flash = new /obj/screen()
	flash.icon_state = "blank"
	flash.name = "flash"
	flash.screen_loc = "1,1 to 15,15"
	flash.layer = 17
	blind = new /obj/screen()
	blind.icon_state = "black"
	blind.name = " "
	blind.screen_loc = "1,1 to 15,15"
	blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
	client.screen.Add(blind, flash)

	if(stat != DEAD)
		var/obj/machinery/computer/communications/comms = locate() in GLOBL.communications_consoles // Change status.
		comms?.post_status("ai_emotion", "Neutral")
	view_core()