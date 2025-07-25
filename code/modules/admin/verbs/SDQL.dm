
//Structured Datum Query Language. Basically SQL meets BYOND objects.

//Note: For use in BS12, need text_starts_with proc, and to modify the action on select to use BS12's object edit command(s).

/client/proc/SDQL_query(query_text as message)
	set category = PANEL_ADMIN

	if(!check_rights(R_DEBUG))  //Shouldn't happen... but just to be safe.
		message_admins("\red ERROR: Non-admin [usr.key] attempted to execute a SDQL query!")
		log_admin("Non-admin [usr.key] attempted to execute a SDQL query!")

	var/list/query_list = SDQL_tokenize(query_text)

	if(length(query_list) < 2)
		if(length(query_list))
			usr << "\red SDQL: Too few discrete tokens in query \"[query_text]\". Please check your syntax and try again."
		return

	if(!(lowertext(query_list[1]) in list("select", "delete", "update")))
		usr << "\red SDQL: Unknown query type: \"[query_list[1]]\" in query \"[query_text]\". Please check your syntax and try again."
		return

	var/list/types = list()

	var/i
	for(i = 2; i <= length(query_list); i += 2)
		types += query_list[i]

		if(i + 1 >= length(query_list) || query_list[i + 1] != ",")
			break

	i++

	var/list/from = list()

	if(i <= length(query_list))
		if(lowertext(query_list[i]) in list("from", "in"))
			for(i++; i <= length(query_list); i += 2)
				from += query_list[i]

				if(i + 1 >= length(query_list) || query_list[i + 1] != ",")
					break

			i++

	if(!length(from))
		from += "world"

	var/list/set_vars = list()

	if(lowertext(query_list[1]) == "update")
		if(i <= length(query_list) && lowertext(query_list[i]) == "set")
			for(i++; i <= length(query_list); i++)
				if(i + 2 <= length(query_list) && query_list[i + 1] == "=")
					set_vars += query_list[i]
					set_vars[query_list[i]] = query_list[i + 2]

				else
					usr << "\red SDQL: Invalid set parameter in query \"[query_text]\". Please check your syntax and try again."
					return

				i += 3

				if(i >= length(query_list) || query_list[i] != ",")
					break

		if(length(set_vars) < 1)
			usr << "\red SDQL: Invalid or missing set in query \"[query_text]\". Please check your syntax and try again."
			return

	var/list/where = list()

	if(i <= length(query_list) && lowertext(query_list[i]) == "where")
		where = query_list.Copy(i + 1)

	var/list/from_objs = list()
	if("world" in from)
		from_objs += world
	else
		for(var/f in from)
			if(copytext(f, 1, 2) == "'" || copytext(f, 1, 2) == "\"")
				from_objs += locate(copytext(f, 2, length(f)))
			else if(copytext(f, 1, 2) != "/")
				from_objs += locate(f)
			else
				var/f2 = text2path(f)
				if(text_starts_with(f, "/mob"))
					for_no_type_check(var/mob/m, GLOBL.mob_list)
						if(istype(m, f2))
							from_objs += m

				else if(text_starts_with(f, "/turf/space"))
					for(var/turf/space/m in world)
						if(istype(m, f2))
							from_objs += m

				else if(text_starts_with(f, "/turf/open"))
					for_no_type_check(var/turf/open/m, GLOBL.open_turf_list)
						if(istype(m, f2))
							from_objs += m

				else if(text_starts_with(f, "/turf"))
					for(var/turf/m in world)
						if(istype(m, f2))
							from_objs += m

				else if(text_starts_with(f, "/area"))
					for_no_type_check(var/area/m, GLOBL.area_list)
						if(istype(m, f2))
							from_objs += m

				else if(text_starts_with(f, "/obj/item"))
					for(var/obj/item/m in GLOBL.movable_atom_list)
						if(istype(m, f2))
							from_objs += m

				else if(text_starts_with(f, "/obj/machinery"))
					for_no_type_check(var/obj/machinery/m, global.PCmachinery.machines)
						if(istype(m, f2))
							from_objs += m

				else if(text_starts_with(f, "/obj"))
					for(var/obj/m in GLOBL.movable_atom_list)
						if(istype(m, f2))
							from_objs += m

				else if(text_starts_with(f, "/atom"))
					for(var/atom/m in world)
						if(istype(m, f2))
							from_objs += m
