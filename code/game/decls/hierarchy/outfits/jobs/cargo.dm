/*
 * Cargo
 */
/decl/hierarchy/outfit/job/cargo
	shoes = /obj/item/clothing/shoes/black

/*
 * Quartermaster
 */
/decl/hierarchy/outfit/job/cargo/qm
	name = "Quartermaster"

	uniform = /obj/item/clothing/under/rank/cargo

	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/brown

	l_ear = /obj/item/radio/headset/qm

	l_hand = /obj/item/clipboard

	pda_type = /obj/item/pda/cargo/quartermaster

/*
 * Cargo Technician
 */
/decl/hierarchy/outfit/job/cargo/technician
	name = "Cargo Technician"

	uniform = /obj/item/clothing/under/rank/cargotech

	//gloves = /obj/item/clothing/gloves/black

	l_ear = /obj/item/radio/headset/cargo

	pda_type = /obj/item/pda/cargo

/*
 * Mailman
 */
/decl/hierarchy/outfit/job/cargo/mailman
	name = "Mailman"

	uniform = /obj/item/clothing/under/rank/mailman

	head = /obj/item/clothing/head/mailman
	gloves = /obj/item/clothing/gloves/blue

	l_ear = /obj/item/radio/headset/cargo

	pda_type = /obj/item/pda/cargo/mailman

/*
 * Mining
 */
/decl/hierarchy/outfit/job/cargo/mining
	backpack_contents = list(
		/obj/item/crowbar,
		/obj/item/storage/bag/ore
	)

	pda_type = /obj/item/pda/shaftminer

	backpack = /obj/item/storage/backpack/industrial
	satchel_one = /obj/item/storage/satchel/eng

/*
 * Mining Foreman
 */
/decl/hierarchy/outfit/job/cargo/mining/foreman
	name = "Mining Foreman"

	uniform = /obj/item/clothing/under/rank/miner/foreman

	gloves = /obj/item/clothing/gloves/black

	l_ear = /obj/item/radio/headset/mining_foreman

/*
 * Shaft Miner
 */
/decl/hierarchy/outfit/job/cargo/mining/miner
	name = "Shaft Miner"

	uniform = /obj/item/clothing/under/rank/miner

	//gloves = /obj/item/clothing/gloves/black

	l_ear = /obj/item/radio/headset/mining