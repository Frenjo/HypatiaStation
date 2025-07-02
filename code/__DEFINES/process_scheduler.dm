// Process status defines
#define PROCESS_STATUS_IDLE				1
#define PROCESS_STATUS_QUEUED			2
#define PROCESS_STATUS_RUNNING			3
#define PROCESS_STATUS_MAYBE_HUNG		4
#define PROCESS_STATUS_PROBABLY_HUNG	5
#define PROCESS_STATUS_HUNG				6

// Process time thresholds
#define PROCESS_DEFAULT_HANG_WARNING_TIME	30 SECONDS
#define PROCESS_DEFAULT_HANG_ALERT_TIME		60 SECONDS
#define PROCESS_DEFAULT_HANG_RESTART_TIME	90 SECONDS
#define PROCESS_DEFAULT_SCHEDULE_INTERVAL	50	// 50 ticks
#define PROCESS_DEFAULT_SLEEP_INTERVAL		8	// 1/8th of a tick

// SCHECK macros
// This references src directly to work around a weird bug with try/catch
#define SCHECK_EVERY(this_many_calls) if(++src.calls_since_last_scheck >= this_many_calls) sleep_check()
#define SCHECK sleep_check()

#define TICKS_IN_DAY	864000
#define TICKS_IN_SECOND 10

//some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26	//Used to trigger removal from a processing list

// Used to add and remove THINGs from PROCESS' processing_list.
#define START_PROCESSING(PROCESS, THING) global.PROCESS.processing_list.Add(THING)
#define STOP_PROCESSING(PROCESS, THING) global.PROCESS.processing_list.Remove(THING)

// Returns an explicitly typed list of all machinery of TYPE (excluding subtypes).
#define GET_MACHINES_TYPED(TYPE) global.PCmachinery.get_machines_by_type(TYPE)
// Returns an explicitly typed list of all machinery of TYPE (including subtypes).
#define GET_MACHINES_SUBTYPED(TYPE) global.PCmachinery.get_machines_by_type_and_subtypes(TYPE)

// Used to add and remove POWERITEMs from the global power items list.
#define REGISTER_POWER_ITEM(POWERITEM) global.PCmachinery.processing_power_items.Add(POWERITEM)
#define UNREGISTER_POWER_ITEM(POWERITEM) global.PCmachinery.processing_power_items.Remove(POWERITEM)

// Used to add and remove POWERNETs from the global powernets list.
#define REGISTER_POWERNET(POWERNET) global.PCmachinery.powernets.Add(POWERNET)
#define UNREGISTER_POWERNET(POWERNET) global.PCmachinery.powernets.Remove(POWERNET)