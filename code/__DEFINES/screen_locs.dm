/*
 *	These defines specify screen locations. For more information, see the byond documentation on the screen_loc var.
 *
 *	The short version:
 *
 *	Everything is encoded as strings because apparently that's how Byond rolls.
 *
 *	"1,1" is the bottom left square of the user's screen. This aligns perfectly with the turf grid.
 *	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
 *	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.
 *
 *	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
 *	Therefore, the top right corner (except during admin shenanigans) is at "15,15".
 */
// Space parallax
#define UI_SPACE_PARALLAX "1:0,1:0"

//Upper left action buttons, displayed when you pick up an item that has this enabled.
#define UI_ACTION_SLOT1 "1:6,14:26"
#define UI_ACTION_SLOT2 "2:8,14:26"
#define UI_ACTION_SLOT3 "3:10,14:26"
#define UI_ACTION_SLOT4 "4:12,14:26"
#define UI_ACTION_SLOT5 "5:14,14:26"

//Lower left, persistant menu
#define UI_INVENTORY "1:6,1:5"

//Lower center, persistant menu
#define UI_SSTORE1 "3:10,1:5"
#define UI_ID_STORE "4:12,1:5"
#define UI_BELT "5:14,1:5"
#define UI_BACK "6:14,1:5"
#define UI_RHAND "7:16,1:5"
#define UI_LHAND "8:16,1:5"
#define UI_EQUIP "7:16,2:5"
#define UI_SWAPHAND1 "7:16,2:5"
#define UI_SWAPHAND2 "8:16,2:5"
#define UI_STORAGE1 "9:18,1:5"
#define UI_STORAGE2 "10:20,1:5"
//aliens
#define UI_ALIEN_HEAD "4:12,1:5"
#define UI_ALIEN_OCLOTHING "5:14,1:5"
//borgs
#define UI_INV1 "6:16,1:5"
#define UI_INV2 "7:16,1:5"
#define UI_INV3 "8:16,1:5"
#define UI_BORG_STORE "9:16,1:5"
//monkey
#define UI_MONKEY_MASK "5:14,1:5"
#define UI_MONKEY_BACK "6:14,1:5"

//Lower right, persistant menu
#define UI_DROPBUTTON "11:22,1:5"
#define UI_DROP_THROW "14:28,2:7"
#define UI_PULL_RESIST "13:26,2:7"
#define UI_ACTI "13:26,1:5"
#define UI_MOVI "12:24,1:5"
#define UI_ZONESEL "14:28,1:5"
#define UI_ACTI_ALT "14:28,1:5" //alternative intent switcher for when the interface is hidden (F12)

#define UI_BORG_PULL "12:24,2:7"
#define UI_BORG_MODULE "13:26,2:7"
#define UI_BORG_PANEL "14:28,2:7"

//Gun buttons
#define UI_GUN1 "13:26,3:7"
#define UI_GUN2 "14:28, 4:7"
#define UI_GUN3 "13:26,4:7"
#define UI_GUN_SELECT "14:28,3:7"

//Upper-middle right (damage indicators)
#define UI_TOXIN "14:28,13:27"
#define UI_FIRE "14:28,12:25"
#define UI_OXYGEN "14:28,11:23"
#define UI_PRESSURE "14:28,10:21"

#define UI_ALIEN_TOXIN "14:28,13:25"
#define UI_ALIEN_FIRE "14:28,12:25"
#define UI_ALIEN_OXYGEN "14:28,11:25"

//Middle right (status indicators)
#define UI_NUTRITION "14:28,5:11"
#define UI_TEMP "14:28,6:13"
#define UI_HEALTH "14:28,7:15"
#define UI_INTERNAL "14:28,8:17"
#define UI_BORG_HEALTH "14:28,6:13"		//borgs have the health display where humans have the pressure damage indicator.
#define UI_ALIEN_HEALTH "14:28,6:13"	//aliens have the health display where humans have the pressure damage indicator.

//Pop-up inventory
#define UI_SHOES "2:8,1:5"

#define UI_ICLOTHING "1:6,2:7"
#define UI_OCLOTHING "2:8,2:7"
#define UI_GLOVES "3:10,2:7"

#define UI_GLASSES "1:6,3:9"
#define UI_MASK "2:8,3:9"
#define UI_L_EAR "3:10,3:9"
#define UI_R_EAR "3:10,4:11"

#define UI_HEAD "2:8,4:11"

//Intent small buttons
#define UI_HELP_SMALL "12:8,1:1"
#define UI_DISARM_SMALL "12:15,1:18"
#define UI_GRAB_SMALL "12:32,1:18"
#define UI_HARM_SMALL "12:39,1:1"

//#define ui_swapbutton "6:-16,1:5" //Unused

//#define ui_headset "SOUTH,8"
#define UI_HAND "6:14,1:5"
#define UI_HSTORE1 "5,5"
//#define ui_resist "EAST+1,SOUTH-1"
#define UI_SLEEP "EAST+1, NORTH-13"
#define UI_REST "EAST+1, NORTH-14"

#define UI_IARROWLEFT "SOUTH-1,11"
#define UI_IARROWRIGHT "SOUTH-1,13"