/*
				else
					for(var/datum/m in world)
						if(istype(m, f2))
							from_objs += m
*/

	var/list/objs = list()

	for(var/from_obj in from_objs)
		if("*" in types)
			objs += from_obj:contents
		else
			for(var/f in types)
				if(copytext(f, 1, 2) == "'" || copytext(f, 1, 2) == "\"")
					objs += locate(copytext(f, 2, length(f))) in from_obj
				else if(copytext(f, 1, 2) != "/")
					objs += locate(f) in from_obj
				else
					var/f2 = text2path(f)
					if(text_starts_with(f, "/mob"))
						for(var/mob/m in from_obj)
							if(istype(m, f2))
								objs += m

					else if(text_starts_with(f, "/turf/space"))
						for(var/turf/space/m in from_obj)
							if(istype(m, f2))
								objs += m

					else if(text_starts_with(f, "/turf/open"))
						for(var/turf/open/m in from_obj)
							if(istype(m, f2))
								objs += m

					else if(text_starts_with(f, "/turf"))
						for(var/turf/m in from_obj)
							if(istype(m, f2))
								objs += m

					else if(text_starts_with(f, "/area"))
						for(var/area/m in from_obj)
							if(istype(m, f2))
								objs += m

					else if(text_starts_with(f, "/obj/item"))
						for(var/obj/item/m in from_obj)
							if(istype(m, f2))
								objs += m

					else if(text_starts_with(f, "/obj/machinery"))
						for(var/obj/machinery/m in from_obj)
							if(istype(m, f2))
								objs += m

					else if(text_starts_with(f, "/obj"))
						for(var/obj/m in from_obj)
							if(istype(m, f2))
								objs += m

					else if(text_starts_with(f, "/atom"))
						for(var/atom/m in from_obj)
							if(istype(m, f2))
								objs += m

					else
						for(var/datum/m in from_obj)
							if(istype(m, f2))
								objs += m


	for(var/datum/t in objs)
		var/currently_false = 0
		for(i = 1, i - 1 < length(where), i++)
			var/v = where[i++]
			var/compare_op = where[i++]
			if(!(compare_op in list("==", "=", "<>", "<", ">", "<=", ">=", "!=")))
				usr << "\red SDQL: Unknown comparison operator [compare_op] in where clause following [v] in query \"[query_text]\". Please check your syntax and try again."
				return

			var/j
			for(j = i, j <= length(where), j++)
				if(lowertext(where[j]) in list("and", "or", ";"))
					break

			if(!currently_false)
				var/value = SDQL_text2value(t, v)
				var/result = SDQL_evaluate(t, where.Copy(i, j))

				switch(compare_op)
					if("=", "==")
						currently_false = !(value == result)

					if("!=", "<>")
						currently_false = !(value != result)

					if("<")
						currently_false = !(value < result)

					if(">")
						currently_false = !(value > result)

					if("<=")
						currently_false = !(value <= result)

					if(">=")
						currently_false = !(value >= result)


			if(j > length(where) || lowertext(where[j]) == ";")
				break
			else if(lowertext(where[j]) == "or")
				if(currently_false)
					currently_false = 0
				else
					break

			i = j

		if(currently_false)
			objs -= t



	usr << "\blue SQDL Query: [query_text]"
	message_admins("[usr] executed SDQL query: \"[query_text]\".")
/*
	for(var/t in types)
		usr << "Type: [t]"

	for(var/t in from)
		usr << "From: [t]"

	for(var/t in set_vars)
		usr << "Set: [t] = [set_vars[t]]"

	if(length(where))
		var/where_str = ""
		for(var/t in where)
			where_str += "[t] "

		usr << "Where: [where_str]"

	usr << "From objects:"
	for(var/datum/t in from_objs)
		usr << t

	usr << "Objects:"
	for(var/datum/t in objs)
		usr << t
*/
	switch(lowertext(query_list[1]))
		if("delete")
			for(var/datum/t in objs)
				qdel(t)

		if("update")
			for(var/datum/t in objs)
				objs[t] = list()
				for(var/v in set_vars)
					if(v in t.vars)
						objs[t][v] = SDQL_text2value(t, set_vars[v])

			for(var/datum/t in objs)
				for(var/v in objs[t])
					t.vars[v] = objs[t][v]

		if("select")
			var/text = ""
			for(var/datum/t in objs)
				if(isatom(t))
					var/atom/a = t

					if(a.x)
						text += "<a href='byond://?src=\ref[t];SDQL_select=\ref[t]'>\ref[t]</a>: [t] at ([a.x], [a.y], [a.z])<br>"

					else if(a.loc && a.loc.x)
						text += "<a href='byond://?src=\ref[t];SDQL_select=\ref[t]'>\ref[t]</a>: [t] in [a.loc] at ([a.loc.x], [a.loc.y], [a.loc.z])<br>"

					else
						text += "<a href='byond://?src=\ref[t];SDQL_select=\ref[t]'>\ref[t]</a>: [t]<br>"

				else
					text += "<a href='byond://?src=\ref[t];SDQL_select=\ref[t]'>\ref[t]</a>: [t]<br>"

				//text += "[t]<br>"
			usr << browse(text, "window=sdql_result")


