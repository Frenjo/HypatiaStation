/obj/mecha/combat
	force = 30

	damage_resistance = list("brute" = 30, "fire" = 0, "bullet" = 30, "laser" = 15, "energy" = 0, "bomb" = 20)

	maint_access = FALSE

	var/melee_cooldown = 1 SECOND
	var/melee_can_hit = TRUE
	var/list/destroyable_obj = list(/obj/mecha, /obj/structure/window, /obj/structure/grille, /turf/closed/wall)
	var/am = "d3c2fbcadca903a41161ccc9df9cf948"

	// Zoom function.
	var/zoom_capable = FALSE
	var/zoom_mode = FALSE
	var/zoom_sound = 'sound/mecha/voice/image_enh.ogg'
	var/zoom_sound_volume = 50

	// Defence mode function.
	var/defence_mode_capable = FALSE
	var/defence_mode = FALSE
	var/defence_mode_deflect = 35

/obj/mecha/combat/New()
	. = ..()
	if(!zoom_capable)
		verbs.Remove(/obj/mecha/combat/verb/toggle_zoom_mode)
	if(!defence_mode_capable)
		verbs.Remove(/obj/mecha/combat/verb/toggle_defence_mode)

/*
/obj/mecha/combat/range_action(atom/target)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		target = pick(view(3, target))
	if(selected_weapon)
		selected_weapon.fire(target)
	return
*/

/obj/mecha/combat/melee_action(atom/target)
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		target = safepick(oview(1, src))
	if(!melee_can_hit || !isatom(target))
		return

	if(isliving(target))
		var/mob/living/M = target
		if(occupant.a_intent == "hurt")
			playsound(src, 'sound/weapons/melee/punch4.ogg', 50, 1)
			if(damtype == "brute")
				step_away(M, src, 15)
			/*
			if(M.stat>1)
				M.gib()
				melee_can_hit = 0
				if(do_after(melee_cooldown))
					melee_can_hit = 1
				return
			*/
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
	//			if (M.health <= 0) return

				var/datum/organ/external/temp = H.get_organ(pick("chest", "chest", "chest", "head"))
				if(temp)
					var/update = 0
					switch(damtype)
						if("brute")
							H.Paralyse(1)
							update |= temp.take_damage(rand(force / 2, force), 0)
						if("fire")
							update |= temp.take_damage(0, rand(force / 2, force))
						if("tox")
							if(H.reagents)
								if(H.reagents.get_reagent_amount("carpotoxin") + force < force * 2)
									H.reagents.add_reagent("carpotoxin", force)
								if(H.reagents.get_reagent_amount("cryptobiolin") + force < force * 2)
									H.reagents.add_reagent("cryptobiolin", force)
						else
							return
					if(update)
						H.UpdateDamageIcon()
				H.updatehealth()

			else
				switch(damtype)
					if("brute")
						M.Paralyse(1)
						M.take_overall_damage(rand(force / 2, force))
					if("fire")
						M.take_overall_damage(0, rand(force / 2, force))
					if("tox")
						if(M.reagents)
							if(M.reagents.get_reagent_amount("carpotoxin") + force < force * 2)
								M.reagents.add_reagent("carpotoxin", force)
							if(M.reagents.get_reagent_amount("cryptobiolin") + force < force * 2)
								M.reagents.add_reagent("cryptobiolin", force)
					else
						return
				M.updatehealth()
			occupant_message(SPAN_DANGER("You hit [target]."))
			visible_message(SPAN_DANGER("[name] hits [target]!"))
		else
			step_away(M, src)
			occupant_message(SPAN_INFO("You push [target] out of the way."))
			visible_message(SPAN_INFO("\The [src] pushes [target] out of the way."))

		melee_can_hit = FALSE
		if(do_after(occupant, melee_cooldown, progress = FALSE))
			melee_can_hit = TRUE
		return

	else
		if(damtype == "brute")
			for(var/target_type in destroyable_obj)
				if(istype(target, target_type) && hascall(target, "attackby"))
					occupant_message(SPAN_DANGER("You hit [target]."))
					visible_message(SPAN_DANGER("[name] hits [target]!"))
					if(!istype(target, /turf/closed/wall))
						target:attackby(src, occupant)
					else if(prob(5))
						target:dismantle_wall(1)
						occupant_message(SPAN_INFO_B("You smash through the wall."))
						visible_message(SPAN_INFO_B("[name] smashes through the wall!"))
						playsound(src, 'sound/weapons/melee/smash.ogg', 50, 1)
					melee_can_hit = FALSE
					if(do_after(occupant, melee_cooldown, progress = FALSE))
						melee_can_hit = TRUE
					break
	return

