GLOBAL_GLOBL_INIT(create_object_html, null)
/datum/admins/proc/create_object(mob/user)
	if(isnull(GLOBL.create_object_html))
		GLOBL.create_object_html = file2text('html/create_object.html')
		GLOBL.create_object_html = replacetext(GLOBL.create_object_html, "null /* object types */", "\"[jointext(typesof(/obj), ";")]\"")

	user << browse(replacetext(GLOBL.create_object_html, "/* ref src */", "\ref[src]"), "window=create_object;size=425x475")

/datum/admins/proc/quick_create_object(mob/user)
	var/list/quick_create_types = list(/obj, /obj/effect, /obj/item, /obj/item/stack, /obj/machinery, /obj/mecha, /obj/structure)
	var/path = input("Select the path of the object you wish to create.", "Path", "/obj") in quick_create_types

	var/quick_create_object_html = file2text('html/create_object.html')
	quick_create_object_html = replacetext(quick_create_object_html, "null /* object types */", "\"[jointext(typesof(path), ";")]\"")

	user << browse(replacetext(quick_create_object_html, "/* ref src */", "\ref[src]"), "window=quick_create_object;size=425x475")