/client/Topic(href, list/href_list, hsrc)
	if(href_list["SDQL_select"])
		debug_variables(locate(href_list["SDQL_select"]))

	..()


/proc/SDQL_evaluate(datum/object, list/equation)
	if(!length(equation))
		return null

	else if(length(equation) == 1)
		return SDQL_text2value(object, equation[1])

	else if(equation[1] == "!")
		return !SDQL_evaluate(object, equation.Copy(2))

	else if(equation[1] == "-")
		return -SDQL_evaluate(object, equation.Copy(2))


	else
		usr << "\red SDQL: Sorry, equations not yet supported :("
		return null


/proc/SDQL_text2value(datum/object, text)
	if(text2num(text) != null)
		return text2num(text)
	else if(text == "null")
		return null
	else if(copytext(text, 1, 2) == "'" || copytext(text, 1, 2) == "\"" )
		return copytext(text, 2, length(text))
	else if(copytext(text, 1, 2) == "/")
		return text2path(text)
	else
		if(findtext(text, "."))
			var/split = findtext(text, ".")
			var/v = copytext(text, 1, split)

			if((v in object.vars) && isdatum(object.vars[v]))
				return SDQL_text2value(object.vars[v], copytext(text, split + 1))
			else
				return null

		else
			if(text in object.vars)
				return object.vars[text]
			else
				return null


/proc/text_starts_with(text, start)
	if(copytext(text, 1, length(start) + 1) == start)
		return 1
	else
		return 0





/proc/SDQL_tokenize(query_text)

	var/list/whitespace = list(" ", "\n", "\t")
	var/list/single = list("(", ")", ",", "+", "-")
	var/list/multi = list(
					"=" = list("", "="),
					"<" = list("", "=", ">"),
					">" = list("", "="),
					"!" = list("", "="))

	var/word = ""
	var/list/query_list = list()
	var/len = length(query_text)

	for(var/i = 1, i <= len, i++)
		var/char = copytext(query_text, i, i + 1)

		if(char in whitespace)
			if(word != "")
				query_list += word
				word = ""

		else if(char in single)
			if(word != "")
				query_list += word
				word = ""

			query_list += char

		else if(char in multi)
			if(word != "")
				query_list += word
				word = ""

			var/char2 = copytext(query_text, i + 1, i + 2)

			if(char2 in multi[char])
				query_list += "[char][char2]"
				i++

			else
				query_list += char

		else if(char == "'")
			if(word != "")
				usr << "\red SDQL: You have an error in your SDQL syntax, unexpected ' in query: \"<font color=gray>[query_text]</font>\" following \"<font color=gray>[word]</font>\". Please check your syntax, and try again."
				return null

			word = "'"

			for(i++, i <= len, i++)
				char = copytext(query_text, i, i + 1)

				if(char == "'")
					if(copytext(query_text, i + 1, i + 2) == "'")
						word += "'"
						i++

					else
						break

				else
					word += char

			if(i > len)
				usr << "\red SDQL: You have an error in your SDQL syntax, unmatched ' in query: \"<font color=gray>[query_text]</font>\". Please check your syntax, and try again."
				return null

			query_list += "[word]'"
			word = ""

		else if(char == "\"")
			if(word != "")
				usr << "\red SDQL: You have an error in your SDQL syntax, unexpected \" in query: \"<font color=gray>[query_text]</font>\" following \"<font color=gray>[word]</font>\". Please check your syntax, and try again."
				return null

			word = "\""

			for(i++, i <= len, i++)
				char = copytext(query_text, i, i + 1)

				if(char == "\"")
					if(copytext(query_text, i + 1, i + 2) == "'")
						word += "\""
						i++

					else
						break

				else
					word += char

			if(i > len)
				usr << "\red SDQL: You have an error in your SDQL syntax, unmatched \" in query: \"<font color=gray>[query_text]</font>\". Please check your syntax, and try again."
				return null

			query_list += "[word]\""
			word = ""

		else
			word += char

	if(word != "")
		query_list += word

	return query_list
