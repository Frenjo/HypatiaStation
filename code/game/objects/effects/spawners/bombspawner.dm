/* The old single tank bombs that dont really work anymore
/obj/effect/spawner/bomb
	name = "bomb"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x"
	var/btype = 0  //0 = radio, 1= prox, 2=time
	var/explosive = 1	// 0= firebomb
	var/btemp = 500	// bomb temperature (degC)
	var/active = 0

/obj/effect/spawner/bomb/radio
	btype = 0

/obj/effect/spawner/bomb/proximity
	btype = 1

/obj/effect/spawner/bomb/timer
	btype = 2

/obj/effect/spawner/bomb/timer/syndicate
	btemp = 450

/obj/effect/spawner/bomb/suicide
	btype = 3

/obj/effect/spawner/bomb/New()
	..()

	switch (src.btype)
		// radio
		if (0)
			var/obj/item/assembly/r_i_ptank/R = new /obj/item/assembly/r_i_ptank(src.loc)
			var/obj/item/tank/plasma/p3 = new /obj/item/tank/plasma(R)
			var/obj/item/radio/signaler/p1 = new /obj/item/radio/signaler(R)
			var/obj/item/igniter/p2 = new /obj/item/igniter(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			p1.master = R
			p2.master = R
			p3.master = R
			R.status = explosive
			p1.b_stat = 0
			p2.secured = 1
			p3.air_contents.temperature = btemp + T0C

		// proximity
		if (1)
			var/obj/item/assembly/m_i_ptank/R = new /obj/item/assembly/m_i_ptank(src.loc)
			var/obj/item/tank/plasma/p3 = new /obj/item/tank/plasma(R)
			var/obj/item/prox_sensor/p1 = new /obj/item/prox_sensor(R)
			var/obj/item/igniter/p2 = new /obj/item/igniter(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			p1.master = R
			p2.master = R
			p3.master = R
			R.status = explosive

			p3.air_contents.temperature = btemp + T0C
			p2.secured = 1

			if(src.active)
				R.part1.secured = 1
				R.part1.icon_state = text("motion[]", 1)
				R.c_state(1, src)

		// timer
		if (2)
			var/obj/item/assembly/t_i_ptank/R = new /obj/item/assembly/t_i_ptank(src.loc)
			var/obj/item/tank/plasma/p3 = new /obj/item/tank/plasma(R)
			var/obj/item/timer/p1 = new /obj/item/timer(R)
			var/obj/item/igniter/p2 = new /obj/item/igniter(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			p1.master = R
			p2.master = R
			p3.master = R
			R.status = explosive

			p3.air_contents.temperature = btemp + T0C
			p2.secured = 1
		//bombvest
		if(3)
			var/obj/item/clothing/suit/armor/a_i_a_ptank/R = new /obj/item/clothing/suit/armor/a_i_a_ptank(src.loc)
			var/obj/item/tank/plasma/p4 = new /obj/item/tank/plasma(R)
			var/obj/item/health_analyser/p1 = new /obj/item/health_analyser(R)
			var/obj/item/igniter/p2 = new /obj/item/igniter(R)
			var/obj/item/clothing/suit/armor/vest/p3 = new /obj/item/clothing/suit/armor/vest(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			R.part4 = p4
			p1.master = R
			p2.master = R
			p3.master = R
			p4.master = R
			R.status = explosive

			p4.air_contents.temperature = btemp + T0C
			p2.secured = 1

	del(src)
*/

/obj/effect/spawner/newbomb
	name = "bomb"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x"
	var/btype = 0 // 0=radio, 1=prox, 2=time

/obj/effect/spawner/newbomb/timer
	btype = 2

/obj/effect/spawner/newbomb/timer/syndicate

/obj/effect/spawner/newbomb/proximity
	btype = 1

/obj/effect/spawner/newbomb/radio
	btype = 0


/obj/effect/spawner/newbomb/initialise()
	. = ..()

	var/obj/item/transfer_valve/V = new(src.loc)
	var/obj/item/tank/plasma/PT = new(V)
	var/obj/item/tank/oxygen/OT = new(V)

	V.tank_one = PT
	V.tank_two = OT

	PT.master = V
	OT.master = V

	PT.air_contents.temperature = PLASMA_FLASHPOINT
	PT.air_contents.adjust_multi(/decl/xgm_gas/plasma, 12, /decl/xgm_gas/carbon_dioxide, 8)

	OT.air_contents.temperature = PLASMA_FLASHPOINT
	OT.air_contents.adjust_gas(/decl/xgm_gas/oxygen, 20)

	var/obj/item/assembly/S

	switch(src.btype)
		// radio
		if(0)
			S = new/obj/item/assembly/signaler(V)

		// proximity
		if(1)
			S = new/obj/item/assembly/prox_sensor(V)

		// timer
		if(2)
			S = new/obj/item/assembly/timer(V)


	V.attached_device = S

	S.holder = V
	S.toggle_secure()

	V.update_icon()

	qdel(src)