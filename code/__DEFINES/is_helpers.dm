/*
 * Mob Helpers
 *
 * Fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
 */
//#define ismob(X)		istype(X, /mob) // Built-in.
#define isliving(X)		istype(X, /mob/living)
#define isobserver(X)	istype(X, /mob/dead/observer)
#define isnewplayer(X)	istype(X, /mob/new_player)

// Carbon.
#define iscarbon(X)		istype(X, /mob/living/carbon)
#define ishuman(X)		istype(X, /mob/living/carbon/human)
#define ismonkey(X)		istype(X, /mob/living/carbon/monkey)
#define isbrain(X)		istype(X, /mob/living/carbon/brain)
#define isalien(X)		istype(X, /mob/living/carbon/alien)
#define islarva(X)		istype(X, /mob/living/carbon/alien/larva)
#define isslime(X)		istype(X, /mob/living/carbon/slime)
#define isslimeadult(X)	istype(X, /mob/living/carbon/slime/adult)

// Silicon.
#define issilicon(X)	istype(X, /mob/living/silicon)
#define isAI(X)			istype(X, /mob/living/silicon/ai)
#define ispAI(X)		istype(X, /mob/living/silicon/pai)
#define isrobot(X)		istype(X, /mob/living/silicon/robot)
#define isdrone(X)		istype(X, /mob/living/silicon/robot/drone)

// Simple Animal.
#define isanimal(X)		istype(X, /mob/living/simple_animal)
#define iscorgi(X)		istype(X, /mob/living/simple_animal/corgi)
#define iscrab(X)		istype(X, /mob/living/simple_animal/crab)
#define iscat(X)		istype(X, /mob/living/simple_animal/cat)
#define ismouse(X)		istype(X, /mob/living/simple_animal/mouse)
#define isbear(X)		istype(X, /mob/living/simple_animal/hostile/bear)
#define iscarp(X)		istype(X, /mob/living/simple_animal/hostile/carp)
#define isclown(X)		istype(X, /mob/living/simple_animal/hostile/retaliate/clown)

/*
 * Object Helpers
 *
 * Fun if you want to typecast objects without writing long path-filled lines.
 */
//#define isobj(X)	istype(X, /obj) // Built-in.
#define isitem(X)	istype(X, /obj/item)

#define isradio(X)	istype(X, /obj/item/device/radio)

// This one line was typed out almost 30+ times so it justifies an entry here.
#define isrune(X) istype(X, /obj/effect/rune)

// Same as above, this one line was typed out many times so it's justified.
#define isMMI(X) istype(X, /obj/item/device/mmi)

/*
 * Turf Helpers
 *
 * Fun if you want to typecast turfs without writing long path-filled lines.
 */
//#define isturf(X)		istype(X, /turf) // Built-in.
#define isspace(X)		istype(X, /turf/space)
#define isopenspace(X)	istype(X, /turf/simulated/floor/open)

/*
 * Miscellaneous Helpers
*/
#define hasorgans(X)	ishuman(X)
#define isorgan(X)		istype(X, /datum/organ/external)