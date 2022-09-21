// These are set in /world/New()
/var/global/href_logfile = null
/var/global/diary = null
/var/global/diaryofmeanpeople = null

/var/global/game_version = "Hypatia"
/var/global/changelog_hash = ""
/var/global/game_year = (text2num(time2text(world.realtime, "YYYY")) + 544)

/var/global/host = null
/var/global/aliens_allowed = FALSE
/var/global/ooc_allowed = TRUE
/var/global/dsay_allowed = TRUE
/var/global/dooc_allowed = TRUE
/var/global/enter_allowed = TRUE
/var/global/guests_allowed = TRUE
/var/global/tinted_weldhelh = TRUE

/var/global/debug2 = FALSE

/var/global/join_motd = null

//This was a define, but I changed it to a variable so it can be changed in-game. -Errorage
/var/global/max_explosion_range = 14
//#define MAX_EXPLOSION_RANGE		14					// Defaults to 12 (was 8) -- TLE