/obj/machinery/computer/disease_curer
	name = "cure research machine"
	icon_state = "dna"
	circuit = /obj/item/circuitboard/cure_research_machine

	var/curing
	var/virusing

	var/obj/item/reagent_containers/container = null

/obj/machinery/computer/disease_curer/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers))
		if(isnull(container))
			container = I
			user.drop_item()
			I.loc = src
		return TRUE

	if(istype(I, /obj/item/virusdish))
		if(virusing)
			user << "<b>The pathogen materializer is still recharging.."
			return TRUE
		var/obj/item/reagent_containers/glass/beaker/product = new /obj/item/reagent_containers/glass/beaker(loc)

		var/list/data = list("donor" = null, "viruses" = null, "blood_DNA" = null, "blood_type" = null, "resistances" = null, "trace_chem" = null, "virus2" = list(), "antibodies" = 0)
		data["virus2"] |= I:virus2
		product.reagents.add_reagent("blood", 30, data)

		virusing = TRUE
		spawn(120 SECONDS)
			virusing = FALSE

		state("The [src.name] buzzes", "blue")
		return TRUE

	return ..()

/obj/machinery/computer/disease_curer/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/disease_curer/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/disease_curer/attack_hand(mob/user)
	if(..())
		return
	user.machine = src
	var/dat
	if(curing)
		dat = "Antibody production in progress"
	else if(virusing)
		dat = "Virus production in progress"
	else if(container)
		// see if there's any blood in the container
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in container.reagents.reagent_list

		if(B)
			dat = "Blood sample inserted."
			var/code = ""
			for(var/V in GLOBL.antigen_list)
				if(text2num(V) & B.data["antibodies"])
					code += GLOBL.antigen_list[V]
			dat += "<BR>Antibodies: [code]"
			dat += "<BR><A href='byond://?src=\ref[src];antibody=1'>Begin antibody production</a>"
		else
			dat += "<BR>Please check container contents."
		dat += "<BR><A href='byond://?src=\ref[src];eject=1'>Eject container</a>"
	else
		dat = "Please insert a container."

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/disease_curer/process()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)

	if(curing)
		curing -= 1
		if(curing == 0)
			if(container)
				createcure(container)
	return

/obj/machinery/computer/disease_curer/Topic(href, href_list)
	if(..())
		return
	usr.machine = src

	if (href_list["antibody"])
		curing = 10
	else if(href_list["eject"])
		container.loc = src.loc
		container = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/obj/machinery/computer/disease_curer/proc/createcure(var/obj/item/reagent_containers/container)
	var/obj/item/reagent_containers/glass/beaker/product = new(src.loc)
	var/datum/reagent/blood/B = locate() in container.reagents.reagent_list

	var/list/data = list()
	data["antibodies"] = B.data["antibodies"]
	product.reagents.add_reagent("antibodies",30,data)

	state("\The [src.name] buzzes", "blue")
