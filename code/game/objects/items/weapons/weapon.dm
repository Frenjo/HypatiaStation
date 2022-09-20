/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'

/obj/item/weapon/Bump(mob/M as mob)
	spawn(0)
		..()
	return

/obj/item/weapon/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	flags = CONDUCT
	force = 3.0
	throwforce = 2.0
	throw_speed = 1
	throw_range = 4
	w_class = 2
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/weapon/rsp
	name = "\improper Rapid-Seed-Producer (RSP)"
	desc = "A device used to rapidly deploy seeds."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	w_class = 3.0

	var/matter = 0
	var/mode = 1

/obj/item/weapon/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	w_class = 1.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/weapon/soap/nanotrasen
	desc = "A NanoTrasen brand bar of soap. Smells of plasma."
	icon_state = "soapnt"

/obj/item/weapon/soap/deluxe
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of condoms."
	icon_state = "soapdeluxe"

/obj/item/weapon/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

/obj/item/weapon/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")

	var/spam_flag = 0

/obj/item/weapon/c_tube
	name = "cardboard tube"
	desc = "A tube... of cardboard."
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	throwforce = 1
	w_class = 1.0
	throw_speed = 4
	throw_range = 5

/obj/item/weapon/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	flags = CONDUCT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	m_amt = 50
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/weapon/disk
	name = "disk"
	icon = 'icons/obj/items.dmi'

/obj/item/weapon/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = 1.0

/*
/obj/item/weapon/game_kit
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

/obj/item/weapon/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	item_state = "gift"
	w_class = 4.0

	var/size = 3.0
	var/obj/item/gift = null

/obj/item/weapon/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = CONDUCT
	throwforce = 0
	w_class = 3.0
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1)

	var/breakouttime = 300	//Deciseconds = 30s = 0.5 minute

/obj/item/weapon/legcuffs/beartrap
	name = "bear trap"
	desc = "A trap used to catch bears and other legged creatures."
	icon_state = "beartrap0"
	throw_speed = 2
	throw_range = 1

	var/armed = 0

/obj/item/weapon/legcuffs/beartrap/suicide_act(mob/user)
	viewers(user) << SPAN_DANGER("[user] is putting the [src.name] on \his head! It looks like \he's trying to commit suicide.")
	return (BRUTELOSS)

/obj/item/weapon/legcuffs/beartrap/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.restrained())
		armed = !armed
		icon_state = "beartrap[armed]"
		to_chat(user, SPAN_NOTICE("[src] is now [armed ? "armed" : "disarmed"]."))

/obj/item/weapon/legcuffs/beartrap/Crossed(AM as mob|obj)
	if(armed)
		if(ishuman(AM))
			if(isturf(src.loc))
				var/mob/living/carbon/H = AM
				if(H.m_intent == "run")
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
		if(isanimal(AM) && !istype(AM, /mob/living/simple_animal/parrot) && !istype(AM, /mob/living/simple_animal/construct) && !istype(AM, /mob/living/simple_animal/shade) && !istype(AM, /mob/living/simple_animal/hostile/viscerator))
			armed = 0
			var/mob/living/simple_animal/SA = AM
			SA.health -= 20
	..()


/obj/item/weapon/caution
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

/obj/item/weapon/caution/cone
	desc = "This cone is trying to warn you of something!"
	name = "warning cone"
	icon_state = "cone"

/obj/item/weapon/rack_parts
	name = "rack parts"
	desc = "Parts of a rack."
	icon = 'icons/obj/items.dmi'
	icon_state = "rack_parts"
	flags = CONDUCT
	m_amt = 3750

/obj/item/weapon/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	sharp = 1
	edge = 1
	desc = "Could probably be used as ... a throwing weapon?"
	w_class = 1.0
	force = 5.0
	throwforce = 8.0
	item_state = "shard-glass"
	g_amt = 3750
	attack_verb = list("stabbed", "slashed", "sliced", "cut")

/obj/item/weapon/shard/suicide_act(mob/user)
	viewers(user) << pick(SPAN_DANGER("[user] is slitting \his wrists with the shard of glass! It looks like \he's trying to commit suicide."), \
						SPAN_DANGER("[user] is slitting \his throat with the shard of glass! It looks like \he's trying to commit suicide."))
	return (BRUTELOSS)

/obj/item/weapon/shard/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/*/obj/item/weapon/syndicate_uplink
	name = "station bounced radio"
	desc = "Remain silent about this..."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 10.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/mob/currentUser = null
	var/obj/item/device/radio/origradio = null
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	w_class = 2.0
	item_state = "radio"
	throw_speed = 4
	throw_range = 20
	m_amt = 100
	origin_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_SYNDICATE = 3)*/

