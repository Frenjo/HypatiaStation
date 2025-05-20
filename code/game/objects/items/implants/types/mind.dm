/obj/item/implant/loyalty
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	matter_amounts = /datum/design/implant/loyal::materials
	origin_tech = /datum/design/implant/loyal::req_tech

/obj/item/implant/loyalty/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> NanoTrasen Employee Management Implant<BR>
<b>Life:</b> Ten years.<BR>
<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}

/obj/item/implant/loyalty/implanted(mob/M)
	if(!ishuman(M))
		return 0
	var/mob/living/carbon/human/H = M
	if(H.mind in global.PCticker.mode.head_revolutionaries)
		H.visible_message("[H] seems to resist the implant!", "You feel the corporate tendrils of NanoTrasen try to invade your mind!")
		return 0
	else if(H.mind in global.PCticker.mode:revolutionaries)
		global.PCticker.mode:remove_revolutionary(H.mind)
	to_chat(H, SPAN_INFO("You feel a surge of loyalty towards NanoTrasen."))
	return 1