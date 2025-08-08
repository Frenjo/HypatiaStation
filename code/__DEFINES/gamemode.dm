#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4

#define IS_MODE_COMPILED(MODE) ispath(##MODE)

// Returns whether or not the current gamemode is of type X.
// Basically exists so there isn't the need to type out long lines.
#define IS_GAME_MODE(X) istype(global.PCticker?.mode, X)