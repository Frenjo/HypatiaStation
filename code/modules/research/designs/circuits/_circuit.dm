////////////////////////////////////
////////// Circuit Boards //////////
////////////////////////////////////
/datum/design/circuit
	req_tech = list(/decl/tech/programming = 2)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = alist(/decl/material/glass = MATERIAL_AMOUNT_PER_SHEET, "sacid" = 20)
	build_time = 1.6 SECONDS

	name_prefix = "Circuit Design"