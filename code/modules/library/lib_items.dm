/* Library Items
 *
 * Contains:
 *		Bookcase
 *		Book
 *		Barcode Scanner
 */

/*
 * Bookcase
 */
/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/obj/library.dmi'
	icon_state = "book-0"
	anchored = TRUE
	density = TRUE
	opacity = TRUE

/obj/structure/bookcase/initialise()
	. = ..()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/book))
			I.loc = src
	update_icon()

/obj/structure/bookcase/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/book))
		user.drop_item()
		O.loc = src
		update_icon()
	else if(istype(O, /obj/item/pen))
		var/newname = stripped_input(usr, "What would you like to title this bookshelf?")
		if(!newname)
			return
		else
			name = ("bookcase ([sanitize(newname)])")
	else
		..()

/obj/structure/bookcase/attack_hand(mob/user)
	if(length(contents))
		var/obj/item/book/choice = input("Which book would you like to remove from the shelf?") in contents
		if(choice)
			if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
				return
			if(ishuman(user))
				if(!user.get_active_hand())
					user.put_in_hands(choice)
			else
				choice.loc = GET_TURF(src)
			update_icon()

/obj/structure/bookcase/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/item/book/b in contents)
				qdel(b)
			qdel(src)
			return
		if(2.0)
			for(var/obj/item/book/b in contents)
				if(prob(50))
					b.loc = GET_TURF(src)
				else qdel(b)
			qdel(src)
			return
		if(3.0)
			if(prob(50))
				for(var/obj/item/book/b in contents)
					b.loc = GET_TURF(src)
				qdel(src)
			return
		else
	return

/obj/structure/bookcase/update_icon()
	if(length(contents) < 5)
		icon_state = "book-[length(contents)]"
	else
		icon_state = "book-5"


/obj/structure/bookcase/manuals/medical
	name = "Medical Manuals bookcase"

