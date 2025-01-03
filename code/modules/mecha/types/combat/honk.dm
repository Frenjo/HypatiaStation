/obj/mecha/combat/honk
	name = "\improper H.O.N.K"
	desc = "Produced by \"Tyranny of Honk, INC\", this exosuit is designed as heavy clown-support. Used to spread the fun and joy of life. HONK!"
	icon_state = "honk"
	infra_luminosity = 5
	initial_icon = "honk"

	health = 140
	step_in = 2
	deflect_chance = 60
	damage_absorption = list("brute" = 1.2, "fire" = 1.5, "bullet" = 1, "laser" = 1, "energy" = 1, "bomb" = 1)
	internal_damage_threshold = 60

	operation_req_access = list(ACCESS_CLOWN)
	add_req_access = FALSE

	wreckage = /obj/structure/mecha_wreckage/honk

	var/squeak = FALSE

/obj/mecha/combat/honk/New()
	. = ..()
	excluded_equipment.Add(/obj/item/mecha_part/equipment/melee_armour_booster, /obj/item/mecha_part/equipment/ranged_armour_booster)

/obj/mecha/combat/honk/melee_action(target)
	if(!melee_can_hit)
		return

	if(ismob(target))
		step_away(target, src, 15)

/obj/mecha/combat/honk/get_stats_part()
	var/integrity = health / initial(health) * 100
	var/cell_charge = get_charge()
	var/tank_pressure = internal_tank ? round(internal_tank.return_pressure(), 0.01) : "None"
	var/tank_temperature = internal_tank ? internal_tank.return_temperature() : "Unknown"
	var/cabin_pressure = round(return_pressure(), 0.01)
	. = {"[report_internal_damage()]
						[integrity < 30 ? "<font color='red'><b>DAMAGE LEVEL CRITICAL</b></font><br>" : null]
						[internal_damage & MECHA_INT_TEMP_CONTROL ? "<font color='red'><b>CLOWN SUPPORT SYSTEM MALFUNCTION</b></font><br>" : null]
						[internal_damage & MECHA_INT_TANK_BREACH ? "<font color='red'><b>GAS TANK HONK</b></font><br>" : null]
						[internal_damage & MECHA_INT_CONTROL_LOST ? "<font color='red'><b>HONK-A-DOODLE</b></font> - <a href='byond://?src=\ref[src];repair_int_control_lost=1'>Recalibrate</a><br>" : null]
						<b>IntegriHONK: </b> [integrity]%<br>
						<b>PowerHONK charge: </b>[isnull(cell_charge) ? "No powercell installed" : "[cell.percent()]%"]<br>
						<b>Air source: </b>[use_internal_tank ? "Internal Airtank" : "Environment"]<br>
						<b>AirHONK pressure: </b>[tank_pressure]kPa<br>
						<b>AirHONK temperature: </b>[tank_temperature]&deg;K|[tank_temperature - T0C]&deg;C<br>
						<b>HONK pressure: </b>[cabin_pressure>WARNING_HIGH_PRESSURE ? "<font color='red'>[cabin_pressure]</font>": cabin_pressure]kPa<br>
						<b>HONK temperature: </b> [return_temperature()]&deg;K|[return_temperature() - T0C]&deg;C<br>
						<b>Lights: </b>[lights ? "on" : "off"]<br>
						[dna ? "<b>DNA-locked:</b><br> <span style='font-size:10px;letter-spacing:-1px;'>[dna]</span> \[<a href='byond://?src=\ref[src];reset_dna=1'>Reset</a>\]<br>" : null]
					"}

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

/obj/mecha/combat/honk/get_commands()
	. = {"<div class='wr'>
						<div class='header'>Sounds of HONK:</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];play_sound=sadtrombone'>Sad Trombone</a>
						</div>
						</div>
						"}
	. += ..()

/obj/mecha/combat/honk/get_equipment_list()
	if(!length(equipment))
		return
	. = "<b>Honk-ON-Systems:</b><div style=\"margin-left: 15px;\">"
	for(var/obj/item/mecha_part/equipment/MT in equipment)
		. += "[selected == MT ? "<b id='\ref[MT]'>" : "<a id='\ref[MT]' href='byond://?src=\ref[src];select_equip=\ref[MT]'>"][MT.get_equip_info()][selected == MT ? "</b>" : "</a>"]<br>"
	. += "</div>"

/obj/mecha/combat/honk/mechstep(direction)
	. = step(src, direction)
	if(.)
		if(!squeak)
			playsound(src, "clownstep", 70, 1)
			squeak = TRUE
		else
			squeak = FALSE

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