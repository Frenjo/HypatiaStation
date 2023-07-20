/*
 * Air Alarm Defines
 *
 * Moved here because they're used in several places.
 */
#define AIR_ALARM_WIRE_IDSCAN 1
#define AIR_ALARM_WIRE_POWER 2
#define AIR_ALARM_WIRE_SYPHON 3
#define AIR_ALARM_WIRE_AI_CONTROL 4
#define AIR_ALARM_WIRE_AALARM 5

#define AIR_ALARM_MODE_SCRUBBING "scrubbing"
#define AIR_ALARM_MODE_REPLACEMENT "replacement"
#define AIR_ALARM_MODE_PANIC "panic"
#define AIR_ALARM_MODE_CYCLE "cycle"
#define AIR_ALARM_MODE_FILL "fill"
#define AIR_ALARM_MODE_OFF "off"

#define AIR_ALARM_SCREEN_MAIN 1
#define AIR_ALARM_SCREEN_VENT 2
#define AIR_ALARM_SCREEN_SCRUB 3
#define AIR_ALARM_SCREEN_MODE 4
#define AIR_ALARM_SCREEN_SENSORS 5

#define AIR_ALARM_REPORT_TIMEOUT 100

#define AIR_ALARM_RCON_NO 1
#define AIR_ALARM_RCON_AUTO 2
#define AIR_ALARM_RCON_YES 3

//1000 joules equates to about 1 degree every 2 seconds for a single tile of air.
#define AIR_ALARM_MAX_ENERGY_CHANGE 1000

#define AIR_ALARM_MAX_TEMPERATURE 90
#define AIR_ALARM_MIN_TEMPERATURE -40