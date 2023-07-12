// Cargo. Note that this is in a separate file to prevent it loading in the preferences screen in the middle of the civilian jobs.
// Jobs are loaded in the preferences in order by file from beginning to end.
/*
 * Quartermaster
 */
/datum/job/qm
	title = "Quartermaster"
	flag = JOB_QUARTERMASTER
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel and the Captain"
	selection_color = "#8c7846"

	access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT,
		ACCESS_QM, ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION,
		ACCESS_RC_ANNOUNCE
	)
	minimal_access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT,
		ACCESS_QM, ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION,
		ACCESS_RC_ANNOUNCE
	)

	outfit = /decl/hierarchy/outfit/job/cargo/qm

/*
 * Cargo Technician
 */
/datum/job/cargo_tech
	title = "Cargo Technician"
	flag = JOB_CARGOTECH
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Quartermaster"
	selection_color = "#aa9682"

	access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM,
		ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION
	)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_MAILSORTING)

	outfit = /decl/hierarchy/outfit/job/cargo/technician

/*
 * Mining Foreman
 */
/datum/job/miningforeman
	title = "Mining Foreman"
	flag = JOB_MININGFOREMAN
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Quartermaster"
	selection_color = "#aa9682"

	access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM,
		ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION
	)
	minimal_access = list(ACCESS_MINING, ACCESS_MINT, ACCESS_MINING_STATION, ACCESS_MAILSORTING)

	outfit = /decl/hierarchy/outfit/job/cargo/mining/foreman
	alt_titles = list("Head Miner")

	special_survival_kit = /obj/item/storage/box/survival/engineer

/*
 * Shaft Miner
 */
/datum/job/mining
	title = "Shaft Miner"
	flag = JOB_MINER
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 3
	spawn_positions = 3

	supervisors = "the Mining Foreman and the Quartermaster"
	selection_color = "#aa9682"

	access = list(
		ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM,
		ACCESS_MINT, ACCESS_MINING, ACCESS_MINING_STATION
	)
	minimal_access = list(ACCESS_MINING, ACCESS_MINT, ACCESS_MINING_STATION, ACCESS_MAILSORTING)

	outfit = /decl/hierarchy/outfit/job/cargo/mining/miner
	alt_titles = list("Prospector")

	special_survival_kit = /obj/item/storage/box/survival/engineer

/*
 * Mailman
 */
// Re-adds mailman, how retro!
// Ported this from cargo tech code.
// Technically, the mailman isn't a part of cargo, but is grouped there...
// For convenience, since he should be coordinating deliveries with cargo techs. -Frenjo
/datum/job/mailman
	title = "Mailman"
	flag = JOB_MAILMAN
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel and the Quartermaster"
	selection_color = "#aa9682"

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_MAILSORTING)

	outfit = /decl/hierarchy/outfit/job/cargo/mailman
	alt_titles = list("Postman", "Delivery Technician") // Should probably change this to "Delivery Specialist", but "Cargo Technician" exists. -Frenjo