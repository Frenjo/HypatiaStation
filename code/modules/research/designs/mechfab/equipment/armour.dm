/datum/design/mechfab/equipment/melee_armour_booster
	name = "Reactive Armour Booster"
	desc = "An exosuit-mounted armour booster designed to defend against melee attacks."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/combat = 4)
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/silver = 4 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/melee_armour_booster
	categories = list("Combat Exosuit Equipment")

/datum/design/mechfab/equipment/melee_defence_shocker
	name = "Melee Defence Shocker"
	desc = "An exosuit module that electrifies the external armour to discourge melee attackers."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/combat = 4, /decl/tech/engineering = 2, /decl/tech/plasma = 2)
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/plasma = 4 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/melee_defence_shocker
	categories = list("Combat Exosuit Equipment")

/datum/design/mechfab/equipment/ranged_armour_booster
	name = "Reflective Armour Booster"
	desc = "An exosuit-mounted armor booster designed to deflect projectile attacks."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/combat = 5, /decl/tech/engineering = 3)
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/gold = 4 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/ranged_armour_booster
	categories = list("Combat Exosuit Equipment")

/datum/design/mechfab/equipment/emp_insulation
	name = "Ablative EMP Insulation"
	desc = "An exosuit module that reinforces the internal systems against energy and EMP-based interference."
	req_tech = alist(/decl/tech/materials = 5, /decl/tech/magnets = 4, /decl/tech/combat = 4, /decl/tech/engineering = 2)
	materials = alist(/decl/material/steel = 10 MATERIAL_SHEETS, /decl/material/uranium = 4 MATERIAL_SHEETS)
	build_path = /obj/item/mecha_equipment/emp_insulation
	categories = list("Combat Exosuit Equipment")