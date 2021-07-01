/decl/hierarchy/supply_pack/security
	name = "Security"
	hierarchy_type = /decl/hierarchy/supply_pack/security


/decl/hierarchy/supply_pack/security/specialops
	name = "Special Ops supplies"
	contains = list(
		/obj/item/weapon/storage/box/emps,
		/obj/item/weapon/grenade/smokebomb,
		/obj/item/weapon/grenade/smokebomb,
		/obj/item/weapon/grenade/smokebomb,
		/obj/item/weapon/pen/paralysis,
		/obj/item/weapon/grenade/chem_grenade/incendiary
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Special Ops crate"
	hidden = 1


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
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/box/flashbangs
	)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Weapons crate"
	access = access_armory


/decl/hierarchy/supply_pack/security/eweapons
	name = "Experimental weapons crate"
	contains = list(
		/obj/item/weapon/flamethrower/full,
		/obj/item/weapon/tank/plasma,
		/obj/item/weapon/tank/plasma,
		/obj/item/weapon/tank/plasma,
		/obj/item/weapon/grenade/chem_grenade/incendiary,
		/obj/item/weapon/grenade/chem_grenade/incendiary,
		/obj/item/weapon/grenade/chem_grenade/incendiary
	)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Experimental weapons crate"
	access = access_heads


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
	access = access_security


/decl/hierarchy/supply_pack/security/riot
	name = "Riot gear crate"
	contains = list(
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/shield/riot,
		/obj/item/weapon/shield/riot,
		/obj/item/weapon/shield/riot,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/handcuffs,
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
	access = access_armory


/decl/hierarchy/supply_pack/security/loyalty
	name = "Loyalty implant crate"
	contains = list (/obj/item/weapon/storage/lockbox/loyalty)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "Loyalty implant crate"
	access = access_armory


/decl/hierarchy/supply_pack/security/ballistic
	name = "Ballistic gear crate"
	contains = list(
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat
	)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Ballistic gear crate"
	access = access_armory


/decl/hierarchy/supply_pack/security/erifle
	name = "Energy marksman crate"
	contains = list(
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/weapon/gun/energy/sniperrifle,
		/obj/item/weapon/gun/energy/sniperrifle
	)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Energy marksman crate"
	access = access_armory


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
	access = access_armory


/decl/hierarchy/supply_pack/security/expenergy
	name = "Experimental energy gear crate"
	contains = list(
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/gun/energy/gun
	)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Experimental energy gear crate"
	access = access_armory


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
	access = access_armory


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
	access = access_teleporter


/decl/hierarchy/supply_pack/security/disablers
	name = "Disabler supply crate"
	contains = list(
		/obj/item/weapon/gun/energy/disabler,
		/obj/item/weapon/gun/energy/disabler,
		/obj/item/weapon/gun/energy/disabler
	)
	cost = 20 // This cost seems to be roughly similar to the taser crate except slightly less since they're only disablers.
	containertype = /obj/structure/closet/crate/secure
	containername = "Disabler supply crate"
	access = access_security