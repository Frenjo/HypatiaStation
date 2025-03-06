/datum/design/autolathe/blank_shotgun_shell
	name = "Shotgun Shell (Blank)"
	materials = alist(/decl/material/steel = 250)
	build_path = /obj/item/ammo_casing/shotgun/blank

/datum/design/autolathe/beanbag_shell
	name = "Beanbag Shell"
	materials = alist(/decl/material/steel = 500)
	build_path = /obj/item/ammo_casing/shotgun/beanbag

/datum/design/autolathe/c45r
	name = "Magazine (.45 Rubber)"
	materials = alist(/decl/material/steel = 50000)
	build_path = /obj/item/ammo_magazine/c45r

/datum/design/autolathe/flamethrower
	name = "Flamethrower"
	req_tech = alist(/decl/tech/combat = 1, /decl/tech/plasma = 1)
	materials = alist(/decl/material/steel = 500)
	build_path = /obj/item/flamethrower/full
	hidden = TRUE

/datum/design/autolathe/a357
	name = "Ammo Box (.357)"
	materials = alist(/decl/material/steel = 50000)
	build_path = /obj/item/ammo_magazine/a357
	hidden = TRUE

/datum/design/autolathe/c45m
	name = "Magazine (.45)"
	materials = alist(/decl/material/steel = 50000)
	build_path = /obj/item/ammo_magazine/c45m
	hidden = TRUE

/datum/design/autolathe/shotgun_shell
	name = "Shotgun Shell (12-gauge)"
	materials = alist(/decl/material/steel = 12500)
	build_path = /obj/item/ammo_casing/shotgun
	hidden = TRUE

/datum/design/autolathe/shotgun_dart
	name = "Shotgun Dart"
	materials = alist(/decl/material/plastic = 12500)
	build_path = /obj/item/ammo_casing/shotgun/dart
	hidden = TRUE