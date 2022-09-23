/obj/structure/closet/secure_closet/captains
	name = "Captain's Locker"
	req_access = list(ACCESS_CAPTAIN)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

/obj/structure/closet/secure_closet/captains/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/captain(src)
	else
		new /obj/item/weapon/storage/satchel/cap(src)

	new /obj/item/clothing/suit/captunic(src)
	new /obj/item/clothing/suit/captunic/capjacket(src)
	new /obj/item/clothing/head/helmet/cap(src)
	new /obj/item/clothing/under/rank/captain(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/weapon/cartridge/captain(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/heads/captain(src)
	new /obj/item/clothing/gloves/captain(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/clothing/suit/armor/captain(src)
	new /obj/item/weapon/melee/telebaton(src)
	new /obj/item/clothing/under/dress/dress_cap(src)


/obj/structure/closet/secure_closet/hop
	name = "Head of Personnel's Locker"
	req_access = list(ACCESS_HOP)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"

/obj/structure/closet/secure_closet/hop/New()
	..()
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/weapon/cartridge/hop(src)
	new /obj/item/device/radio/headset/heads/hop(src)
	new /obj/item/weapon/storage/box/ids(src)
	new /obj/item/weapon/storage/box/ids(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/device/flash(src)


/obj/structure/closet/secure_closet/hop2
	name = "Head of Personnel's Attire"
	req_access = list(ACCESS_HOP)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"

/obj/structure/closet/secure_closet/hop2/New()
	..()
	new /obj/item/clothing/under/rank/head_of_personnel(src)
	new /obj/item/clothing/under/dress/dress_hop(src)
	new /obj/item/clothing/under/dress/dress_hr(src)
	new /obj/item/clothing/under/lawyer/female(src)
	new /obj/item/clothing/under/lawyer/black(src)
	new /obj/item/clothing/under/lawyer/red(src)
	new /obj/item/clothing/under/lawyer/oldman(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/leather(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/under/rank/head_of_personnel_whimsy(src)


/obj/structure/closet/secure_closet/hos
	name = "Head of Security's Locker"
	req_access = list(ACCESS_HOS)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

/obj/structure/closet/secure_closet/hos/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/satchel/sec(src)

	new /obj/item/clothing/head/helmet/HoS(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/under/rank/head_of_security/jensen(src)
	new /obj/item/clothing/under/rank/head_of_security/corp(src)
	new /obj/item/clothing/suit/armor/hos/jensen(src)
	new /obj/item/clothing/suit/armor/hos(src)
	new /obj/item/clothing/head/helmet/HoS/dermal(src)
	new /obj/item/weapon/cartridge/hos(src)
	new /obj/item/device/radio/headset/heads/hos(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/weapon/shield/riot(src)
	new /obj/item/weapon/storage/lockbox/loyalty(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/belt/security(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/clothing/tie/holster/waist(src)
	new /obj/item/weapon/melee/telebaton(src)


/obj/structure/closet/secure_closet/warden
	name = "Warden's Locker"
	req_access = list(ACCESS_ARMORY)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"

/obj/structure/closet/secure_closet/warden/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/satchel/sec(src)

	new /obj/item/clothing/suit/armor/vest/security(src)
	new /obj/item/clothing/under/rank/warden(src)
	new /obj/item/clothing/under/rank/warden/corp(src)
	new /obj/item/clothing/suit/armor/vest/warden(src)
	new /obj/item/clothing/head/helmet/warden(src)
//	new /obj/item/weapon/cartridge/security(src)
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/belt/security(src)
	new /obj/item/weapon/reagent_containers/spray/pepper(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/weapon/storage/box/holobadge(src)


/obj/structure/closet/secure_closet/security
	name = "Security Officer's Locker"
	req_access = list(ACCESS_SECURITY)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/security/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/security(src)
	else
		new /obj/item/weapon/storage/satchel/sec(src)

	new /obj/item/clothing/suit/armor/vest/security(src)
	new /obj/item/clothing/head/helmet(src)
//	new /obj/item/weapon/cartridge/security(src)
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/weapon/storage/belt/security(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/reagent_containers/spray/pepper(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/device/hailer(src)
	new /obj/item/clothing/tie/storage/black_vest(src)
	new /obj/item/clothing/head/soft/sec/corp(src)
	new /obj/item/clothing/under/rank/security/corp(src)


/obj/structure/closet/secure_closet/security/cargo

/obj/structure/closet/secure_closet/security/cargo/New()
	..()
	new /obj/item/clothing/tie/armband/cargo(src)
	new /obj/item/device/encryptionkey/headset_cargo(src)


/obj/structure/closet/secure_closet/security/engine

/obj/structure/closet/secure_closet/security/engine/New()
	..()
	new /obj/item/clothing/tie/armband/engine(src)
	new /obj/item/device/encryptionkey/headset_eng(src)


/obj/structure/closet/secure_closet/security/science

/obj/structure/closet/secure_closet/security/science/New()
	..()
	new /obj/item/clothing/tie/armband/science(src)
	new /obj/item/device/encryptionkey/headset_sci(src)


/obj/structure/closet/secure_closet/security/med

/obj/structure/closet/secure_closet/security/med/New()
	..()
	new /obj/item/clothing/tie/armband/medgreen(src)
	new /obj/item/device/encryptionkey/headset_med(src)


/obj/structure/closet/secure_closet/detective
	name = "Detective's Cabinet"
	req_access = list(ACCESS_FORENSICS_LOCKERS)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

/obj/structure/closet/secure_closet/detective/New()
	..()
	new /obj/item/clothing/under/det(src)
	new /obj/item/clothing/under/det/black(src)
	new /obj/item/clothing/under/det/slob(src)
	new /obj/item/clothing/suit/storage/det_suit(src)
	new /obj/item/clothing/suit/storage/det_suit/black(src)
	new /obj/item/clothing/suit/storage/forensics/blue(src)
	new /obj/item/clothing/suit/storage/forensics/red(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/head/det_hat(src)
	new /obj/item/clothing/head/det_hat/black(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/weapon/storage/box/evidence(src)
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/device/detective_scanner(src)
	new /obj/item/clothing/suit/armor/det_suit(src)
	new /obj/item/ammo_magazine/c45r(src)
	new /obj/item/ammo_magazine/c45r(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/weapon/gun/projectile/detective/semiauto(src)
	new /obj/item/clothing/tie/holster/armpit(src)


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

/obj/structure/closet/secure_closet/injection
	name = "Lethal Injections"
	req_access = list(ACCESS_CAPTAIN)

/obj/structure/closet/secure_closet/injection/New()
	..()
	new /obj/item/weapon/reagent_containers/ld50_syringe/choral(src)
	new /obj/item/weapon/reagent_containers/ld50_syringe/choral(src)


/obj/structure/closet/secure_closet/brig
	name = "Brig Locker"
	req_access = list(ACCESS_BRIG)
	anchored = TRUE
	var/id = null

/obj/structure/closet/secure_closet/brig/New()
	..()
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/shoes/orange(src)


/obj/structure/closet/secure_closet/courtroom
	name = "Courtroom Locker"
	req_access = list(ACCESS_COURT)

/obj/structure/closet/secure_closet/courtroom/New()
	..()
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/weapon/paper/Court(src)
	new /obj/item/weapon/paper/Court(src)
	new /obj/item/weapon/paper/Court(src)
	new /obj/item/weapon/pen(src)
	new /obj/item/clothing/suit/judgerobe(src)
	new /obj/item/clothing/head/powdered_wig(src)
	new /obj/item/weapon/storage/briefcase(src)


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
