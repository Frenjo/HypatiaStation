/////////////////////////
// DNA2 SETUP
/////////////////////////
GLOBAL_GLOBL(datum/dna_data/dna_data)

/datum/controller/master/proc/setup_genetics()
	to_world(SPAN_DANGER("↪ Setting up DNA2."))
	GLOBL.dna_data = new /datum/dna_data()
	GLOBL.dna_data.setup()

/datum/dna_data
	var/block_add = 0
	var/diff_mut = 0

	var/blind_block = 0
	var/deaf_block = 0
	var/hulk_block = 0
	var/tele_block = 0
	var/fire_block = 0
	var/xray_block = 0
	var/clumsy_block = 0
	var/fake_block = 0

	// Unused
	var/cough_block = 0
	var/glasses_block = 0
	var/epilepsy_block = 0
	var/twitch_block = 0
	var/nervous_block = 0

	var/monkey_block = 0

	// Bay12 mutations (also unused)
	var/headache_block = 0
	var/no_breath_block = 0
	var/remote_view_block = 0
	var/regenerate_block = 0
	var/increase_run_block = 0
	var/remote_talk_block = 0
	var/morph_block = 0
	var/blend_block = 0 // This one's not even assigned anywhere which is double odd.
	var/hallucination_block = 0
	var/no_prints_block = 0
	var/shock_immunity_block = 0
	var/small_size_block = 0

// Randomize block, assign a reference name, and optionally define difficulty (by making activation zone smaller or bigger)
// The name is used on /vg/ for species with predefined genetic traits,
// and for the DNA panel in the player panel.
/datum/dna_data/proc/get_assigned_block(name, list/blocksLeft, activity_bounds = DNA_DEFAULT_BOUNDS)
	if(!length(blocksLeft))
		warning("[name]: No more blocks left to assign!")
		return 0
	var/assigned = pick(blocksLeft)
	blocksLeft.Remove(assigned)
	assigned_blocks[assigned] = name
	dna_activity_bounds[assigned] = activity_bounds
	//testing("[name] assigned to block #[assigned].")
	return assigned

/datum/dna_data/proc/setup()
	if(prob(50))
		// Currently unused. Will revisit. - N3X
		block_add = rand(-300, 300)
	if(prob(75))
		diff_mut = rand(0, 20)

	/* Old, for reference (so I don't accidentally activate something) - N3X
	var/list/avnums = list()
	var/tempnum

	avnums.Add(2)
	avnums.Add(12)
	avnums.Add(10)
	avnums.Add(8)
	avnums.Add(4)
	avnums.Add(11)
	avnums.Add(13)
	avnums.Add(6)

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	hulk_block = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	tele_block = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	fire_block = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	xray_block = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	clumsy_block = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	fake_block = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	deaf_block = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	blind_block = tempnum
	*/
	var/list/nums_to_assign = list()
	for(var/i = 1; i < DNA_SE_LENGTH; i++)
		nums_to_assign += i

	//testing("Assigning DNA blocks:")

	// Standard muts, imported from older code above.
	blind_block		= get_assigned_block("BLIND", nums_to_assign)
	deaf_block		= get_assigned_block("DEAF", nums_to_assign)
	hulk_block		= get_assigned_block("HULK", nums_to_assign, DNA_HARD_BOUNDS)
	tele_block		= get_assigned_block("TELE", nums_to_assign, DNA_HARD_BOUNDS)
	fire_block		= get_assigned_block("FIRE", nums_to_assign, DNA_HARDER_BOUNDS)
	xray_block		= get_assigned_block("XRAY", nums_to_assign, DNA_HARDER_BOUNDS)
	clumsy_block	= get_assigned_block("CLUMSY", nums_to_assign)
	fake_block		= get_assigned_block("FAKE", nums_to_assign)

	// UNUSED!
	//cough_block		= get_assigned_block("COUGH", nums_to_assign)
	//glasses_block		= get_assigned_block("GLASSES", nums_to_assign)
	//epilepsy_block	= get_assigned_block("EPILEPSY", nums_to_assign)
	//twitch_block		= get_assigned_block("TWITCH", nums_to_assign)
	//nervous_block		= get_assigned_block("NERVOUS", nums_to_assign)

	// Bay muts (UNUSED)
	//headache_block		= get_assigned_block("HEADACHE", nums_to_assign)
	//no_breath_block		= get_assigned_block("NOBREATH", nums_to_assign, DNA_HARD_BOUNDS)
	//remote_view_block		= get_assigned_block("REMOTEVIEW", nums_to_assign, DNA_HARDER_BOUNDS)
	//regenerate_block		= get_assigned_block("REGENERATE", nums_to_assign, DNA_HARDER_BOUNDS)
	//increase_run_block	= get_assigned_block("INCREASERUN", nums_to_assign, DNA_HARDER_BOUNDS)
	//remote_talk_block		= get_assigned_block("REMOTETALK", nums_to_assign, DNA_HARDER_BOUNDS)
	//morph_block			= get_assigned_block("MORPH", nums_to_assign, DNA_HARDER_BOUNDS)
	//COLDBLOCK				= get_assigned_block("COLD", nums_to_assign)
	//hallucination_block	= get_assigned_block("HALLUCINATION", nums_to_assign)
	//no_prints_block		= get_assigned_block("NOPRINTS", nums_to_assign, DNA_HARD_BOUNDS)
	//shock_immunity_block	= get_assigned_block("SHOCKIMMUNITY", nums_to_assign)
	//small_size_block		= get_assigned_block("SMALLSIZE", nums_to_assign, DNA_HARD_BOUNDS)

	//
	// Static Blocks
	/////////////////////////////////////////////.

	// Monkeyblock is always last.
	monkey_block = DNA_SE_LENGTH

	// And the genes that actually do the work. (domutcheck improvements)
	var/list/blocks_assigned[DNA_SE_LENGTH]
	for(var/gene_type in GLOBL.all_dna_genes)
		var/decl/gene/gene = GLOBL.all_dna_genes[gene_type]
		if(gene.block)
			if(gene.block in blocks_assigned)
				warning("DNA2: Gene [gene.name] trying to use already-assigned block [gene.block] (used by [english_list(blocks_assigned[gene.block])])")
			var/list/assignedToBlock[0]
			if(blocks_assigned[gene.block])
				assignedToBlock = blocks_assigned[gene.block]
			assignedToBlock.Add(gene.name)
			blocks_assigned[gene.block] = assignedToBlock
			//testing("DNA2: Gene [gene.name] assigned to block [gene.block].")

	testing("DNA2: [length(nums_to_assign)] blocks are unused: [english_list(nums_to_assign)]")

	// HIDDEN MUTATIONS / SUPERPOWERS INITIALIZTION

	/*
	for(var/x in typesof(/datum/mutations) - /datum/mutations)
		var/datum/mutations/mut = new x

		for(var/i = 1, i <= mut.required, i++)
			var/datum/mutationreq/require = new/datum/mutationreq
			require.block = rand(1, 13)
			require.subblock = rand(1, 3)

			// Create random requirement identification
			require.reqID = pick("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", \
							 "B", "C", "D", "E", "F")

			mut.requirements += require


		global_mutations += mut// add to global mutations list!
	*/