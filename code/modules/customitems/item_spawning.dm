//switch this out to use a database at some point
//list of ckey/ real_name and item paths
//gives item to specific people when they join if it can
//for multiple items just add mutliple entries, unless i change it to be a listlistlist
//yes, it has to be an item, you can't pick up nonitems

/proc/EquipCustomItems(mob/living/carbon/human/M)
	// load lines
	var/file = file2text("config/custom_items.txt")
	var/lines = splittext(file, "\n")

	for(var/line in lines)
		// split & clean up
		var/list/Entry = splittext(line, ":")
		for(var/i = 1 to Entry.len)
			Entry[i] = trim(Entry[i])

		if(Entry.len < 3)
			continue;

		if(Entry[1] == M.ckey && Entry[2] == M.real_name)
			var/list/Paths = splittext(Entry[3], ",")
			for(var/P in Paths)
				var/ok = 0  // 1 if the item was placed successfully
				P = trim(P)
				var/path = text2path(P)
				var/obj/item/Item = new path()
				if(istype(Item,/obj/item/card/id))
					//id card needs to replace the original ID
					if(M.ckey == "nerezza" && M.real_name == "Asher Spock" && M.mind.role_alt_title && M.mind.role_alt_title != "Emergency Physician")
						//only spawn ID if asher is joining as an emergency physician
						ok = 1
						qdel(Item)
						goto skip
					var/obj/item/card/id/I = Item
					for(var/obj/item/card/id/C in M)
						//default settings
						I.name = "[M.real_name]'s ID Card ([M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role])"
						I.registered_name = M.real_name
						I.access = C.access
						I.assignment = C.assignment
						I.blood_type = C.blood_type
						I.dna_hash = C.dna_hash
						I.fingerprint_hash = C.fingerprint_hash
						//I.pin = C.pin

						//custom stuff
						if(M.ckey == "fastler" && M.real_name == "Fastler Greay") //This is a Lifetime ID
							I.name = "[M.real_name]'s Lifetime ID Card ([M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role])"
						else if(M.ckey == "nerezza" && M.real_name == "Asher Spock") //This is an Odysseus Specialist ID
							I.name = "[M.real_name]'s Odysseus Specialist ID Card ([M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role])"
							I.access += list(ACCESS_ROBOTICS) //Station-based mecha pilots need this to access the recharge bay.
						else if(M.ckey == "roaper" && M.real_name == "Ian Colm") //This is a Technician ID
							I.name = "[M.real_name]'s Technician ID ([M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role])"

						//replace old ID
						qdel(C)
						ok = M.equip_if_possible(I, SLOT_ID_WEAR_ID, 0)	//if 1, last argument deletes on fail
						break
				else if(istype(Item,/obj/item/storage/belt))
					if(M.ckey == "jakksergal" && M.real_name == "Nashi Ra'hal" && M.mind.role_alt_title && M.mind.role_alt_title != "Nurse" && M.mind.role_alt_title != "Chemist")
						ok = 1
						qdel(Item)
						goto skip
					var/obj/item/storage/belt/medical/fluff/nashi_belt/I = Item
					if(istype(M.belt,/obj/item/storage/belt))
						for(var/obj/item/storage/belt/B in M)
							qdel(B)
							M.belt=null
						ok = M.equip_if_possible(I, SLOT_ID_BELT, 0)
						break
					if(istype(M.belt,/obj/item/device/pda))
						for(var/obj/item/device/pda/Pda in M)
							M.belt=null
							M.equip_if_possible(Pda, SLOT_ID_L_STORE, 0)
						ok = M.equip_if_possible(I, SLOT_ID_BELT, 0)
				else if(istype(M.back,/obj/item/storage)) // Try to place it in something on the mob's back
					var/obj/item/storage/back = M.back
					if(back.contents.len < back.storage_slots)
						Item.loc = back
						ok = 1

				else
					for(var/obj/item/storage/S in M.contents) // Try to place it in any item that can store stuff, on the mob.
						if (S.contents.len < S.storage_slots)
							Item.loc = S
							ok = 1
							break

				skip:
				if (ok == 0) // Finally, since everything else failed, place it on the ground
					Item.loc = get_turf(M.loc)
