/*
 * Holds procs to help with list operations
 * Contains groups:
 *			Misc
 *			Sorting
 */

/*
 * Misc
 */
//Returns a list in plain english as a string
/proc/english_list(list/input, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "")
	var/total = length(input)
	if(!total)
		return "[nothing_text]"
	else if(total == 1)
		return "[input[1]]"
	else if(total == 2)
		return "[input[1]][and_text][input[2]]"
	else
		var/output = ""
		var/index = 1
		while(index < total)
			if(index == total - 1)
				comma_text = final_comma_text

			output += "[input[index]][comma_text]"
			index++

		return "[output][and_text][input[index]]"

//Returns list element or null. Should prevent "index out of bounds" error.
/proc/listgetindex(list/list, index)
	if(length(list))
		if(isnum(index))
			if(InRange(index, 1, length(list)))
				return list[index]
		else if(index in list)
			return list[index]
	return

//Return either pick(list) or null if list is not of type /list or is empty
/proc/safepick(list/list)
	if(!length(list))
		return
	return pick(list)

//Checks if the list is empty
/proc/isemptylist(list/list)
	if(!length(list))
		return 1
	return 0

//Checks for specific types in a list
/proc/is_type_in_list(atom/A, list/L)
	for(var/type in L)
		if(istype(A, type))
			return 1
	return 0

//Empties the list by setting the length to 0. Hopefully the elements get garbage collected
/proc/clearlist(list/list)
	if(istype(list))
		list.len = 0
	return

//Removes any null entries from the list
/proc/listclearnulls(list/list)
	if(istype(list))
		while(null in list)
			list -= null
	return

/*
 * Returns list containing all the entries from first list that are not present in second.
 * If skiprep = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/difflist(list/first, list/second, skiprep = 0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = list()
	if(skiprep)
		for(var/e in first)
			if(!(e in result) && !(e in second))
				result.Add(e)
	else
		result = first - second
	return result

/*
 * Returns list containing entries that are in either list but not both.
 * If skipref = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/uniquemergelist(list/first, list/second, skiprep = 0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = list()
	if(skiprep)
		result = difflist(first, second, skiprep) + difflist(second, first, skiprep)
	else
		result = first ^ second
	return result

//Pretends to pick an element based on its weight but really just seems to pick a random element.
/proc/pickweight(list/L)
	var/total = 0
	var/item
	for(item in L)
		if(L[item])
			L[item] = 1
		total += L[item]

	total = rand(1, total)
	for(item in L)
		total -= L[item]
		if(total <= 0)
			return item

	return null

//Pick a random element from the list and remove it from the list.
/proc/pick_n_take(list/listfrom)
	if(length(listfrom))
		var/picked = pick(listfrom)
		listfrom.Remove(picked)
		return picked
	return null

//Returns the top(last) element from the list and removes it from the list (typical stack function)
/proc/pop(list/listfrom)
	if(length(listfrom))
		var/picked = listfrom[length(listfrom)]
		listfrom.len--
		return picked
	return null

//Returns the next element in parameter list after first appearance of parameter element. If it is the last element of the list or not present in list, returns first element.
/proc/next_in_list(element, list/L)
	for(var/i = 1, i < length(L), i++)
		if(L[i] == element)
			return L[i + 1]
	return L[1]

/*
 * Sorting
 */
//Reverses the order of items in the list
/proc/reverselist(list/L)
	var/list/output = list()
	if(!isnull(L))
		for(var/i = length(L); i >= 1; i--)
			output += L[i]
	return output

//Randomize: Return the list in a random order
/proc/shuffle(list/shufflelist)
	if(isnull(shufflelist))
		return
	var/list/new_list = list()
	var/list/old_list = shufflelist.Copy()
	while(length(old_list))
		var/item = pick(old_list)
		new_list.Add(item)
		old_list.Remove(item)
	return new_list

//Return a list with no duplicate entries
/proc/uniquelist(list/L)
	var/list/K = list()
	for(var/item in L)
		if(!(item in K))
			K.Add(item)
	return K

