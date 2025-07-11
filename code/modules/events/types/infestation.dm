#define LOC_KITCHEN 0
#define LOC_ATMOS 1
#define LOC_INCIN 2
#define LOC_CHAPEL 3
#define LOC_LIBRARY 4
#define LOC_HYDRO 5
#define LOC_VAULT 6
#define LOC_CONSTR 7
#define LOC_TECH 8
#define LOC_ASSEMBLY 9

#define VERM_MICE 0
#define VERM_LIZARDS 1
#define VERM_SPIDERS 2

/datum/round_event/infestation
	announce_when = 10
	end_when = 11

	var/location
	var/locstring
	var/vermin
	var/vermstring

/datum/round_event/infestation/start()
	location = rand(0, 9)
	var/list/turf/open/floor/turfs = list()
	var/spawn_area_type
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/station/crew/kitchen
			locstring = "the kitchen"
		if(LOC_ATMOS)
			spawn_area_type = /area/station/engineering/atmospherics
			locstring = "atmospherics"
		if(LOC_INCIN)
			spawn_area_type = /area/station/maintenance/incinerator
			locstring = "the incinerator"
		if(LOC_CHAPEL)
			spawn_area_type = /area/station/crew/chapel/main
			locstring = "the chapel"
		if(LOC_LIBRARY)
			spawn_area_type = /area/station/crew/library
			locstring = "the library"
		if(LOC_HYDRO)
			spawn_area_type = /area/station/crew/hydroponics
			locstring = "hydroponics"
		if(LOC_VAULT)
			spawn_area_type = /area/station/command/vault
			locstring = "the vault"
		if(LOC_CONSTR)
			spawn_area_type = /area/station/construction
			locstring = "the construction area"
		if(LOC_TECH)
			spawn_area_type = /area/station/storage/tech
			locstring = "technical storage"
		if(LOC_ASSEMBLY)
			spawn_area_type = /area/external/abandoned/assembly_line
			locstring = "the unused assembly line"

	//to_world("looking for [spawn_area_type]")
	for(var/areapath in typesof(spawn_area_type))
		//to_world("	checking [areapath]")
		var/area/A = locate(areapath)
		//to_world("	A: [A], contents.len: [length(A.contents)]")
		//for(var/area/B in A.related)
			//to_world("	B: [B], contents.len: [length(B.contents)]")
			//for(var/turf/open/floor/F in B.turf_list)
				//if(!length(F.contents))
					//turfs += F
		for(var/turf/open/floor/F in A.turf_list)
			if(!length(F.contents))
				turfs.Add(F)

	var/list/spawn_types = list()
	var/max_number
	vermin = rand(0, 2)
	switch(vermin)
		if(VERM_MICE)
			spawn_types = list(/mob/living/simple/mouse/gray, /mob/living/simple/mouse/brown, /mob/living/simple/mouse/white)
			max_number = 12
			vermstring = "mice"
		if(VERM_LIZARDS)
			spawn_types = list(/mob/living/simple/lizard)
			max_number = 6
			vermstring = "lizards"
		if(VERM_SPIDERS)
			spawn_types = list(/obj/effect/spider/spiderling)
			vermstring = "spiders"

	spawn(0)
		var/num = rand(2, max_number)
		while(length(turfs) && num > 0)
			var/turf/open/floor/T = pick(turfs)
			turfs.Remove(T)
			num--

			if(vermin == VERM_SPIDERS)
				var/obj/effect/spider/spiderling/S = new /obj/effect/spider/spiderling(T)
				S.amount_grown = -1
			else
				var/spawn_type = pick(spawn_types)
				new spawn_type(T)

/datum/round_event/infestation/announce()
	priority_announce(
		"Bioscans indicate that [vermstring] have been breeding in [locstring]. Clear them out, before this starts to affect productivity.",
		"Vermin Infestation"
	)

#undef LOC_KITCHEN
#undef LOC_ATMOS
#undef LOC_INCIN
#undef LOC_CHAPEL
#undef LOC_LIBRARY
#undef LOC_HYDRO
#undef LOC_VAULT
#undef LOC_TECH
#undef LOC_ASSEMBLY

#undef VERM_MICE
#undef VERM_LIZARDS
#undef VERM_SPIDERS