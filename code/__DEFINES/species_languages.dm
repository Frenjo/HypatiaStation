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

// Language flags.
#define WHITELISTED	BITFLAG(0) // Language is available if the speaker is whitelisted.
#define RESTRICTED	BITFLAG(1) // Language can only be accquired by spawning or an admin.
#define NONVERBAL	BITFLAG(2) // Language has a significant non-verbal component.
#define SIGNLANG	BITFLAG(3) // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND	BITFLAG(4) // Broadcast to all mobs with this language.