/obj/structure/bookcase/manuals/medical/New()
	..()
	new /obj/item/book/manual/medical_cloning(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	update_icon()


/obj/structure/bookcase/manuals/engineering
	name = "Engineering Manuals bookcase"

/obj/structure/bookcase/manuals/engineering/New()
	..()
	new /obj/item/book/manual/engineering_construction(src)
	new /obj/item/book/manual/engineering_particle_accelerator(src)
	new /obj/item/book/manual/engineering_hacking(src)
	new /obj/item/book/manual/engineering_guide(src)
	new /obj/item/book/manual/atmospipes(src)
	new /obj/item/book/manual/engineering_singularity_safety(src)
	new /obj/item/book/manual/evaguide(src)
	update_icon()


/obj/structure/bookcase/manuals/research_and_development
	name = "R&D Manuals bookcase"

/obj/structure/bookcase/manuals/research_and_development/New()
	..()
	new /obj/item/book/manual/research_and_development(src)
	update_icon()


/*
 * Book
 */
/obj/item/book
	name = "book"
	icon = 'icons/obj/library.dmi'
	icon_state ="book"
	throw_speed = 1
	throw_range = 5
	w_class = 3		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	var/dat			 	// Actual page content
	var/due_date = 0	// Game time in 1/10th seconds
	var/author		 	// Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/unique = FALSE	// FALSE - Normal book, TRUE - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title		 	// The real name of the book.
	var/carved = FALSE	 // Has the book been hollowed out for use as a secret storage item?
	var/obj/item/store	//What's in the book?

/obj/item/book/attack_self(mob/user)
	if(carved)
		if(store)
			to_chat(user, SPAN_NOTICE("[store] falls out of [title]!"))
			store.loc = GET_TURF(src)
			store = null
			return
		else
			to_chat(user, SPAN_NOTICE("The pages of [title] have been cut out!"))
			return
	if(src.dat)
		user << browse("<TT><I>Penned by [author].</I></TT> <BR>" + "[dat]", "window=book")
		user.visible_message("[user] opens a book titled \"[src.title]\" and begins reading intently.")
		onclose(user, "book")
	else
		to_chat(user, "This book is completely blank!")

/obj/item/book/attackby(obj/item/W, mob/user)
	if(carved)
		if(!store)
			if(W.w_class < 3)
				user.drop_item()
				W.loc = src
				store = W
				to_chat(user, SPAN_NOTICE("You put [W] in [title]."))
				return
			else
				to_chat(user, SPAN_NOTICE("[W] won't fit in [title]."))
				return
		else
			to_chat(user, SPAN_NOTICE("There's already something in [title]!"))
			return
	if(istype(W, /obj/item/pen))
		if(unique)
			to_chat(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
			return
		var/choice = input("What would you like to change?") in list("Title", "Contents", "Author", "Cancel")
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(stripped_input(usr, "Write a new title:"))
				if(!newtitle)
					to_chat(usr, "The title is invalid.")
					return
				else
					src.name = newtitle
					src.title = newtitle
			if("Contents")
				var/content = strip_html(input(usr, "Write your book's contents (HTML NOT allowed):"), 8192)
				if(!content)
					to_chat(usr, "The content is invalid.")
					return
				else
					src.dat += content
			if("Author")
				var/newauthor = stripped_input(usr, "Write the author's name:")
				if(!newauthor)
					to_chat(usr, "The name is invalid.")
					return
				else
					src.author = newauthor
			else
				return
	else if(istype(W, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = W
		if(!scanner.computer)
			to_chat(user, "[W]'s screen flashes: 'No associated computer found!'")
		else
			switch(scanner.mode)
				if(0)
					scanner.book = src
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer.'")
				if(1)
					scanner.book = src
					scanner.computer.buffer_book = src.name
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Book title stored in associated computer buffer.'")
				if(2)
					scanner.book = src
					for(var/datum/borrowbook/b in scanner.computer.checkouts)
						if(b.bookname == src.name)
							scanner.computer.checkouts.Remove(b)
							to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Book has been checked in.'")
							return
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. No active check-out record found for current title.'")
				if(3)
					scanner.book = src
					for(var/obj/item/book in scanner.computer.inventory)
						if(book == src)
							to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Title already present in inventory, aborting to avoid duplicate entry.'")
							return
					scanner.computer.inventory.Add(src)
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Title added to general inventory.'")
	else if(istype(W, /obj/item/kitchenknife) || iswirecutter(W))
		if(carved)
			return
		to_chat(user, SPAN_NOTICE("You begin to carve out [title]."))
		if(do_after(user, 30))
			to_chat(user, SPAN_NOTICE("You carve out the pages from [title]! You didn't want to read it anyway."))
			carved = TRUE
			return
	else
		..()


/*
 * Barcode Scanner
 */
/obj/item/barcodescanner
	name = "barcode scanner"
	icon = 'icons/obj/library.dmi'
	icon_state ="scanner"
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
	var/obj/machinery/librarycomp/computer // Associated computer - Modes 1 to 3 use this
	var/obj/item/book/book	 //  Currently scanned book
	var/mode = 0 					// 0 - Scan only, 1 - Scan and Set Buffer, 2 - Scan and Attempt to Check In, 3 - Scan and Attempt to Add to Inventory

/obj/item/barcodescanner/attack_self(mob/user)
	mode += 1
	if(mode > 3)
		mode = 0
	to_chat(user, "[src] Status Display:")
	var/modedesc
	switch(mode)
		if(0)
			modedesc = "Scan book to local buffer."
		if(1)
			modedesc = "Scan book to local buffer and set associated computer buffer to match."
		if(2)
			modedesc = "Scan book to local buffer, attempt to check in scanned book."
		if(3)
			modedesc = "Scan book to local buffer, attempt to add book to general inventory."
		else
			modedesc = "ERROR"
	to_chat(user, " - Mode [mode] : [modedesc]")
	if(src.computer)
		to_chat(user, "<font color=green>Computer has been associated with this unit.</font>")
	else
		to_chat(user, "<font color=red>No associated computer found. Only local scans will function properly.</font>")
	to_chat(user, "\n")