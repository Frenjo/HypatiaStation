GLOBAL_GLOBL_INIT(create_mob_html, null)
/datum/admins/proc/create_mob(mob/user)
	if(isnull(GLOBL.create_mob_html))
		GLOBL.create_mob_html = file2text('html/create_object.html')
		GLOBL.create_mob_html = replacetext(GLOBL.create_mob_html, "null /* object types */", "\"[jointext(typesof(/mob), ";")]\"")

	user << browse(replacetext(GLOBL.create_mob_html, "/* ref src */", "\ref[src]"), "window=create_mob;size=425x475")