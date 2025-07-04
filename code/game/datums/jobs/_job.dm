/datum/job
	// The name of the job.
	var/title = "NOPE"
	// Bitflag for the job.
	var/flag = 0

	// The typepath of the department the job belongs to.
	var/department = null
	// Whether this is a head position.
	var/head_position = FALSE

	// How many players can be this job.
	var/total_positions = 0
	// How many players can spawn in as this job.
	var/spawn_positions = 0
	// How many players have this job.
	var/current_positions = 0

	// Supervisors, who this person directly answers to.
	var/supervisors = null
	// Selection screen color.
	var/selection_color = "#ffffff"

	// If this is set to TRUE, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify = FALSE
	// If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	// Job access. The use of minimal_access or access is determined by a config setting: CONFIG_GET(/decl/configuration_entry/jobs_have_minimal_access).
	var/list/access = null			// Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/list/minimal_access = null	// Useful for servers which prefer to only have access given to the places a job absolutely needs (IE larger server population.)

	// The typepath of the outfit that mobs with this job will spawn with, if any.
	var/outfit
	// List of alternate titles with alternate outfit typepaths as associative values, if any.
	var/list/alt_titles

	// The typepath of the specific survival kit provided to characters with this job, if there is one.
	// Currently only used for engineering jobs.
	var/special_survival_kit = null

/datum/job/proc/equip(mob/living/carbon/human/H, alt_title)
	SHOULD_CALL_PARENT(TRUE)

	var/outfit_type = outfit
	if(isnotnull(alt_title) && alt_title != title)
		outfit_type = alt_titles[alt_title]

	. = H.equip_outfit(outfit_type)

/datum/job/proc/equip_preview(mob/living/carbon/human/H, alt_title)
	var/species = H.get_species()
	if(species == SPECIES_SOGHUN || species == SPECIES_TAJARAN)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), SLOT_ID_SHOES)
	else if(species == SPECIES_PLASMALIN)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/plasmalin(H), SLOT_ID_WEAR_UNIFORM)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/plasmalin(H), SLOT_ID_GLOVES)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/plasmalin(H), SLOT_ID_HEAD)
	else if(species == SPECIES_VOX)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vox(src), SLOT_ID_WEAR_MASK)

	return equip(H, alt_title)

/datum/job/proc/get_access()
	if(CONFIG_GET(/decl/configuration_entry/jobs_have_minimal_access) && isnotnull(minimal_access))
		return minimal_access.Copy()
	return access.Copy()

/*
 * player_old_enough()
 *
 * If the configuration option is set to require players' accounts to be logged as old enough to play certain jobs, then this proc checks that they are.
 * Returns TRUE if their account is old enough or if the configuration option is disabled, FALSE otherwise.
 */
/datum/job/proc/player_old_enough(client/C)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(available_in_days(C) == 0)
		return TRUE	// Available in 0 days = available right now = player is old enough to play.
	return FALSE

/datum/job/proc/available_in_days(client/C)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(isnull(C))
		return 0
	if(!CONFIG_GET(/decl/configuration_entry/use_age_restriction_for_jobs))
		return 0
	if(!isnum(C.player_age))
		return 0 // This is only a number if the db connection is established, otherwise it is text: "Requires database", meaning these restrictions cannot be enforced.
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)

// Returns a list of strings displayed to mobs with this job when spawning into the round.
/datum/job/proc/get_spawn_message_content(alt_title = null)
	RETURN_TYPE(/list)
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	var/job_title = isnotnull(alt_title) ? alt_title : title
	. += "<B>You are the [job_title].</B>"
	if(isnotnull(supervisors))
		. += "<B>As the [job_title] you answer directly to [supervisors]. Special circumstances may change this.</B>"
	if(req_admin_notify)
		. += "<B>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</B>"