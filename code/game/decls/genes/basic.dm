/////////////////////
// BASIC GENES
//
// These just chuck in a mutation and display a message.
//
// Gene is activated:
//	1. If mutation already exists in mob
//	2. If the probability roll succeeds
//	3. Activation is forced (done in domutcheck)
/////////////////////
/decl/gene/basic
	name = "BASIC GENE"

	// Mutation to give.
	var/mutation = 0

	// Activation probability.
	var/activation_prob = 45

	// Possible activation messages.
	var/list/activation_messages = list()

	// Possible deactivation messages.
	var/list/deactivation_messages = list()

/decl/gene/basic/can_activate(mob/M, flags)
	if(flags & MUTCHK_FORCED)
		return TRUE
	// Probability check.
	return probinj(activation_prob, (flags & MUTCHK_FORCED))

/decl/gene/basic/activate(mob/M)
	M.mutations.Add(mutation)
	if(length(activation_messages))
		var/msg = pick(activation_messages)
		to_chat(M, SPAN_INFO("[msg]"))

/decl/gene/basic/deactivate(mob/M)
	M.mutations.Remove(mutation)
	if(length(deactivation_messages))
		var/msg = pick(deactivation_messages)
		to_chat(M, SPAN_WARNING("[msg]"))