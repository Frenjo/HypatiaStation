datum/air_group
	var/group_processing = 1 //Processing all tiles as one large tile if 1

	var/datum/gas_mixture/air = new

	var/current_cycle = 0 //cycle that oxygen value represents
	var/archived_cycle = 0 //cycle that oxygen_archived value represents
		//The use of archived cycle saves processing power by permitting the archiving step of FET
		//	to be rolled into the updating step

	//optimization vars
	var/next_check = 0  //number of ticks before this group updates
	var/check_delay = 10  //number of ticks between updates, starts fairly high to get boring groups out of the way

	proc/members()
		//Returns the members of the group
	proc/process_group()


	var/list/borders //Tiles that connect this group to other groups/individual tiles
	var/list/members //All tiles in this group

	var/list/space_borders
	var/length_space_border = 0


	proc/suspend_group_processing()
		group_processing = 0
		update_tiles_from_group()
		check_delay=0
		next_check=0


	//Copy group air information to individual tile air
	//Used right before turning on group processing
	proc/update_group_from_tiles()
		var/sample_member = pick(members)
		var/datum/gas_mixture/sample_air = sample_member:air

		air.copy_from(sample_air)
		air.group_multiplier = members.len
		return 1


	//Copy group air information to individual tile air
	//Used right before turning off group processing
	proc/update_tiles_from_group()
		for(var/member in members)
			member:air.copy_from(air)
			if(isopenturf(member))
				var/turf/open/turfmem=member
				turfmem.reset_delay()


	proc/archive()
		air.archive()
		archived_cycle = air_master.current_cycle


	//If individually processing tiles, checks all member tiles to see if they are close enough that the group may resume group processing
	//Warning: Do not call, called by air_master.process()
	proc/check_regroup()
		//Purpose: Checks to see if group processing should be turned back on
		//Returns: group_processing
		if(prevent_airgroup_regroup)
			return 0

		if(group_processing) return 1

		var/turf/open/sample = pick(members)
		for(var/member in members)
			if(member:active_hotspot)
				return 0
			if(member:air.compare(sample.air)) continue
			else
				return 0

		update_group_from_tiles()
		group_processing = 1
		return 1


