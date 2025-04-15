/obj/effect/manifest
	name = "manifest"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x"
	unacidable = TRUE	//Just to be sure.

/obj/effect/manifest/New()
	src.invisibility = INVISIBILITY_MAXIMUM
	return

/obj/effect/manifest/proc/manifest()
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/carbon/human/M in GLOBL.mob_list)
		dat += "    <B>[M.name]</B> -  [M.get_assignment()]<BR>"
	var/obj/item/paper/P = new /obj/item/paper(src.loc)
	P.info = dat
	P.name = "paper - 'Crew Manifest'"
	qdel(src)
	return