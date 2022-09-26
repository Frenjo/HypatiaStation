/obj/item/device/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	flags = CONDUCT
	w_class = 2.0
	m_amt = 100
	g_amt = 0
	w_amt = 0
	throwforce = 2
	throw_speed = 3
	throw_range = 10
	origin_tech = list(RESEARCH_TECH_MAGNETS = 1)

	var/secured = 1
	var/list/attached_overlays = null
	var/obj/item/device/assembly_holder/holder = null
	var/cooldown = 0	//To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

//What the device does when turned on
/obj/item/device/assembly/proc/activate()
	return

//Called when another assembly acts on this one, var/radio will determine where it came from for wire calcs
/obj/item/device/assembly/proc/pulsed(radio = 0)
	return

//Called when this device attempts to act on another device, var/radio determines if it was sent via radio or direct
/obj/item/device/assembly/proc/pulse(radio = 0)
	return

//Code that has to happen when the assembly is un\secured goes here
/obj/item/device/assembly/proc/toggle_secure()
	return

//Called when an assembly is attacked by another
/obj/item/device/assembly/proc/attach_assembly(obj/A, mob/user)
	return

//Called via spawn(10) to have it count down the cooldown var
/obj/item/device/assembly/proc/process_cooldown()
	return

//Called when the holder is moved
/obj/item/device/assembly/proc/holder_movement()
	return

//Called when attack_self is called
/obj/item/device/assembly/interact(mob/user as mob)
	return

/obj/item/device/assembly/process_cooldown()
	cooldown--
	if(cooldown <= 0)
		return 0
	spawn(10)
		process_cooldown()
	return 1

/obj/item/device/assembly/pulsed(radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return 1

/obj/item/device/assembly/pulse(radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
//	if(radio && (wires & WIRE_RADIO_PULSE))
		//Not sure what goes here quite yet send signal?
	return 1

/obj/item/device/assembly/activate()
	if(!secured || (cooldown > 0))
		return 0
	cooldown = 2
	spawn(10)
		process_cooldown()
	return 1

/obj/item/device/assembly/toggle_secure()
	secured = !secured
	update_icon()
	return secured

/obj/item/device/assembly/attach_assembly(obj/item/device/assembly/A, mob/user)
	holder = new/obj/item/device/assembly_holder(get_turf(src))
	if(holder.attach(A, src, user))
		to_chat(user, SPAN_INFO("You attach \the [A] to \the [src]!"))
		return 1
	return 0

/obj/item/device/assembly/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isassembly(W))
		var/obj/item/device/assembly/A = W
		if((!A.secured) && (!secured))
			attach_assembly(A, user)
			return
	if(isscrewdriver(W))
		if(toggle_secure())
			to_chat(user, SPAN_INFO("\The [src] is ready!"))
		else
			to_chat(user, SPAN_INFO("\The [src] can now be attached!"))
		return
	..()
	return

/obj/item/device/assembly/process()
	GLOBL.processing_objects.Remove(src)
	return

/obj/item/device/assembly/examine()
	set src in view()
	..()
	if((in_range(src, usr) || loc == usr))
		if(secured)
			to_chat(usr, "\The [src] is ready!")
		else
			to_chat(usr, "\The [src] can be attached!")
	return

/obj/item/device/assembly/attack_self(mob/user as mob)
	if(!user)
		return 0
	user.set_machine(src)
	interact(user)
	return 1

/obj/item/device/assembly/interact(mob/user as mob)
	return //HTML MENU FOR WIRES GOES HERE

/*
	var/small_icon_state = null//If this obj will go inside the assembly use this for icons
	var/list/small_icon_state_overlays = null//Same here
	var/obj/holder = null
	var/cooldown = 0//To prevent spam

	proc
		Activate()//Called when this assembly is pulsed by another one
		Process_cooldown()//Call this via spawn(10) to have it count down the cooldown var
		Attach_Holder(var/obj/H, var/mob/user)//Called when an assembly holder attempts to attach, sets src's loc in here


	Activate()
		if(cooldown > 0)
			return 0
		cooldown = 2
		spawn(10)
			Process_cooldown()
		//Rest of code here
		return 0


	Process_cooldown()
		cooldown--
		if(cooldown <= 0)	return 0
		spawn(10)
			Process_cooldown()
		return 1


	Attach_Holder(var/obj/H, var/mob/user)
		if(!H)	return 0
		if(!H.IsAssemblyHolder())	return 0
		//Remember to have it set its loc somewhere in here
*/