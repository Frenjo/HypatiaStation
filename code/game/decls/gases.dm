/decl/xgm_gas/oxygen
	name = "Oxygen"

	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.032	// kg/mol

	flags = XGM_GAS_OXIDIZER

/decl/xgm_gas/nitrogen
	name = "Nitrogen"

	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.028	// kg/mol

/decl/xgm_gas/hydrogen
	name = "Hydrogen"

	specific_heat = 100	// J/(mol*K)
	molar_mass = 0.002	// kg/mol

	flags = XGM_GAS_FUEL

/decl/xgm_gas/carbon_dioxide
	name = "Carbon Dioxide"

	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol

/decl/xgm_gas/plasma
	name = "Plasma"

	specific_heat = 200	// J/(mol*K)

	//Hypothetical group 14 (same as carbon), period 8 element.
	//Using multiplicity rule, it's atomic number is 162
	//and following a N/Z ratio of 1.5, the molar mass of a monatomic gas is:
	molar_mass = 0.405	// kg/mol

	tile_overlay = "plasma"
	overlay_limit = 0.7

	flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT

/decl/xgm_gas/oxygen_agent_b
	name = "Oxygen Agent-B"	//what is this?

	specific_heat = 300	// J/(mol*K)
	molar_mass = 0.032	// kg/mol

/decl/xgm_gas/nitrous_oxide
	name = "Nitrous Oxide"

	specific_heat = 40	// J/(mol*K)
	molar_mass = 0.044	// kg/mol.

	tile_overlay = "nitrous_oxide"
	overlay_limit = 1

	flags = XGM_GAS_OXIDIZER

// What kind of gas even is this? I assume it's some kind of n-Octane but I can't find one which matches the provided specific heat and molar mass.
/decl/xgm_gas/volatile_fuel
	name = "Volatile Fuel"

	specific_heat = 253	// J/(mol*K)	C8H18 gasoline. Isobaric, but good enough.
	molar_mass = 0.114	// kg/mol.		same.

	flags = XGM_GAS_FUEL