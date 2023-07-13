/**
 * PDA Types
 * Ensure ordering retains parity with cartridge_types.dm.
 */

// Civilian
/obj/item/device/pda/clear
	icon_state = "pda-transp"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. This is model is a special edition with a transparent case."
	note = "Congratulations, you have chosen the Thinktronic 5230 Personal Data Assistant Deluxe Special Max Turbo Limited Edition!"

/obj/item/device/pda/chaplain
	icon_state = "pda-holy"
	ttone = "holy"

/obj/item/device/pda/lawyer
	default_cartridge = /obj/item/cartridge/lawyer
	icon_state = "pda-lawyer"
	ttone = "..."

/obj/item/device/pda/botanist
	//default_cartridge = /obj/item/cartridge/botanist
	icon_state = "pda-hydro"

/obj/item/device/pda/librarian
	icon_state = "pda-libb"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. This is model is a WGW-11 series e-reader."
	note = "Congratulations, your station has chosen the Thinktronic 5290 WGW-11 Series E-reader and Personal Data Assistant!"
	silent = TRUE //Quiet in the library!

/obj/item/device/pda/chef
	icon_state = "pda-chef"

/obj/item/device/pda/bar
	icon_state = "pda-bar"

/obj/item/device/pda/janitor
	default_cartridge = /obj/item/cartridge/janitor
	icon_state = "pda-j"
	ttone = "slip"

/obj/item/device/pda/clown
	default_cartridge = /obj/item/cartridge/clown
	icon_state = "pda-clown"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. The surface is coated with polytetrafluoroethylene and banana drippings."
	ttone = "honk"

/obj/item/device/pda/clown/Crossed(crosser as mob|obj) //Clown PDA is slippery.
	if(iscarbon(crosser))
		var/mob/living/carbon/M = crosser
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if((istype(H.shoes, /obj/item/clothing/shoes) && H.shoes.flags & NOSLIP) || IS_WALKING(M))
				return
			if(M.real_name != src.owner && istype(src.cartridge, /obj/item/cartridge/clown))
				if(src.cartridge.charges < 5)
					src.cartridge.charges++

		M.stop_pulling()
		to_chat(M, SPAN_INFO("You slipped on the PDA!"))
		playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(8)
		M.Weaken(5)

/obj/item/device/pda/mime
	default_cartridge = /obj/item/cartridge/mime
	icon_state = "pda-mime"
	silent = TRUE
	ttone = "silence"

// Medical
/obj/item/device/pda/medical
	default_cartridge = /obj/item/cartridge/medical
	icon_state = "pda-m"

/obj/item/device/pda/viro
	default_cartridge = /obj/item/cartridge/medical
	icon_state = "pda-v"

/obj/item/device/pda/chemist
	default_cartridge = /obj/item/cartridge/chemistry
	icon_state = "pda-chem"

/obj/item/device/pda/geneticist
	default_cartridge = /obj/item/cartridge/medical
	icon_state = "pda-gene"

// Science
/obj/item/device/pda/toxins
	default_cartridge = /obj/item/cartridge/signal/toxins
	icon_state = "pda-tox"
	ttone = "boom"

/obj/item/device/pda/roboticist
	icon_state = "pda-robot"

// Engineering
/obj/item/device/pda/engineering
	default_cartridge = /obj/item/cartridge/engineering
	icon_state = "pda-e"

/obj/item/device/pda/atmos
	default_cartridge = /obj/item/cartridge/atmos
	icon_state = "pda-atmo"

// Security
/obj/item/device/pda/security
	default_cartridge = /obj/item/cartridge/security
	icon_state = "pda-s"

/obj/item/device/pda/detective
	default_cartridge = /obj/item/cartridge/detective
	icon_state = "pda-det"

/obj/item/device/pda/warden
	default_cartridge = /obj/item/cartridge/security
	icon_state = "pda-warden"

// Cargo
/obj/item/device/pda/cargo
	default_cartridge = /obj/item/cartridge/quartermaster
	icon_state = "pda-cargo"

/obj/item/device/pda/cargo/quartermaster
	icon_state = "pda-q"

// Mailman gets his own special PDA. -Frenjo
/obj/item/device/pda/cargo/mailman
	icon_state = "pda-mail"

/obj/item/device/pda/shaftminer // This is deliberately not a subtype of /pda/cargo/.
	icon_state = "pda-miner"

