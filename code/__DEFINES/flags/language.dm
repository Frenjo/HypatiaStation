/*
 * Language Flags
 */
#define LANGUAGE_FLAG_WHITELISTED	BITFLAG(0) // Language is available if the speaker is whitelisted.
#define LANGUAGE_FLAG_RESTRICTED	BITFLAG(1) // Language can only be accquired by spawning or an admin.
#define LANGUAGE_FLAG_NONVERBAL		BITFLAG(2) // Language has a significant non-verbal component.
#define LANGUAGE_FLAG_SIGNLANG		BITFLAG(3) // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define LANGUAGE_FLAG_HIVEMIND		BITFLAG(4) // Broadcast to all mobs with this language.