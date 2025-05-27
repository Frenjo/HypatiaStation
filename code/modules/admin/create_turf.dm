GLOBAL_GLOBL_INIT(create_turf_html, null)
/datum/admins/proc/create_turf(mob/user)
	if(isnull(GLOBL.create_turf_html))
		GLOBL.create_turf_html = file2text('html/misc/create_object.html')
		GLOBL.create_turf_html = replacetext(GLOBL.create_turf_html, "null /* object types */", "\"[jointext(typesof(/turf), ";")]\"")

	user << browse(replacetext(GLOBL.create_turf_html, "/* ref src */", "\ref[src]"), "window=create_turf;size=425x475")