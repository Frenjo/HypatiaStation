#define EFFECT_TOUCH 0
#define EFFECT_AURA 1
#define EFFECT_PULSE 2
#define MAX_EFFECT 2

#define TRIGGER_TOUCH 0
#define TRIGGER_WATER 1
#define TRIGGER_ACID 2
#define TRIGGER_VOLATILE 3
#define TRIGGER_TOXIN 4
#define TRIGGER_FORCE 5
#define TRIGGER_ENERGY 6
#define TRIGGER_HEAT 7
#define TRIGGER_COLD 8
#define TRIGGER_PLASMA 9
#define TRIGGER_OXY 10
#define TRIGGER_CO2 11
#define TRIGGER_NITRO 12
#define MAX_TRIGGER 12

/*
//sleeping gas appears to be bugged, currently
var/list/valid_primary_effect_types = list(\
	/datum/artifact_effect/cellcharge,\
	/datum/artifact_effect/celldrain,\
	/datum/artifact_effect/forcefield,\
	/datum/artifact_effect/gasoxy,\
	/datum/artifact_effect/gasplasma,\
/*	/datum/artifact_effect/gassleeping,\*/
	/datum/artifact_effect/heal,\
	/datum/artifact_effect/hurt,\
	/datum/artifact_effect/emp,\
	/datum/artifact_effect/teleport,\
	/datum/artifact_effect/robohurt,\
	/datum/artifact_effect/roboheal)

var/list/valid_secondary_effect_types = list(\
	/datum/artifact_effect/cold,\
	/datum/artifact_effect/badfeeling,\
	/datum/artifact_effect/cellcharge,\
	/datum/artifact_effect/celldrain,\
	/datum/artifact_effect/dnaswitch,\
	/datum/artifact_effect/emp,\
	/datum/artifact_effect/gasco2,\
	/datum/artifact_effect/gasnitro,\
	/datum/artifact_effect/gasoxy,\
	/datum/artifact_effect/gasplasma,\
/*	/datum/artifact_effect/gassleeping,\*/
	/datum/artifact_effect/goodfeeling,\
	/datum/artifact_effect/heal,\
	/datum/artifact_effect/hurt,\
	/datum/artifact_effect/radiate,\
	/datum/artifact_effect/roboheal,\
	/datum/artifact_effect/robohurt,\
	/datum/artifact_effect/sleepy,\
	/datum/artifact_effect/stun,\
	/datum/artifact_effect/teleport)
*/