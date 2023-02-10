/decl/xgm_gas/oxygen
	id = GAS_OXYGEN
	name = "Oxygen"

	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.032	// kg/mol

	flags = XGM_GAS_OXIDIZER

/decl/xgm_gas/nitrogen
	id = GAS_NITROGEN
	name = "Nitrogen"

	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.028	// kg/mol

/decl/xgm_gas/hydrogen
	id = GAS_HYDROGEN
	name = "Hydrogen"

	specific_heat = 100	// J/(mol*K)
	molar_mass = 0.002	// kg/mol

	flags = XGM_GAS_FUEL

/decl/xgm_gas/carbon_dioxide
	id = GAS_CARBON_DIOXIDE
	name = "Carbon Dioxide"

	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol

/decl/xgm_gas/plasma
	id = GAS_PLASMA
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
	id = GAS_OXYGEN_AGENT_B
	name = "Oxygen Agent-B"	//what is this?

	specific_heat = 300	// J/(mol*K)
	molar_mass = 0.032	// kg/mol

/decl/xgm_gas/sleeping_agent
	id = GAS_SLEEPING_AGENT
	name = "Sleeping Agent"

	specific_heat = 40	// J/(mol*K)
	molar_mass = 0.044	// kg/mol. N2O

	tile_overlay = "sleeping_agent"
	overlay_limit = 1

	flags = XGM_GAS_OXIDIZER

/decl/xgm_gas/volatile_fuel
	id = GAS_VOLATILE_FUEL
	name = "Volatile Fuel"

	specific_heat = 253	// J/(mol*K)	C8H18 gasoline. Isobaric, but good enough.
	molar_mass = 0.114	// kg/mol.		same.

	flags = XGM_GAS_FUEL