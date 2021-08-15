//Preference toggles
#define SOUND_ADMINHELP	1
#define SOUND_MIDI		2
#define SOUND_AMBIENCE	4
#define SOUND_LOBBY		8
#define CHAT_OOC		16
#define CHAT_DEAD		32
#define CHAT_GHOSTEARS	64
#define CHAT_GHOSTSIGHT	128
#define CHAT_PRAYER		256
#define CHAT_RADIO		512
#define CHAT_ATTACKLOGS	1024
#define CHAT_DEBUGLOGS	2048
#define CHAT_LOOC		4096
#define CHAT_GHOSTRADIO 8192

#define TOGGLES_DEFAULT (SOUND_ADMINHELP | SOUND_MIDI | SOUND_AMBIENCE | SOUND_LOBBY | CHAT_OOC | CHAT_DEAD | CHAT_GHOSTEARS | CHAT_GHOSTSIGHT | CHAT_PRAYER | CHAT_RADIO | CHAT_ATTACKLOGS | CHAT_LOOC)

#define BE_TRAITOR		1
#define BE_OPERATIVE	2
#define BE_CHANGELING	4
#define BE_WIZARD		8
#define BE_MALF			16
#define BE_REV			32
#define BE_ALIEN		64
#define BE_PAI			128
#define BE_CULTIST		256
#define BE_MONKEY		512
#define BE_NINJA		1024
#define BE_RAIDER		2048
#define BE_PLANT		4096

var/list/be_special_flags = list(
	"Traitor" = BE_TRAITOR,
	"Operative" = BE_OPERATIVE,
	"Changeling" = BE_CHANGELING,
	"Wizard" = BE_WIZARD,
	"Malf AI" = BE_MALF,
	"Revolutionary" = BE_REV,
	"Xenomorph" = BE_ALIEN,
	"pAI" = BE_PAI,
	"Cultist" = BE_CULTIST,
	"Monkey" = BE_MONKEY,
	"Ninja" = BE_NINJA,
	"Raider" = BE_RAIDER,
	"Diona" = BE_PLANT
	)