#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4

#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/"+(MODE))))

//Security levels
#define SEC_LEVEL_GREEN		0
#define SEC_LEVEL_YELLOW	1
#define SEC_LEVEL_BLUE		2
#define SEC_LEVEL_RED		3
#define SEC_LEVEL_DELTA		4