// Mob helpers
// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
#define ishuman(x)		istype(x, /mob/living/carbon/human)

#define ismonkey(x)		istype(x, /mob/living/carbon/monkey)

#define isbrain(x)		istype(x, /mob/living/carbon/brain)

#define isalien(x)		istype(x, /mob/living/carbon/alien)

#define islarva(x)		istype(x, /mob/living/carbon/alien/larva)

#define isslime(x)		istype(x, /mob/living/carbon/slime)

#define isslimeadult(x)	istype(x, /mob/living/carbon/slime/adult)

#define isrobot(x)		istype(x, /mob/living/silicon/robot)

#define isdrone(x)		istype(x, /mob/living/silicon/robot/drone)

#define isanimal(x)		istype(x, /mob/living/simple_animal)

#define iscorgi(x)		istype(x, /mob/living/simple_animal/corgi)

#define iscrab(x)		istype(x, /mob/living/simple_animal/crab)

#define iscat(x)		istype(x, /mob/living/simple_animal/cat)

#define ismouse(x)		istype(x, /mob/living/simple_animal/mouse)

#define isnear(x)		istype(x, /mob/living/simple_animal/hostile/bear)

#define iscarp(x)		istype(x, /mob/living/simple_animal/hostile/carp)

#define isclown(x)		istype(x, /mob/living/simple_animal/hostile/retaliate/clown)

#define isAI(x)			istype(x, /mob/living/silicon/ai)

#define ispAI(x)		istype(x, /mob/living/silicon/pai)

#define iscarbon(x)		istype(x, /mob/living/carbon)

#define issilicon(x)	istype(x, /mob/living/silicon)

#define isliving(x)		istype(x, /mob/living)

#define isobserver(x) 	istype(x, /mob/dead/observer)

#define isorgan(x)		istype(x, /datum/organ/external)

#define hasorgans(x)	ishuman(x)

// Cult-related checks.
// This one line was typed out almost 30+ times so it justifies an entry here.
#define isrune(x) istype(x, /obj/effect/rune)

// MMI check.
// Same as above, this one line was typed out many times so it's justified.
#define isMMI(x) istype(x, /obj/item/device/mmi)

// Chat-related.
#define to_chat(target, message)	target << message
#define to_world(message)			to_chat(world, message)

#define SPAN(class, text)		"<span class='[class]'>[text]</span>"
#define SPAN_INFO(text)			SPAN("info", text)
#define SPAN_INFO_B(text)		SPAN_INFO("<B>[text]</B>")
#define SPAN_NOTICE(text)		SPAN("notice", text)
#define SPAN_WARNING(text)		SPAN("warning", text)
#define SPAN_DANGER(text)		SPAN("danger", text)
#define SPAN_ALIUM(text)		SPAN("alium", text)
#define SPAN_RADIOACTIVE(text)	SPAN_ALIUM("<B>[text]</B>")
#define SPAN_ALERT(text)		SPAN("alert", text)
#define SPAN_ERROR(text)		SPAN("error", text)
#define SPAN_DISARM(text)		SPAN("disarm", text)
#define SPAN_CAUTION(text)		SPAN("caution", text)
#define SPAN_MODERATE(text)		SPAN("moderate", text)

// GC/qdel.
#define qdel_null(x) if(x) { qdel(x); x = null }

// List-related macro that has to be here because it's used in __HELPERS.
#define SUBTYPESOF(prototype) (typesof(prototype) - prototype)

// Bitflags.
#define BITFLAG(X) (1 << X)