//Mergesort: divides up the list into halves to begin the sort
/proc/sortKey(list/client/L, order = 1)
	if(isnull(L) || length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1
	return mergeKey(sortKey(L.Copy(0, middle)), sortKey(L.Copy(middle)), order)

//Mergsort: does the actual sorting and returns the results back to sortAtom
/proc/mergeKey(list/client/L, list/client/R, order = 1)
	var/Li = 1
	var/Ri = 1
	var/list/result = list()
	while(Li <= length(L) && Ri <= length(R))
		var/client/rL = L[Li]
		var/client/rR = R[Ri]
		if(sorttext(rL.ckey, rR.ckey) == order)
			result += L[Li++]
		else
			result += R[Ri++]

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

//Mergesort: divides up the list into halves to begin the sort
/proc/sortAtom(list/atom/L, order = 1)
	if(isnull(L) || length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1
	return mergeAtoms(sortAtom(L.Copy(0, middle)), sortAtom(L.Copy(middle)), order)

//Mergsort: does the actual sorting and returns the results back to sortAtom
/proc/mergeAtoms(list/atom/L, list/atom/R, order = 1)
	var/Li = 1
	var/Ri = 1
	var/list/result = list()
	while(Li <= length(L) && Ri <= length(R))
		var/atom/rL = L[Li]
		var/atom/rR = R[Ri]
		if(sorttext(rL.name, rR.name) == order)
			result.Add(L[Li++])
		else
			result.Add(R[Ri++])

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

//Mergesort: Specifically for record datums in a list.
/proc/sortRecord(list/datum/data/record/L, field = "name", order = 1)
	if(isnull(L))
		return list()
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1
	return mergeRecordLists(sortRecord(L.Copy(0, middle), field, order), sortRecord(L.Copy(middle), field, order), field, order)

//Mergsort: does the actual sorting and returns the results back to sortRecord
/proc/mergeRecordLists(list/datum/data/record/L, list/datum/data/record/R, field = "name", order = 1)
	var/Li = 1
	var/Ri = 1
	var/list/result = list()
	if(!isnull(L) && !isnull(R))
		while(Li <= length(L) && Ri <= length(R))
			var/datum/data/record/rL = L[Li]
			if(isnull(rL))
				L.Remove(rL)
				continue
			var/datum/data/record/rR = R[Ri]
			if(isnull(rR))
				R.Remove(rR)
				continue
			if(sorttext(rL.fields[field], rR.fields[field]) == order)
				result.Add(L[Li++])
			else
				result.Add(R[Ri++])

		if(Li <= length(L))
			return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

//Mergesort: any value in a list
/proc/sortList(list/L)
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1 // Copy is first,second-1
	return mergeLists(sortList(L.Copy(0, middle)), sortList(L.Copy(middle))) //second parameter null = to end of list

//Mergsorge: uses sortList() but uses the var's name specifically. This should probably be using mergeAtom() instead
/proc/sortNames(list/L)
	var/list/Q = list()
	for(var/atom/x in L)
		Q[x.name] = x
	return sortList(Q)

/proc/mergeLists(list/L, list/R)
	var/Li = 1
	var/Ri = 1
	var/list/result = list()
	while(Li <= length(L) && Ri <= length(R))
		if(sorttext(L[Li], R[Ri]) < 1)
			result.Add(R[Ri++])
		else
			result.Add(L[Li++])

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

// List of lists, sorts by element[key] - for things like crew monitoring computer sorting records by name.
/proc/sortByKey(list/L, key)
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1
	return mergeKeyedLists(sortByKey(L.Copy(0, middle), key), sortByKey(L.Copy(middle), key), key)

/proc/mergeKeyedLists(list/L, list/R, key)
	var/Li = 1
	var/Ri = 1
	var/list/result = list()
	while(Li <= length(L) && Ri <= length(R))
		if(sorttext(L[Li][key], R[Ri][key]) < 1)
			// Works around list += list2 merging lists; it's not pretty but it works
			result.Add("temp item")
			result[length(result)] = R[Ri++]
		else
			result.Add("temp item")
			result[length(result)] = L[Li++]

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

//Mergesort: any value in a list, preserves key=value structure
/proc/sortAssoc(list/L)
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1 // Copy is first,second-1
	return mergeAssoc(sortAssoc(L.Copy(0, middle)), sortAssoc(L.Copy(middle))) //second parameter null = to end of list

/proc/mergeAssoc(list/L, list/R)
	var/Li = 1
	var/Ri = 1
	var/list/result = list()
	while(Li <= length(L) && Ri <= length(R))
		if(sorttext(L[Li], R[Ri]) < 1)
			result.Add(R&R[Ri++])
		else
			result.Add(L&L[Li++])

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

// Macros to test for bits in a bitfield. Note, that this is for use with indexes, not bit-masks!
#define BITTEST(bitfield, index) ((bitfield) & (1 << (index)))
#define BITSET(bitfield, index)  (bitfield) |= (1 << (index))
#define BITRESET(bitfield, index)  (bitfield) &= ~(1 << (index))
#define BITFLIP(bitfield, index)  (bitfield) ^= (1 << (index))

//Converts a bitfield to a list of numbers (or words if a wordlist is provided)
/proc/bitfield2list(bitfield = 0, list/wordlist)
	var/list/r = list()
	if(islist(wordlist))
		var/max = min(length(wordlist), 16)
		var/bit = 1
		for(var/i = 1, i <= max, i++)
			if(bitfield & bit)
				r.Add(wordlist[i])
			bit = bit << 1
	else
		for(var/bit = 1, bit <= 65535, bit = bit << 1)
			if(bitfield & bit)
				r.Add(bit)

	return r

// Returns the key based on the index
/proc/get_key_by_index(list/L, index)
	var/i = 1
	for(var/key in L)
		if(index == i)
			return key
		i++
	return null

/proc/count_by_type(list/L, type)
	var/i = 0
	for(var/T in L)
		if(istype(T, type))
			i++
	return i

//Don't use this on lists larger than half a dozen or so
/proc/insertion_sort_numeric_list_ascending(list/L)
	//world.log << "ascending len input: [length(L)]"
	var/list/out = list(pop(L))
	for(var/entry in L)
		if(isnum(entry))
			var/success = FALSE
			for(var/i = 1, i <= length(out), i++)
				if(entry <= out[i])
					success = TRUE
					out.Insert(i, entry)
					break
			if(!success)
				out.Add(entry)

	//world.log << "	output: [length(out)]"
	return out

/proc/insertion_sort_numeric_list_descending(list/L)
	//world.log << "descending len input: [length(L)]"
	var/list/out = insertion_sort_numeric_list_ascending(L)
	//world.log << "	output: [length(out)]"
	return reverselist(out)

/proc/dd_sortedObjectList(list/L, cache = list())
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1 // Copy is first,second-1
	return dd_mergeObjectList(dd_sortedObjectList(L.Copy(0, middle), cache), dd_sortedObjectList(L.Copy(middle), cache), cache) //second parameter null = to end of list

/proc/dd_mergeObjectList(list/L, list/R, list/cache)
	var/Li = 1
	var/Ri = 1
	var/list/result = list()
	while(Li <= length(L) && Ri <= length(R))
		var/LLi = L[Li]
		var/RRi = R[Ri]
		var/LLiV = cache[LLi]
		var/RRiV = cache[RRi]
		if(!LLiV)
			LLiV = LLi:dd_SortValue()
			cache[LLi] = LLiV
		if(!RRiV)
			RRiV = RRi:dd_SortValue()
			cache[RRi] = RRiV
		if(LLiV < RRiV)
			result.Add(L[Li++])
		else
			result.Add(R[Ri++])

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

// Insert an object into a sorted list, preserving sortedness
/proc/dd_insertObjectList(list/L, O)
	var/min = 1
	var/max = length(L)
	var/Oval = O:dd_SortValue()

	while(1)
		var/mid = min + round((max - min) / 2)

		if(mid == max)
			L.Insert(mid, O)
			return

		var/Lmid = L[mid]
		var/midval = Lmid:dd_SortValue()
		if(Oval == midval)
			L.Insert(mid, O)
			return
		else if(Oval < midval)
			max = mid
		else
			min = mid + 1

/datum/proc/dd_SortValue()
	return "[src]"

/obj/machinery/dd_SortValue()
	return "[sanitize(name)]"

/obj/machinery/camera/dd_SortValue()
	return "[c_tag]"

// Creates every subtype of the provided prototype and adds it to a list.
// If no list is provided, one is created.
/proc/init_subtypes(prototype, list/L = null)
	if(isnull(L))
		L = list()

	for(var/path in SUBTYPESOF(prototype))
		L.Add(new path())

	return L