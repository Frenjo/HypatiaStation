/obj/mecha/attack_hand(mob/user)
	log_message("Attack by hand/paw. Attacker - [user].", 1)

	if(isliving(user))
		var/mob/living/L = user
		var/did_shock = FALSE
		for(var/obj/item/mecha_equipment/melee_defence_shocker/shocker in equipment)
			if(shocker.attack_react(L))
				did_shock = TRUE
				break
		if(did_shock)
			return

	var/deflection_chance = deflect_chance
	var/damage_coefficient = 1
	for(var/obj/item/mecha_equipment/melee_armour_booster/booster in equipment)
		if(booster.attack_react(user))
			deflection_chance *= booster.deflect_coeff
			damage_coefficient *= booster.damage_coeff
			break

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(user))
			if(!prob(deflection_chance))
				take_damage(round(15 * damage_coefficient))
				check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
				playsound(src, 'sound/weapons/melee/slash.ogg', 50, 1, -1)
				user.visible_message(
					SPAN_WARNING("\The [user] slashes at \the [src]'s armour!"),
					SPAN_WARNING("You slash at the armoured suit!")
				)
			else
				log_append_to_last("Armour saved.")
				playsound(src, 'sound/weapons/melee/slash.ogg', 50, 1, -1)
				user.visible_message(
					SPAN_INFO("\The [user] rebounds off of \the [src]'s armour!"),
					SPAN_ALIUM("Your claws have no effect on \the [src]!")
				)
				occupant_message(SPAN_INFO("\The [user]'s claws are stopped by the armour."))
		else
			user.visible_message(
				SPAN_DANGER("[user] hits \the [src]. Nothing happens."),
				SPAN_DANGER("You hit \the [src] with no visible effect.")
			)
			log_append_to_last("Armour saved.")
		return
	else if((MUTATION_HULK in user.mutations) && !prob(deflection_chance))
		take_damage(round(15 * damage_coefficient))
		check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
		user.visible_message(
			SPAN_DANGER("[user] hits \the [src], doing some damage."),
			SPAN_DANGER("You hit \the [src] with all your might. The metal creaks and bends."),
			SPAN_WARNING("You hear metal creaking and bending.")
		)
	else
		user.visible_message(
			SPAN_DANGER("[user] hits \the [src]. Nothing happens."),
			SPAN_DANGER("You hit \the [src] with no visible effect.")
		)
		log_append_to_last("Armour saved.")

/obj/mecha/attack_animal(mob/living/user)
	return attack_hand(user)

/obj/mecha/attack_animal(mob/living/simple/user)
	log_message("Attack by simple animal. Attacker - [user].", 1)

	var/deflection_chance = deflect_chance
	var/damage_coefficient = 1
	for(var/obj/item/mecha_equipment/melee_armour_booster/booster in equipment)
		if(booster.attack_react(user))
			deflection_chance *= booster.deflect_coeff
			damage_coefficient *= booster.damage_coeff
			break

	if(user.melee_damage_upper == 0)
		user.emote("[user.friendly] [src]")
	else
		if(!prob(deflection_chance))
			var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
			take_damage(round(damage * damage_coefficient))
			check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
			visible_message("\red <B>[user]</B> [user.attacktext] [src]!")
			user.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [name]</font>"
		else
			log_append_to_last("Armour saved.")
			playsound(src, 'sound/weapons/melee/slash.ogg', 50, 1, -1)
			user.visible_message(
				SPAN_WARNING("\The [user] rebounds off of \the [src]'s armour!"),
				SPAN_WARNING("You rebound off of \the [src]'s armour!")
			)
			occupant_message(SPAN_INFO("The [user]'s attack is stopped by the armour."))
			user.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [name]</font>"

//////////////////////
////// AttackBy //////
//////////////////////
/obj/mecha/attack_tool(obj/item/tool, mob/user)
	if(isliving(user)) // This needs to be moved to a future pre_attack() proc.
		var/mob/living/L = user
		var/did_shock = FALSE
		for(var/obj/item/mecha_equipment/melee_defence_shocker/shocker in equipment)
			if(shocker.attack_react(L))
				did_shock = TRUE
				break
		if(did_shock)
			return TRUE

	if(iswrench(tool))
		if(state == 1)
			state = 2
			to_chat(user, SPAN_NOTICE("You undo the securing bolts on \the [src]."))
		else if(state == 2)
			state = 1
			to_chat(user, SPAN_NOTICE("You tighten the securing bolts on \the [src]."))
		return TRUE

	if(iscrowbar(tool))
		if(state == 2)
			state = 3
			to_chat(user, SPAN_NOTICE("You open the hatch to \the [src]'s power unit."))
		else if(state == 3)
			state = 2
			to_chat(user, SPAN_NOTICE("You close the hatch to \the [src]'s power unit."))
		return TRUE

	if(iscable(tool))
		if(state == 3 && internal_damage & MECHA_INT_SHORT_CIRCUIT)
			var/obj/item/stack/cable_coil/cable = tool
			if(cable.amount > 1)
				cable.use(2)
				clear_internal_damage(MECHA_INT_SHORT_CIRCUIT)
				to_chat(user, SPAN_NOTICE("You replace \the [src]'s fused wires."))
			else
				to_chat(user, SPAN_WARNING("There's not enough wire to finish the task!"))
		return TRUE

	if(isscrewdriver(tool))
		if(internal_damage & MECHA_INT_TEMP_CONTROL)
			clear_internal_damage(MECHA_INT_TEMP_CONTROL)
			to_chat(user, SPAN_NOTICE("You repair \the [src]'s damaged temperature controller."))
		else if(isnotnull(cell))
			if(state == 3)
				cell.forceMove(loc)
				cell = null
				state = 4
				to_chat(user, SPAN_NOTICE("You unscrew and pry out \the [src]'s power cell."))
				log_message("Powercell removed")
			else if(state == 4)
				state = 3
				to_chat(user, SPAN_NOTICE("You screw \the [src]'s power cell into place."))
		return TRUE

	if(iswelder(tool) && user.a_intent != "hurt")
		var/obj/item/weldingtool/welder = tool
		if(!welder.remove_fuel(0, user))
			FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
			return TRUE
		if(internal_damage & MECHA_INT_TANK_BREACH)
			clear_internal_damage(MECHA_INT_TANK_BREACH)
			to_chat(user, SPAN_NOTICE("You repair \the [src]'s damaged gas tank."))
			return TRUE
		if(health < initial(health))
			to_chat(user, SPAN_NOTICE("You repair some damage on \the [src]."))
			health += min(10, initial(health) - health)
		else
			to_chat(user, SPAN_NOTICE("\The [src] is at full integrity."))
		return TRUE

	return ..()

