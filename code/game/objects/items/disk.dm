/*
 * Disks
 *
 * Spelt 'disk' instead of 'disc' because they're literally floppies.
 */
/obj/item/disk
	name = "disk"
	icon = 'icons/obj/items.dmi'
	item_state = "card-id"

// Nuclear authentication disk
/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	w_class = 1.0

// Technology datum disk
/obj/item/disk/tech
	name = "technology disk"
	desc = "A disk for storing technology data for further research."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	w_class = 1.0
	matter_amounts = list(MATERIAL_METAL = 30, /decl/material/glass = 10)
	origin_tech = list(/decl/tech/programming = 1)

	var/decl/tech/stored = null

/obj/item/disk/tech/New()
	. = ..()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)

// Design datum disk
/obj/item/disk/design
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	w_class = 1.0
	matter_amounts = list(MATERIAL_METAL = 30, /decl/material/glass = 10)
	origin_tech = list(/decl/tech/programming = 1)

	var/datum/design/blueprint = null

/obj/item/disk/design/New()
	. = ..()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)

//The return of data disks?? Just for transferring between genetics machine/cloning machine.
//TO-DO: Make the genetics machine accept them.
/obj/item/disk/cloning_data
	name = "cloning data disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0" //Gosh I hope syndies don't mistake them for the nuke disk.
	w_class = 1

	var/datum/dna2/record/buf = null
	var/read_only = FALSE // Well, it's still a floppy disk.

/obj/item/disk/cloning_data/New()
	. = ..()
	buf = new /datum/dna2/record()
	buf.dna = new /datum/dna()
	icon_state = "datadisk[pick(0, 1, 2)]"

/obj/item/disk/cloning_data/attack_self(mob/user)
	read_only = !read_only
	to_chat(user, "You flip the write-protect tab to [read_only ? "protected" : "unprotected"].")

/obj/item/disk/cloning_data/examine()
	set src in oview(5)
	. = ..()
	to_chat(usr, "The write-protect tab is set to [read_only ? "protected" : "unprotected"].")

// God Emperor Of Mankind disk
/obj/item/disk/cloning_data/demo
	name = "cloning data disk - 'God Emperor of Mankind'"
	read_only = TRUE

/obj/item/disk/cloning_data/demo/New()
	. = ..()
	buf.types = DNA2_BUF_UE | DNA2_BUF_UI
	//data = "066000033000000000AF00330660FF4DB002690"
	//data = "0C80C80C80C80C80C8000000000000161FBDDEF" - Farmer Jeff
	buf.dna.real_name = "God Emperor of Mankind"
	buf.dna.unique_enzymes = md5(buf.dna.real_name)
	buf.dna.UI = list(0x066, 0x000, 0x033, 0x000, 0x000, 0x000, 0xAF0, 0x033, 0x066, 0x0FF, 0x4DB, 0x002, 0x690)
	//buf.dna.UI=list(0x0C8,0x0C8,0x0C8,0x0C8,0x0C8,0x0C8,0x000,0x000,0x000,0x000,0x161,0xFBD,0xDEF) // Farmer Jeff
	buf.dna.UpdateUI()

// Mr. Muggles disk
/obj/item/disk/cloning_data/monkey
	name = "cloning data disk - 'Mr. Muggles'"
	read_only = TRUE

/obj/item/disk/cloning_data/monkey/New()
	. = ..()
	buf.types = DNA2_BUF_SE
	var/list/new_SE = list(0x098, 0x3E8, 0x403, 0x44C, 0x39F, 0x4B0, 0x59D, 0x514, 0x5FC, 0x578, 0x5DC, 0x640, 0x6A4)
	for(var/i = length(new_SE); i <= DNA_SE_LENGTH; i++)
		new_SE += rand(1, 1024)
	buf.dna.SE = new_SE
	buf.dna.SetSEValueRange(GLOBL.dna_data.monkey_block, 0xDAC, 0xFFF)