/proc/get_centcom_access(job)
	switch(job)
		if("VIP Guest")
			return list(ACCESS_CENT_GENERAL)
		if("Custodian")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE)
		if("Thunderdome Overseer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_THUNDER)
		if("Intel Officer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING)
		if("Medical Officer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_MEDICAL)
		if("Death Commando")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE)
		if("Research Officer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_TELEPORTER, ACCESS_CENT_STORAGE)
		if("BlackOps Commander")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_THUNDER, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE, ACCESS_CENT_CREED)
		if("Supreme Commander")
			return get_all_centcom_access()

/proc/get_access_ids(access_types = ACCESS_TYPE_ALL)
	RETURN_TYPE(/list)

	. = list()
	for_no_type_check(var/decl/access/access, GET_DECL_SUBTYPE_INSTANCES(/decl/access))
		if(access.access_type & access_types)
			. += access.id

GLOBAL_GLOBL_LIST_INIT(all_access_datums_assoc, null)
/proc/get_all_access_datums_assoc()
	if(isnull(GLOBL.all_access_datums_assoc))
		GLOBL.all_access_datums_assoc = list()
		for_no_type_check(var/decl/access/access, GET_DECL_SUBTYPE_INSTANCES(/decl/access))
			GLOBL.all_access_datums_assoc["[access.id]"] = access

	return GLOBL.all_access_datums_assoc

GLOBAL_GLOBL_LIST_INIT(all_access, null)
/proc/get_all_access()
	if(isnull(GLOBL.all_access))
		GLOBL.all_access = get_access_ids()

	return GLOBL.all_access

GLOBAL_GLOBL_LIST_INIT(all_station_access, null)
/proc/get_all_station_access()
	if(isnull(GLOBL.all_station_access))
		GLOBL.all_station_access = get_access_ids(ACCESS_TYPE_STATION)

	return GLOBL.all_station_access

GLOBAL_GLOBL_LIST_INIT(all_centcom_access, null)
/proc/get_all_centcom_access()
	if(isnull(GLOBL.all_centcom_access))
		GLOBL.all_centcom_access = get_access_ids(ACCESS_TYPE_CENTCOM)

	return GLOBL.all_centcom_access

GLOBAL_GLOBL_LIST_INIT(all_syndicate_access, null)
/proc/get_all_syndicate_access()
	if(isnull(GLOBL.all_syndicate_access))
		GLOBL.all_syndicate_access = get_access_ids(ACCESS_TYPE_SYNDICATE)

	return GLOBL.all_syndicate_access

GLOBAL_GLOBL_LIST_INIT(all_region_access, null)
/proc/get_region_accesses(code)
	if(code == ACCESS_REGION_ALL)
		return get_all_station_access()

	if(isnull(GLOBL.all_region_access))
		GLOBL.all_region_access = list()
		var/list/temp_region_access = list()
		for_no_type_check(var/decl/access/access, GET_DECL_SUBTYPE_INSTANCES(/decl/access))
			LAZYINITLIST(GLOBL.all_region_access["[access.region]"])
			temp_region_access.Add(access.id)
		GLOBL.all_region_access = temp_region_access

	return GLOBL.all_region_access["[code]"]

/proc/get_region_accesses_name(code)
	switch(code)
		if(ACCESS_REGION_ALL)
			return "All"
		if(ACCESS_REGION_SECURITY) // Security
			return "Security"
		if(ACCESS_REGION_MEDBAY) // Medbay
			return "Medbay"
		if(ACCESS_REGION_RESEARCH) // Research
			return "Research"
		if(ACCESS_REGION_ENGINEERING) // Engineering/Maintenance
			return "Engineering"
		if(ACCESS_REGION_COMMAND) // Command
			return "Command"
		if(ACCESS_REGION_GENERAL) // Station General
			return "Station General"
		if(ACCESS_REGION_SUPPLY) // Supply
			return "Supply"

/proc/get_access_desc(id)
	var/list/accesses = get_all_access_datums_assoc()
	var/decl/access/access = accesses["[id]"]

	return isnotnull(access) ? access.name : ""