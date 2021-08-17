// Mob helpers
// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
#define ishuman(A)		istype(A, /mob/living/carbon/human)

#define ismonkey(A)		istype(A, /mob/living/carbon/monkey)

#define isbrain(A)		istype(A, /mob/living/carbon/brain)

#define isalien(A)		istype(A, /mob/living/carbon/alien)

#define islarva(A)		istype(A, /mob/living/carbon/alien/larva)

#define isslime(A)		istype(A, /mob/living/carbon/slime)

#define isslimeadult(A)	istype(A, /mob/living/carbon/slime/adult)

#define isrobot(A)		istype(A, /mob/living/silicon/robot)

#define isdrone(A)		istype(A, /mob/living/silicon/robot/drone)

#define isanimal(A)		istype(A, /mob/living/simple_animal)

#define iscorgi(A)		istype(A, /mob/living/simple_animal/corgi)

#define iscrab(A)		istype(A, /mob/living/simple_animal/crab)

#define iscat(A)		istype(A, /mob/living/simple_animal/cat)

#define ismouse(A)		istype(A, /mob/living/simple_animal/mouse)

#define isnear(A)		istype(A, /mob/living/simple_animal/hostile/bear)

#define iscarp(A)		istype(A, /mob/living/simple_animal/hostile/carp)

#define isclown(A)		istype(A, /mob/living/simple_animal/hostile/retaliate/clown)

#define isAI(A)			istype(A, /mob/living/silicon/ai)

#define ispAI(A)		istype(A, /mob/living/silicon/pai)

#define iscarbon(A)		istype(A, /mob/living/carbon)

#define issilicon(A)	istype(A, /mob/living/silicon)

#define isliving(A)		istype(A, /mob/living)

#define isobserver(A) 	istype(A, /mob/dead/observer)

#define isorgan(A)		istype(A, /datum/organ/external)

#define hasorgans(A)	ishuman(A)


// Chat-related stuff
#define to_chat(target, message)	target << message

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


// GC/qdel stuff
#define qdel_null(x) if(x) { qdel(x); x = null }