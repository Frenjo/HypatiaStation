//A 'wound' system for space suits.
//Breaches greatly increase the amount of lost gas and decrease the armour rating of the suit.
//They can be healed with plastic or metal sheeting.

/datum/breach
	var/class = 0							// Size. Lower is smaller.
	var/descriptor							// 'gaping hole' etc.
	var/damtype = BURN						// Punctured or melted
	var/obj/item/clothing/suit/space/holder	// Suit containing the list of breaches holding this instance.

/obj/item/clothing/suit/space
	var/can_breach = 1						// Set to 0 to disregard all breaching.
	var/list/datum/breach/breaches = list()	// Breach datum container.
	var/resilience = 0.2					// Multiplier that turns damage into breach class. 1 is 100% of damage to breach, 0.1 is 10%.
	var/breach_threshold = 3				// Min damage before a breach is possible.
	var/damage = 0							// Current total damage
	var/brute_damage = 0					// Specifically brute damage.
	var/burn_damage = 0						// Specifically burn damage.
	var/base_name							// Used to keep the original name safe while we apply modifiers.

/obj/item/clothing/suit/space/initialise()
	. = ..()
	base_name = "[name]"

//Some simple descriptors for breaches. Global because lazy, TODO: work out a better way to do this.
GLOBAL_GLOBL_LIST_INIT(breach_brute_descriptors, list(
	"tiny puncture",
	"ragged tear",
	"large split",
	"huge tear",
	"gaping wound"
))

GLOBAL_GLOBL_LIST_INIT(breach_burn_descriptors, list(
	"small burn",
	"melted patch",
	"sizable burn",
	"large scorched area",
	"huge scorched area"
))

/datum/breach/proc/update_descriptor()
	//Sanity...
	class = max(1, min(class, 5))
	//Apply the correct descriptor.
	if(damtype == BURN)
		descriptor = GLOBL.breach_burn_descriptors[class]
	else if(damtype == BRUTE)
		descriptor = GLOBL.breach_brute_descriptors[class]

//Repair a certain amount of brute or burn damage to the suit.
/obj/item/clothing/suit/space/proc/repair_breaches(damtype, amount, mob/user)
	if(!can_breach || !length(breaches) || !damage)
		to_chat(user, "There are no breaches to repair on \the [src].")
		return

	var/list/datum/breach/valid_breaches = list()

	for_no_type_check(var/datum/breach/B, breaches)
		if(B.damtype == damtype)
			valid_breaches.Add(B)

	if(!length(valid_breaches))
		to_chat(user, "There are no breaches to repair on \the [src].")
		return

	var/amount_left = amount
	for_no_type_check(var/datum/breach/B, valid_breaches)
		if(!amount_left)
			break

		if(B.class <= amount_left)
			amount_left -= B.class
			valid_breaches.Remove(B)
			breaches.Remove(B)
		else
			B.class	-= amount_left
			amount_left = 0
			B.update_descriptor()

	user.visible_message("<b>[user]</b> patches some of the damage on \the [src].")
	calc_breach_damage()

/obj/item/clothing/suit/space/proc/create_breaches(damtype, amount)
	if(!can_breach || !amount)
		return

	LAZYINITLIST(breaches)

	if(damage > 25)
		return //We don't need to keep tracking it when it's at 250% pressure loss, really.

	if(!loc)
		return
	var/turf/T = GET_TURF(src)
	if(isnull(T))
		return

	amount = amount * src.resilience

	//Increase existing breaches.
	for_no_type_check(var/datum/breach/existing, breaches)
		if(existing.damtype != damtype)
			continue

		if(existing.class < 5)
			var/needs = 5 - existing.class
			if(amount < needs)
				existing.class += amount
				amount = 0
			else
				existing.class = 5
				amount -= needs

			if(existing.damtype == BRUTE)
				T.visible_message(SPAN_WARNING("\The [existing.descriptor] on [src] gapes wider!"))
			else if(existing.damtype == BURN)
				T.visible_message(SPAN_WARNING("\The [existing.descriptor] on [src] widens!"))

	if(amount)
		//Spawn a new breach.
		var/datum/breach/B = new /datum/breach()
		breaches.Add(B)

		B.class = min(amount, 5)

		B.damtype = damtype
		B.update_descriptor()
		B.holder = src

		if(B.damtype == BRUTE)
			T.visible_message(SPAN_WARNING("\A [B.descriptor] opens up on [src]!"))
		else if(B.damtype == BURN)
			T.visible_message(SPAN_WARNING("\A [B.descriptor] marks the surface of [src]!"))

	calc_breach_damage()

//Calculates the current extent of the damage to the suit.
/obj/item/clothing/suit/space/proc/calc_breach_damage()
	damage = 0
	brute_damage = 0
	burn_damage = 0

	if(!can_breach || !length(breaches))
		name = base_name
		return 0

	for_no_type_check(var/datum/breach/B, breaches)
		if(!B.class)
			src.breaches.Remove(B)
			qdel(B)
		else
			damage += B.class
			if(B.damtype == BRUTE)
				brute_damage += B.class
			else if(B.damtype == BURN)
				burn_damage += B.class

	if(damage >= 3)
		if(brute_damage >= 3 && brute_damage > burn_damage)
			name = "punctured [base_name]"
		else if(burn_damage >= 3 && burn_damage > brute_damage)
			name = "scorched [base_name]"
		else
			name = "damaged [base_name]"
	else
		name = "[base_name]"

	return damage

//Handles repairs (and also upgrades).
/obj/item/clothing/suit/space/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/sheet/plastic) || istype(W, /obj/item/stack/sheet/steel))
		if(isliving(src.loc))
			to_chat(user, SPAN_WARNING("How do you intend to patch a hardsuit while someone is wearing it?"))
			return

		if(!damage || !burn_damage)
			to_chat(user, "There is no surface damage on \the [src] to repair.")
			return

		var/obj/item/stack/sheet/P = W
		if(P.amount < 3)
			P.use(P.amount)
			repair_breaches(BURN, (istype(P, /obj/item/stack/sheet/plastic) ? P.amount : (P.amount * 2)), user)
		else
			P.use(3)
			repair_breaches(BURN, (istype(P, /obj/item/stack/sheet/plastic) ? 3 : 5), user)
		return

	else if(iswelder(W))
		if(isliving(src.loc))
			to_chat(user, SPAN_WARNING("How do you intend to patch a hardsuit while someone is wearing it?"))
			return

		if(!damage || ! brute_damage)
			to_chat(user, "There is no structural damage on \the [src] to repair.")
			return

		var/obj/item/weldingtool/WT = W
		if(!WT.remove_fuel(5))
			to_chat(user, SPAN_WARNING("You need more welding fuel to repair this suit."))
			return

		repair_breaches(BRUTE, 3, user)
		return
	..()

/obj/item/clothing/suit/space/examine()
	..()
	if(can_breach && length(breaches))
		for_no_type_check(var/datum/breach/B, breaches)
			to_chat(usr, SPAN_DANGER("It has \a [B.descriptor]."))