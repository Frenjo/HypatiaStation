/*
 * Configuration Entries: game_options.txt
 */

/*
 * Category: Health Thresholds
 */
CONFIG_ENTRY(health_threshold_softcrit, 0, list("Level of health at which a mob goes into continual shock (soft crit)."), CATEGORY_HEALTH, TYPE_NUMERIC)
CONFIG_ENTRY(health_threshold_crit, -50, list("Level of health at which a mob becomes unconscious (crit)."), CATEGORY_HEALTH, TYPE_NUMERIC)
CONFIG_ENTRY(health_threshold_dead, -100, list("Level of health at which a mob becomes dead."), CATEGORY_HEALTH, TYPE_NUMERIC)

/*
 * Category: Bone/Limb Breakage
 */
CONFIG_ENTRY(bones_can_break, TRUE, list("Determines whether bones can be broken through excessive damage to the organ.",\
"0 means bones can't break, 1 means they can."), CATEGORY_BREAKAGE, TYPE_BOOLEAN)
CONFIG_ENTRY(limbs_can_break, TRUE, list("Determines whether limbs can be amputated through excessive damage to the organ.",\
"0 means limbs can't be amputated, 1 means they can."), CATEGORY_BREAKAGE, TYPE_BOOLEAN)

/*
 * Category: Organ Multipliers
 */
CONFIG_ENTRY(organ_health_multiplier, 100, list("Multiplier which enables organs to take more damage before bones breaking or limbs being destroyed.",\
"100 means normal, 50 means half."), CATEGORY_ORGANS, TYPE_NUMERIC)
CONFIG_ENTRY(organ_regeneration_multiplier, 75, list("Multiplier which influences how fast organs regenerate naturally.",\
"100 means normal, 50 means half."), CATEGORY_ORGANS, TYPE_NUMERIC)

/*
 * Category: Revival
 */
CONFIG_ENTRY(revival_pod_plants, TRUE, list("Whether pod plants work or not."), CATEGORY_REVIVAL, TYPE_BOOLEAN)
CONFIG_ENTRY(revival_cloning, TRUE, list("Whether cloning tubes work or not."), CATEGORY_REVIVAL, TYPE_BOOLEAN)
CONFIG_ENTRY(revival_brain_life, -1, list("Amount of time (in hundredths of seconds) for which a brain retains the \"spark of life\" after the person's death.",\
"Set to -1 for infinite."), CATEGORY_REVIVAL, TYPE_NUMERIC)

/*
 * Category: Universal Speed Modifiers
 */
CONFIG_ENTRY(run_speed, 2, list("We suggest editing this variable in-game to find a good speed for your server. To do this you must be a high level admin.",\
"This value gets directly added to values and totals in-game. To speed things up make the number negative, to slow things down, make the number positive.",\
"This modifies the run speed of all mobs before the mob-specific modifiers are applied."), CATEGORY_MOVEMENT_UNIVERSAL, TYPE_NUMERIC)
CONFIG_ENTRY(walk_speed, 5, list("We suggest editing this variable in-game to find a good speed for your server. To do this you must be a high level admin.",\
"This value gets directly added to values and totals in-game. To speed things up make the number negative, to slow things down, make the number positive.",\
"This modifies the walk speed of all mobs before the mob-specific modifiers are applied."), CATEGORY_MOVEMENT_UNIVERSAL, TYPE_NUMERIC)

/*
 * Category: Mob Specific Speed Modifiers
 */
CONFIG_ENTRY(human_delay, 0, list("This affects the movement speed of human mobs."), CATEGORY_MOVEMENT_SPECIFIC, TYPE_NUMERIC)
CONFIG_ENTRY(robot_delay, 0, list("This affects the movement speed of robot mobs."), CATEGORY_MOVEMENT_SPECIFIC, TYPE_NUMERIC)
CONFIG_ENTRY(monkey_delay, 0, list("This affects the movement speed of monkey mobs."), CATEGORY_MOVEMENT_SPECIFIC, TYPE_NUMERIC)
CONFIG_ENTRY(alien_delay, 0, list("This affects the movement speed of alien mobs."), CATEGORY_MOVEMENT_SPECIFIC, TYPE_NUMERIC)
CONFIG_ENTRY(slime_delay, 0, list("This affects the movement speed of slime mobs."), CATEGORY_MOVEMENT_SPECIFIC, TYPE_NUMERIC)
CONFIG_ENTRY(animal_delay, 0, list("This affects the movement speed of animal mobs."), CATEGORY_MOVEMENT_SPECIFIC, TYPE_NUMERIC)

/*
 * Category: Miscellaneous
 */
CONFIG_ENTRY(welding_protection_tint, TRUE, list("Whether headwear and eyewear that provides welding protection also reduces view range."), CATEGORY_MISCELLANEOUS_1, TYPE_BOOLEAN)