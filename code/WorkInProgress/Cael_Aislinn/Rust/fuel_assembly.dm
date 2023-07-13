
/obj/item/fuel_assembly
	icon = 'code/WorkInProgress/Cael_Aislinn/Rust/rust.dmi'
	icon_state = "fuel_assembly"
	name = "Fuel Rod Assembly"
	var/list/rod_quantities
	var/percent_depleted = 1
	layer = 3.1
	//

/obj/item/fuel_assembly/New()
	rod_quantities = list()

//these can be abstracted away for now
/*
/obj/item/fuel_rod
/obj/item/control_rod
*/
