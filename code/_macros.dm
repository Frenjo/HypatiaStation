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
#define isHuman(A) istype(A, /mob/living/carbon/human)

#define isMonkey(A) istype(A, /mob/living/carbon/monkey)

#define isBrain(A) istype(A, /mob/living/carbon/brain)

#define isAlien(A) istype(A, /mob/living/carbon/alien)

#define isLarva(A) istype(A, /mob/living/carbon/alien/larva)

#define isSlime(A) istype(A, /mob/living/carbon/slime)

#define isSlimeAdult(A) istype(A, /mob/living/carbon/slime/adult)

#define isRobot(A) istype(A, /mob/living/silicon/robot)

#define isAnimal(A) istype(A, /mob/living/simple_animal)

#define isCorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define isCrab(A) istype(A, /mob/living/simple_animal/crab)

#define isCat(A) istype(A, /mob/living/simple_animal/cat)

#define isMouse(A) istype(A, /mob/living/simple_animal/mouse)

#define isBear(A) istype(A, /mob/living/simple_animal/hostile/bear)

#define isCarp(A) istype(A, /mob/living/simple_animal/hostile/carp)

#define isClown(A) istype(A, /mob/living/simple_animal/hostile/retaliate/clown)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define isPAI(A) istype(A, /mob/living/silicon/pai)

#define isCarbon(A) istype(A, /mob/living/carbon)

#define isSilicon(A) istype(A, /mob/living/silicon)

#define isLiving(A) istype(A, /mob/living)

#define isObserver(A) istype(A, /mob/dead/observer)

#define isOrgan(A) istype(A, /datum/organ/external)

#define hasOrgans(A) isHuman(A)

// Chat-related stuff
#define to_chat(target, message) target << message
#define span(class, text) ("<span class='[class]'>[text]</span>")

// GC/qdel stuff
#define qdel_null(x) if(x) { qdel(x) ; x = null }