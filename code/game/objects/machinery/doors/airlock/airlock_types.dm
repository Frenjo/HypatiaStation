/obj/machinery/door/airlock/command
	name = "Airlock"
	icon = 'icons/obj/doors/command.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_com

/obj/machinery/door/airlock/security
	name = "Airlock"
	icon = 'icons/obj/doors/security/security.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_sec

/obj/machinery/door/airlock/security/hatch
	icon = 'icons/obj/doors/security/armoury_hatch.dmi'

/obj/machinery/door/airlock/engineering
	name = "Airlock"
	icon = 'icons/obj/doors/engineering/engineering.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_eng

/obj/machinery/door/airlock/medical
	name = "Airlock"
	icon = 'icons/obj/doors/medsci/medical.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_med

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	icon = 'icons/obj/doors/engineering/maintenance.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_mai

/obj/machinery/door/airlock/maintenance/New()
	. = ..()
	GLOBL.maintenance_airlocks_list.Add(src)

/obj/machinery/door/airlock/maintenance/Destroy()
	GLOBL.maintenance_airlocks_list.Remove(src)
	return ..()

/obj/machinery/door/airlock/maintenance/update_icon()
	if(!isnull(overlays))
		overlays.Cut()
	if(density)
		// Maintenance doors flash yellow if we have emergency maintenance access. -Frenjo
		if(isStationLevel(z) && maint_all_access)
			if(lights && !locked)
				icon_state = "door_maint_access"
			else if(lights && locked)
				icon_state = "door_maint_access_locked"
		else if(locked && lights)
			icon_state = "door_locked"
		else
			icon_state = "door_closed"
		if(p_open || welded)
			overlays = list()
			if(p_open)
				overlays.Add(image(icon, "panel_open"))
			if(welded)
				overlays.Add(image(icon, "welded"))
	else
		icon_state = "door_open"

/obj/machinery/door/airlock/maintenance/do_animate(animation)
	switch(animation)
		if("opening")
			if(!isnull(overlays))
				overlays.Cut()
			if(p_open)
				flick("o_door_opening", src)
			else
				flick("door_opening", src)
		if("closing")
			if(!isnull(overlays))
				overlays.Cut()
			if(p_open)
				flick("o_door_closing", src)
			else
				flick("door_closing", src)
		if("spark")
			flick("door_spark", src)
		if("deny")
			// Flick to deny even if the door has maint access. -Frenjo
			if(isStationLevel(z) && maint_all_access)
				flick("door_maint_access_locked_deny", src)
			else
				flick("door_deny", src)

/obj/machinery/door/airlock/external
	name = "External Airlock"
	icon = 'icons/obj/doors/exterior.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext

/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/centcom
	name = "Airlock"
	icon = 'icons/obj/doors/ele.dmi'
	opacity = FALSE

/obj/machinery/door/airlock/vault
	name = "Vault"
	icon = 'icons/obj/doors/vault.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	icon = 'icons/obj/doors/freezer.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_fre

/obj/machinery/door/airlock/hatch
	name = "Airtight Hatch"
	icon = 'icons/obj/doors/ele_hatch.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch

/obj/machinery/door/airlock/maintenance_hatch
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/engineering/maintenance_hatch.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_mhatch

/obj/machinery/door/airlock/glass_command
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/command_glass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	glass = TRUE

/obj/machinery/door/airlock/glass_engineering
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/engineering/engineering_glass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	glass = TRUE

/obj/machinery/door/airlock/glass_security
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/security/security_glass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	glass = TRUE

/obj/machinery/door/airlock/glass_medical
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/medsci/medical_glass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	glass = TRUE

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	icon = 'icons/obj/doors/mining.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_min

/obj/machinery/door/airlock/atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/engineering/atmos.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo

/obj/machinery/door/airlock/research
	name = "Airlock"
	icon = 'icons/obj/doors/medsci/research.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_research

/obj/machinery/door/airlock/glass_research
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/medsci/research_glass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	glass = TRUE
	heat_proof = TRUE

// Adds dual medical/research airlocks, I sprited these too. -Frenjo
/obj/machinery/door/airlock/medres
	name = "Airlock"
	icon = 'icons/obj/doors/medsci/medsci.dmi'
	//assembly_type = /obj/structure/door_assembly/door_assembly_research

/obj/machinery/door/airlock/glass_medres
	name = "Airlock"
	icon = 'icons/obj/doors/medsci/medsci_glass.dmi'
	//assembly_type = /obj/structure/door_assembly/door_assembly_research
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/glass_mining
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/mining_glass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	glass = TRUE

/obj/machinery/door/airlock/glass_atmos
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/engineering/atmos_glass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	glass = TRUE

/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	icon = 'icons/obj/doors/mineral/gold.dmi'
	mineral = MATERIAL_GOLD

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	icon = 'icons/obj/doors/mineral/silver.dmi'
	mineral = MATERIAL_SILVER

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	icon = 'icons/obj/doors/mineral/diamond.dmi'
	mineral = MATERIAL_DIAMOND

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	icon = 'icons/obj/doors/mineral/uranium.dmi'
	mineral = MATERIAL_URANIUM

	var/last_event = 0

/obj/machinery/door/airlock/uranium/process()
	if(world.time > last_event + 20)
		if(prob(50))
			radiate()
		last_event = world.time
	. = ..()

/obj/machinery/door/airlock/uranium/proc/radiate()
	for(var/mob/living/L in range (3, src))
		L.apply_effect(15, IRRADIATE, 0)

/obj/machinery/door/airlock/plasma
	name = "Plasma Airlock"
	desc = "No way this can end badly."
	icon = 'icons/obj/doors/mineral/plasma.dmi'
	mineral = MATERIAL_PLASMA

/obj/machinery/door/airlock/plasma/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/obj/machinery/door/airlock/plasma/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/obj/machinery/door/airlock/plasma/proc/PlasmaBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2, loc))
		target_tile.assume_gas(/decl/xgm_gas/plasma, 35, 400 + T0C)
		spawn(0)
			target_tile.hotspot_expose(temperature, 400)
	for(var/obj/structure/falsewall/plasma/F in range(3, src))	//Hackish as fuck, but until temperature_expose works, there is nothing I can do -Sieve
		var/turf/T = get_turf(F)
		T.ChangeTurf(/turf/simulated/wall/mineral/plasma)
		qdel(F)
	for(var/turf/simulated/wall/mineral/plasma/W in range(3, src))
		W.ignite(temperature / 4)	//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/plasma/D in range(3, src))
		D.ignite(temperature / 4)
	new /obj/structure/door_assembly(loc)
	qdel(src)

/obj/machinery/door/airlock/clown
	name = "Bananium Airlock"
	icon = 'icons/obj/doors/mineral/bananium.dmi'
	mineral = MATERIAL_BANANIUM

/obj/machinery/door/airlock/sandstone
	name = "Sandstone Airlock"
	icon = 'icons/obj/doors/mineral/sandstone.dmi'
	mineral = MATERIAL_SANDSTONE

/obj/machinery/door/airlock/science
	name = "Airlock"
	icon = 'icons/obj/doors/medsci/science.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_science

/obj/machinery/door/airlock/glass_science
	name = "Glass Airlocks"
	icon = 'icons/obj/doors/medsci/science_glass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	glass = 1

/obj/machinery/door/airlock/highsecurity
	name = "High Tech Security Airlock"
	icon = 'icons/obj/doors/security/high_tech_security.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity