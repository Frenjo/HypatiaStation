/decl/hierarchy/supply_pack/engineering
	name = "Engineering"


/decl/hierarchy/supply_pack/engineering/internals
	name = "Internals crate"
	contains = list(
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/tank/air,
		/obj/item/weapon/tank/air,
		/obj/item/weapon/tank/air
	)
	cost = 10
	containertype = /obj/structure/closet/crate/internals
	containername = "Internals crate"


/decl/hierarchy/supply_pack/engineering/evacuation
	name = "Emergency equipment"
	contains = list(
		/obj/item/weapon/storage/toolbox/emergency,
		/obj/item/weapon/storage/toolbox/emergency,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/weapon/tank/emergency_oxygen,
		/obj/item/weapon/tank/emergency_oxygen,
		/obj/item/weapon/tank/emergency_oxygen,
		/obj/item/weapon/tank/emergency_oxygen,
		/obj/item/weapon/tank/emergency_oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas
	)
	cost = 35
	containertype = /obj/structure/closet/crate/internals
	containername = "Emergency crate"


/decl/hierarchy/supply_pack/engineering/inflatables
	name = "Inflatable barriers"
	contains = list(
		/obj/item/weapon/storage/briefcase/inflatable,
		/obj/item/weapon/storage/briefcase/inflatable,
		/obj/item/weapon/storage/briefcase/inflatable
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Inflatable Barrier Crate"


/decl/hierarchy/supply_pack/engineering/lightbulbs
	name = "Replacement lights"
	contains = list(
		/obj/item/weapon/storage/box/lights/mixed,
		/obj/item/weapon/storage/box/lights/mixed,
		/obj/item/weapon/storage/box/lights/mixed
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Replacement lights"


/decl/hierarchy/supply_pack/engineering/metal50
	name = "50 metal sheets"
	contains = list(/obj/item/stack/sheet/metal)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Metal sheets crate"


/decl/hierarchy/supply_pack/engineering/glass50
	name = "50 glass sheets"
	contains = list(/obj/item/stack/sheet/glass)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Glass sheets crate"


/decl/hierarchy/supply_pack/engineering/wood50
	name = "50 wooden planks"
	contains = list(/obj/item/stack/sheet/wood)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Wooden planks crate"


/decl/hierarchy/supply_pack/engineering/electrical
	name = "Electrical maintenance crate"
	contains = list(
		/obj/item/weapon/storage/toolbox/electrical,
		/obj/item/weapon/storage/toolbox/electrical,
		/obj/item/clothing/gloves/yellow,
		/obj/item/clothing/gloves/yellow,
		/obj/item/weapon/cell,
		/obj/item/weapon/cell,
		/obj/item/weapon/cell/high,
		/obj/item/weapon/cell/high
	)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Electrical maintenance crate"


/decl/hierarchy/supply_pack/engineering/mechanical
	name = "Mechanical maintenance crate"
	contains = list(
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/hardhat
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Mechanical maintenance crate"


/decl/hierarchy/supply_pack/engineering/fueltank
	name = "Fuel tank crate"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"


/decl/hierarchy/supply_pack/engineering/solar
	name = "Solar Pack crate"
	contains  = list(
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly, // 21 Solar Assemblies. 1 Extra for the controller
		/obj/item/weapon/circuitboard/solar_control,
		/obj/item/weapon/tracker_electronics,
		/obj/item/weapon/paper/solar
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Solar pack crate"


/decl/hierarchy/supply_pack/engineering/engine
	name = "Emitter crate"
	contains = list(
		/obj/machinery/power/emitter,
		/obj/machinery/power/emitter
	)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Emitter crate"
	access = access_ce


/decl/hierarchy/supply_pack/engineering/field_gen
	name = "Field Generator crate"
	contains = list(
		/obj/machinery/field_generator,
		/obj/machinery/field_generator
	)
	containertype = /obj/structure/closet/crate/secure
	containername = "Field Generator crate"
	access = access_ce


/decl/hierarchy/supply_pack/engineering/sing_gen
	name = "Singularity Generator crate"
	contains = list(/obj/machinery/the_singularitygen)
	containertype = /obj/structure/closet/crate/secure
	containername = "Singularity Generator crate"
	access = access_ce


/decl/hierarchy/supply_pack/engineering/collector
	name = "Collector crate"
	contains = list(
		/obj/machinery/power/rad_collector,
		/obj/machinery/power/rad_collector,
		/obj/machinery/power/rad_collector
	)
	containername = "Collector crate"


/decl/hierarchy/supply_pack/engineering/particle_accelerator
	name = "Particle Accelerator crate"
	cost = 40
	contains = list(
		/obj/structure/particle_accelerator/fuel_chamber,
		/obj/machinery/particle_accelerator/control_box,
		/obj/structure/particle_accelerator/particle_emitter/center,
		/obj/structure/particle_accelerator/particle_emitter/left,
		/obj/structure/particle_accelerator/particle_emitter/right,
		/obj/structure/particle_accelerator/power_box,
		/obj/structure/particle_accelerator/end_cap
	)
	containertype = /obj/structure/closet/crate/secure
	containername = "Particle Accelerator crate"
	access = access_ce


/decl/hierarchy/supply_pack/engineering/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(
		/obj/item/weapon/book/manual/ripley_build_and_repair,
		/obj/item/weapon/circuitboard/mecha/ripley/main,		//TEMPORARY due to lack of circuitboard printer
		/obj/item/weapon/circuitboard/mecha/ripley/peripherals	//TEMPORARY due to lack of circuitboard printer
	)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "APLU \"Ripley\" Circuit Crate"
	access = access_robotics


/decl/hierarchy/supply_pack/engineering/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(
		/obj/item/weapon/circuitboard/mecha/odysseus/peripherals,	//TEMPORARY due to lack of circuitboard printer
		/obj/item/weapon/circuitboard/mecha/odysseus/main			//TEMPORARY due to lack of circuitboard printer
	)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\"Odysseus\" Circuit Crate"
	access = access_robotics


/decl/hierarchy/supply_pack/engineering/robotics
	name = "Robotics assembly crate"
	contains = list(
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/weapon/storage/toolbox/electrical,
		/obj/item/device/flash,
		/obj/item/device/flash,
		/obj/item/device/flash,
		/obj/item/device/flash,
		/obj/item/weapon/cell/high,
		/obj/item/weapon/cell/high
	)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robotics assembly"
	access = access_robotics


/decl/hierarchy/supply_pack/engineering/rust_injector
	contains = list(/obj/machinery/power/rust_fuel_injector)
	name = "RUST fuel injector"
	cost = 50
	containertype = /obj/structure/closet/crate/secure/large
	containername = "RUST injector crate"
	access = access_engine


/decl/hierarchy/supply_pack/engineering/rust_compressor
	contains = list(/obj/item/weapon/module/rust_fuel_compressor)
	name = "RUST fuel compressor circuitry"
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "RUST fuel compressor circuitry"
	access = access_engine


/decl/hierarchy/supply_pack/engineering/rust_assembly_port
	contains = list(/obj/item/weapon/module/rust_fuel_port)
	name = "RUST fuel assembly port circuitry"
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "RUST fuel assembly port circuitry"
	access = access_engine


/decl/hierarchy/supply_pack/engineering/rust_core
	contains = list(/obj/machinery/power/rust_core)
	name = "RUST Tokamak Core"
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large
	containername = "RUST tokamak crate"
	access = access_engine


/decl/hierarchy/supply_pack/engineering/shield_gen
	contains = list(/obj/item/weapon/circuitboard/shield_gen)
	name = "Experimental bubble shield generator circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Experimental bubble shield generator circuitry crate"
	access = access_ce


/decl/hierarchy/supply_pack/engineering/shield_cap
	contains = list(/obj/item/weapon/circuitboard/shield_cap)
	name = "Experimental bubble shield capacitor circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Experimental bubble shield capacitor circuitry crate"
	access = access_ce


/decl/hierarchy/supply_pack/engineering/smbig
	name = "Supermatter Core"
	contains = list(/obj/machinery/power/supermatter)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Supermatter crate (CAUTION)"
	access = access_ce


/decl/hierarchy/supply_pack/engineering/smsmall
	name = "Supermatter Shard"
	contains = list(/obj/machinery/power/supermatter/shard)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Supermatter shard crate (CAUTION)"
	access = access_ce


/decl/hierarchy/supply_pack/engineering/teg
	contains = list(/obj/machinery/power/generator)
	name = "Mark I Thermoelectric Generator"
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Mk1 TEG crate"
	access = access_engine


/decl/hierarchy/supply_pack/engineering/circulator
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	name = "Binary atmospheric circulator"
	cost = 60
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Atmospheric circulator crate"
	access = access_engine


/decl/hierarchy/supply_pack/engineering/air_dispenser
	contains = list(/obj/machinery/pipedispenser/orderable)
	name = "Pipe Dispenser"
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Pipe Dispenser Crate"
	access = access_atmospherics


/decl/hierarchy/supply_pack/engineering/disposals_dispenser
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	name = "Disposals Pipe Dispenser"
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Disposal Dispenser Crate"
	access = access_atmospherics