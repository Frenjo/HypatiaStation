// Species name defines.
#define SPECIES_HUMAN "Human"
#define SPECIES_SOGHUN "Soghun"
#define SPECIES_TAJARAN "Tajaran"
#define SPECIES_SKRELL "Skrell"
#define SPECIES_MACHINE "Machine"
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
#define NO_BLOOD	BITFLAG(0)
#define NO_BREATHE	BITFLAG(1)
#define NO_SCAN		BITFLAG(2)
#define NO_PAIN		BITFLAG(3)
#define NO_SLIP		BITFLAG(4)
#define NO_POISON	BITFLAG(5)

#define HAS_SKIN_TONE	BITFLAG(6)
#define HAS_SKIN_COLOR	BITFLAG(7)
#define HAS_EYE_COLOR	BITFLAG(8)
#define HAS_LIPS		BITFLAG(9)
#define HAS_UNDERWEAR	BITFLAG(10)
#define HAS_TAIL		BITFLAG(11)

#define IS_PLANT		BITFLAG(12)
#define IS_WHITELISTED	BITFLAG(13)
#define IS_SYNTHETIC	BITFLAG(14)

#define RAD_ABSORB		BITFLAG(15)
#define REQUIRE_LIGHT	BITFLAG(16)

// Language flags.
#define WHITELISTED	BITFLAG(0) // Language is available if the speaker is whitelisted.
#define RESTRICTED	BITFLAG(1) // Language can only be accquired by spawning or an admin.
#define NONVERBAL	BITFLAG(2) // Language has a significant non-verbal component.
#define SIGNLANG	BITFLAG(3) // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND	BITFLAG(4) // Broadcast to all mobs with this language.