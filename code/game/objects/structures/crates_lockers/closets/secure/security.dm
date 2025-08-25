/*
 * Captain
 */
/obj/structure/closet/secure/captains
	name = "captain's locker"
	req_access = list(ACCESS_CAPTAIN)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	starts_with = list(
		/obj/item/clothing/suit/captunic,
		/obj/item/clothing/suit/captunic/capjacket,
		/obj/item/clothing/head/helmet/cap,
		/obj/item/clothing/under/rank/captain,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/cartridge/captain,
		/obj/item/clothing/head/helmet/swat,
		/obj/item/clothing/shoes/brown,
		/obj/item/radio/headset/heads/captain,
		/obj/item/clothing/gloves/captain,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/suit/armor/captain,
		/obj/item/melee/telebaton,
		/obj/item/clothing/under/dress/dress_cap
	)

/obj/structure/closet/secure/captains/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/captain)
	else
		starts_with.Add(/obj/item/storage/satchel/cap)
	. = ..()

/*
 * Head of Personnel
 */
/obj/structure/closet/secure/hop
	name = "head of personnel's locker"
	req_access = list(ACCESS_HOP)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"

	starts_with = list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/head/helmet,
		/obj/item/cartridge/hop,
		/obj/item/radio/headset/heads/hop,
		/obj/item/storage/box/ids,
		/obj/item/storage/box/ids,
		/obj/item/gun/energy/gun,
		/obj/item/flash
	)

/*
 * Head of Personnel Attire
 */
/obj/structure/closet/secure/hop2
	name = "head of personnel's attire"
	req_access = list(ACCESS_HOP)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"

	starts_with = list(
		/obj/item/clothing/under/rank/head_of_personnel,
		/obj/item/clothing/under/dress/dress_hop,
		/obj/item/clothing/under/dress/dress_hr,
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/oldman,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/head_of_personnel_whimsy
	)

/*
 * Head of Security
 */
/obj/structure/closet/secure/hos
	name = "head of security's locker"
	req_access = list(ACCESS_HOS)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/suit/armor/hos/jensen,
		/obj/item/clothing/suit/armor/hos,
		/obj/item/clothing/head/helmet/HoS/dermal,
		/obj/item/cartridge/hos,
		/obj/item/radio/headset/heads/hos,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/shield/riot,
		/obj/item/storage/lockbox/mindshield,
		/obj/item/storage/lockbox/loyalty,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/melee/baton,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/tie/holster/waist,
		/obj/item/melee/telebaton
	)

/obj/structure/closet/secure/hos/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/security)
	else
		starts_with.Add(/obj/item/storage/satchel/sec)
	. = ..()

/*
 * Warden
 */
/obj/structure/closet/secure/warden
	name = "warden's locker"
	req_access = list(ACCESS_ARMOURY)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"

	starts_with = list(
		/obj/item/clothing/suit/armor/vest/security,
		/obj/item/clothing/under/rank/warden,
		/obj/item/clothing/under/rank/warden/corp,
		/obj/item/clothing/suit/armor/vest/warden,
		/obj/item/clothing/head/helmet/warden,
	//	/obj/item/cartridge/security,
		/obj/item/radio/headset/sec,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/reagent_holder/spray/pepper,
		/obj/item/melee/baton,
		/obj/item/gun/energy/taser,
		/obj/item/storage/box/holobadge
	)

/obj/structure/closet/secure/warden/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/security)
	else
		starts_with.Add(/obj/item/storage/satchel/sec)
	. = ..()

/*
 * Security Officer
 */
/obj/structure/closet/secure/security
	name = "security officer's locker"
	req_access = list(ACCESS_SECURITY)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	starts_with = list(
		/obj/item/clothing/suit/armor/vest/security,
		/obj/item/clothing/head/helmet,
	//	/obj/item/cartridge/security,
		/obj/item/radio/headset/sec,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/reagent_holder/spray/pepper,
		/obj/item/grenade/flashbang,
		/obj/item/melee/baton,
		/obj/item/gun/energy/taser,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/hailer,
		/obj/item/clothing/tie/storage/black_vest,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/flashlight/flare
	)

