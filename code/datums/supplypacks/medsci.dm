/decl/hierarchy/supply_pack/medsci
	name = "Medical / Science"


/decl/hierarchy/supply_pack/medsci/stemcell
	name = "Stem-Cell Pack (2)"
	contains = list(
		/obj/item/cloning/charge,
		/obj/item/cloning/charge
	)
	cost = 125
	containertype = /obj/structure/closet/crate/secure/bio
	containername = "Stem-Cell Long Term Storage Unit"
	access = ACCESS_MEDICAL


/decl/hierarchy/supply_pack/medsci/medical
	name = "Medical crate"
	contains = list(
		/obj/item/weapon/storage/firstaid/regular,
		/obj/item/weapon/storage/firstaid/fire,
		/obj/item/weapon/storage/firstaid/toxin,
		/obj/item/weapon/storage/firstaid/o2,
		/obj/item/weapon/storage/firstaid/adv,
		/obj/item/weapon/storage/firstaid/radiation, // Added this so we can get the kit from somewhere before I try editing the map. -Frenjo
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/storage/box/autoinjectors
	)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "Medical crate"


/decl/hierarchy/supply_pack/medsci/virus
	name = "Virus sample crate"
/*	contains = list(/obj/item/weapon/reagent_containers/glass/bottle/flu_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/cold,
					/obj/item/weapon/reagent_containers/glass/bottle/epiglottis_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/liver_enhance_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/fake_gbs,
					/obj/item/weapon/reagent_containers/glass/bottle/magnitis,
					/obj/item/weapon/reagent_containers/glass/bottle/pierrot_throat,
					/obj/item/weapon/reagent_containers/glass/bottle/brainrot,
					/obj/item/weapon/reagent_containers/glass/bottle/hullucigen_virion,
					/obj/item/weapon/storage/box/syringes,
					/obj/item/weapon/storage/box/beakers,
					/obj/item/weapon/reagent_containers/glass/bottle/mutagen)*/
	contains = list(
		/obj/item/weapon/virusdish/random,
		/obj/item/weapon/virusdish/random,
		/obj/item/weapon/virusdish/random,
		/obj/item/weapon/virusdish/random
	)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Virus sample crate"
	access = ACCESS_CMO


/decl/hierarchy/supply_pack/medsci/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"


/decl/hierarchy/supply_pack/medsci/plasma
	name = "Plasma assembly crate"
	contains = list(
		/obj/item/weapon/tank/plasma,
		/obj/item/weapon/tank/plasma,
		/obj/item/weapon/tank/plasma,
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/timer,
		/obj/item/device/assembly/timer,
		/obj/item/device/assembly/timer
	)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Plasma assembly crate"
	access = ACCESS_TOX_STORAGE


/decl/hierarchy/supply_pack/medsci/surgery
	name = "Surgery crate"
	contains = list(
		/obj/item/weapon/cautery,
		/obj/item/weapon/surgicaldrill,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/weapon/tank/anesthetic,
		/obj/item/weapon/FixOVein,
		/obj/item/weapon/hemostat,
		/obj/item/weapon/scalpel,
		/obj/item/weapon/bonegel,
		/obj/item/weapon/retractor,
		/obj/item/weapon/bonesetter,
		/obj/item/weapon/circular_saw
	)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Surgery crate"
	access = ACCESS_MEDICAL


/decl/hierarchy/supply_pack/medsci/sterile
	name = "Sterile equipment crate"
	contains = list(
		/obj/item/clothing/under/rank/medical/green,
		/obj/item/clothing/under/rank/medical/green,
		/obj/item/weapon/storage/box/masks,
		/obj/item/weapon/storage/box/gloves
	)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Sterile equipment crate"