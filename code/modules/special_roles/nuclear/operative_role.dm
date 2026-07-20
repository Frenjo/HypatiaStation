/decl/special_role/operative
	name = "Nuclear Operative"

	role_type = SPECIAL_ROLE_SYNDICATE
	role_flag = BE_OPERATIVE

	var/list/operative_spawns = list()

	var/nuke_code

/decl/special_role/operative/New()
	. = ..()
	nuke_code = "[rand(10000, 99999)]"
	for_no_type_check(var/obj/effect/landmark/A, GLOBL.landmark_list)
		if(A.name == "Syndicate-Spawn")
			operative_spawns += GET_TURF(A)
			qdel(A)
			continue

/decl/special_role/operative/setup(mob/living/carbon/human/operative)
	. = ..()

	var/static/spawnpos = 1
	if(spawnpos > length(operative_spawns))
		spawnpos = 1

	operative.forceMove(operative_spawns[spawnpos])
	operative.real_name = "[syndicate_name()] Operative" // placeholder while we get their actual name
	assign_name(operative)

	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		forge_syndicate_objectives(operative)
	operative.equip_outfit(/decl/hierarchy/outfit/syndicate/nuclear)
	greet_operative(operative, spawnpos == 1)
	spawnpos++

	global.PCticker.mode.update_synd_icons_added(operative.mind)

/decl/special_role/operative/proc/assign_name(mob/living/carbon/human/operative)
	set waitfor = FALSE

	var/choose_name = input(operative, "You are a [syndicate_name()] agent! What is your name?", "Choose a name") as text
	if(!choose_name)
		return
	operative.name = choose_name
	operative.real_name = choose_name

/decl/special_role/operative/proc/forge_syndicate_objectives(mob/living/carbon/human/operative)
	var/datum/objective/nuclear/syndobj = new /datum/objective/nuclear()
	syndobj.owner = operative.mind
	operative.mind.objectives += syndobj

/decl/special_role/operative/proc/greet_operative(mob/living/carbon/human/operative, is_leader = FALSE)
	to_chat(operative, SPAN_DANGER("<font size=3>You are a [syndicate_name()] [is_leader ? "leader" : "agent"].</font>"))
	if(is_leader)
		operative.mind.store_memory("<B>Syndicate Nuclear Bomb Code</B>: [nuke_code]", 0, 0)
		to_chat(operative, "The nuclear authorisation code is: <B>[nuke_code]</B>")
		var/obj/item/paper/P = new /obj/item/paper()
		P.info = "The nuclear authorisation code is: <b>[nuke_code]</b>"
		P.name = "nuclear bomb code"
		P.forceMove(operative.loc)

	show_objectives(operative)