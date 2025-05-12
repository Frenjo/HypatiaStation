/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "A rune drawn in crayon."
	icon = 'icons/obj/rune.dmi'
	layer = 2.1
	anchored = TRUE

/obj/effect/decal/cleanable/crayon/examine()
	set src in view(2)
	..()
	return

/obj/effect/decal/cleanable/crayon/New(location, main = "#FFFFFF", shade = "#000000", type = "rune")
	..()
	loc = location

	name = type
	desc = "A [type] drawn in crayon."

	switch(type)
		if("rune")
			type = "rune[rand(1, 6)]"
		if("graffiti")
			type = pick("amyjon", "face", "matt", "revolution", "engie", "guy", "end", "dwarf", "uboa")

	var/icon/mainOverlay = new/icon('icons/effects/decals/crayon.dmi', "[type]", 2.1)
	var/icon/shadeOverlay = new/icon('icons/effects/decals/crayon.dmi', "[type]s", 2.1)

	mainOverlay.Blend(main, ICON_ADD)
	shadeOverlay.Blend(shade, ICON_ADD)

	overlays += mainOverlay
	overlays += shadeOverlay

	add_hiddenprint(usr)