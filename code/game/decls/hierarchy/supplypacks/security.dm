/decl/hierarchy/supply_pack/security
	name = "Security"


/decl/hierarchy/supply_pack/security/specialops
	name = "Special Ops supplies"
	contains = list(
		/obj/item/storage/box/emps,
		/obj/item/grenade/smokebomb,
		/obj/item/grenade/smokebomb,
		/obj/item/grenade/smokebomb,
		/obj/item/pen/paralysis,
		/obj/item/grenade/chem_grenade/incendiary
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Special Ops crate"
	hidden = TRUE


/decl/hierarchy/supply_pack/security/beanbagammo
	name = "Beanbag shells"
	contains = list(
		/obj/item/ammo_casing/shotgun/beanbag,
		/obj/item/ammo_casing/shotgun/beanbag,
		/obj/item/ammo_casing/shotgun/beanbag,
		/obj/item/ammo_casing/shotgun/beanbag,
		/obj/item/ammo_casing/shotgun/beanbag,
		/obj/item/ammo_casing/shotgun/beanbag,
		/obj/item/ammo_casing/shotgun/beanbag,
		/obj/item/ammo_casing/shotgun/beanbag,
		/obj/item/ammo_casing/shotgun/beanbag,
		/obj/item/ammo_casing/shotgun/beanbag
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Beanbag shells"


/decl/hierarchy/supply_pack/security/weapons
	name = "Weapons crate"
	contains = list(
		/obj/item/melee/baton,
		/obj/item/melee/baton,
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/taser,
		/obj/item/gun/energy/taser,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/box/flashbangs
	)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Weapons crate"
	access = ACCESS_ARMOURY


/decl/hierarchy/supply_pack/security/eweapons
	name = "Experimental weapons crate"
	contains = list(
		/obj/item/flamethrower/full,
		/obj/item/tank/plasma,
		/obj/item/tank/plasma,
		/obj/item/tank/plasma,
		/obj/item/grenade/chem_grenade/incendiary,
		/obj/item/grenade/chem_grenade/incendiary,
		/obj/item/grenade/chem_grenade/incendiary
	)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Experimental weapons crate"
	access = ACCESS_BRIDGE


/decl/hierarchy/supply_pack/security/armor
	name = "Armor crate"
	contains = list(
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/suit/armor/vest
	)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "Armor crate"
	access = ACCESS_SECURITY


/decl/hierarchy/supply_pack/security/riot
	name = "Riot gear crate"
	contains = list(
		/obj/item/melee/baton,
		/obj/item/melee/baton,
		/obj/item/melee/baton,
		/obj/item/shield/riot,
		/obj/item/shield/riot,
		/obj/item/shield/riot,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/box/flashbangs,
		/obj/item/handcuffs,
		/obj/item/handcuffs,
		/obj/item/handcuffs,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/suit/armor/riot
	)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Riot gear crate"
	access = ACCESS_ARMOURY


/decl/hierarchy/supply_pack/security/loyalty
	name = "Loyalty implant crate"
	contains = list (/obj/item/storage/lockbox/loyalty)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Loyalty implant crate"
	access = ACCESS_ARMOURY


/decl/hierarchy/supply_pack/security/ballistic
	name = "Ballistic gear crate"
	contains = list(
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/gun/projectile/shotgun/pump/combat,
		/obj/item/gun/projectile/shotgun/pump/combat
	)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Ballistic gear crate"
	access = ACCESS_ARMOURY


/decl/hierarchy/supply_pack/security/erifle
	name = "Energy marksman crate"
	contains = list(
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/gun/energy/sniperrifle,
		/obj/item/gun/energy/sniperrifle
	)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Energy marksman crate"
	access = ACCESS_ARMOURY


/decl/hierarchy/supply_pack/security/shotgunammo
	name = "Shotgun shells"
	contains = list(
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Shotgun shells"
	access = ACCESS_ARMOURY


/decl/hierarchy/supply_pack/security/expenergy
	name = "Experimental energy gear crate"
	contains = list(
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/gun
	)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Experimental energy gear crate"
	access = ACCESS_ARMOURY


/decl/hierarchy/supply_pack/security/exparmor
	name = "Experimental armor crate"
	contains = list(
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/suit/armor/riot
	)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "Experimental armor crate"
	access = ACCESS_ARMOURY


/decl/hierarchy/supply_pack/security/securitybarriers
	name = "Security barrier crate"
	contains = list(
		/obj/machinery/deployable/barrier,
		/obj/machinery/deployable/barrier,
		/obj/machinery/deployable/barrier,
		/obj/machinery/deployable/barrier
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Security barrier crate"


/decl/hierarchy/supply_pack/security/securityshields
	name = "Wall shield generators"
	contains = list(
		/obj/machinery/shieldwallgen,
		/obj/machinery/shieldwallgen,
		/obj/machinery/shieldwallgen,
		/obj/machinery/shieldwallgen
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Wall shield generators crate"
	access = ACCESS_TELEPORTER


/decl/hierarchy/supply_pack/security/disablers
	name = "Disabler supply crate"
	contains = list(
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/disabler,
		/obj/item/gun/energy/disabler
	)
	cost = 20 // This cost seems to be roughly similar to the taser crate except slightly less since they're only disablers.
	containertype = /obj/structure/closet/crate/secure
	containername = "Disabler supply crate"
	access = ACCESS_SECURITY