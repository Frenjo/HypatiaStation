//Mergesort: Specifically for record datums in a list.
/proc/sortRecord(list/datum/record/L, field = "name", order = 1)
	if(isnull(L))
		return list()
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1
	return mergeRecordLists(sortRecord(L.Copy(0, middle), field, order), sortRecord(L.Copy(middle), field, order), field, order)

//Mergsort: does the actual sorting and returns the results back to sortRecord
/proc/mergeRecordLists(list/datum/record/L, list/datum/record/R, field = "name", order = 1)
	var/Li = 1
	var/Ri = 1
	var/list/result = list()
	if(isnotnull(L) && isnotnull(R))
		while(Li <= length(L) && Ri <= length(R))
			var/datum/record/rL = L[Li]
			if(isnull(rL))
				L.Remove(rL)
				continue
			var/datum/record/rR = R[Ri]
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