/////////////////////
// DISABILITY GENES
//
// These activate either a mutation, disability, or sdisability.
//
// Gene is always activated.
/////////////////////
/decl/gene/disability
	name = "DISABILITY"

	// Mutation to give (or 0)
	var/mutation = 0

	// Disability to give (or 0)
	var/disability = 0

	// SDisability to give (or 0)
	var/sdisability = 0

	// Activation message
	var/activation_message = ""

	// Yay, you're no longer growing 3 arms
	var/deactivation_message = ""

/decl/gene/disability/can_activate(mob/M, flags)
	return TRUE // Always set!

/decl/gene/disability/activate(mob/M, connected, flags)
	if(mutation && !(mutation in M.mutations))
		M.mutations.Add(mutation)
	if(disability)
		M.disabilities |= disability
	if(mutation)
		M.sdisabilities |= sdisability
	if(activation_message)
		to_chat(M, SPAN_WARNING("[activation_message]"))
	else
		testing("[name] has no activation message.")

/decl/gene/disability/deactivate(mob/M, connected, flags)
	if(mutation && (mutation in M.mutations))
		M.mutations.Remove(mutation)
	if(disability)
		M.disabilities -= disability
	if(mutation)
		M.sdisabilities -= sdisability
	if(deactivation_message)
		to_chat(M, SPAN_WARNING("[activation_message]"))
	else
		testing("[name] has no deactivation message.")

// Hallucinate
// Note: Doesn't seem to do squat, at the moment.
/decl/gene/disability/hallucinate
	name = "Hallucinate"
	activation_message = "Your mind says 'Hello'."
	mutation = MUTATION_HALLUCINATION

/decl/gene/disability/hallucinate/New()
	. = ..()
	block = GLOBL.dna_data.hallucination_block

// Epilepsy
/decl/gene/disability/epilepsy
	name = "Epilepsy"
	activation_message = "You get a headache."
	disability = EPILEPSY

/decl/gene/disability/epilepsy/New()
	. = ..()
	block = GLOBL.dna_data.headache_block

// Cough
/decl/gene/disability/cough
	name = "Coughing"
	activation_message = "You start coughing."
	disability = COUGHING

/decl/gene/disability/cough/New()
	. = ..()
	block = GLOBL.dna_data.cough_block

// Clumsiness
/decl/gene/disability/clumsy
	name = "Clumsiness"
	activation_message = "You feel lightheaded."
	mutation = MUTATION_CLUMSY

/decl/gene/disability/clumsy/New()
	. = ..()
	block = GLOBL.dna_data.clumsy_block

// Tourettes
/decl/gene/disability/tourettes
	name = "Tourettes"
	activation_message = "You twitch."
	disability = TOURETTES

/decl/gene/disability/tourettes/New()
	. = ..()
	block = GLOBL.dna_data.twitch_block

// Nervousness
/decl/gene/disability/nervousness
	name = "Nervousness"
	activation_message = "You feel nervous."
	disability = NERVOUS

/decl/gene/disability/nervousness/New()
	. = ..()
	block = GLOBL.dna_data.nervous_block

// Blindness
/decl/gene/disability/blindness
	name = "Blindness"
	activation_message = "You can't seem to see anything."
	sdisability = BLIND

/decl/gene/disability/blindness/New()
	. = ..()
	block = GLOBL.dna_data.blind_block

// Deafness
/decl/gene/disability/deaf
	name = "Deafness"
	activation_message = "It's kinda quiet."
	sdisability = DEAF

/decl/gene/disability/deaf/New()
	. = ..()
	block = GLOBL.dna_data.deaf_block

/decl/gene/disability/deaf/activate(mob/M, connected, flags)
	..(M,connected, flags)
	M.ear_deaf = 1

// Nearsightedness
/decl/gene/disability/nearsighted
	name = "Nearsightedness"
	activation_message = "Your eyes feel weird..."
	disability = NEARSIGHTED

/decl/gene/disability/nearsighted/New()
	. = ..()
	block = GLOBL.dna_data.glasses_block