/*
/obj/mecha/combat/proc/mega_shake(target)
	if(!isobj(target) && !ismob(target)) return
	if(ismob(target))
		var/mob/M = target
		M.make_dizzy(3)
		M.adjustBruteLoss(1)
		M.updatehealth()
		for (var/mob/V in viewers(src))
			V.show_message("[name] shakes [M] like a rag doll.")
	return
*/

/*
	if(energy>0 && can_move)
		if(step(src,direction))
			can_move = 0
			spawn(step_in) can_move = 1
			if(overload)
				energy = energy-2
				health--
			else
				energy--
			return 1

	return 0
*/
/*
/obj/mecha/combat/hear_talk(mob/M, text)
	..()
	if(am && M==occupant)
		if(findtext(text,""))
			sam()
	return

/obj/mecha/combat/proc/sam()
	if(am)
		var/window = {"<html>
							<head>
							<style>
							body {background:#000;color: #00ff00;font-family:"Courier",monospace;font-size:12px;}
							#target {word-wrap: break-word;width:100%;padding-right:2px;}
							#form {display:none;padding:0;margin:0;}
							#input {background:#000;color: #00ff00;font-family:"Courier",monospace;border:none;padding:0;margin:0;width:90%;font-size:12px;}
							</style>
							<script type="text/javascript">
							var text = "SGNL RCVD\\nTAG ANL :: STTS ACCPTD \\nINITSOC{buff:{128,0,NIL};p:'-zxf';stddev;inenc:'bin';outenc:'plain'}\\nSOD ->\\n0010101100101011001000000101010001101000011010010111001100100000011011010110000101100011011010000110100101101110011001010010000001101001011100110010000001100100011010010111001101100011011010000110000101110010011001110110010101100100001000000110100101101110011101000110111100100000011110010110111101110101011100100010000001100011011000010111001001100101001000000010101100101011000011010000101000101011001010110010000001000110011010010110011101101000011101000010000001110111011010010111010001101000001000000111010001101000011010010111001100100000011011010110000101100011011010000110100101101110011001010010110000100000011000010110111001100100001000000110011101110101011000010111001001100100001000000110100101110100001000000110011001110010011011110110110100100000011101000110100001100101001000000111001101101000011000010110110101100101001000000110111101100110001000000110010001100101011001100110010101100001011101000010000000101011001010110000110100001010001010110010101100100000010100110110010101110010011101100110010100100000011101000110100001101001011100110010000001101101011000010110001101101000011010010110111001100101001011000010000001100001011100110010000001111001011011110111010100100000011101110110111101110101011011000110010000100000011010000110000101110110011001010010000001100110011010010110011101101000011101000010000001101001011101000010000001100110011011110111001000100000011110010110111101110101001000000010101100101011\\n<- EOD\\nSOCFLUSH\\n";
							var target_id = "target";
							var form_id = "form";
							var input_id = "input";
							var delay=5;
							var currentChar=0;
							var inter;
							var cur_el;
							var maiden_el;

							function type()
							{
							  maiden_el = cur_el = document.getElementById(target_id);
							  if(cur_el && typeof(cur_el)!='undefined'){
									inter = setInterval(function(){appendText(cur_el)},delay);
							  }
							}

							function appendText(el){
								if(currentChar>text.length){
									maiden_el.style.border = 'none';
									clearInterval(inter);
									var form = document.getElementById(form_id);
									var input = document.getElementById(input_id);
									if((form && typeof(form)!='undefined') && (input && typeof(input)!='undefined')){
										form.style.display = 'block';
										input.focus();
									}
									return;
								}
								var tchar = text.substr(currentChar, 1);
								if(tchar=='\\n'){
									el = cur_el = document.createElement('div');
									maiden_el.appendChild(cur_el);
									currentChar++;
									return;
								}
								if(!el.firstChild){
									var tNode=document.createTextNode(tchar);
									el.appendChild(tNode);
								}
								else {
									el.firstChild.nodeValue = el.firstChild.nodeValue+tchar
								}
								currentChar++;
							}

							function addSubmitEvent(form, input) {
							    input.onkeydown = function(e) {
							        e = e || window.event;
							        if (e.keyCode == 13) {
							            form.submit();
							            return false;
							        }
							    };
							}

							window.onload = function(){
								var form = document.getElementById(form_id);
								var input = document.getElementById(input_id);
								if((!form || typeof(form)=='undefined') || (!input || typeof(input)=='undefined')){
									return false;
								}
								addSubmitEvent(form,input);
								type();
							}
							</script>
							</head>
							<body>
							<div id="wrapper"><div id="target"></div>
							<form id="form" name="form" action="byond://" method="get">
							<label for="input">&gt;</label><input name="saminput" type="text" id="input" value="" />
							<input type=\"hidden\" name=\"src\" value=\"\ref[src]\">
							</form>
							</div>
							</body>
							</html>
						  "}
		SHOW_BROWSER(occupant, window, "window=sam;size=800x600;")
		onclose(occupant, "sam", src)
	return
*/
// This will always be a /mob/living/carbon/human UNLESS it's a Swarmer entering an Eidolon.
/obj/mecha/combat/moved_inside(mob/living/pilot)
	. = ..()
	if(!.)
		return FALSE

	if(isnotnull(pilot.client))
		pilot.client.mouse_pointer_icon = file("icons/obj/mecha/mecha_mouse.dmi")

