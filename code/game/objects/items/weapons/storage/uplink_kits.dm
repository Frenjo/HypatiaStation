/obj/item/weapon/storage/box/syndicate/New()
	switch(pickweight(list("bloodyspai" = 1, "stealth" = 1, "screwed" = 1, "guns" = 1, "murder" = 1, "freedom" = 1, "hacker" = 1, "lordsingulo" = 1, "smoothoperator" = 1)))
		if("bloodyspai")
			starts_with = list(
				/obj/item/clothing/under/chameleon,
				/obj/item/clothing/mask/gas/voice,
				/obj/item/weapon/card/id/syndicate,
				/obj/item/clothing/shoes/syndigaloshes
			)

		if("stealth")
			starts_with = list(
				/obj/item/weapon/gun/energy/crossbow,
				/obj/item/weapon/pen/paralysis,
				/obj/item/device/chameleon
			)

		if("screwed")
			starts_with = list(
				/obj/effect/spawner/newbomb/timer/syndicate,
				/obj/effect/spawner/newbomb/timer/syndicate,
				/obj/item/device/powersink,
				/obj/item/clothing/suit/space/syndicate,
				/obj/item/clothing/head/helmet/space/syndicate
			)

		if("guns")
			starts_with = list(
				/obj/item/weapon/gun/projectile,
				/obj/item/ammo_magazine/a357,
				/obj/item/weapon/card/emag,
				/obj/item/weapon/plastique
			)

		if("murder")
			starts_with = list(
				/obj/item/weapon/melee/energy/sword,
				/obj/item/clothing/glasses/thermal/syndi,
				/obj/item/weapon/card/emag,
				/obj/item/clothing/shoes/syndigaloshes
			)

		if("freedom")
			var/obj/item/weapon/implanter/O = new /obj/item/weapon/implanter(src)
			O.imp = new /obj/item/weapon/implant/freedom(O)
			var/obj/item/weapon/implanter/U = new /obj/item/weapon/implanter(src)
			U.imp = new /obj/item/weapon/implant/uplink(U)

		if("hacker")
			starts_with = list(
				/obj/item/weapon/aiModule/syndicate,
				/obj/item/weapon/card/emag,
				/obj/item/device/encryptionkey/binary
			)

		if("lordsingulo")
			starts_with = list(
				/obj/item/device/radio/beacon/syndicate,
				/obj/item/clothing/suit/space/syndicate,
				/obj/item/clothing/head/helmet/space/syndicate,
				/obj/item/weapon/card/emag
			)

		if("smoothoperator")
			starts_with = list(
				/obj/item/weapon/gun/projectile/pistol,
				/obj/item/weapon/silencer,
				/obj/item/weapon/soap/syndie,
				/obj/item/weapon/storage/bag/trash,
				/obj/item/bodybag,
				/obj/item/clothing/under/suit_jacket,
				/obj/item/clothing/shoes/laceup
			)

	return ..()

/obj/item/weapon/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box"
	icon_state = "box_of_doom"

/obj/item/weapon/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_freedom/New()
	. = ..()
	var/obj/item/weapon/implanter/O = new /obj/item/weapon/implanter(src)
	O.imp = new /obj/item/weapon/implant/freedom(O)
	O.update()

/obj/item/weapon/storage/box/syndie_kit/imp_compress
	name = "box (C)"

	starts_with = list(
		/obj/item/weapon/implanter/compressed
	)

/obj/item/weapon/storage/box/syndie_kit/imp_explosive
	name = "box (E)"

	starts_with = list(
		/obj/item/weapon/implanter/explosive
	)

/obj/item/weapon/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_uplink/New()
	. = ..()
	var/obj/item/weapon/implanter/O = new /obj/item/weapon/implanter(src)
	O.imp = new /obj/item/weapon/implant/uplink(O)
	O.update()

/obj/item/weapon/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"

	starts_with = list(
		/obj/item/clothing/suit/space/syndicate,
		/obj/item/clothing/head/helmet/space/syndicate
	)
