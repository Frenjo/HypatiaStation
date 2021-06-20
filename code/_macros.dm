// New lighting
#define CLAMP01(x) 			(Clamp(x, 0, 1))
#define CLAMP02(x, y, z) 	(x <= y ? y : (x >= z ? z : x))

#define FOR_DVIEW(type, range, center, invis_flags) \
	dview_mob.loc = center; \
	dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))
#define END_FOR_DVIEW dview_mob.loc = null

// XGM stuff
#define QUANTIZE(variable)      (round(variable, 0.0001))

// Mob helpers
// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
#define ishuman(A) istype(A, /mob/living/carbon/human)

#define ismonkey(A) istype(A, /mob/living/carbon/monkey)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define islarva(A) istype(A, /mob/living/carbon/alien/larva)

#define isslime(A) istype(A, /mob/living/carbon/slime)

#define isslimeadult(A) istype(A, /mob/living/carbon/slime/adult)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define isdrone(A) istype(A, /mob/living/silicon/robot/drone)

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define iscrab(A) istype(A, /mob/living/simple_animal/crab)

#define iscat(A) istype(A, /mob/living/simple_animal/cat)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)

#define isnear(A) istype(A, /mob/living/simple_animal/hostile/bear)

#define iscarp(A) istype(A, /mob/living/simple_animal/hostile/carp)

#define isclown(A) istype(A, /mob/living/simple_animal/hostile/retaliate/clown)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define iscarbon(A) istype(A, /mob/living/carbon)

#define issilicon(A) istype(A, /mob/living/silicon)

#define isliving(A) istype(A, /mob/living)

#define isobserver(A) istype(A, /mob/dead/observer)

#define isorgan(A) istype(A, /datum/organ/external)

#define hasorgans(A) ishuman(A)

// Chat-related stuff
#define to_chat(target, message) target << message
#define SPAN(class, text) "<span class='[class]'>[text]</span>"
#define SPAN_INFO(text) SPAN("info", text)
#define SPAN_NOTICE(text) SPAN("notice", text)
#define SPAN_WARNING(text) SPAN("warning", text)
#define SPAN_DANGER(text) SPAN("danger", text)
#define SPAN_ALERT(text) SPAN("alert", text)
#define SPAN_ERROR(text) SPAN("error", text)
#define SPAN_DISARM(text) SPAN("disarm", text)

// GC/qdel stuff
#define qdel_null(x) if(x) { qdel(x) ; x = null }