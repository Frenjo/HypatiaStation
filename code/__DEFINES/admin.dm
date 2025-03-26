//A set of constants used to determine which type of mute an admin wishes to apply:
//Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO etc = (MUTE_IC << 1)
//Therefore there needs to be a gap between the flags for the automute flags
#define MUTE_IC BITFLAG(0)
#define MUTE_OOC BITFLAG(1)
#define MUTE_PRAY BITFLAG(2)
#define MUTE_ADMINHELP BITFLAG(3)
#define MUTE_DEADCHAT BITFLAG(4)
#define MUTE_ALL (MUTE_IC | MUTE_OOC | MUTE_PRAY | MUTE_ADMINHELP | MUTE_DEADCHAT)

//Number of identical messages required to get the spam-prevention automute thing to trigger warnings and automutes
#define SPAM_TRIGGER_WARNING	5
#define SPAM_TRIGGER_AUTOMUTE	10

//Some constants for DB_Ban
#define BANTYPE_PERMA		1
#define BANTYPE_TEMP		2
#define BANTYPE_JOB_PERMA	3
#define BANTYPE_JOB_TEMP	4
#define BANTYPE_ANY_FULLBAN	5 //used to locate stuff to unban.

#define ROUNDSTART_LOGOUT_REPORT_TIME (10 MINUTES) // Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

//Please don't edit these values without speaking to Errorage first	~Carn
//Admin Permissions
#define R_REJUVENATE BITFLAG(0)
#define R_BUILDMODE BITFLAG(1)
#define R_POSSESS BITFLAG(2)
#define R_STEALTH BITFLAG(3)
#define R_SPAWN BITFLAG(4)
#define R_VAREDIT BITFLAG(5)
#define R_MOD BITFLAG(6)
#define R_BAN BITFLAG(7)
#define R_ADMIN BITFLAG(8)
#define R_FUN BITFLAG(9)
#define R_SERVER BITFLAG(10)
#define R_DEBUG BITFLAG(11)
#define R_PERMISSIONS BITFLAG(12)
#define R_MAXPERMISSION BITFLAG(12)

#define R_HOST (R_REJUVENATE | R_BUILDMODE | R_POSSESS | R_STEALTH | R_SPAWN | R_VAREDIT | R_MOD | R_BAN | R_ADMIN | R_FUN | R_SERVER | R_DEBUG | R_PERMISSIONS)