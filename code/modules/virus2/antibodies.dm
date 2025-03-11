//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

// reserving some numbers for later special antigens
#define ANTIGEN_A BITFLAG(0)
#define ANTIGEN_B BITFLAG(1)
#define ANTIGEN_RH BITFLAG(2)
#define ANTIGEN_Q BITFLAG(3)
#define ANTIGEN_U BITFLAG(4)
#define ANTIGEN_V BITFLAG(5)
#define ANTIGEN_X BITFLAG(6)
#define ANTIGEN_Y BITFLAG(7)
#define ANTIGEN_Z BITFLAG(8)
#define ANTIGEN_M BITFLAG(9)
#define ANTIGEN_N BITFLAG(10)
#define ANTIGEN_P BITFLAG(11)
#define ANTIGEN_O BITFLAG(12)

GLOBAL_GLOBL_ALIST_INIT(antigen_list, list( // Change this to alist() when things get more stable.
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