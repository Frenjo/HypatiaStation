/obj/effect/manifest
	name = "manifest"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	unacidable = TRUE	//Just to be sure.

/obj/effect/manifest/New()
	src.invisibility = INVISIBILITY_MAXIMUM
	return

/obj/effect/manifest/proc/manifest()
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/carbon/human/M in mob_list)
		dat += "    <B>[M.name]</B> -  [M.get_assignment()]<BR>"
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(src.loc)
	P.info = dat
	P.name = "paper - 'Crew Manifest'"
	qdel(src)
	return