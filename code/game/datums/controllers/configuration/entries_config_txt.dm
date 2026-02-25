/*
 * Configuration Entries: config.txt
 */

/*
 * Category: Server Information
 */
CONFIG_ENTRY(server_name, null, list("Server name, used for world name / status.", "This appears at the top of the screen in-game.",\
"By default, it will read \"Space Station 13 - Hypatia: current_map.station_name\" where station_name is the name specified by the currently active map datum.",\
"If not left blank, any value set here will override the default with the name of your choice."), CATEGORY_INFORMATION, TYPE_STRING)
CONFIG_ENTRY(server_suffix, FALSE, list("If set, generates a numeric suffix for the server's name based on the server's port."), CATEGORY_INFORMATION, TYPE_BOOLEAN)
CONFIG_ENTRY(hostedby, null, list("Sets a hosted by name for unix platforms."), CATEGORY_INFORMATION, TYPE_STRING)

/*
 * Category: Tick
 */
CONFIG_ENTRY(ticklag, 0.9, list("Defines the ticklag for the world. 0.9 is the normal one, 0.5 is smoother."), CATEGORY_TICK, TYPE_NUMERIC)

/*
 * Category: URLs
 */
CONFIG_ENTRY(server, null, list("Sets a server location for world reboot. Don't include the byond://, just give the address and port."), CATEGORY_URLS, TYPE_STRING)
CONFIG_ENTRY(hub_url, null, list("The URL opened when the game version string is clicked on the BYOND Hub."), CATEGORY_URLS, TYPE_STRING)
CONFIG_ENTRY(wikiurl, null, list("Wiki address."), CATEGORY_URLS, TYPE_STRING)
CONFIG_ENTRY(forumurl, null, list("Forum address."), CATEGORY_URLS, TYPE_STRING)
CONFIG_ENTRY(donateurl, null, list("Donation address."), CATEGORY_URLS, TYPE_STRING) // Why is this even missing damnit Techy/Akai/Numbers! -- Marajin
CONFIG_ENTRY(banappeals, null, list("Ban appeals URL - usually for a forum or wherever people should go to contact your admins."), CATEGORY_URLS, TYPE_STRING)
CONFIG_ENTRY(resource_urls, null, list("If you want to use custom resource URLs instead of preloading the rsc, add them here."), CATEGORY_URLS, TYPE_LIST)

/*
 * Category: Python
 */
CONFIG_ENTRY(python_path, null, list("Path to the python executable. Leave blank for default.",\
"Defaults to \"python\" on windows and \"/usr/bin/env python2\" on unix."), CATEGORY_PYTHON, TYPE_STRING)
CONFIG_ENTRY(use_lib_nudge, FALSE, list("If set, use the C library nudge instead of the python script.",\
"This helps security and stability on Linux, but you need to compile the library first."), CATEGORY_PYTHON, TYPE_BOOLEAN)
CONFIG_ENTRY(nudge_script_path, "nudge.py", list("Where the nudge.py script is located."), CATEGORY_PYTHON, TYPE_STRING)

/*
 * Category: IRC
 */
CONFIG_ENTRY(use_irc_bot, FALSE, list("Set to enable sending data to the IRC bot."), CATEGORY_PYTHON, TYPE_BOOLEAN)
CONFIG_ENTRY(irc_bot_host, "localhost", list("Host where the IRC bot is hosted.",\
"Port 45678 needs to be open."), CATEGORY_PYTHON, TYPE_STRING)
CONFIG_ENTRY(main_irc, "#main", list("IRC channel to send information to. Leave blank to disable."), CATEGORY_PYTHON, TYPE_STRING)
CONFIG_ENTRY(admin_irc, "#admin", list("IRC channel to send adminhelps to. Leave blank to disable adminhelps-to-irc."), CATEGORY_PYTHON, TYPE_STRING)

/*
 * Category: Logging
 */