/obj/item/weapon/shard/shrapnel
	name = "shrapnel"
	icon = 'icons/obj/shards.dmi'
	icon_state = "shrapnellarge"
	desc = "A bunch of tiny bits of shattered metal."

/obj/item/weapon/shard/shrapnel/New()
	src.icon_state = pick("shrapnellarge", "shrapnelmedium", "shrapnelsmall")
	switch(src.icon_state)
		if("shrapnelsmall")
			src.pixel_x = rand(-12, 12)
			src.pixel_y = rand(-12, 12)
		if("shrapnelmedium")
			src.pixel_x = rand(-8, 8)
			src.pixel_y = rand(-8, 8)
		if("shrapnellarge")
			src.pixel_x = rand(-5, 5)
			src.pixel_y = rand(-5, 5)
		else
	return

/obj/item/weapon/SWF_uplink
	name = "station-bounced radio"
	desc = "used to communicate it appears."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "radio"
	throwforce = 5
	w_class = 2.0
	throw_speed = 4
	throw_range = 20
	m_amt = 100
	origin_tech = list(RESEARCH_TECH_MAGNETS = 1)

	var/temp = null
	var/uses = 4.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/obj/item/device/radio/origradio = null

/obj/item/weapon/table_parts
	name = "table parts"
	desc = "Parts of a table. Poor table."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "table_parts"
	m_amt = 3750
	flags = CONDUCT
	attack_verb = list("slammed", "bashed", "battered", "bludgeoned", "thrashed", "whacked")

/obj/item/weapon/table_parts/reinforced
	name = "reinforced table parts"
	desc = "Hard table parts. Well...harder..."
	icon = 'icons/obj/items.dmi'
	icon_state = "reinf_tableparts"
	m_amt = 7500
	flags = CONDUCT

/obj/item/weapon/table_parts/wood
	name = "wooden table parts"
	desc = "Keep away from fire."
	icon_state = "wood_tableparts"
	flags = null

/obj/item/weapon/wire
	desc = "This is just a simple piece of regular insulated wire."
	name = "wire"
	icon = 'icons/obj/power.dmi'
	icon_state = "item_wire"
	m_amt = 40
	attack_verb = list("whipped", "lashed", "disciplined", "tickled")

	var/amount = 1.0
	var/laying = 0.0
	var/old_lay = null

/obj/item/weapon/wire/suicide_act(mob/user)
	viewers(user) << SPAN_DANGER("[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.")
	return (OXYLOSS)

/obj/item/device/camera_bug
	name = "camera bug"
	icon = 'icons/obj/device.dmi'
	icon_state = "flash"
	w_class = 1.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20

/obj/item/weapon/camera_bug/attack_self(mob/usr as mob)
	var/list/cameras = new/list()
	for(var/obj/machinery/camera/C in cameranet.cameras)
		if(C.bugged && C.status)
			cameras.Add(C)
	if(length(cameras) == 0)
		to_chat(usr, SPAN_WARNING("No bugged functioning cameras found."))
		return

	var/list/friendly_cameras = new/list()

	for(var/obj/machinery/camera/C in cameras)
		friendly_cameras.Add(C.c_tag)

	var/target = input("Select the camera to observe", null) as null | anything in friendly_cameras
	if(!target)
		return
	for(var/obj/machinery/camera/C in cameras)
		if(C.c_tag == target)
			target = C
			break
	if(usr.stat == DEAD)
		return

	usr.client.eye = target

/obj/item/weapon/syntiflesh
	name = "syntiflesh"
	desc = "Meat that appears... strange..."
	icon = 'icons/obj/food.dmi'
	icon_state = "meat"
	flags = CONDUCT
	w_class = 1.0
	origin_tech = list(RESEARCH_TECH_BIOTECH = 2)

