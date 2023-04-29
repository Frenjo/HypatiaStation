#define AIRLOCK_WIRE_IDSCAN			1
#define AIRLOCK_WIRE_MAIN_POWER1	2
#define AIRLOCK_WIRE_MAIN_POWER2	3
#define AIRLOCK_WIRE_DOOR_BOLTS		4
#define AIRLOCK_WIRE_BACKUP_POWER1	5
#define AIRLOCK_WIRE_BACKUP_POWER2	6
#define AIRLOCK_WIRE_OPEN_DOOR		7
#define AIRLOCK_WIRE_AI_CONTROL		8
#define AIRLOCK_WIRE_ELECTRIFY		9
#define AIRLOCK_WIRE_SAFETY			10
#define AIRLOCK_WIRE_SPEED			11
#define AIRLOCK_WIRE_LIGHT			12

// aiControlDisabled:
// If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
// If 0, AI control is enabled.
// If 1, AI control is disabled until the AI hacks back in and disables the lock.
// If 2, the AI has bypassed the lock.
#define AIRLOCK_AI_CONTROL_BYPASSED			-1
#define AIRLOCK_AI_CONTROL_ENABLED			0
#define AIRLOCK_AI_CONTROL_HACK_REQUIRED	1
#define AIRLOCK_AI_CONTROL_HACKED			2