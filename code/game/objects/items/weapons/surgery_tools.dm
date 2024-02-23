/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 *		Bone Gel
 *		FixOVein
 *		Bone Setter
 */

/*
 * Retractor
 */
/obj/item/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	matter_amounts = list(MATERIAL_METAL = 10000, MATERIAL_GLASS = 5000)
	obj_flags = OBJ_FLAG_CONDUCT
	w_class = 2.0
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_BIOTECH = 1)

/*
 * Hemostat
 */
/obj/item/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	matter_amounts = list(MATERIAL_METAL = 5000, MATERIAL_GLASS = 2500)
	obj_flags = OBJ_FLAG_CONDUCT
	w_class = 2.0
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_BIOTECH = 1)
	attack_verb = list("attacked", "pinched")

/*
 * Cautery
 */
/obj/item/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	matter_amounts = list(MATERIAL_METAL = 5000, MATERIAL_GLASS = 2500)
	obj_flags = OBJ_FLAG_CONDUCT
	w_class = 2.0
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_BIOTECH = 1)
	attack_verb = list("burnt")

/*
 * Surgical Drill
 */
/obj/item/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter_amounts = list(MATERIAL_METAL = 15000, MATERIAL_GLASS = 10000)
	obj_flags = OBJ_FLAG_CONDUCT
	force = 15.0
	w_class = 2.0
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_BIOTECH = 1)
	attack_verb = list("drilled")

/obj/item/surgicaldrill/suicide_act(mob/user)
	user.visible_message(pick( \
		SPAN_DANGER("[user] is pressing the [src.name] to \his temple and activating it! It looks like \he's trying to commit suicide."), \
		SPAN_DANGER("[user] is pressing [src.name] to \his chest and activating it! It looks like \he's trying to commit suicide.") \
		)
	)
	return (BRUTELOSS)

/*
 * Scalpel
 */
/obj/item/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 10.0
	sharp = 1
	edge = 1
	w_class = 2.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	matter_amounts = list(MATERIAL_METAL = 10000, MATERIAL_GLASS = 5000)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_BIOTECH = 1)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/scalpel/suicide_act(mob/user)
	user.visible_message(pick( \
		SPAN_DANGER("[user] is slitting \his wrists with the [src.name]! It looks like \he's trying to commit suicide.</b>"), \
		SPAN_DANGER("[user] is slitting \his throat with the [src.name]! It looks like \he's trying to commit suicide.</b>"), \
		SPAN_DANGER("[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.") \
		)
	)
	return (BRUTELOSS)

/*
 * Researchable Scalpels
 */
/obj/item/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"

/obj/item/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = 12.0

/obj/item/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = 15.0

/obj/item/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5

/*
 * Circular Saw
 */
/obj/item/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw3"
	hitsound = 'sound/weapons/circsawhit.ogg'
	obj_flags = OBJ_FLAG_CONDUCT
	force = 15.0
	w_class = 2.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	matter_amounts = list(MATERIAL_METAL = 20000, MATERIAL_GLASS = 10000)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_BIOTECH = 1)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = 1
	edge = 1


//misc, formerly from code/defines/weapons.dm
/*
 * Bone Gel
 */
/obj/item/bonegel
	name = "bone gel"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	force = 0
	w_class = 2.0
	throwforce = 1.0

/*
 * FixOVein
 */
/obj/item/FixOVein
	name = "FixOVein"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_BIOTECH = 3)
	w_class = 2.0

	var/usage_amount = 10

/*
 * Bone Setter
 */
/obj/item/bonesetter
	name = "bone setter"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = 2.0
	attack_verb = list("attacked", "hit", "bludgeoned")