CONFIG_ENTRY(log_ooc, TRUE, list("Log OOC channel?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_access, TRUE, list("Log client access (logon/logoff)?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_say, TRUE, list("Log client say?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_admin, TRUE, list("Log admin actions?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_debug, TRUE, list("Log debug output?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_game, TRUE, list("Log game actions (start of round, results, etc)?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_vote, TRUE, list("Log player votes?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_whisper, TRUE, list("Log client whisper?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_emote, TRUE, list("Log emotes?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_attack, TRUE, list("Log attack messages?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_adminchat, FALSE, list("Log admin chat messages?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_adminwarn, FALSE, list("Log admin warning messages?", "Also duplicates a bunch of other messages."), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_pda, TRUE, list("Log PDA messages?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_hrefs, FALSE, list("Log all Topic() calls (for use by coders in tracking down Topic issues)?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_runtime, FALSE, list("Log world.log and runtime errors to a file?"), CATEGORY_LOGGING, TYPE_BOOLEAN)
CONFIG_ENTRY(log_world_output, FALSE, list("Log world.log messages?"), CATEGORY_LOGGING, TYPE_BOOLEAN)

/*
 * Category: Chat
 */
CONFIG_ENTRY(ooc_allowed, TRUE, list("Whether non-admins can use OOC chat."), CATEGORY_CHAT, TYPE_BOOLEAN)
CONFIG_ENTRY(dead_ooc_allowed, TRUE, list("Whether dead, non-admin players can use OOC chat."), CATEGORY_CHAT, TYPE_BOOLEAN)
CONFIG_ENTRY(dsay_allowed, TRUE, list("Whether non-admins can use deadchat."), CATEGORY_CHAT, TYPE_BOOLEAN)

/*
 * Category: Admin
 */
CONFIG_ENTRY(admin_legacy_system, TRUE, list("Defines whether the server uses the legacy admin system with admins.txt or the SQL system.",\
"You need to set up your database to use the SQL based system."), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(ban_legacy_system, TRUE, list("Defines whether the server uses the legacy banning system with the files in /data or the SQL system.",\
"You need to set up your database to use the SQL based system."), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_admin_ooccolor, FALSE, list("Allow admins with relevant permissions to have their own personal OOC colour?"), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_admin_jump, TRUE, list("Allow admins to jump teleport?"), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_admin_spawning, TRUE, list("Allow admins to spawn items?"), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_admin_rev, TRUE, list("Allow admins to revive mobs?"), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(forbid_singulo_possession, FALSE, list("Set this to forbid admins from posessing the singularity."), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(popup_admin_pm, FALSE, list("If set, adminPMs to non-admins show in a pop-up 'reply' window.",\
"The intention is to make adminPMs more visible, although I find popups annoying so this defaults to off."), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY_UNDESCRIBED(simultaneous_pm_warning_timeout, 100, CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(ert_admin_call_only, FALSE, list("If set, ERTs can only be called by admins."), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(kick_inactive, FALSE, list("Force disconnect for inactive players?"), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(ToRban, FALSE, list("If set, bans the use of ToR."), CATEGORY_ADMIN, TYPE_BOOLEAN)
CONFIG_ENTRY(automute_on, FALSE, list("If set, enables automuting/spam prevention."), CATEGORY_ADMIN, TYPE_BOOLEAN)

/*
 * Category: Gamemode
 */
CONFIG_ENTRY(cult_ghostwriter, TRUE, list("If set, allows ghosts to write in blood during Cult rounds."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(cult_ghostwriter_req_cultists, 6, list("Sets the minimum number of cultists needed for ghosts to write in blood."), CATEGORY_GAMEMODE, TYPE_NUMERIC)
CONFIG_ENTRY(continous_rounds, TRUE, list("If set, gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.",\
"Malf and Rev will let the shuttle be called when the antags/protags are dead."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(protect_roles_from_antagonist, FALSE, list("Set this to make it prohibited for security to be most antagonists."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(traitor_scaling, TRUE, list("If amount of traitors scales based on amount of players."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(objectives_disabled, FALSE, list("If antagonist objectives are disabled or not."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(antag_hud_allowed, TRUE, list("Ghosts can turn on Antag-O-Vision to see a HUD of who is the bad guys this round."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(antag_hud_restricted, TRUE, list("Ghosts that turn on Antag-O-Vision cannot rejoin the round."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_random_events, TRUE, list("Enables random events mid-round when set."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_holidays, TRUE, list("Whether the holiday system is enabled.",\
"Allows special 'Easter-egg' events on special holidays such as seasonal holidays and stuff like 'Talk Like a Pirate Day' :3 YAARRR"), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(holiday_name, null, list("If the holiday system is active, the name of the current holiday."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)
CONFIG_ENTRY(aliens_allowed, FALSE, list("Whether aliens are allowed."), CATEGORY_GAMEMODE, TYPE_BOOLEAN)

/*
 * Category: Voting
 */
CONFIG_ENTRY(allow_vote_restart, TRUE, list("Allow players to initiate a restart vote?"), CATEGORY_VOTING, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_vote_mode, TRUE, list("Allow players to initiate a mode-change vote?"), CATEGORY_VOTING, TYPE_BOOLEAN)
CONFIG_ENTRY(vote_no_default, TRUE, list("If set, players' votes default to \"No vote\". (tbi)",\
"Otherwise, default to \"No change\"."), CATEGORY_VOTING, TYPE_BOOLEAN)
CONFIG_ENTRY(vote_no_dead, FALSE, list("If set, prevents dead players from voting or starting votes. (tbi)"), CATEGORY_VOTING, TYPE_BOOLEAN)
CONFIG_ENTRY(vote_delay, 6000, list("Minimum time between voting sessions in deciseconds.", "Default is 10 minutes."), CATEGORY_VOTING, TYPE_NUMERIC)
CONFIG_ENTRY(vote_period, 600, list("Length of voting periods in deciseconds.", "Default is 1 minute."), CATEGORY_VOTING, TYPE_NUMERIC)
CONFIG_ENTRY(vote_autotransfer_initial, 108000, list("Length of time, in deciseconds, before the first automatic transfer vote is called.",\
"Default is 180 minutes."), CATEGORY_VOTING, TYPE_NUMERIC)
CONFIG_ENTRY(vote_autotransfer_interval, 36000, list("Length of time, in deciseconds, before sequential automatic transfer votes are called.",\
"Default is 60 minutes."), CATEGORY_VOTING, TYPE_NUMERIC)
CONFIG_ENTRY(vote_autogamemode_timeleft, 120, list("Length of time, in seconds, before round start when the gamemode vote is called.",\
"Default is 120, or 2 minutes."), CATEGORY_VOTING, TYPE_NUMERIC)

/*
 * Category: Whitelists
 */
CONFIG_ENTRY(guests_allowed, FALSE, list("If set, prevents those without a registered ckey from connecting.",\
"IE, guest-* are all blocked from connecting."), CATEGORY_WHITELISTS, TYPE_BOOLEAN)
CONFIG_ENTRY(guest_jobban, TRUE, list("If set, jobbans \"guest-\" accounts from Captain, HoS, HoP, CE, RD, CMO, Warden, Security, Detective, and AI positions.",\
"Set to 1 to ban, 0 to allow."), CATEGORY_WHITELISTS, TYPE_BOOLEAN)
CONFIG_ENTRY(usewhitelist, FALSE, list("Set to jobban everyone who's key is not listed in data/whitelist.txt from Captain, HoS, HoP, CE, RD, CMO, Warden, Security, Detective, and AI positions.",\
"See GUEST_JOBBAN and regular jobbans for more options."), CATEGORY_WHITELISTS, TYPE_BOOLEAN)
CONFIG_ENTRY(usealienwhitelist, TRUE, list("If set, restricts non-admins from playing humanoid alien races."), CATEGORY_WHITELISTS, TYPE_BOOLEAN)
CONFIG_ENTRY(limitalienplayers, FALSE, list("If set, restricts the number of alien players allowed in the round.",\
"Uses the ratio set by ALIEN_TO_HUMAN_RATIO."), CATEGORY_WHITELISTS, TYPE_BOOLEAN)
CONFIG_ENTRY(alien_to_human_ratio, 0.2, list("If enabled, this number represents the number of alien players allowed for every human player."), CATEGORY_WHITELISTS, TYPE_NUMERIC)
CONFIG_ENTRY(use_age_restriction_for_jobs, FALSE, list("If set, certain jobs require your account to be at least a certain number of days old to select.",\
"You can configure the exact age requirements for different jobs by editing the minimum_player_age variable on specific job datums.",\
"Set minimal_player_age to 0 to disable age requirement for that job.", "REQUIRES the database set up to work. Keep it hashed if you don't have a database set up.",\
"NOTE: If you have just set-up the database keep this DISABLED, as player age is determined from the first time they connect to the server with the database up.",\
"If you just set it up, it means you have noone older than 0 days, since noone has been logged yet. Only turn this on once you have had the database up for 30 days."), CATEGORY_WHITELISTS, TYPE_BOOLEAN)
CONFIG_ENTRY(disable_player_mice, FALSE, list("If set, disables players spawning as mice."), CATEGORY_WHITELISTS, TYPE_BOOLEAN)
CONFIG_ENTRY(uneducated_mice, TRUE, list("Set this to prevent newly-spawned mice from understanding human speech."), CATEGORY_WHITELISTS, TYPE_BOOLEAN)

/*
 * Category: Alert Level Descriptions
 */
CONFIG_ENTRY(alert_desc_green, "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced.",\
list("Green"), CATEGORY_ALERTS, TYPE_STRING)
CONFIG_ENTRY(alert_desc_yellow_upto, "There is a security alert in progress. Security staff may have weapons visible, however privacy laws remain fully enforced.",\
list("Yellow (Raising To)"), CATEGORY_ALERTS, TYPE_STRING)
CONFIG_ENTRY(alert_desc_yellow_downto, "The possible threat has passed. Security staff may continue to have their weapons visible, however they may no longer conduct random searches.",\
list("Yellow (Lowering To)"), CATEGORY_ALERTS, TYPE_STRING)
CONFIG_ENTRY(alert_desc_blue_upto, "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted.",\
list("Blue (Raising To)"), CATEGORY_ALERTS, TYPE_STRING)
CONFIG_ENTRY(alert_desc_blue_downto, "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed.",\
list("Blue (Lowering To)"), CATEGORY_ALERTS, TYPE_STRING)
CONFIG_ENTRY(alert_desc_red_upto, "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised.",\
list("Red (Raising To)"), CATEGORY_ALERTS, TYPE_STRING)
CONFIG_ENTRY(alert_desc_red_downto, "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised.",\
list("Red (Lowering To)"), CATEGORY_ALERTS, TYPE_STRING)
CONFIG_ENTRY(alert_desc_delta, "The station's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill.",\
list("Delta"), CATEGORY_ALERTS, TYPE_STRING)

/*
 * Category: Mobs
 */
CONFIG_ENTRY(del_new_on_log, TRUE, list("If set, calls del() on new players if they log out before they spawn in."), CATEGORY_MOBS, TYPE_BOOLEAN)
CONFIG_ENTRY(ghost_interaction, FALSE, list("If enabled, allows ghosts to spin chairs."), CATEGORY_MOBS, TYPE_BOOLEAN)
CONFIG_ENTRY(respawn, TRUE, list("If true, allows respawning."), CATEGORY_MOBS, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_ai, TRUE, list("Allow ai job?"), CATEGORY_MOBS, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_drone_spawn, TRUE, list("If enabled, allows the spawning of maintenance drones."), CATEGORY_MOBS, TYPE_BOOLEAN)
CONFIG_ENTRY(max_maint_drones, 5, list("The maximum number of maintenance drones that can spawn, assuming they're allowed to."), CATEGORY_MOBS, TYPE_NUMERIC)
CONFIG_ENTRY(drone_build_time, 1200, list("The time in ticks between new maintenance drones becoming available.",\
"Default is 2 minutes."), CATEGORY_MOBS, TYPE_NUMERIC)
CONFIG_ENTRY(humans_need_surnames, FALSE, list("If true, forces all player controlled mobs to have a second name."), CATEGORY_MOBS, TYPE_BOOLEAN)
CONFIG_ENTRY(jobs_have_minimal_access, TRUE, list("Determines whether jobs use minimal or expanded access.",\
"This is intended for servers with low populations - where there are not enough players to fill all roles, so players need to do more than just one job.",\
"Also for servers where they don't want people to hide in their own departments."), CATEGORY_MOBS, TYPE_BOOLEAN)
CONFIG_ENTRY(assistant_maint, FALSE, list("If true, assistants get maintenance access?"), CATEGORY_MOBS, TYPE_BOOLEAN)

/*
 * Category: Miscellaneous
 */
CONFIG_ENTRY(sql_enabled, FALSE, list("For sql switching."), CATEGORY_MISCELLANEOUS_0, TYPE_BOOLEAN)
CONFIG_ENTRY(use_recursive_explosions, FALSE, list("Set this to use recursive explosions.",\
"Recursive explosions react to walls, airlocks and blast doors, making them look a lot cooler than the boring old circular explosions.",\
"They require more CPU and are (as of January 2013) experimental."), CATEGORY_MISCELLANEOUS_0, TYPE_BOOLEAN)
CONFIG_ENTRY(allow_metadata, FALSE, list("If set, metadata is supported."), CATEGORY_MISCELLANEOUS_0, TYPE_BOOLEAN)
CONFIG_ENTRY(feature_object_spell_system, FALSE, list("Spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard."), CATEGORY_MISCELLANEOUS_0, TYPE_BOOLEAN)
CONFIG_ENTRY(load_jobs_from_txt, FALSE, list("If set, jobs will load up from the .txt."), CATEGORY_MISCELLANEOUS_0, TYPE_BOOLEAN)
CONFIG_ENTRY(socket_talk, FALSE, list("Whether the server will talk to other processes through socket_talk."), CATEGORY_MISCELLANEOUS_0, TYPE_BOOLEAN)
CONFIG_ENTRY(comms_password, null, list("Password used for authorizing ircbot and other external tools."), CATEGORY_MISCELLANEOUS_0, TYPE_STRING)
CONFIG_ENTRY(gateway_delay, 18000, list("How long the delay is before the Away Mission gate opens.",\
"Default is 30 minutes."), CATEGORY_MISCELLANEOUS_0, TYPE_NUMERIC)
CONFIG_ENTRY(starlight, 2, list("Configures the brightness of ambient starlight on space tiles."), CATEGORY_MISCELLANEOUS_0, TYPE_NUMERIC)