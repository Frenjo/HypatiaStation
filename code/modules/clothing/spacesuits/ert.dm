/obj/item/clothing/head/helmet/space/rig/ert
	name = "emergency response team helmet"
	desc = "A helmet worn by members of the NanoTrasen Emergency Response Team. Armoured and space ready."
	icon_state = "rig0-ert_commander"
	item_state = "helm-command"
	armor = list(melee = 50, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 60)
	siemens_coefficient = 0.6
	var/obj/machinery/camera/camera

/obj/item/clothing/head/helmet/space/rig/ert/attack_self(mob/user)
	if(camera)
		..(user)
	else
		camera = new /obj/machinery/camera(src)
		camera.network = list("ERT")
		global.CTcameranet.remove_camera(camera)
		camera.c_tag = user.name
		to_chat(user, SPAN_INFO("User scanned as [camera.c_tag]. Camera activated."))

/obj/item/clothing/head/helmet/space/rig/ert/get_examine_text(mob/user)
	. = ..()
	if(!in_range(src, user))
		return
	. += SPAN_INFO("It has a built-in camera. It's <em>[isnotnull(camera) ? "" : "in"]active</em>.")

/obj/item/clothing/suit/space/rig/ert
	name = "emergency response team suit"
	desc = "A suit worn by members of the NanoTrasen Emaergency Response Team. Armoured, space ready, and fire resistant."
	icon_state = "ert_commander"
	item_state = "suit-command"
	w_class = WEIGHT_CLASS_NORMAL
	can_store = list(
		/obj/item/flashlight, /obj/item/tank, /obj/item/t_scanner, /obj/item/rcd, /obj/item/crowbar,
		/obj/item/screwdriver, /obj/item/welding_torch, /obj/item/wirecutters, /obj/item/wrench, /obj/item/multitool,
		/obj/item/radio, /obj/item/gas_analyser, /obj/item/gun/energy/laser, /obj/item/gun/energy/pulse_rifle,
		/obj/item/gun/energy/taser, /obj/item/melee/baton, /obj/item/gun/energy/gun
	)
	slowdown = 1
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 60)
	siemens_coefficient = 0.6

//Commander
/obj/item/clothing/head/helmet/space/rig/ert/commander
	name = "emergency response team commander helmet"
	desc = "A helmet worn by the commander of a NanoTrasen Emergency Response Team. Has blue highlights. Armoured and space ready."
	icon_state = "rig0-ert_commander"
	item_state = "helm-command"
	item_color = "ert_commander"

/obj/item/clothing/suit/space/rig/ert/commander
	name = "emergency response team commander suit"
	desc = "A suit worn by the commander of a NanoTrasen Emergency Response Team. Has blue highlights. Armoured, space ready, and fire resistant."
	icon_state = "ert_commander"
	item_state = "suit-command"

//Security
/obj/item/clothing/head/helmet/space/rig/ert/security
	name = "emergency response team security helmet"
	desc = "A helmet worn by security members of a NanoTrasen Emergency Response Team. Has red highlights. Armoured and space ready."
	icon_state = "rig0-ert_security"
	item_state = "syndicate-helm-black-red"
	item_color = "ert_security"

/obj/item/clothing/suit/space/rig/ert/security
	name = "emergency response team security suit"
	desc = "A suit worn by security members of a NanoTrasen Emergency Response Team. Has red highlights. Armoured, space ready, and fire resistant."
	icon_state = "ert_security"
	item_state = "syndicate-black-red"

//Engineer
/obj/item/clothing/head/helmet/space/rig/ert/engineer
	name = "emergency response team engineer helmet"
	desc = "A helmet worn by engineering members of a NanoTrasen Emergency Response Team. Has blue highlights. Armoured and space ready."
	icon_state = "rig0-ert_engineer"
	item_color = "ert_engineer"

/obj/item/clothing/suit/space/rig/ert/engineer
	name = "emergency response team engineer suit"
	desc = "A suit worn by the engineering of a NanoTrasen Emergency Response Team. Has blue highlights. Armoured, space ready, and fire resistant."
	icon_state = "ert_engineer"

//Medical
/obj/item/clothing/head/helmet/space/rig/ert/medical
	name = "emergency response team medical helmet"
	desc = "A helmet worn by medical members of a NanoTrasen Emergency Response Team. Has white highlights. Armoured and space ready."
	icon_state = "rig0-ert_medical"
	item_color = "ert_medical"

/obj/item/clothing/suit/space/rig/ert/medical
	name = "emergency response team medical suit"
	desc = "A suit worn by medical members of a NanoTrasen Emergency Response Team. Has white highlights. Armoured and space ready."
	icon_state = "ert_medical"

// Janitor -Frenjo
/obj/item/clothing/head/helmet/space/rig/ert/janitor
	name = "emergency response team custodial helmet"
	desc = "A helmet worn by custodial members of a NanoTrasen Emergency Response Team. Has purple highlights. Armoured and space ready."
	icon_state = "rig0-ert_janitor"
	item_color = "ert_janitor"

/obj/item/clothing/suit/space/rig/ert/janitor
	name = "emergency response team custodial suit"
	desc = "A suit worn by custodial members of a NanoTrasen Emergency Response Team. Has purple highlights. Armoured and space ready."
	icon_state = "ert_janitor"