//Look into this
	turf/process_group()
		current_cycle = air_master.current_cycle
		if(!group_processing)	 //Revert to individual processing then end
			for(var/T in members)
				var/turf/open/member = T
				member.process_cell()
			return

			//check if we're skipping this tick
		if (next_check > 0)
			next_check--
			return 1
		var/player_count = max(player_list.len, 3) / 3
		next_check += check_delay + rand(player_count, player_count * 1.5)
		check_delay++

		var/turf/open/list/border_individual = list()
		var/datum/air_group/list/border_group = list()

		var/turf/open/list/enemies = list() //used to send the appropriate border tile of a group to the group proc
		var/turf/open/list/self_group_borders = list()
		var/turf/open/list/self_tile_borders = list()

		if(archived_cycle < air_master.current_cycle)
			archive()
				//Archive air data for use in calculations
				//But only if another group didn't store it for us

		for(var/turf/open/border_tile in src.borders)
			for(var/direction in cardinal) //Go through all border tiles and get bordering groups and individuals
				if(border_tile.group_border&direction)
					var/turf/open/enemy_tile = get_step(border_tile, direction) //Add found tile to appropriate category
					if(istype(enemy_tile) && enemy_tile.parent && enemy_tile.parent.group_processing)
						border_group += enemy_tile.parent
						enemies += enemy_tile
						self_group_borders += border_tile
					else
						border_individual += enemy_tile
						self_tile_borders += border_tile

		var/abort_group = 0

		// Process connections to adjacent groups
		var/border_index = 1
		for(var/datum/air_group/AG in border_group)
			if(AG.archived_cycle < archived_cycle) //archive other groups information if it has not been archived yet this cycle
				AG.archive()
			if(AG.current_cycle < current_cycle)
				//This if statement makes sure two groups only process their individual connections once!
				//Without it, each connection would be processed a second time as the second group is evaluated

				var/connection_difference = 0
				var/turf/open/floor/self_border = self_group_borders[border_index]
				var/turf/open/floor/enemy_border = enemies[border_index]

				var/result = air.check_gas_mixture(AG.air)
				if(result == 1)
					connection_difference = air.share(AG.air)
				else if(result == -1)
					AG.suspend_group_processing()
					connection_difference = air.share(enemy_border.air)
				else
					abort_group = 1
					break

				if(connection_difference)
					if(connection_difference > 0)
						self_border.consider_pressure_difference(connection_difference, get_dir(self_border,enemy_border))
					else
						var/turf/enemy_turf = enemy_border
						if(!isturf(enemy_turf))
							enemy_turf = enemy_border.loc
						enemy_turf.consider_pressure_difference(-connection_difference, get_dir(enemy_turf,self_border))

				border_index++

		// Process connections to adjacent tiles
		border_index = 1
		if(!abort_group)
			for(var/atom/enemy_tile in border_individual)
				var/connection_difference = 0
				var/turf/open/floor/self_border = self_tile_borders[border_index]

				if(isopenturf(enemy_tile))
					if(enemy_tile:archived_cycle < archived_cycle) //archive tile information if not already done
						enemy_tile:archive()
					if(enemy_tile:current_cycle < current_cycle)
						if(air.check_gas_mixture(enemy_tile:air))
							connection_difference = air.share(enemy_tile:air)
						else
							abort_group = 1
							break
				else if(isturf(enemy_tile))
					if(air.check_turf(enemy_tile))
						connection_difference = air.mimic(enemy_tile)
					else
						abort_group = 1
						break

				if(connection_difference)
					if(connection_difference > 0)
						self_border.consider_pressure_difference(connection_difference, get_dir(self_border,enemy_tile))
					else
						var/turf/enemy_turf = enemy_tile
						if(!isturf(enemy_turf))
							enemy_turf = enemy_tile.loc
						enemy_turf.consider_pressure_difference(-connection_difference, get_dir(enemy_tile,enemy_turf))

		// Process connections to space
		border_index = 1
		if(!abort_group)
			if(length_space_border > 0)
				var/turf/space/sample = locate()
				var/connection_difference = 0

				if(air.check_turf(sample))
					connection_difference = air.mimic(sample, length_space_border)
				else
					abort_group = 1

				if(connection_difference)
					for(var/turf/open/self_border in space_borders)
						self_border.consider_pressure_difference_space(connection_difference)

		if(abort_group)
			suspend_group_processing()
		else
			if(air.check_tile_graphic())
				for(var/T in members)
					var/turf/open/member = T
					member.update_visuals(air)


		if(air.temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
			for(var/T in members)
				var/turf/open/member = T
				member.hotspot_expose(air.temperature, CELL_VOLUME)
				member.consider_superconductivity(starting=1)

		air.react()
		return



	object/process_group()
		current_cycle = air_master.current_cycle

		if(!group_processing)	return //See if processing this group as a group

		var/turf/open/list/border_individual = list()
		var/datum/air_group/list/border_group = list()

		var/turf/open/list/enemies = list() //used to send the appropriate border tile of a group to the group proc
		var/enemy_index = 1

		if(archived_cycle < air_master.current_cycle)
			archive()
				//Archive air data for use in calculations
				//But only if another group didn't store it for us

		enemy_index = 1
		var/abort_group = 0
		for(var/datum/air_group/AG in border_group)
			if(AG.archived_cycle < archived_cycle) //archive other groups information if it has not been archived yet this cycle
				AG.archive()
			if(AG.current_cycle < current_cycle)
				//This if statement makes sure two groups only process their individual connections once!
				//Without it, each connection would be processed a second time as the second group is evaluated

				var/result = air.check_gas_mixture(AG.air)
				if(result == 1)
					air.share(AG.air)
				else if(result == -1)
					AG.suspend_group_processing()
					var/turf/open/floor/enemy_border = enemies[enemy_index]
					air.share(enemy_border.air)
				else
					abort_group = 0
					break
				enemy_index++

		if(!abort_group)
			for(var/enemy_tile in border_individual)
				if(isopenturf(enemy_tile))
					if(enemy_tile:archived_cycle < archived_cycle) //archive tile information if not already done
						enemy_tile:archive()
					if(enemy_tile:current_cycle < current_cycle)
						if(air.check_gas_mixture(enemy_tile:air))
							air.share(enemy_tile:air)
						else
							abort_group = 1
							break
				else
					if(air.check_turf(enemy_tile))
						air.mimic(enemy_tile)
					else
						abort_group = 1
						break

		if(abort_group)
			suspend_group_processing()

		return