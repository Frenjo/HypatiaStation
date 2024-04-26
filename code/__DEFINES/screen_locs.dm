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
// Space Parallax
#define UI_SPACE_PARALLAX "WEST:0, SOUTH:0"

/*
 * Upper Left Action Buttons
 * Displayed when you pick up an item that has this enabled.
 *
 * These are in left-to-right order.
 */
#define UI_ACTION_SLOT1 "WEST:6, SOUTH+13:26"
#define UI_ACTION_SLOT2 "WEST+1:8, SOUTH+13:26"
#define UI_ACTION_SLOT3 "WEST+2:10, SOUTH+13:26"
#define UI_ACTION_SLOT4 "WEST+3:12, SOUTH+13:26"
#define UI_ACTION_SLOT5 "WEST+4:14, SOUTH+13:26"

// Lower Left (Persistent Menu)
#define UI_INVENTORY_TOGGLE "WEST:6, SOUTH:5"

/*
 * Lower Centre
 * (Persistent Menu)
 *
 * These are in left-to-right, bottom-to-top order.
 */
#define UI_ID_STORE "WEST+3:12, SOUTH:5"
#define UI_BELT "WEST+4:14, SOUTH:5"
#define UI_BACK "WEST+5:14, SOUTH:5"
#define UI_STORAGE1 "WEST+8:18, SOUTH:5"
#define UI_STORAGE2 "WEST+9:20, SOUTH:5"
#define UI_LHAND "WEST+7:16, SOUTH:5"
#define UI_RHAND "WEST+6:16, SOUTH:5"
#define UI_EQUIP "WEST+6:16, SOUTH+1:5"
#define UI_SWAPHAND1 "WEST+6:16, SOUTH+1:5"
#define UI_SWAPHAND2 "WEST+7:16, SOUTH+1:5"
// Alien
#define UI_ALIEN_HEAD "WEST+3:12, SOUTH:5"
#define UI_ALIEN_OCLOTHING "WEST+4:14, SOUTH:5"
// Cyborg
#define UI_INV1 "WEST+5:16, SOUTH:5"
#define UI_INV2 "WEST+6:16, SOUTH:5"
#define UI_INV3 "WEST+7:16, SOUTH:5"
#define UI_BORG_STORE "WEST+8:16, SOUTH:5"
// Monkey
#define UI_MONKEY_MASK "WEST+4:14, SOUTH:5"
#define UI_MONKEY_BACK "WEST+5:14, SOUTH:5"

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

/*
 * Pop-up Inventory
 * These are in left-to-right, bottom-to-top order.
 */
#define UI_SHOES "WEST+1:8, SOUTH:5"
#define UI_SSTORE1 "WEST+2:10, SOUTH:5"
#define UI_ICLOTHING "WEST:6, SOUTH+1:7"
#define UI_OCLOTHING "WEST+1:8, SOUTH+1:7"
#define UI_GLOVES "WEST+2:10, SOUTH+1:7"
#define UI_R_EAR "WEST:6, SOUTH+2:9"
#define UI_MASK "WEST+1:8, SOUTH+2:9"
#define UI_L_EAR "WEST+2:10, SOUTH+2:9"
#define UI_GLASSES "WEST:6, SOUTH+3:11"
#define UI_HEAD "WEST+1:8, SOUTH+3:11"

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