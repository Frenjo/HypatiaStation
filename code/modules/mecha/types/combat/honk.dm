/obj/mecha/combat/honk
	name = "\improper H.O.N.K"
	desc = "Produced by \"Tyranny of Honk, INC\", this exosuit is designed as heavy clown-support. Used to spread the fun and joy of life. HONK!"
	icon_state = "honk"
	infra_luminosity = 5

	health = 140
	move_delay = 0.3 SECONDS
	deflect_chance = 60
	damage_resistance = list("brute" = 0, "fire" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0)
	internal_damage_threshold = 60

	operation_req_access = list(ACCESS_CLOWN)
	add_req_access = FALSE

	mecha_type = MECHA_TYPE_HONK
	excluded_equipment = list(
		/obj/item/mecha_equipment/melee_armour_booster,
		/obj/item/mecha_equipment/melee_defence_shocker,
		/obj/item/mecha_equipment/ranged_armour_booster,
		/obj/item/mecha_equipment/emp_insulation
	)

	wreckage = /obj/structure/mecha_wreckage/honk

	var/squeak = TRUE

/obj/mecha/combat/honk/melee_action(target)
	if(!melee_can_hit)
		return

	if(ismob(target))
		step_away(target, src, 15)

/obj/mecha/combat/honk/play_step_sound()
	if(squeak)
		playsound(src, "clownstep", 70, 1)
	squeak = !squeak

/obj/mecha/combat/honk/wreck()
	. = ..()
	playsound(src, 'sound/misc/sadtrombone.ogg', 50) // Womp womp!

/obj/mecha/combat/honk/get_stats_html()
	. = {"<html>
		<head><title>[name] data</title>
		<style>
		body {color: #00ff00; background: #32CD32; font-family:"Courier",monospace; font-size: 12px;}
		hr {border: 1px solid #0f0; color: #fff; background-color: #000;}
		a {padding:2px 5px;;color:#0f0;}
		.wr {margin-bottom: 5px;}
		.header {cursor:pointer;}
		.open, .closed {background: #32CD32; color:#000; padding:1px 2px;}
		.links a {margin-bottom: 2px;padding-top:3px;}
		.visible {display: block;}
		.hidden {display: none;}
		</style>
		<script language='javascript' type='text/javascript'>
		[js_byjax]
		[js_dropdowns]
		function ticker() {
			setInterval(function(){
				window.location='byond://?src=\ref[src]&update_content=1';
				document.body.style.color = get_rand_color_string();
				document.body.style.background = get_rand_color_string();
			}, 1000);
		}

		function get_rand_color_string() {
			var color = new Array;
			for(var i=0;i<3;i++){
				color.push(Math.floor(Math.random()*255));
			}
			return "rgb("+color.toString()+")";
		}

		window.onload = function() {
			dropdowns();
			ticker();
		}
		</script>
		</head>
		<body>
		<div id='content'>
		[get_stats_part()]
		</div>
		<div id='eq_list'>
		[get_equipment_list()]
		</div>
		<hr>
		<div id='commands'>
		[get_commands()]
		</div>
		</body>
		</html>
	"}

/obj/mecha/combat/honk/get_stats_part()
	var/integrity = health / initial(health) * 100
	var/cell_charge = get_charge()
	var/tank_pressure = internal_tank ? round(internal_tank.return_pressure(), 0.01) : "None"
	var/tank_temperature = internal_tank ? internal_tank.return_temperature() : "Unknown"
	var/cabin_pressure = round(return_pressure(), 0.01)
	. = {"[report_internal_damage()]
		[integrity < 30 ? "[SPAN_DANGER("DAMAGE LEVEL CRITICAL")]<br>" : null]
		[internal_damage & MECHA_INT_TEMP_CONTROL ? "[SPAN_DANGER("CLOWN SUPPORT SYSTEM MALFUNCTION")]<br>" : null]
		[internal_damage & MECHA_INT_TANK_BREACH ? "[SPAN_DANGER("GAS TANK HONK")]<br>" : null]
		[internal_damage & MECHA_INT_CONTROL_LOST ? "[SPAN_DANGER("HONK-A-DOODLE")] - <a href='byond://?src=\ref[src];repair_int_control_lost=1'>Recalibrate</a><br>" : null]
		<b>IntegriHONK: </b> [integrity]%<br>
		<b>PowerHONK Charge: </b>[isnull(cell_charge) ? "no power cell installed" : "[cell.percent()]%"]<br>
		<b>Air Source: </b>[use_internal_tank ? "internal air tank" : "environment"]<br>
		<b>AirHONK Pressure: </b>[tank_pressure]kPa<br>
		<b>AirHONK Temperature: </b>[tank_temperature]&deg;K|[tank_temperature - T0C]&deg;C<br>
		<b>HONK Pressure: </b>[cabin_pressure > WARNING_HIGH_PRESSURE ? SPAN_WARNING(cabin_pressure) : cabin_pressure]kPa<br>
		<b>HONK Temperature: </b> [return_temperature()]&deg;K|[return_temperature() - T0C]&deg;C<br>
		<b>Lights: </b>[lights ? "on" : "off"]<br>
		[dna ? "<b>DNA-locked:</b><br> <span style='font-size:10px;letter-spacing:-1px;'>[dna]</span> \[<a href='byond://?src=\ref[src];reset_dna=1'>Reset</a>\]<br>" : null]
	"}

/obj/mecha/combat/honk/get_equipment_list()
	if(!length(equipment))
		return
	. = "<b>Honk-ON-Systems:</b><div style=\"margin-left: 15px;\">"
	for_no_type_check(var/obj/item/mecha_equipment/equip, equipment)
		. += "[selected == equip ? "<b id='\ref[equip]'>" : "<a id='\ref[equip]' href='byond://?src=\ref[src];select_equip=\ref[equip]'>"][equip.get_equip_info()][selected == equip ? "</b>" : "</a>"]<br>"
	. += "</div>"

/obj/mecha/combat/honk/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Sounds of HONK:</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];play_sound=sadtrombone'>Sad Trombone</a>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/combat/honk/Topic(href, href_list)
	. = ..()
	if(href_list["play_sound"])
		switch(href_list["play_sound"])
			if("sadtrombone")
				playsound(src, 'sound/misc/sadtrombone.ogg', 50)

/proc/rand_hex_colour()
	var/list/colours = list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f")
	. = ""
	for(var/i = 0; i < 6; i++)
		. += pick(colours)