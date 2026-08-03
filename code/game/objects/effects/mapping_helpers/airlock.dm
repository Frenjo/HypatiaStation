/obj/effect/mapping_helper/initialise()
	. = ..()
	return INITIALISE_LATE_QDEL

/obj/effect/mapping_helper/airlock/late_initialise()
	. = ..()
	var/obj/machinery/door/airlock/target = locate(/obj/machinery/door/airlock) in loc
	if(isnotnull(target))
		payload(target)

/obj/effect/mapping_helper/airlock/proc/payload(obj/machinery/door/airlock/target)
	return

/obj/effect/mapping_helper/airlock/lock
	name = "airlock lock helper"
	icon_state = "airlock_locked"

/obj/effect/mapping_helper/airlock/lock/payload(obj/machinery/door/airlock/target)
	target.locked = TRUE
	target.update_icon()

/obj/effect/mapping_helper/airlock/autoname
	name = "airlock autoname helper"
	icon_state = "airlock_autoname"

/obj/effect/mapping_helper/airlock/autoname/payload(obj/machinery/door/airlock/target)
	var/area/target_area = GET_AREA(target)
	target.name = target_area.name

/obj/effect/mapping_helper/airlock/access
	name = "airlock access helper"
	icon_state = "airlock_access"

	var/list/access_list = null

/obj/effect/mapping_helper/airlock/access/payload(obj/machinery/door/airlock/target)
	target.req_one_access = access_list

/obj/effect/mapping_helper/airlock/access/atmospherics
	name = "airlock atmos access helper"
	icon_state = "airlock_access_atmos"
	access_list = list(ACCESS_ATMOSPHERICS)

/obj/effect/mapping_helper/airlock/access/supply
	name = "airlock supply access helper"
	icon_state = "airlock_access_sup"
	access_list = list(ACCESS_CARGO, ACCESS_MINING)

/obj/effect/mapping_helper/airlock/access/supply/cargo
	name = "airlock cargo access helper"
	icon_state = "airlock_access_cargo"
	access_list = list(ACCESS_CARGO)

/obj/effect/mapping_helper/airlock/access/supply/mining
	name = "airlock mining access helper"
	icon_state = "airlock_access_mine"
	access_list = list(ACCESS_MINING)

/obj/effect/mapping_helper/airlock/access/supply/mining/eva
	name = "airlock mining eva access helper"
	icon_state = "airlock_access_mine_eva"
	access_list = list(ACCESS_MINING, ACCESS_XENOARCH)

/obj/effect/mapping_helper/airlock/access/engineering
	name = "airlock engi access helper"
	icon_state = "airlock_access_engi"
	access_list = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP)

/obj/effect/mapping_helper/airlock/access/engineering/atmos
	name = "airlock engi/atmos access helper"
	icon_state = "airlock_access_engi_atmos"
	access_list = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_ATMOSPHERICS)

/obj/effect/mapping_helper/airlock/access/medical
	name = "airlock med access helper"
	icon_state = "airlock_access_med"
	access_list = list(ACCESS_MEDICAL, ACCESS_CHEMISTRY, ACCESS_VIROLOGY)

/obj/effect/mapping_helper/airlock/access/research
	name = "airlock sci access helper"
	icon_state = "airlock_access_sci"
	access_list = list(ACCESS_RESEARCH)

/obj/effect/mapping_helper/airlock/access/research/xenoarch
	name = "airlock xenoarch access helper"
	icon_state = "airlock_access_xenoarch"
	access_list = list(ACCESS_XENOARCH)

/obj/effect/mapping_helper/airlock/access/security
	name = "airlock sec access helper"
	icon_state = "airlock_access_sec"
	access_list = list(ACCESS_SECURITY, ACCESS_BRIG)

/obj/effect/mapping_helper/airlock/access/security/doors
	name = "airlock sec doors access helper"
	icon_state = "airlock_access_sec_doors"
	access_list = list(ACCESS_SECURITY, ACCESS_BRIG, ACCESS_SEC_DOORS)

/obj/effect/mapping_helper/airlock/access/command
	name = "airlock command access helper"
	icon_state = "airlock_access_comm"
	access_list = list(ACCESS_BRIDGE)

/obj/effect/mapping_helper/airlock/access/tcomsat
	name = "airlock tcomsat access helper"
	icon_state = "airlock_access"
	access_list = list(ACCESS_TCOMSAT)