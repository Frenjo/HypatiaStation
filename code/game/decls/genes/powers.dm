///////////////////////////////////
// POWERS
///////////////////////////////////

// No Breathing
/decl/gene/basic/nobreath
	name = "No Breathing"
	activation_messages = list("You feel no need to breathe.")
	mutation = mNobreath

/decl/gene/basic/nobreath/New()
	. = ..()
	block = NOBREATHBLOCK

// Remote Viewing
/decl/gene/basic/remoteview
	name = "Remote Viewing"
	activation_messages = list("Your mind expands.")
	mutation = mRemote

/decl/gene/basic/remoteview/New()
	. = ..()
	block = REMOTEVIEWBLOCK

/decl/gene/basic/remoteview/activate(mob/M, connected, flags)
	..(M,connected, flags)
	M.verbs.Add(/mob/living/carbon/human/proc/remoteobserve)

// Regenerate
/decl/gene/basic/regenerate
	name = "Regenerate"
	activation_messages = list("You feel better.")
	mutation = mRegen

/decl/gene/basic/regenerate/New()
	. = ..()
	block = REGENERATEBLOCK

// Super Speed
/decl/gene/basic/increaserun
	name = "Super Speed"
	activation_messages = list("Your leg muscles pulsate.")
	mutation = mRun

/decl/gene/basic/increaserun/New()
	. = ..()
	block = INCREASERUNBLOCK

// Telepathy
/decl/gene/basic/remotetalk
	name = "Telepathy"
	activation_messages = list("You expand your mind outwards.")
	mutation = mRemotetalk

/decl/gene/basic/remotetalk/New()
	. = ..()
	block = REMOTETALKBLOCK

/decl/gene/basic/remotetalk/activate(mob/M, connected, flags)
	..(M,connected, flags)
	M.verbs.Add(/mob/living/carbon/human/proc/remotesay)

// Morph
/decl/gene/basic/morph
	name = "Morph"
	activation_messages = list("Your skin feels strange.")
	mutation = mMorph

/decl/gene/basic/morph/New()
	. = ..()
	block = MORPHBLOCK

/decl/gene/basic/morph/activate(mob/M)
	..(M)
	M.verbs.Add(/mob/living/carbon/human/proc/morph)

// Heat Resistance
/* Not used on bay
/decl/gene/basic/heat_resist
	name = "Heat Resistance"
	activation_messages = list("Your skin is icy to the touch.")
	mutation = mHeatres

/decl/gene/basic/heat_resist/New()
	. = ..()
	block = COLDBLOCK

/decl/gene/basic/heat_resist/can_activate(var/mob/M,var/flags)
	if(flags & MUTCHK_FORCED)
		return !(/decl/gene/basic/cold_resist in M.active_genes)
	// Probability check
	var/_prob = 15
	if(COLD_RESISTANCE in M.mutations)
		_prob = 5
	if(probinj(_prob, (flags & MUTCHK_FORCED)))
		return TRUE

/decl/gene/basic/heat_resist/OnDrawUnderlays(var/mob/M,var/g,var/fat)
	return "cold[fat]_s"
*/

// Cold Resistance
/decl/gene/basic/cold_resist
	name = "Cold Resistance"
	activation_messages = list("Your body is filled with warmth.")
	mutation = COLD_RESISTANCE

/decl/gene/basic/cold_resist/New()
	. = ..()
	block = FIREBLOCK

/decl/gene/basic/cold_resist/can_activate(mob/M, flags)
	if(flags & MUTCHK_FORCED)
		return TRUE
	//	return !(/datum/dna/gene/basic/heat_resist in M.active_genes)
	// Probability check
	var/_prob = 30
	//if(mHeatres in M.mutations)
	//	_prob=5
	if(probinj(_prob, (flags & MUTCHK_FORCED)))
		return TRUE

/decl/gene/basic/cold_resist/OnDrawUnderlays(mob/M, g, fat)
	return "fire[fat]_s"

// No Prints
/decl/gene/basic/noprints
	name = "No Prints"
	activation_messages = list("Your fingers feel numb.")
	mutation = mFingerprints

/decl/gene/basic/noprints/New()
	. = ..()
	block = NOPRINTSBLOCK

// Shock Immunity
/decl/gene/basic/noshock
	name = "Shock Immunity"
	activation_messages = list("Your skin feels strange.")
	mutation = mShock

/decl/gene/basic/noshock/New()
	. = ..()
	block = SHOCKIMMUNITYBLOCK

// Midget
/decl/gene/basic/midget
	name = "Midget"
	activation_messages = list("Your skin feels rubbery.")
	mutation = mSmallsize

/decl/gene/basic/midget/New()
	. = ..()
	block = SMALLSIZEBLOCK

/decl/gene/basic/midget/can_activate(mob/M, flags)
	// Can't be big and small.
	if(HULK in M.mutations)
		return FALSE
	return ..(M, flags)

/decl/gene/basic/midget/activate(mob/M, connected, flags)
	..(M, connected, flags)
	SET_PASS_FLAGS(M, PASS_FLAG_TABLE)

/decl/gene/basic/midget/deactivate(mob/M, connected, flags)
	..(M, connected, flags)
	UNSET_PASS_FLAGS(M, PASS_FLAG_TABLE) //This may cause issues down the track, but offhand I can't think of any other way for humans to get passtable short of varediting so it should be fine. ~Z

// Hulk
/decl/gene/basic/hulk
	name = "Hulk"
	activation_messages = list("Your muscles hurt.")
	mutation = HULK

/decl/gene/basic/hulk/New()
	. = ..()
	block = HULKBLOCK

/decl/gene/basic/hulk/can_activate(mob/M, flags)
	// Can't be big and small.
	if(mSmallsize in M.mutations)
		return 0
	return ..(M, flags)

/decl/gene/basic/hulk/OnDrawUnderlays(mob/M, g, fat)
	if(fat)
		return "hulk_[fat]_s"
	else
		return "hulk_[g]_s"

/decl/gene/basic/hulk/OnMobLife(mob/living/carbon/human/M)
	if(!istype(M))
		return
	if(M.health <= 25)
		M.mutations.Remove(HULK)
		M.update_mutations()		//update our mutation overlays
		to_chat(M, SPAN_WARNING("You suddenly feel very weak."))
		M.Weaken(3)
		M.emote("collapse")

// X-ray Vision
/decl/gene/basic/xray
	name = "X-Ray Vision"
	activation_messages = list("The walls suddenly disappear.")
	mutation = XRAY

/decl/gene/basic/xray/New()
	. = ..()
	block = XRAYBLOCK

// Telekinesis
/decl/gene/basic/tk
	name = "Telekenesis"
	activation_messages = list("You feel smarter.")
	mutation = TK
	activation_prob = 15

/decl/gene/basic/tk/New()
	. = ..()
	block = TELEBLOCK

/decl/gene/basic/tk/OnDrawUnderlays(mob/M, g, fat)
	return "telekinesishead[fat]_s"