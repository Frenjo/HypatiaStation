/obj/item/Bump(mob/M)
	spawn(0)
		..()
	return

/obj/item/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 3.0
	throwforce = 2.0
	throw_speed = 1
	throw_range = 4
	w_class = 2
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/c_tube
	name = "cardboard tube"
	desc = "A tube... of cardboard."
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	throwforce = 1
	w_class = 1.0
	throw_speed = 4
	throw_range = 5

/obj/item/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	matter_amounts = list(MATERIAL_METAL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/*
/obj/item/game_kit
	name = "Gaming Kit"
	icon = 'icons/obj/items.dmi'
	icon_state = "game_kit"
	var/selected = null
	var/board_stat = null
	var/data = ""
	var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	item_state = "sheet-metal"
	w_class = 5.0
*/

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	item_state = "gift"
	w_class = 4.0

	var/size = 3.0
	var/obj/item/gift = null

/obj/item/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	obj_flags = OBJ_FLAG_CONDUCT
	throwforce = 0
	w_class = 3.0
	origin_tech = list(/datum/tech/materials = 1)

	var/breakouttime = 300	//Deciseconds = 30s = 0.5 minute

/obj/item/legcuffs/beartrap
	name = "bear trap"
	desc = "A trap used to catch bears and other legged creatures."
	icon_state = "beartrap0"
	throw_speed = 2
	throw_range = 1

	var/armed = 0

/obj/item/legcuffs/beartrap/suicide_act(mob/user)
	viewers(user) << SPAN_DANGER("[user] is putting the [src.name] on \his head! It looks like \he's trying to commit suicide.")
	return (BRUTELOSS)

/obj/item/legcuffs/beartrap/attack_self(mob/user)
	..()
	if(ishuman(user) && !user.stat && !user.restrained())
		armed = !armed
		icon_state = "beartrap[armed]"
		to_chat(user, SPAN_NOTICE("[src] is now [armed ? "armed" : "disarmed"]."))

/obj/item/legcuffs/beartrap/Crossed(atom/movable/AM)
	if(armed)
		if(ishuman(AM))
			if(isturf(src.loc))
				var/mob/living/carbon/H = AM
				if(IS_RUNNING(H))
					armed = 0
					H.legcuffed = src
					src.loc = H
					H.update_inv_legcuffed()
					to_chat(H, SPAN_DANGER("You step on \the [src]!"))
					feedback_add_details("handcuffs", "B") //Yes, I know they're legcuffs. Don't change this, no need for an extra variable. The "B" is used to tell them apart.
					for(var/mob/O in viewers(H, null))
						if(O == H)
							continue
						O.show_message(SPAN_DANGER("[H] steps on \the [src]."), 1)
		if(issimple(AM) && !istype(AM, /mob/living/simple/parrot) && !istype(AM, /mob/living/simple/construct) && !istype(AM, /mob/living/simple/shade) && !istype(AM, /mob/living/simple/hostile/viscerator))
			armed = 0
			var/mob/living/simple/SA = AM
			SA.health -= 20
	..()


/obj/item/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	force = 1.0
	throwforce = 3.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	attack_verb = list("warned", "cautioned", "smashed")

/obj/item/caution/cone
	desc = "This cone is trying to warn you of something!"
	name = "warning cone"
	icon_state = "cone"

/obj/item/rack_parts
	name = "rack parts"
	desc = "Parts of a rack."
	icon = 'icons/obj/items.dmi'
	icon_state = "rack_parts"
	obj_flags = OBJ_FLAG_CONDUCT
	matter_amounts = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET)

/obj/item/shard
	name = "shard"
	icon = 'icons/obj/items/shards.dmi'
	icon_state = "large"
	sharp = 1
	edge = 1
	desc = "Could probably be used as ... a throwing weapon?"
	w_class = 1.0
	force = 5.0
	throwforce = 8.0
	item_state = "shard-glass"
	matter_amounts = list(/decl/material/glass = MATERIAL_AMOUNT_PER_SHEET)
	attack_verb = list("stabbed", "slashed", "sliced", "cut")

/obj/item/shard/suicide_act(mob/user)
	viewers(user) << pick(SPAN_DANGER("[user] is slitting \his wrists with the shard of glass! It looks like \he's trying to commit suicide."), \
						SPAN_DANGER("[user] is slitting \his throat with the shard of glass! It looks like \he's trying to commit suicide."))
	return (BRUTELOSS)

/obj/item/shard/attack(mob/living/carbon/M, mob/living/carbon/user)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/*/obj/item/syndicate_uplink
	name = "station bounced radio"
	desc = "Remain silent about this..."
	icon = 'icons/obj/items/devices/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 10.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/mob/currentUser = null
	var/obj/item/radio/origradio = null
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	w_class = 2.0
	item_state = "radio"
	throw_speed = 4
	throw_range = 20
	m_amt = 100
	origin_tech = list(/datum/tech/magnets = 2, /datum/tech/syndicate = 3)*/

/obj/item/shard/shrapnel
	name = "shrapnel"
	icon_state = "shrapnellarge"
	desc = "A bunch of tiny bits of shattered metal."

/obj/item/shard/shrapnel/New()
	. = ..()
	icon_state = pick("shrapnellarge", "shrapnelmedium", "shrapnelsmall")
	switch(icon_state)
		if("shrapnelsmall")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("shrapnelmedium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("shrapnellarge")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)

/obj/item/SWF_uplink
	name = "station-bounced radio"
	desc = "used to communicate it appears."
	icon = 'icons/obj/items/devices/radio.dmi'
	icon_state = "radio"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	item_state = "radio"
	throwforce = 5
	w_class = 2.0
	throw_speed = 4
	throw_range = 20
	matter_amounts = list(MATERIAL_METAL = 100)
	origin_tech = list(/datum/tech/magnets = 1)

	var/temp = null
	var/uses = 4.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/obj/item/radio/origradio = null

/obj/item/table_parts
	name = "table parts"
	desc = "Parts of a table. Poor table."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "table_parts"
	matter_amounts = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET)
	obj_flags = OBJ_FLAG_CONDUCT
	attack_verb = list("slammed", "bashed", "battered", "bludgeoned", "thrashed", "whacked")

