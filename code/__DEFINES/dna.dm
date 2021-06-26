//bitflags for mutations
// Extra powers:
#define LASER			(1<<8) 	// harm intent - click anywhere to shoot lasers from eyes
#define HEAL			(1<<9) 	// healing people with hands
#define SHADOW			(1<<10)	// shadow teleportation (create in/out portals anywhere) (25%)
#define SCREAM			(1<<11)	// supersonic screaming (25%)
#define EXPLOSIVE		(1<<12)	// exploding on-demand (15%)
#define REGENERATION	(1<<13)	// superhuman regeneration (30%)
#define REPROCESSOR		(1<<14)	// eat anything (50%)
#define SHAPESHIFTING	(1<<15)	// take on the appearance of anything (40%)
#define PHASING			(1<<16)	// ability to phase through walls (40%)
#define SHIELD			(1<<17)	// shielding from all projectile attacks (30%)
#define SHOCKWAVE		(1<<18)	// attack a nearby tile and cause a massive shockwave, knocking most people on their asses (25%)
#define ELECTRICITY		(1<<19)	// ability to shoot electric attacks (15%)

// String identifiers for associative list lookup

// mob/var/list/mutations

#define STRUCDNASIZE 27
#define UNIDNASIZE 13

// Generic mutations:
#define	TK				1
#define COLD_RESISTANCE	2
#define XRAY			3
#define HULK			4
#define CLUMSY			5
#define FAT				6
#define HUSK			7
#define NOCLONE			8

//2spooky
#define SKELETON	29
#define PLANT		30

// Other Mutations:
#define mNobreath		100		// no need to breathe
#define mRemote			101		// remote viewing
#define mRegen			102		// health regen
#define mRun			103		// no slowdown
#define mRemotetalk		104		// remote talking
#define mMorph			105		// changing appearance
#define mBlend			106		// nothing (seriously nothing)
#define mHallucination	107		// hallucinations
#define mFingerprints	108		// no fingerprints
#define mShock			109		// insulated hands
#define mSmallsize		110		// table climbing

//disabilities
#define NEARSIGHTED	1
#define EPILEPSY	2
#define COUGHING	4
#define TOURETTES	8
#define NERVOUS		16

//sdisabilities
#define BLIND	1
#define MUTE	2
#define DEAF	4

var/list/global_mutations = list() // list of hidden mutation things