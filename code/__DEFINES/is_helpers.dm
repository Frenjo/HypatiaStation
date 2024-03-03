/*
 * Atom Helpers
 *
 * Fun if you want to typecast atoms without writing long path-filled lines.
 */
#define isatom(X)		istype(X, /atom)
#define ismovable(X)	istype(X, /atom/movable)

/*
 * Client Helpers
 *
 * Fun if you want to typecast clients without writing long path-filled lines.
 */
#define isclient(X)	istype(X, /client)

/*
 * Datum Helpers
 *
 * Fun if you want to typecast datums without writing long path-filled lines.
 */
#define isdatum(X)	istype(X, /datum)

#define isorgan(X)	istype(X, /datum/organ/external)

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
#define isobj(X)	istype(X, /obj) // The built-in does not behave as expected.
#define ismecha(X)	istype(X, /obj/mecha)

#define isitem(X)	istype(X, /obj/item)
#define isradio(X)	istype(X, /obj/item/radio)
#define isMMI(X) istype(X, /obj/item/mmi)

#define isrune(X) istype(X, /obj/effect/rune)

/*
 * Turf Helpers
 *
 * Fun if you want to typecast turfs without writing long path-filled lines.
 */
//#define isturf(X)		istype(X, /turf) // This built-in has slightly different behaviour but as long as nobody instantiates /atom it'll be fine.
#define isspace(X)		istype(X, /turf/space)
#define issimulated(X)	istype(X, /turf/simulated)
#define isopenspace(X)	istype(X, /turf/simulated/floor/open)

/*
 * Miscellaneous Helpers
*/
#define hasorgans(X)	ishuman(X)