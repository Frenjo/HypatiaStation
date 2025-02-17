// Circuits
/datum/design/autolathe/power_control_module
	name = "Power Control Module"
	req_tech = list(/decl/tech/engineering = 1, /decl/tech/power_storage = 1, /decl/tech/programming = 1)
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/module/power_control

/datum/design/autolathe/airlock_electronics
	name = "Airlock Electronics"
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/airlock_electronics

/datum/design/autolathe/air_alarm_electronics
	name = "Air Alarm Electronics"
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/airalarm_electronics

/datum/design/autolathe/fire_alarm_electronics
	name = "Fire Alarm Electronics"
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/firealarm_electronics

// Assembly Components
/datum/design/autolathe/igniter
	name = "Igniter"
	materials = list(MATERIAL_METAL = 500, /decl/material/glass = 50)
	build_path = /obj/item/assembly/igniter

/datum/design/autolathe/signaler
	name = "Remote Signalling Device"
	materials = list(MATERIAL_METAL = 1000, /decl/material/glass = 200)
	build_path = /obj/item/assembly/signaler

/datum/design/autolathe/infrared_emitter
	name = "Infrared Emitter"
	materials = list(MATERIAL_METAL = 1000, /decl/material/glass = 500)
	build_path = /obj/item/assembly/infra

/datum/design/autolathe/timer
	name = "Timer"
	materials = list(MATERIAL_METAL = 500, /decl/material/glass = 50)
	build_path = /obj/item/assembly/timer

/datum/design/autolathe/proximity_sensor
	name = "Proximity Sensor"
	materials = list(MATERIAL_METAL = 800, /decl/material/glass = 200)
	build_path = /obj/item/assembly/prox_sensor

// Lights
/datum/design/autolathe/light_tube
	name = "Light Tube"
	materials = list(MATERIAL_METAL = 60, /decl/material/glass = 100)
	build_path = /obj/item/light/tube

/datum/design/autolathe/light_bulb
	name = "Light Bulb"
	materials = list(MATERIAL_METAL = 60, /decl/material/glass = 100)
	build_path = /obj/item/light/bulb

// Miscellaneous
/datum/design/autolathe/camera_assembly
	name = "Camera Assembly"
	materials = list(MATERIAL_METAL = 700, /decl/material/glass = 300)
	build_path = /obj/item/camera_assembly

/datum/design/autolathe/compressed_matter
	name = "Compressed Matter Cartridge"
	materials = list(MATERIAL_METAL = 30000, /decl/material/glass = 15000)
	build_path = /obj/item/rcd_ammo