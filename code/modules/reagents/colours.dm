/proc/mix_colour_from_reagents(list/reagent_list)
	if(isnull(reagent_list) || !length(reagent_list))
		return 0

	var/contents = length(reagent_list)
	var/list/weight = new /list(contents)
	var/list/red_colour = new /list(contents)
	var/list/green_colour = new /list(contents)
	var/list/blue_colour = new /list(contents)
	var/i

	//fill the list of weights
	for(i = 1; i <= contents; i++)
		var/datum/reagent/reagent = reagent_list[i]
		var/reagent_weight = reagent.volume
		if(istype(reagent, /datum/reagent/paint))
			reagent_weight *= 20 //Paint colours a mixture twenty times as much
		weight[i] = reagent_weight

	//fill the lists of colours
	for(i = 1; i <= contents; i++)
		var/datum/reagent/reagent = reagent_list[i]
		var/hue = reagent.color
		if(length(hue) != 7)
			return 0
		red_colour[i] = hex2num(copytext(hue, 2, 4))
		green_colour[i] = hex2num(copytext(hue, 4, 6))
		blue_colour[i] = hex2num(copytext(hue, 6, 8))

	//mix all the colors
	var/red = mix_one_colour(weight, red_colour)
	var/green = mix_one_colour(weight, green_colour)
	var/blue = mix_one_colour(weight, blue_colour)

	//assemble all the pieces
	var/finalcolour = "#[red][green][blue]"
	return finalcolour

/proc/mix_one_colour(list/weight, list/colour)
	if(isnull(weight) || isnull(colour) || length(weight) != length(colour))
		return 0

	var/contents = length(weight)
	var/i

	//normalize weights
	var/listsum = 0
	for(i = 1; i <= contents; i++)
		listsum += weight[i]
	for(i = 1; i <= contents; i++)
		weight[i] /= listsum

	//mix them
	var/mixedcolour = 0
	for(i = 1; i <= contents; i++)
		mixedcolour += weight[i] * colour[i]
	mixedcolour = round(mixedcolour)

	//until someone writes a formal proof for this algorithm, let's keep this in
	if(mixedcolour < 0x00 || mixedcolour > 0xFF)
		return 0

	var/finalcolour = num2hex(mixedcolour)
	while(length(finalcolour) < 2)
		finalcolour = "0[finalcolour]" //Takes care of leading zeroes
	return finalcolour