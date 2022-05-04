//A set of constants used to determine which type of mute an admin wishes to apply:
//Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO etc = (MUTE_IC << 1)
//Therefore there needs to be a gap between the flags for the automute flags
#define MUTE_IC			1
#define MUTE_OOC		2
#define MUTE_PRAY		4
#define MUTE_ADMINHELP	8
#define MUTE_DEADCHAT	16
#define MUTE_ALL		31

//Number of identical messages required to get the spam-prevention automute thing to trigger warnings and automutes
#define SPAM_TRIGGER_WARNING	5
#define SPAM_TRIGGER_AUTOMUTE	10

//Some constants for DB_Ban
#define BANTYPE_PERMA		1
#define BANTYPE_TEMP		2
#define BANTYPE_JOB_PERMA	3
#define BANTYPE_JOB_TEMP	4
#define BANTYPE_ANY_FULLBAN	5 //used to locate stuff to unban.

#define ROUNDSTART_LOGOUT_REPORT_TIME 6000 //Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

//Please don't edit these values without speaking to Errorage first	~Carn
//Admin Permissions
#define R_REJUVINATE	1
#define R_BUILDMODE		2
#define R_POSSESS		4
#define R_STEALTH		8
#define R_SOUNDS		16 //sort of singe-tasked
#define R_SPAWN			32
#define R_VAREDIT		64
#define R_DONOR			128//lowest "rank"/perm
#define R_MOD			256//MOD > DONOR
#define R_BAN			512
#define R_ADMIN			1024
#define R_FUN			2048
#define R_SERVER		4096
#define R_DEBUG			8192
#define R_ZAS			16384
//#define R_HIGHDEBUG	16384
//#define R_PERMISSIONS	32768
#define R_PERMISSIONS	32768
#define R_MAXPERMISSION	32768

#define R_HOST			65535

/var/global/gravity_is_on = TRUE