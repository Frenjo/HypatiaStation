//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

// reserving some numbers for later special antigens
/var/global/const/ANTIGEN_A	= 1
/var/global/const/ANTIGEN_B	= 2
/var/global/const/ANTIGEN_RH	= 4
/var/global/const/ANTIGEN_Q	= 8
/var/global/const/ANTIGEN_U	= 16
/var/global/const/ANTIGEN_V	= 32
/var/global/const/ANTIGEN_X	= 64
/var/global/const/ANTIGEN_Y	= 128
/var/global/const/ANTIGEN_Z	= 256
/var/global/const/ANTIGEN_M	= 512
/var/global/const/ANTIGEN_N	= 1024
/var/global/const/ANTIGEN_P	= 2048
/var/global/const/ANTIGEN_O	= 4096

GLOBAL_GLOBL_LIST_INIT(antigen_list, list(
	"[ANTIGEN_A]" = "A",
	"[ANTIGEN_B]" = "B",
	"[ANTIGEN_RH]" = "RH",
	"[ANTIGEN_Q]" = "Q",
	"[ANTIGEN_U]" = "U",
	"[ANTIGEN_V]" = "V",
	"[ANTIGEN_Z]" = "Z",
	"[ANTIGEN_M]" = "M",
	"[ANTIGEN_N]" = "N",
	"[ANTIGEN_P]" = "P",
	"[ANTIGEN_O]" = "O"
))

// pure concentrated antibodies
/datum/reagent/antibodies
	name = "Antibodies"
	id = "antibodies"
	reagent_state = REAGENT_LIQUID
	color = "#0050F0"
	data = list("antibodies" = 0)

/datum/reagent/antibodies/reaction_mob(mob/M, method = TOUCH, volume)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(data && method == INGEST)
			if(C.virus2)
				for(var/datum/disease2/disease/D in C.virus2)
					if(data["antibodies"] & D.antigen)
						D.dead = 1
			C.antibodies |= data["antibodies"]
	return

// iterate over the list of antigens and see what matches
/proc/antigens2string(antigens)
	var/code = ""
	for(var/V in GLOBL.antigen_list)
		if(text2num(V) & antigens)
			code += GLOBL.antigen_list[V]
	return code