// TODO: Move a lot of these to be inside the /configuration object itself.

// These are set in /world/New()
GLOBAL_GLOBL_INIT(href_logfile, null)
GLOBAL_GLOBL_INIT(diary, null)
GLOBAL_GLOBL_INIT(diaryofmeanpeople, null)

GLOBAL_GLOBL_INIT(game_version, "Hypatia")
GLOBAL_GLOBL_INIT(changelog_hash, "")
GLOBAL_GLOBL_INIT(game_year, (text2num(time2text(world.realtime, "YYYY")) + 544))

GLOBAL_GLOBL_INIT(host, null)
GLOBAL_GLOBL_INIT(enter_allowed, TRUE)

GLOBAL_GLOBL_INIT(debug2, FALSE)

GLOBAL_GLOBL_INIT(join_motd, null)

//This was a define, but I changed it to a variable so it can be changed in-game. -Errorage
GLOBAL_GLOBL_INIT(max_explosion_range, 14)
//#define MAX_EXPLOSION_RANGE		14					// Defaults to 12 (was 8) -- TLE