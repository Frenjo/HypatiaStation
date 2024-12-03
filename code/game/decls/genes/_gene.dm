/*
 * /decl-ised genes.
 * Apparently domutcheck() was getting pretty hairy and this was the solution!
 *
 * The original /datum/dna/gene was authored by N3X15 <nexisentertainment@gmail.com>.
 */
/decl/gene
	// Display name.
	var/name = "BASE GENE"

	// Description.
	// Probably won't get used but why the fuck not.
	var/desc = "Oh god who knows what this does."

	// What gene activates this?
	var/block = 0

	// Any of a number of GENE_* flags.
	var/flags = 0

/*
 * Is the gene active in this mob's DNA?
 */
/decl/gene/proc/is_active(mob/M)
	return M.active_genes && (type in M.active_genes)

/*
 * Returns TRUE if the gene can activate, FALSE if not.
 * MUTCHK_FORCED should be handled here.
 */
/decl/gene/proc/can_activate(mob/M, flags)
	return FALSE

/*
 * Called when the gene activates.
 * Do your magic here.
 */
/decl/gene/proc/activate(mob/M, connected, flags)
	return

/*
 * Called when the gene deactivates. Undo your magic here.
 * Only called when the block is deactivated.
 */
/decl/gene/proc/deactivate(mob/M, connected, flags)
	return

// This section inspired by goone's bioEffects.

/*
 * Called in each life() tick.
 */
/decl/gene/proc/OnMobLife(mob/M)
	return

/*
 * Called when the mob dies.
 */
/decl/gene/proc/OnMobDeath(mob/M)
	return

/*
 * Called when the mob says shit.
 */
/decl/gene/proc/OnSay(mob/M, message)
	return message

/**
* Called after the mob runs update_icons.
*
* @params M The subject.
* @params g Gender (m or f)
* @params fat Fat? (0 or 1)
*/
/decl/gene/proc/OnDrawUnderlays(mob/M, g, fat)
	return null