//bitflags for mutations
// Extra powers:
#define LASER			(1<<8)	// harm intent - click anywhere to shoot lasers from eyes
#define HEAL			(1<<9)	// healing people with hands
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

// mob/var/list/mutations

#define STRUCDNASIZE 27
#define UNIDNASIZE 13

// Generic mutations:
#define	MUTATION_TELEKINESIS		1
#define MUTATION_COLD_RESISTANCE	2
#define MUTATION_XRAY				3
#define MUTATION_HULK				4
#define MUTATION_CLUMSY				5
#define MUTATION_FAT				6
#define MUTATION_HUSK				7
#define MUTATION_NO_CLONE			8

//2spooky
#define MUTATION_SKELETON	29
#define MUTATION_PLANT		30

// Other Mutations:
#define MUTATION_NO_BREATHE			100		// no need to breathe
#define MUTATION_REMOTE_VIEW		101		// remote viewing
#define MUTATION_REGENERATE			102		// health regen
#define MUTATION_NO_SLOWDOWN		103		// no slowdown
#define MUTATION_REMOTE_TALK		104		// remote talking
#define MUTATION_MORPH				105		// changing appearance
#define MUTATION_BLEND				106		// nothing (seriously nothing)
#define MUTATION_HALLUCINATION		107		// hallucinations
#define MUTATION_NO_FINGERPRINTS	108		// no fingerprints
#define MUTATION_SHOCK_PROOF		109		// insulated hands
#define MUTATION_SMALL_SIZE			110		// table climbing

// Disabilities.
#define NEARSIGHTED	BITFLAG(0)
#define EPILEPSY	BITFLAG(1)
#define COUGHING	BITFLAG(2)
#define TOURETTES	BITFLAG(3)
#define NERVOUS		BITFLAG(4)

// sdisabilities.
#define BLIND	BITFLAG(0)
#define MUTE	BITFLAG(1)
#define DEAF	BITFLAG(2)