/obj/structure/closet/secure/security/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/security)
	else
		starts_with.Add(/obj/item/storage/satchel/sec)
	. = ..()

/obj/structure/closet/secure/security/cargo/New()
	starts_with.Add(/obj/item/clothing/tie/armband/cargo)
	starts_with.Add(/obj/item/encryptionkey/cargo)
	. = ..()

/obj/structure/closet/secure/security/engine/New()
	starts_with.Add(/obj/item/clothing/tie/armband/engine)
	starts_with.Add(/obj/item/encryptionkey/engi)
	. = ..()

/obj/structure/closet/secure/security/science/New()
	starts_with.Add(/obj/item/clothing/tie/armband/science)
	starts_with.Add(/obj/item/encryptionkey/sci)
	. = ..()

/obj/structure/closet/secure/security/med/New()
	starts_with.Add(/obj/item/clothing/tie/armband/medgreen)
	starts_with.Add(/obj/item/encryptionkey/med)
	. = ..()

/*
 * Detective
 */
/obj/structure/closet/secure/detective
	name = "detective's cabinet"
	req_access = list(ACCESS_FORENSICS_LOCKERS)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

	starts_with = list(
		/obj/item/clothing/under/det,
		/obj/item/clothing/under/det/black,
		/obj/item/clothing/under/det/slob,
		/obj/item/clothing/suit/storage/det_suit,
		/obj/item/clothing/suit/storage/det_suit/black,
		/obj/item/clothing/suit/storage/forensics/blue,
		/obj/item/clothing/suit/storage/forensics/red,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/head/det_hat,
		/obj/item/clothing/head/det_hat/black,
		/obj/item/clothing/shoes/brown,
		/obj/item/storage/box/evidence,
		/obj/item/radio/headset/sec,
		/obj/item/detective_scanner,
		/obj/item/clothing/suit/armor/det_suit,
		/obj/item/ammo_magazine/c45r,
		/obj/item/ammo_magazine/c45r,
		/obj/item/taperoll/police,
		/obj/item/gun/projectile/detective/semiauto,
		/obj/item/clothing/tie/holster/armpit
	)

/obj/structure/closet/secure/detective/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/*
 * Lethal Injections
 */
/obj/structure/closet/secure/injection
	name = "lethal injections"
	req_access = list(ACCESS_CAPTAIN)

	starts_with = list(
		/obj/item/reagent_holder/ld50_syringe/chloral,
		/obj/item/reagent_holder/ld50_syringe/chloral
	)

/*
 * Brig
 */
/obj/structure/closet/secure/brig
	name = "brig locker"
	req_access = list(ACCESS_BRIG)
	anchored = TRUE

	starts_with = list(
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/shoes/orange
	)

	var/id = null

/*
 * Courtroom
 */
/obj/structure/closet/secure/courtroom
	name = "courtroom locker"
	req_access = list(ACCESS_COURT)

	starts_with = list(
		/obj/item/clothing/shoes/brown,
		/obj/item/paper/Court,
		/obj/item/paper/Court,
		/obj/item/paper/Court,
		/obj/item/pen,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/clothing/head/powdered_wig,
		/obj/item/storage/briefcase
	)

/*
 * Wall Locker
 */
/obj/structure/closet/secure/wall
	name = "wall locker"
	req_access = list(ACCESS_SECURITY)
	icon_state = "wall-locker1"
	density = TRUE
	icon_closed = "wall-locker"
	icon_locked = "wall-locker1"
	icon_opened = "wall-lockeropen"
	icon_broken = "wall-lockerbroken"
	icon_off = "wall-lockeroff"

	//too small to put a man in
	large = 0

/obj/structure/closet/secure/wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened