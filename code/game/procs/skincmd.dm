/mob/var/skincmds = list()
/obj/proc/SkinCmd(mob/user as mob, data as text)

/proc/SkinCmdRegister(mob/user, name as text, O as obj)
	user.skincmds[name] = O

/mob/verb/skincmd(data as text)
	set hidden = 1

	var/ref = copytext(data, 1, findtext(data, ";"))
	if(isnotnull(src.skincmds[ref]))
		var/obj/a = src.skincmds[ref]
		a.SkinCmd(src, copytext(data, findtext(data, ";") + 1))