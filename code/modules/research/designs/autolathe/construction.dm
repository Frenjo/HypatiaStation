// Circuits
/datum/design/autolathe/power_control_module
	name = "Power Control Module"
	req_tech = alist(/decl/tech/engineering = 1, /decl/tech/power_storage = 1, /decl/tech/programming = 1)
	materials = alist(/decl/material/plastic = 0.25 MATERIAL_SHEETS, /decl/material/glass = 0.25 MATERIAL_SHEETS)
	build_path = /obj/item/module/power_control

/datum/design/autolathe/airlock_electronics
	name = "Airlock Electronics"
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/airlock_electronics

/datum/design/autolathe/air_alarm_electronics
	name = "Air Alarm Electronics"
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/airalarm_electronics

/datum/design/autolathe/fire_alarm_electronics
	name = "Fire Alarm Electronics"
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/firealarm_electronics

// Assembly Components
/datum/design/autolathe/igniter
	name = "Igniter"
	req_tech = alist(/decl/tech/magnets = 1)
	materials = alist(/decl/material/plastic = 1.25 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/assembly/igniter

/datum/design/autolathe/signaler
	name = "Remote Signalling Device"
	req_tech = alist(/decl/tech/magnets = 1)
	materials = alist(/decl/material/plastic = 1 MATERIAL_SHEET, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 1.2)
	build_path = /obj/item/assembly/signaler

/datum/design/autolathe/infrared_emitter
	name = "Infrared Emitter"
	req_tech = alist(/decl/tech/magnets = 1)
	materials = alist(/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/glass = 1 MATERIAL_SHEET)
	build_path = /obj/item/assembly/infra

/datum/design/autolathe/timer
	name = "Timer"
	req_tech = alist(/decl/tech/magnets = 1)
	materials = alist(/decl/material/plastic = 1 MATERIAL_SHEET, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/assembly/timer

/datum/design/autolathe/proximity_sensor
	name = "Proximity Sensor"
	req_tech = alist(/decl/tech/magnets = 1)
	materials = alist(/decl/material/plastic = 2 MATERIAL_SHEETS, /decl/material/glass = 0.5 MATERIAL_SHEETS)
	build_path = /obj/item/assembly/prox_sensor

// Lights
/datum/design/autolathe/light_tube
	name = "Light Tube"
	materials = alist(/decl/material/iron = QUARTER_SHEET_MATERIAL_AMOUNT * 1.25, /decl/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 1.25)
	build_path = /obj/item/light/tube

/datum/design/autolathe/light_bulb
	name = "Light Bulb"
	materials = alist(/decl/material/iron = 0.25 MATERIAL_SHEETS, /decl/material/glass = 0.5 MATERIAL_SHEETS)
	build_path = /obj/item/light/bulb

// Miscellaneous
/datum/design/autolathe/camera_assembly
	name = "Camera Assembly"
	materials = alist(/decl/material/plastic = 1 MATERIAL_SHEET, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/camera_assembly

/datum/design/autolathe/compressed_matter
	name = "Compressed Matter Cartridge"
	req_tech = alist(/decl/tech/materials = 1)
	materials = alist(/decl/material/steel = 15 MATERIAL_SHEETS, /decl/material/glass = 7.5 MATERIAL_SHEETS)
	build_path = /obj/item/rcd_ammo