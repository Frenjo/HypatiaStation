// Value types for /decl/configuration_entry.
#define TYPE_NONE 0
#define TYPE_BOOLEAN 1
#define TYPE_NUMERIC 2
#define TYPE_STRING 3
#define TYPE_LIST 4 // Lists are basically whitespace-separated strings which use splittext().

// Undefined categories.
#define CATEGORY_NONE_DEFAULT "Uncategorised (Error)"

// Categories that go into gamemode_probabilities.txt.
#define CATEGORY_GAMEMODE_PROBABILITIES "Gamemode Probabilities"

// Categories that go into config.txt.
#define CATEGORY_INFORMATION "Server Information"
#define CATEGORY_TICK "Tick"
#define CATEGORY_URLS "URLs"
#define CATEGORY_PYTHON "Python"
#define CATEGORY_IRC "IRC"
#define CATEGORY_LOGGING "Logging"
#define CATEGORY_CHAT "Chat"
#define CATEGORY_ADMIN "Admin"
#define CATEGORY_GAMEMODE "Gamemode"
#define CATEGORY_VOTING "Voting"
#define CATEGORY_WHITELISTS "Whitelists"
#define CATEGORY_ALERTS "Alert Level Descriptions"
#define CATEGORY_MOBS "Mobs"
#define CATEGORY_MISCELLANEOUS_0 "Miscellaneous (config.txt)"

// Categories that go into game_options.txt.
#define CATEGORY_HEALTH "Health Thresholds"
#define CATEGORY_BREAKAGE "Bone/Limb Breakage"
#define CATEGORY_ORGANS "Organ Multipliers"
#define CATEGORY_REVIVAL "Revival"
#define CATEGORY_MOVEMENT_UNIVERSAL "Universal Speed Modifiers"
#define CATEGORY_MOVEMENT_SPECIFIC "Mob Specific Speed Modifiers"
#define CATEGORY_MISCELLANEOUS_1 "Miscellaneous (game_options.txt)"

// Categories that go into dbconfig.txt.
#define CATEGORY_DATABASE "MySQL Connection Configuration"
#define CATEGORY_FEEDBACK_DATABASE "MySQL Feedback Configuration"

// Categories that go into forumdbconfig.txt.
#define CATEGORY_FORUM_DATABASE "Forum MySQL Database Configuration"