/obj/mecha/combat/mmi_moved_inside(obj/item/mmi/mmi_as_oc, mob/user)
	. = ..()
	if(!.)
		return FALSE

	if(isnotnull(occupant.client))
		occupant.client.mouse_pointer_icon = file("icons/obj/mecha/mecha_mouse.dmi")

/obj/mecha/combat/go_out()
	if(isnotnull(occupant?.client))
		occupant.client.mouse_pointer_icon = initial(occupant.client.mouse_pointer_icon)
		occupant.client.view = world.view
		zoom_mode = FALSE
	. = ..()

/obj/mecha/combat/Topic(href, href_list)
	. = ..()
	var/datum/topic_input/topic_filter = new /datum/topic_input(href, href_list)
	if(topic_filter.get("close"))
		am = null
		return
	if(topic_filter.get("zoom"))
		toggle_zoom_mode()
		return
	if(topic_filter.get("defence_mode"))
		toggle_defence_mode()
		return
	/*
	if(filter.get("saminput"))
		if(md5(filter.get("saminput")) == am)
			occupant_message("From the lies of the Antipath, Circuit preserve us.")
		am = null
	return
	*/

/obj/mecha/combat/relaymove(mob/user, direction)
	if(zoom_mode)
		if(COOLDOWN_FINISHED(src, cooldown_mecha_message))
			occupant_message(SPAN_WARNING("Unable to move while in zoom mode."))
			COOLDOWN_START(src, cooldown_mecha_message, MECHA_MESSAGE_COOLDOWN)
		return FALSE
	if(defence_mode)
		if(COOLDOWN_FINISHED(src, cooldown_mecha_message))
			occupant_message(SPAN_WARNING("Unable to move while in defence mode."))
			COOLDOWN_START(src, cooldown_mecha_message, MECHA_MESSAGE_COOLDOWN)
		return FALSE
	return ..()

/obj/mecha/combat/verb/toggle_zoom_mode()
	set category = "Exosuit Interface"
	set name = "Toggle Zoom Mode"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return
	if(isnull(occupant?.client))
		return

	zoom_mode = !zoom_mode
	balloon_alert(occupant, "[zoom_mode ? "en" : "dis"]abled zoom mode")
	send_byjax(occupant, "exosuit.browser", "zoom_command", "[zoom_mode ? "Dis" : "En"]able Zoom Mode")
	log_message("Toggled zoom mode.")
	if(zoom_mode)
		occupant.client.view = 12
		SOUND_TO(occupant, sound(zoom_sound, volume = zoom_sound_volume))
	else
		occupant.client.view = world.view//world.view - default mob view size

/obj/mecha/combat/verb/toggle_defence_mode()
	set category = "Exosuit Interface"
	set name = "Toggle Defence Mode"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	defence_mode = !defence_mode
	if(defence_mode)
		deflect_chance = defence_mode_deflect
	else
		deflect_chance = initial(deflect_chance)
	balloon_alert(occupant, "[defence_mode ? "en" : "dis"]abled defence mode")
	send_byjax(occupant, "exosuit.browser", "defence_mode_command", "[defence_mode ? "Dis" : "En"]able Defence Mode")
	log_message("Toggled defence mode.")