/obj/item/weapon/hatchet/soghunknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "soghunknife"
	attack_verb = list("ripped", "torn", "cut")

/*
/obj/item/weapon/cigarpacket
	name = "Pete's Cuban Cigars"
	desc = "The most robust cigars on the planet."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarpacket"
	item_state = "cigarpacket"
	w_class = 1
	throwforce = 2
	var/cigarcount = 6
	flags = ONBELT | TABLEPASS */

/obj/item/weapon/pai_cable
	desc = "A flexible coated cable with a universal jack on one end."
	name = "data cable"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

	var/obj/machinery/machine

/obj/item/weapon/ectoplasm
	name = "ectoplasm"
	desc = "spooky"
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

/obj/item/weapon/research	//Makes testing much less of a pain -Sieve
	name = "research"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "capacitor"
	desc = "A debug item for research."
	origin_tech = list(
		RESEARCH_TECH_MATERIALS = 8, RESEARCH_TECH_PROGRAMMING = 8, RESEARCH_TECH_MAGNETS = 8,
		RESEARCH_TECH_POWERSTORAGE = 8, RESEARCH_TECH_BLUESPACE = 8, RESEARCH_TECH_COMBAT = 8,
		RESEARCH_TECH_BIOTECH = 8, RESEARCH_TECH_SYNDICATE = 8
	)

// --- Things below are originally from weaponry.dm ---
/obj/item/weapon/banhammer
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

/obj/item/weapon/banhammer/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is hitting \himself with the [src.name]! It looks like \he's trying to ban \himself from life."))
	return (BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS)

/obj/item/weapon/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 15
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = 1

/obj/item/weapon/nullrod/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide."))
	return (BRUTELOSS | FIRELOSS)

/obj/item/weapon/nullrod/attack(mob/M as mob, mob/living/user as mob) //Paste from old-code to decult with a null rod.
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")

	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if(!(ishuman(user) || ticker) && ticker.mode.name != "monkey")
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	if(CLUMSY in user.mutations && prob(50))
		to_chat(user, SPAN_WARNING("The rod slips out of your hand and hits your head."))
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if(M.stat != DEAD)
		if(M.mind in ticker.mode.cult && prob(33))
			to_chat(M, SPAN_WARNING("The power of [src] clears your mind of the cult's influence!"))
			to_chat(user, SPAN_WARNING("You wave [src] over [M]'s head and see their eyes become clear, their mind returning to normal."))
			ticker.mode.remove_cultist(M.mind)
			M.visible_message(SPAN_WARNING("[user] waves [src] over [M]'s head."))
		else if(prob(10))
			to_chat(user, SPAN_WARNING("The rod slips in your hand."))
			..()
		else
			to_chat(user, SPAN_WARNING("The rod appears to do nothing."))
			M.visible_message(SPAN_WARNING("[user] waves [src] over [M]'s head."))

/obj/item/weapon/nullrod/afterattack(atom/A, mob/user as mob)
	if(istype(A, /turf/simulated/floor))
		to_chat(user, SPAN_INFO("You hit the floor with the [src]."))
		call(/obj/effect/rune/proc/revealrunes)(src)

/obj/item/weapon/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	slot_flags = SLOT_BELT
	force = 2
	throwforce = 1
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/sord/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide."))
	return(BRUTELOSS)

/obj/item/weapon/sord/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 40
	throwforce = 10
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/claymore/IsShield()
	return 1

/obj/item/weapon/claymore/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is falling on the [src.name]! It looks like \he's trying to commit suicide."))
	return(BRUTELOSS)

/obj/item/weapon/claymore/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/katana
	name = "katana"
	desc = "Woefully underpowered in D20"
	icon_state = "katana"
	item_state = "katana"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 40
	throwforce = 10
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/katana/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku."))
	return(BRUTELOSS)

/obj/item/weapon/katana/IsShield()
	return 1

/obj/item/weapon/katana/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/harpoon
	name = "harpoon"
	sharp = 1
	edge = 0
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	force = 20
	throwforce = 15
	w_class = 3
	attack_verb = list("jabbed", "stabbed", "ripped")