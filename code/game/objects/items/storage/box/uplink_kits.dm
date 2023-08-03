/obj/item/storage/box/syndicate/New()
	switch(pickweight(list(
		"bloodyspai" = 1, "stealth" = 1, "screwed" = 1,
		"guns" = 1, "murder" = 1, "freedom" = 1,
		"hacker" = 1, "lordsingulo" = 1, "smoothoperator" = 1
	)))
		if("bloodyspai")
			starts_with = list(
				/obj/item/clothing/under/chameleon,
				/obj/item/clothing/mask/gas/voice,
				/obj/item/card/id/syndicate,
				/obj/item/clothing/shoes/syndigaloshes
			)

		if("stealth")
			starts_with = list(
				/obj/item/gun/energy/crossbow,
				/obj/item/pen/paralysis,
				/obj/item/device/chameleon
			)

		if("screwed")
			starts_with = list(
				/obj/effect/spawner/newbomb/timer/syndicate = 2,
				/obj/item/device/powersink,
				/obj/item/clothing/suit/space/syndicate,
				/obj/item/clothing/head/helmet/space/syndicate
			)

		if("guns")
			starts_with = list(
				/obj/item/gun/projectile,
				/obj/item/ammo_magazine/a357,
				/obj/item/card/emag,
				/obj/item/plastique
			)

		if("murder")
			starts_with = list(
				/obj/item/melee/energy/sword,
				/obj/item/clothing/glasses/thermal/syndi,
				/obj/item/card/emag,
				/obj/item/clothing/shoes/syndigaloshes
			)

		if("freedom")
			var/obj/item/implanter/O = new /obj/item/implanter(src)
			O.imp = new /obj/item/implant/freedom(O)
			var/obj/item/implanter/U = new /obj/item/implanter(src)
			U.imp = new /obj/item/implant/uplink(U)

		if("hacker")
			starts_with = list(
				/obj/item/aiModule/syndicate,
				/obj/item/card/emag,
				/obj/item/device/encryptionkey/binary
			)

		if("lordsingulo")
			starts_with = list(
				/obj/item/device/radio/beacon/syndicate,
				/obj/item/clothing/suit/space/syndicate,
				/obj/item/clothing/head/helmet/space/syndicate,
				/obj/item/card/emag
			)

		if("smoothoperator")
			starts_with = list(
				/obj/item/gun/projectile/pistol,
				/obj/item/silencer,
				/obj/item/soap/syndie,
				/obj/item/storage/bag/trash,
				/obj/item/bodybag,
				/obj/item/clothing/under/suit_jacket,
				/obj/item/clothing/shoes/laceup
			)

	return ..()

/obj/item/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box"
	icon_state = "box_of_doom"

/obj/item/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_freedom/New()
	. = ..()
	var/obj/item/implanter/O = new /obj/item/implanter(src)
	O.imp = new /obj/item/implant/freedom(O)
	O.update()

/obj/item/storage/box/syndie_kit/imp_compress
	name = "box (C)"

	starts_with = list(
		/obj/item/implanter/compressed
	)

/obj/item/storage/box/syndie_kit/imp_explosive
	name = "box (E)"

	starts_with = list(
		/obj/item/implanter/explosive
	)

/obj/item/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_uplink/New()
	. = ..()
	var/obj/item/implanter/O = new /obj/item/implanter(src)
	O.imp = new /obj/item/implant/uplink(O)
	O.update()

/obj/item/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"

	starts_with = list(
		/obj/item/clothing/suit/space/syndicate,
		/obj/item/clothing/head/helmet/space/syndicate
	)