/obj/mecha/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/mmi)) // This should also cover /obj/item/mmi/posibrain.
		var/obj/item/mmi/brain = I
		if(mmi_move_inside(brain, user))
			to_chat(user, SPAN_INFO("[src]-MMI interface initialised sucessfully."))
		else
			to_chat(user, SPAN_WARNING("[src]-MMI interface initialisation failed."))
		return TRUE

	if(istype(I, /obj/item/card/id) || istype(I, /obj/item/pda))
		if(add_req_access || maint_access)
			if(internals_access_allowed(usr))
				var/obj/item/card/id/id_card
				if(istype(I, /obj/item/card/id))
					id_card = I
				else
					var/obj/item/pda/pda = I
					id_card = pda.id
				output_maintenance_dialog(id_card, user)
				return TRUE
			else
				to_chat(user, SPAN_WARNING("Invalid ID: Access denied."))
		else
			to_chat(user, SPAN_WARNING("Maintenance protocols disabled by operator."))
		return TRUE

	if(istype(I, /obj/item/cell))
		if(state == 4)
			if(isnull(cell))
				to_chat(user, SPAN_NOTICE("You install \the [I] into \the [src]."))
				user.drop_item()
				I.forceMove(src)
				cell = I
				log_message("Powercell installed")
			else
				to_chat(user, SPAN_WARNING("There's already a power cell installed in \the [src]."))
		return TRUE

	if(istype(I, /obj/item/mecha_equipment))
		var/obj/item/mecha_equipment/E = I
		if(E.can_attach(src))
			user.drop_item()
			E.attach(src)
			user.visible_message(
				SPAN_INFO("[user] attaches \the [I] to \the [src]."),
				SPAN_INFO("You attach \the [I] to \the [src]."),
				SPAN_INFO("You hear a clunk.")
			)
		else
			to_chat(user, SPAN_WARNING("You were unable to attach \the [I] to \the [src]."))
		return TRUE

	if(istype(I, /obj/item/mecha_part/tracking))
		user.drop_from_inventory(I)
		I.forceMove(src)
		user.visible_message(
			SPAN_INFO("[user] attaches \the [I] to \the [src]."),
			SPAN_INFO("You attach \the [I] to \the [src]."),
			SPAN_INFO("You hear a click.")
		)
		return TRUE

	return ..()

/obj/mecha/attackby(obj/item/W, mob/user)
	if(!HAS_ITEM_FLAGS(W, ITEM_FLAG_NO_BLUDGEON))
		log_message("Attacked by [W]. Attacker - [user]")
		var/deflection_chance = deflect_chance
		var/damage_coefficient = 1
		for(var/obj/item/mecha_equipment/melee_armour_booster/booster in equipment)
			if(booster.attack_react(user))
				deflection_chance *= booster.deflect_coeff
				damage_coefficient *= booster.damage_coeff
				break

		if(prob(deflection_chance))
			user.visible_message(
				SPAN_WARNING("\The [W] bounces off of \the [src]'s armour."),
				SPAN_WARNING("\The [W] bounces off of \the [src].")
			)
			log_append_to_last("Armour saved.")
		else
			user.visible_message(
				SPAN_DANGER("[user] hits \the [src] with \the [W]."),
				SPAN_DANGER("You hit \the [src] with \the [W].")
			)
			take_damage(round(W.force * damage_coefficient), W.damtype)
			check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))

/*
/obj/mecha/attack_ai(var/mob/living/silicon/ai/user)
	if(!isAI(user))
		return
	var/output = {"<b>Assume direct control over [src]?</b>
						<a href='byond://?src=\ref[src];ai_take_control=\ref[user];duration=3000'>Yes</a><br>
						"}
	user << browse(output, "window=mecha_attack_ai")
*/