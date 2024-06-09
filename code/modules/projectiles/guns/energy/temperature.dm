/obj/item/gun/energy/temperature
	name = "temperature gun"
	desc = "A gun that changes temperatures."
	icon_state = "freezegun"

	origin_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 2, /datum/tech/combat = 3,
		/datum/tech/power_storage = 3
	)

	fire_sound = 'sound/weapons/pulse3.ogg'

	cell_type = /obj/item/cell/crap

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/temp)

	var/temperature = T20C
	var/current_temperature = T20C

/obj/item/gun/energy/temperature/New()
	. = ..()
	GLOBL.processing_objects.Add(src)

/obj/item/gun/energy/temperature/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/gun/energy/temperature/attack_self(mob/living/user)
	user.set_machine(src)
	var/temp_text = ""
	if(temperature > (T0C - 50))
		temp_text = "<FONT color=black>[temperature] ([round(temperature-T0C)]&deg;C) ([round(temperature*1.8-459.67)]&deg;F)</FONT>"
	else
		temp_text = "<FONT color=blue>[temperature] ([round(temperature-T0C)]&deg;C) ([round(temperature*1.8-459.67)]&deg;F)</FONT>"

	var/dat = {"<B>Freeze Gun Configuration: </B><BR>
	Current output temperature: [temp_text]<BR>
	Target output temperature: <A href='byond://?src=\ref[src];temp=-100'>-</A> <A href='byond://?src=\ref[src];temp=-10'>-</A> <A href='byond://?src=\ref[src];temp=-1'>-</A> [current_temperature] <A href='byond://?src=\ref[src];temp=1'>+</A> <A href='byond://?src=\ref[src];temp=10'>+</A> <A href='byond://?src=\ref[src];temp=100'>+</A><BR>
	"}

	user << browse(dat, "window=freezegun;size=450x300;can_resize=1;can_close=1;can_minimize=1")
	onclose(user, "window=freezegun", src)

/obj/item/gun/energy/temperature/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		if(amount > 0)
			current_temperature = min(500, current_temperature + amount)
		else
			current_temperature = max(0, current_temperature + amount)
	if(ismob(loc))
		attack_self(loc)
	add_fingerprint(usr)
	return

/obj/item/gun/energy/temperature/process()
	switch(temperature)
		if(0 to 100)
			charge_cost = 1000
		if(100 to 250)
			charge_cost = 500
		if(251 to 300)
			charge_cost = 100
		if(301 to 400)
			charge_cost = 500
		if(401 to 500)
			charge_cost = 1000

	if(current_temperature != temperature)
		var/difference = abs(current_temperature - temperature)
		if(difference >= 10)
			if(current_temperature < temperature)
				temperature -= 10
			else
				temperature += 10
		else
			temperature = current_temperature