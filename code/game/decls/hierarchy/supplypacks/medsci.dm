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
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/firstaid/fire,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/firstaid/adv,
		/obj/item/storage/firstaid/radiation, // Added this so we can get the kit from somewhere before I try editing the map. -Frenjo
		/obj/item/reagent_containers/glass/bottle/antitoxin,
		/obj/item/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/reagent_containers/glass/bottle/stoxin,
		/obj/item/storage/box/syringes,
		/obj/item/storage/box/autoinjectors
	)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "Medical crate"


/decl/hierarchy/supply_pack/medsci/virus
	name = "Virus sample crate"
/*	contains = list(/obj/item/reagent_containers/glass/bottle/flu_virion,
					/obj/item/reagent_containers/glass/bottle/cold,
					/obj/item/reagent_containers/glass/bottle/epiglottis_virion,
					/obj/item/reagent_containers/glass/bottle/liver_enhance_virion,
					/obj/item/reagent_containers/glass/bottle/fake_gbs,
					/obj/item/reagent_containers/glass/bottle/magnitis,
					/obj/item/reagent_containers/glass/bottle/pierrot_throat,
					/obj/item/reagent_containers/glass/bottle/brainrot,
					/obj/item/reagent_containers/glass/bottle/hullucigen_virion,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/beakers,
					/obj/item/reagent_containers/glass/bottle/mutagen)*/
	contains = list(
		/obj/item/virusdish/random,
		/obj/item/virusdish/random,
		/obj/item/virusdish/random,
		/obj/item/virusdish/random
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
		/obj/item/tank/plasma,
		/obj/item/tank/plasma,
		/obj/item/tank/plasma,
		/obj/item/assembly/igniter,
		/obj/item/assembly/igniter,
		/obj/item/assembly/igniter,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/prox_sensor,
		/obj/item/assembly/timer,
		/obj/item/assembly/timer,
		/obj/item/assembly/timer
	)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Plasma assembly crate"
	access = ACCESS_TOX_STORAGE


/decl/hierarchy/supply_pack/medsci/surgery
	name = "Surgery crate"
	contains = list(
		/obj/item/cautery,
		/obj/item/surgicaldrill,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/tank/anesthetic,
		/obj/item/FixOVein,
		/obj/item/hemostat,
		/obj/item/scalpel,
		/obj/item/bonegel,
		/obj/item/retractor,
		/obj/item/bonesetter,
		/obj/item/circular_saw
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
		/obj/item/storage/box/masks,
		/obj/item/storage/box/gloves
	)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Sterile equipment crate"