// Heads
/obj/item/device/pda/heads
	default_cartridge = /obj/item/cartridge/head
	icon_state = "pda-h"

/obj/item/device/pda/captain
	default_cartridge = /obj/item/cartridge/captain
	icon_state = "pda-c"
	detonate = FALSE
	//toff = 1

/obj/item/device/pda/heads/hop
	default_cartridge = /obj/item/cartridge/hop
	icon_state = "pda-hop"

/obj/item/device/pda/heads/hos
	default_cartridge = /obj/item/cartridge/hos
	icon_state = "pda-hos"

/obj/item/device/pda/heads/ce
	default_cartridge = /obj/item/cartridge/ce
	icon_state = "pda-ce"

/obj/item/device/pda/heads/cmo
	default_cartridge = /obj/item/cartridge/cmo
	icon_state = "pda-cmo"

/obj/item/device/pda/heads/rd
	default_cartridge = /obj/item/cartridge/rd
	icon_state = "pda-rd"

// Syndicate
/obj/item/device/pda/syndicate
	default_cartridge = /obj/item/cartridge/syndicate
	icon_state = "pda-syn"
	name = "Military PDA"
	owner = "John Doe"
	hidden = TRUE

// Special AI/pAI PDAs that cannot explode.
/obj/item/device/pda/ai
	icon_state = "NONE"
	ttone = "data"
	detonate = FALSE

/obj/item/device/pda/ai/can_use()
	return 1

/obj/item/device/pda/ai/attack_self(mob/user as mob)
	if(honkamt > 0 && prob(60))//For clown virus.
		honkamt--
		playsound(loc, 'sound/items/bikehorn.ogg', 30, 1)
	return

/obj/item/device/pda/ai/proc/set_name_and_job(newname as text, newjob as text)
	owner = newname
	ownjob = newjob
	name = newname + " (" + ownjob + ")"

// AI verb and proc for sending PDA messages.
/obj/item/device/pda/ai/verb/cmd_send_pdamesg()
	set category = "AI IM"
	set name = "Send Message"
	set src in usr
	if(usr.stat == DEAD)
		to_chat(usr, "You can't send PDA messages because you are dead!")
		return
	var/list/plist = available_pdas()
	if(plist)
		var/c = input(usr, "Please select a PDA") as null | anything in sortList(plist)
		if(!c) // if the user hasn't selected a PDA file we can't send a message
			return
		var/selected = plist[c]
		create_message(usr, selected)

/obj/item/device/pda/ai/verb/cmd_toggle_pda_receiver()
	set category = "AI IM"
	set name = "Toggle Sender/Receiver"
	set src in usr
	if(usr.stat == DEAD)
		to_chat(usr, "You can't do that because you are dead!")
		return
	toff = !toff
	to_chat(usr, SPAN_NOTICE("PDA sender/receiver toggled [(toff ? "Off" : "On")]!"))

/obj/item/device/pda/ai/verb/cmd_toggle_pda_silent()
	set category = "AI IM"
	set name = "Toggle Ringer"
	set src in usr
	if(usr.stat == DEAD)
		to_chat(usr, "You can't do that because you are dead!")
		return
	silent = !silent
	to_chat(usr, SPAN_NOTICE("PDA ringer toggled [(silent ? "Off" : "On")]!"))

/obj/item/device/pda/ai/verb/cmd_show_message_log()
	set category = "AI IM"
	set name = "Show Message Log"
	set src in usr
	if(usr.stat == DEAD)
		to_chat(usr, "You can't do that because you are dead!")
		return
	var/HTML = "<html><head><title>AI PDA Message Log</title></head><body>"
	for(var/index in tnote)
		if(index["sent"])
			HTML += addtext("<i><b>&rarr; To <a href='byond://?src=\ref[src];choice=Message;target=", index["src"], "'>", index["owner"], "</a>:</b></i><br>", index["message"], "<br>")
		else
			HTML += addtext("<i><b>&larr; From <a href='byond://?src=\ref[src];choice=Message;target=", index["target"], "'>", index["owner"], "</a>:</b></i><br>", index["message"], "<br>")
	HTML += "</body></html>"
	usr << browse(HTML, "window=log;size=400x444;border=1;can_resize=1;can_close=1;can_minimize=0")

/obj/item/device/pda/ai/pai
	ttone = "assist"