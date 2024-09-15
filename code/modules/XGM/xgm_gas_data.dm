/decl/xgm_gas_data
	// Simple list of all the gas typepaths.
	var/list/gases = list()
	// The friendly, human-readable name for the gas.
	var/list/name = list()
	// Specific heat of the gas. Used for calculating heat capacity.
	var/list/specific_heat = list()
	// Molar mass of the gas. Used for calculating specific entropy.
	var/list/molar_mass = list()
	// Tile overlays. /images, created from references to 'icons/effects/tile_effects.dmi'
	var/list/tile_overlay = list()
	// Overlay limits. There must be at least this many moles for the overlay to appear.
	var/list/overlay_limit = list()
	// Flags.
	var/list/flags = list()

/decl/xgm_gas
	var/name = "Unnamed Gas"
	var/specific_heat = 20	// J/(mol*K)
	var/molar_mass = 0.032	// kg/mol

	var/tile_overlay = null
	var/overlay_limit = null

	var/flags = 0

/hook/startup/proc/generate_gas_data()
	. = TRUE
	var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
	for(var/type in SUBTYPESOF(/decl/xgm_gas))
		var/decl/xgm_gas/gas = GET_DECL_INSTANCE(type) // Avoid initial() because of potential New() actions.

		if(type in gas_data.gases)
			error("Duplicate gas `[type]`!")

		gas_data.gases.Add(type)
		gas_data.name[type] = gas.name
		gas_data.specific_heat[type] = gas.specific_heat
		gas_data.molar_mass[type] = gas.molar_mass
		if(gas.tile_overlay)
			gas_data.tile_overlay[type] = image('icons/effects/tile_effects.dmi', gas.tile_overlay, FLY_LAYER)
		if(gas.overlay_limit)
			gas_data.overlay_limit[type] = gas.overlay_limit
		gas_data.flags[type] = gas.flags