/obj/item/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = 4.0
	force = 10
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_MATERIALS = 2)
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

	var/recentpump = 0 // to prevent spammage
	var/pumped = 0
	var/obj/item/ammo_casing/current_shell = null

/obj/item/gun/projectile/shotgun/pump/isHandgun()
	return FALSE

/obj/item/gun/projectile/shotgun/pump/load_into_chamber()
	if(in_chamber)
		return 1
	return 0

/obj/item/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(recentpump)
		return

	pump(user)
	recentpump = 1
	spawn(10)
		recentpump = 0
	return

/obj/item/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)
	pumped = 0
	if(current_shell)//We have a shell in the chamber
		current_shell.loc = get_turf(src)//Eject casing
		current_shell = null
		if(in_chamber)
			in_chamber = null
	if(!length(loaded))
		return 0

	var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
	loaded -= AC //Remove casing from loaded list.
	current_shell = AC
	if(AC.BB)
		in_chamber = AC.BB //Load projectile into chamber.
	update_icon()	//I.E. fix the desc
	return 1

/obj/item/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	icon_state = "cshotgun"
	max_shells = 8
	origin_tech = list(RESEARCH_TECH_COMBAT = 5, RESEARCH_TECH_MATERIALS = 2)
	ammo_type = /obj/item/ammo_casing/shotgun

//this is largely hacky and bad :(	-Pete
/obj/item/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon_state = "dshotgun"
	item_state = "shotgun"
	max_shells = 2
	w_class = 4.0
	force = 10
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 1)
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/gun/projectile/shotgun/doublebarrel/load_into_chamber()
//		if(in_chamber)
//			return 1 {R}
	if(!length(loaded))
		return 0

	var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
	loaded -= AC //Remove casing from loaded list.
	AC.desc += " This one is spent."

	if(AC.BB)
		in_chamber = AC.BB //Load projectile into chamber.
		AC.BB.loc = src //Set projectile loc to gun.
		return 1
	return 0

/obj/item/gun/projectile/shotgun/doublebarrel/attack_self(mob/living/user as mob)
	if(!(locate(/obj/item/ammo_casing/shotgun) in src) && !length(loaded))
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))
		return

	for(var/obj/item/ammo_casing/shotgun/shell in src)	//This feels like a hack.	//don't code at 3:30am kids!!
		if(shell in loaded)
			loaded -= shell
		shell.loc = get_turf(src.loc)

	to_chat(user, SPAN_NOTICE("You break \the [src]."))
	update_icon()

/obj/item/gun/projectile/shotgun/doublebarrel/attackby(obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/ammo_casing) && !load_method)
		var/obj/item/ammo_casing/AC = A
		if(AC.caliber == caliber && (length(loaded) < max_shells) && (length(contents) < max_shells))	//forgive me father, for i have sinned
			user.drop_item()
			AC.loc = src
			loaded += AC
			to_chat(user, SPAN_NOTICE("You load a shell into \the [src]!"))
	A.update_icon()
	update_icon()

	if(istype(A, /obj/item/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/pickaxe/plasmacutter))
		to_chat(user, SPAN_NOTICE("You begin to shorten the barrel of \the [src]."))
		if(length(loaded))
			afterattack(user, user)	//will this work?
			afterattack(user, user)	//it will. we call it twice, for twice the FUN
			playsound(user, fire_sound, 50, 1)
			user.visible_message(SPAN_DANGER("The shotgun goes off!"), SPAN_DANGER("The shotgun goes off in your face!"))
			return

		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			w_class = 3.0
			item_state = "gun"
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
			name = "sawn-off shotgun"
			desc = "Omar's coming!"
			to_chat(user, SPAN_WARNING("You shorten the barrel of \the [src]!"))