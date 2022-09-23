GLOBAL_GLOBL_LIST_NEW(preferences_datums)

/var/global/list/special_roles = list(
//some autodetection here.
	"traitor" = IS_MODE_COMPILED("traitor"),			// 0
	"operative" = IS_MODE_COMPILED("nuclear"),			// 1
	"changeling" = IS_MODE_COMPILED("changeling"),		// 2
	"wizard" = IS_MODE_COMPILED("wizard"),				// 3
	"malf AI" = IS_MODE_COMPILED("malfunction"),		// 4
	"revolutionary" = IS_MODE_COMPILED("revolution"),	// 5
	"alien candidate" = TRUE, //always show				// 6
	"pAI candidate" = TRUE, // -- TLE					// 7
	"cultist" = IS_MODE_COMPILED("cult"),				// 8
	"infested monkey" = IS_MODE_COMPILED("monkey"),		// 9
	"ninja" = TRUE,										// 10
	//"vox raider" = IS_MODE_COMPILED("heist"),			// 11
	"diona" = TRUE,										// 12
)

//Preferences stuff
	//Hairstyles
GLOBAL_GLOBL_LIST_NEW(hair_styles_list)					//stores /datum/sprite_accessory/hair indexed by name
GLOBAL_GLOBL_LIST_NEW(hair_styles_male_list)
GLOBAL_GLOBL_LIST_NEW(hair_styles_female_list)
GLOBAL_GLOBL_LIST_NEW(facial_hair_styles_list)			//stores /datum/sprite_accessory/facial_hair indexed by name
GLOBAL_GLOBL_LIST_NEW(facial_hair_styles_male_list)
GLOBAL_GLOBL_LIST_NEW(facial_hair_styles_female_list)
GLOBAL_GLOBL_LIST_NEW(skin_styles_female_list)			//unused
	//Underwear
// Curse whoever made male/female underwear diffrent colours
GLOBAL_GLOBL_LIST_INIT(underwear_m, list("White", "Grey", "Green", "Blue", "Black", "Mankini", "None"))
GLOBAL_GLOBL_LIST_INIT(underwear_f, list("Red", "White", "Yellow", "Blue", "Black", "Thong", "None"))
	//Backpacks
GLOBAL_GLOBL_LIST_INIT(backbaglist, list("Nothing", "Backpack", "Satchel", "Satchel Alt"))

/var/global/list/be_special_flags = list(
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