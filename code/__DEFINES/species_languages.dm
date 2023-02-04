// Species name defines.
#define SPECIES_HUMAN "Human"
#define SPECIES_SOGHUN "Soghun"
#define SPECIES_TAJARAN "Tajaran"
#define SPECIES_SKRELL "Skrell"
#define SPECIES_VOX "Vox"
#define SPECIES_VOX_ARMALIS "Vox Armalis"
#define SPECIES_DIONA "Diona"
#define SPECIES_OBSEDAI "Obsedai"
#define SPECIES_PLASMALIN "Plasmalin"
// Xenomorph subtypes.
#define SPECIES_XENOMORPH "Xenomorph"
#define SPECIES_XENOMORPH_DRONE "Xenomorph Drone"
#define SPECIES_XENOMORPH_SENTINEL "Xenomorph Sentinel"
#define SPECIES_XENOMORPH_HUNTER "Xenomorph Hunter"
#define SPECIES_XENOMORPH_QUEEN "Xenomorph Queen"

// Species flags.
#define NO_BLOOD	1
#define NO_BREATHE	2
#define NO_SCAN		4
#define NO_PAIN		8
#define NO_SLIP		16
#define NO_POISON	32

#define HAS_SKIN_TONE	64
#define HAS_SKIN_COLOR	128
#define HAS_EYE_COLOR	256
#define HAS_LIPS		512
#define HAS_UNDERWEAR	1024
#define HAS_TAIL		2048

#define IS_PLANT		4096
#define IS_WHITELISTED	8192
#define IS_SYNTHETIC	16384

#define RAD_ABSORB		32768
#define REQUIRE_LIGHT	65536

// Language flags.
#define WHITELISTED	1	// Language is available if the speaker is whitelisted.
#define RESTRICTED	2	// Language can only be accquired by spawning or an admin.
#define NONVERBAL	4		// Language has a significant non-verbal component.
#define SIGNLANG	8		// Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND	16		// Broadcast to all mobs with this language.