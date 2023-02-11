/stack
	var/list/contents = new

/stack/proc/Push(value)
	contents += value

/stack/proc/Pop()
	if(!length(contents))
		return null
	. = contents[length(contents)]
	contents.len--

/stack/proc/Top() //returns the item on the top of the stack without removing it
	if(!length(contents))
		return null
	return contents[length(contents)]

/stack/proc/Copy()
	var/stack/S = new()
	S.contents = src.contents.Copy()
	return S

/stack/proc/Clear()
	contents.Cut()