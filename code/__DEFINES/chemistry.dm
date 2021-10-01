// Factor of how fast mob nutrition decreases
#define HUNGER_FACTOR 0.05

// How many units of reagent are consumed per tick, by default.
#define REAGENTS_METABOLISM 0.2

// By defining the effect multiplier this way, it'll exactly adjust
// all effects according to how they originally were with the 0.4 metabolism
#define REAGENTS_EFFECT_MULTIPLIER	(REAGENTS_METABOLISM / 0.4)
#define REM 						REAGENTS_EFFECT_MULTIPLIER

#define TOUCH	1
#define INGEST	2

#define REAGENT_SOLID	1
#define REAGENT_LIQUID	2
#define REAGENT_GAS		3

#define FOOD_METABOLISM 0.4

#define REAGENTS_OVERDOSE 30

#define ANTIDEPRESSANT_MESSAGE_DELAY (5 * 60 * 10)

//Some on_mob_life() procs check for alien races.
#define IS_HUMAN		0
#define IS_SOGHUN		1
#define IS_TAJARAN		2
#define IS_SKRELL		3
#define IS_VOX			4
#define IS_DIONA		5
#define IS_OBSEDAI		6
#define IS_PLASMALIN	7
#define IS_XENOMORPH	8

//feel free to add shit to lists below
var/list/tachycardics = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine")	//increase heart rate
var/list/bradycardics = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")					//decrease heart rate
var/list/heartstopper = list("potassium_phorochloride", "zombie_powder") //this stops the heart
var/list/cheartstopper = list("potassium_chloride") //this stops the heart when overdose is met -- c = conditional