/obj/item/table_parts/reinforced
	name = "reinforced table parts"
	desc = "Hard table parts. Well...harder..."
	icon = 'icons/obj/items.dmi'
	icon_state = "reinf_tableparts"
	matter_amounts = list(/decl/material/steel = (MATERIAL_AMOUNT_PER_SHEET * 2))

/obj/item/table_parts/wood
	name = "wooden table parts"
	desc = "Keep away from fire."
	icon_state = "wood_tableparts"
	atom_flags = null

/obj/item/camera_bug
	name = "camera bug"
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "flash"
	w_class = 1.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20

/obj/item/camera_bug/attack_self(mob/user)
	var/list/cameras = list()
	for_no_type_check(var/obj/machinery/camera/C, global.CTcameranet.cameras)
		if(C.bugged && C.status)
			cameras.Add(C)
	if(length(cameras) == 0)
		to_chat(user, SPAN_WARNING("No bugged functioning cameras found."))
		return

	var/list/friendly_cameras = list()

	for(var/obj/machinery/camera/C in cameras)
		friendly_cameras.Add(C.c_tag)

	var/target = input("Select the camera to observe", null) as null | anything in friendly_cameras
	if(!target)
		return
	for(var/obj/machinery/camera/C in cameras)
		if(C.c_tag == target)
			target = C
			break
	if(user.stat == DEAD)
		return

	user.client.eye = target

/obj/item/syntiflesh
	name = "syntiflesh"
	desc = "Meat that appears... strange..."
	icon = 'icons/obj/items/food.dmi'
	icon_state = "meat"
	obj_flags = OBJ_FLAG_CONDUCT
	w_class = 1.0
	origin_tech = list(/datum/tech/biotech = 2)

/obj/item/hatchet/soghunknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "soghunknife"
	attack_verb = list("ripped", "torn", "cut")

/*
/obj/item/cigarpacket
	name = "Pete's Cuban Cigars"
	desc = "The most robust cigars on the planet."
	icon = 'icons/obj/items/cigarettes.dmi'
	icon_state = "cigarpacket"
	item_state = "cigarpacket"
	w_class = 1
	throwforce = 2
	var/cigarcount = 6
	flags = ONBELT | TABLEPASS */

/obj/item/ectoplasm
	name = "ectoplasm"
	desc = "spooky"
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

// --- Things below are originally from weaponry.dm ---
/obj/item/banhammer
	desc = "A banhammer"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	attack_verb = list("banned")

/obj/item/banhammer/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is hitting \himself with the [src.name]! It looks like \he's trying to ban \himself from life."))
	return (BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS)

/obj/item/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 15
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = 1

/obj/item/nullrod/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide."))
	return (BRUTELOSS | FIRELOSS)

/obj/item/nullrod/attack(mob/M, mob/living/user) //Paste from old-code to decult with a null rod.
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")

	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return

	if(CLUMSY in user.mutations && prob(50))
		to_chat(user, SPAN_WARNING("The rod slips out of your hand and hits your head."))
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if(M.stat != DEAD)
		if(M.mind in global.PCticker.mode.cult && prob(33))
			to_chat(M, SPAN_WARNING("The power of [src] clears your mind of the cult's influence!"))
			to_chat(user, SPAN_WARNING("You wave [src] over [M]'s head and see their eyes become clear, their mind returning to normal."))
			global.PCticker.mode.remove_cultist(M.mind)
			M.visible_message(SPAN_WARNING("[user] waves [src] over [M]'s head."))
		else if(prob(10))
			to_chat(user, SPAN_WARNING("The rod slips in your hand."))
			..()
		else
			to_chat(user, SPAN_WARNING("The rod appears to do nothing."))
			M.visible_message(SPAN_WARNING("[user] waves [src] over [M]'s head."))

/obj/item/nullrod/afterattack(atom/A, mob/user)
	if(istype(A, /turf/open/floor))
		to_chat(user, SPAN_INFO("You hit the floor with the [src]."))
		call(/obj/effect/rune/proc/revealrunes)(src)

/obj/item/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "sord"
	item_state = "sord"
	slot_flags = SLOT_BELT
	force = 2
	throwforce = 1
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/sord/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide."))
	return(BRUTELOSS)

/obj/item/sord/attack(mob/living/carbon/M, mob/living/carbon/user)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "claymore"
	item_state = "claymore"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	force = 40
	throwforce = 10
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/claymore/IsShield()
	return 1

/obj/item/claymore/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is falling on the [src.name]! It looks like \he's trying to commit suicide."))
	return(BRUTELOSS)

/obj/item/claymore/attack(mob/living/carbon/M, mob/living/carbon/user)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/katana
	name = "katana"
	desc = "Woefully underpowered in D20"
	icon_state = "katana"
	item_state = "katana"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 40
	throwforce = 10
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/katana/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku."))
	return(BRUTELOSS)

/obj/item/katana/IsShield()
	return 1

/obj/item/katana/attack(mob/living/carbon/M, mob/living/carbon/user)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/harpoon
	name = "harpoon"
	desc = "Tharr she blows!"
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "harpoon"
	item_state = "harpoon"
	sharp = 1
	edge = 0
	force = 20
	throwforce = 15
	w_class = 3
	attack_verb = list("jabbed", "stabbed", "ripped")