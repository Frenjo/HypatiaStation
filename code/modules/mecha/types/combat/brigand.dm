// Brigand
/obj/mecha/combat/brigand
	name = "\improper Brigand"
	desc = "An exceptionally slow, heavy-duty, prototype combat exosuit. \
		Principally, it consists of a Durand-type skeleton with an engineering-grade emitter mounted to it. \
		The Brigand-type was the first exosuit to be installed with experimental armour plating that would later see regular use on the Marauder- and Seraph-types."
	icon_state = "brigand"
	infra_luminosity = 5

	force = 42.5

	health = 450
	move_delay = 0.6 SECONDS
	max_temperature = 45000
	deflect_chance = 22.5
	damage_resistance = list(brute = 50, fire = 15, bullet = 45, laser = 27.5, energy = 20, bomb = 25)
	internal_damage_threshold = 37.5

	max_equip = 4
	mecha_type = MECHA_TYPE_BRIGAND
	starts_with = list(/obj/item/mecha_equipment/weapon/energy/brigand_emitter)

	wreckage = /obj/structure/mecha_wreckage/durand/brigand // This is a subtype as it's made with Durand parts.

	zoom_capable = TRUE
	defence_mode_capable = TRUE

/obj/mecha/combat/brigand/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];defence_mode=1'><span id="defence_mode_command">[defence_mode ? "Dis" : "En"]able Defence Mode</span></a>
		<a href='byond://?src=\ref[src];zoom=1'><span id="zoom_command">[zoom_mode ? "Dis" : "En"]able Zoom Mode</span></a><br>
		</div>
		</div>
	"}
	. += ..()