/*
 * Captain
 */
/obj/structure/closet/secure_closet/captains
	name = "Captain's Locker"
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
		/obj/item/weapon/cartridge/captain,
		/obj/item/clothing/head/helmet/swat,
		/obj/item/clothing/shoes/brown,
		/obj/item/device/radio/headset/heads/captain,
		/obj/item/clothing/gloves/captain,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/suit/armor/captain,
		/obj/item/weapon/melee/telebaton,
		/obj/item/clothing/under/dress/dress_cap
	)

/obj/structure/closet/secure_closet/captains/New()
	if(prob(50))
		starts_with.Add(/obj/item/weapon/storage/backpack/captain)
	else
		starts_with.Add(/obj/item/weapon/storage/satchel/cap)
	. = ..()

/*
 * Head of Personnel
 */
/obj/structure/closet/secure_closet/hop
	name = "Head of Personnel's Locker"
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
		/obj/item/weapon/cartridge/hop,
		/obj/item/device/radio/headset/heads/hop,
		/obj/item/weapon/storage/box/ids,
		/obj/item/weapon/storage/box/ids,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/device/flash
	)

/*
 * Head of Personnel Attire
 */
/obj/structure/closet/secure_closet/hop2
	name = "Head of Personnel's Attire"
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
/obj/structure/closet/secure_closet/hos
	name = "Head of Security's Locker"
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
		/obj/item/weapon/cartridge/hos,
		/obj/item/device/radio/headset/heads/hos,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/weapon/shield/riot,
		/obj/item/weapon/storage/lockbox/loyalty,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/belt/security,
		/obj/item/device/flash,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/tie/holster/waist,
		/obj/item/weapon/melee/telebaton
	)

/obj/structure/closet/secure_closet/hos/New()
	if(prob(50))
		starts_with.Add(/obj/item/weapon/storage/backpack/security)
	else
		starts_with.Add(/obj/item/weapon/storage/satchel/sec)
	. = ..()

/*
 * Warden
 */
/obj/structure/closet/secure_closet/warden
	name = "Warden's Locker"
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
	//	/obj/item/weapon/cartridge/security,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/weapon/storage/box/flashbangs,
		/obj/item/weapon/storage/belt/security,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/weapon/storage/box/holobadge
	)

/obj/structure/closet/secure_closet/warden/New()
	if(prob(50))
		starts_with.Add(/obj/item/weapon/storage/backpack/security)
	else
		starts_with.Add(/obj/item/weapon/storage/satchel/sec)
	. = ..()

/*
 * Security Officer
 */
/obj/structure/closet/secure_closet/security
	name = "Security Officer's Locker"
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
	//	/obj/item/weapon/cartridge/security,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/weapon/storage/belt/security,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/grenade/flashbang,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/device/hailer,
		/obj/item/clothing/tie/storage/black_vest,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp
	)

/obj/structure/closet/secure_closet/security/New()
	if(prob(50))
		starts_with.Add(/obj/item/weapon/storage/backpack/security)
	else
		starts_with.Add(/obj/item/weapon/storage/satchel/sec)
	. = ..()

/obj/structure/closet/secure_closet/security/cargo/New()
	starts_with.Add(/obj/item/clothing/tie/armband/cargo)
	starts_with.Add(/obj/item/device/encryptionkey/headset_cargo)
	. = ..()

/obj/structure/closet/secure_closet/security/engine/New()
	starts_with.Add(/obj/item/clothing/tie/armband/engine)
	starts_with.Add(/obj/item/device/encryptionkey/headset_eng)
	. = ..()

/obj/structure/closet/secure_closet/security/science/New()
	starts_with.Add(/obj/item/clothing/tie/armband/science)
	starts_with.Add(/obj/item/device/encryptionkey/headset_sci)
	. = ..()

/obj/structure/closet/secure_closet/security/med/New()
	starts_with.Add(/obj/item/clothing/tie/armband/medgreen)
	starts_with.Add(/obj/item/device/encryptionkey/headset_med)
	. = ..()

/*
 * Detective
 */
/obj/structure/closet/secure_closet/detective
	name = "Detective's Cabinet"
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
		/obj/item/weapon/storage/box/evidence,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/device/detective_scanner,
		/obj/item/clothing/suit/armor/det_suit,
		/obj/item/ammo_magazine/c45r,
		/obj/item/ammo_magazine/c45r,
		/obj/item/taperoll/police,
		/obj/item/weapon/gun/projectile/detective/semiauto,
		/obj/item/clothing/tie/holster/armpit
	)

/obj/structure/closet/secure_closet/detective/update_icon()
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
/obj/structure/closet/secure_closet/injection
	name = "Lethal Injections"
	req_access = list(ACCESS_CAPTAIN)

	starts_with = list(
		/obj/item/weapon/reagent_containers/ld50_syringe/choral,
		/obj/item/weapon/reagent_containers/ld50_syringe/choral
	)

/*
 * Brig
 */
/obj/structure/closet/secure_closet/brig
	name = "Brig Locker"
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
/obj/structure/closet/secure_closet/courtroom
	name = "Courtroom Locker"
	req_access = list(ACCESS_COURT)

	starts_with = list(
		/obj/item/clothing/shoes/brown,
		/obj/item/weapon/paper/Court,
		/obj/item/weapon/paper/Court,
		/obj/item/weapon/paper/Court,
		/obj/item/weapon/pen,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/clothing/head/powdered_wig,
		/obj/item/weapon/storage/briefcase
	)

/*
 * Wall Locker
 */
/obj/structure/closet/secure_closet/wall
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

/obj/structure/closet/secure_closet/wall/update_icon()
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