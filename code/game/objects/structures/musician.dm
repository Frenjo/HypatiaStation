//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/datum/song
	var/name = "Untitled"
	var/list/lines = list()
	var/tempo = 5

/obj/structure/device/piano
	name = "space minimoog"
	icon = 'icons/obj/musician.dmi'
	icon_state = "minimoog"
	anchored = TRUE
	density = TRUE
	var/datum/song/song
	var/playing = 0
	var/help = 0
	var/edit = 1
	var/repeat = 0

/obj/structure/device/piano/initialise()
	. = ..()
	if(prob(50))
		name = "space minimoog"
		desc = "This is a minimoog, like a space piano, but more spacey!"
		icon_state = "minimoog"
	else
		name = "space piano"
		desc = "This is a space piano, like a regular piano, but always in tune! Even if the musician isn't."
		icon_state = "piano"

/obj/structure/device/piano/proc/playnote(note as text)
	//to_world("Note: [note]")
	var/soundfile
	/*BYOND loads resource files at compile time if they are ''. This means you can't really manipulate them dynamically.
	Tried doing it dynamically at first but its more trouble than its worth. Would have saved many lines tho.*/
	switch(note)
		if("Cn1")	soundfile = 'sound/instruments/piano/Cn1.ogg'
		if("C#1")	soundfile = 'sound/instruments/piano/C#1.ogg'
		if("Db1")	soundfile = 'sound/instruments/piano/Db1.ogg'
		if("Dn1")	soundfile = 'sound/instruments/piano/Dn1.ogg'
		if("D#1")	soundfile = 'sound/instruments/piano/D#1.ogg'
		if("Eb1")	soundfile = 'sound/instruments/piano/Eb1.ogg'
		if("En1")	soundfile = 'sound/instruments/piano/En1.ogg'
		if("E#1")	soundfile = 'sound/instruments/piano/E#1.ogg'
		if("Fb1")	soundfile = 'sound/instruments/piano/Fb1.ogg'
		if("Fn1")	soundfile = 'sound/instruments/piano/Fn1.ogg'
		if("F#1")	soundfile = 'sound/instruments/piano/F#1.ogg'
		if("Gb1")	soundfile = 'sound/instruments/piano/Gb1.ogg'
		if("Gn1")	soundfile = 'sound/instruments/piano/Gn1.ogg'
		if("G#1")	soundfile = 'sound/instruments/piano/G#1.ogg'
		if("Ab1")	soundfile = 'sound/instruments/piano/Ab1.ogg'
		if("An1")	soundfile = 'sound/instruments/piano/An1.ogg'
		if("A#1")	soundfile = 'sound/instruments/piano/A#1.ogg'
		if("Bb1")	soundfile = 'sound/instruments/piano/Bb1.ogg'
		if("Bn1")	soundfile = 'sound/instruments/piano/Bn1.ogg'
		if("B#1")	soundfile = 'sound/instruments/piano/B#1.ogg'
		if("Cb2")	soundfile = 'sound/instruments/piano/Cb2.ogg'
		if("Cn2")	soundfile = 'sound/instruments/piano/Cn2.ogg'
		if("C#2")	soundfile = 'sound/instruments/piano/C#2.ogg'
		if("Db2")	soundfile = 'sound/instruments/piano/Db2.ogg'
		if("Dn2")	soundfile = 'sound/instruments/piano/Dn2.ogg'
		if("D#2")	soundfile = 'sound/instruments/piano/D#2.ogg'
		if("Eb2")	soundfile = 'sound/instruments/piano/Eb2.ogg'
		if("En2")	soundfile = 'sound/instruments/piano/En2.ogg'
		if("E#2")	soundfile = 'sound/instruments/piano/E#2.ogg'
		if("Fb2")	soundfile = 'sound/instruments/piano/Fb2.ogg'
		if("Fn2")	soundfile = 'sound/instruments/piano/Fn2.ogg'
		if("F#2")	soundfile = 'sound/instruments/piano/F#2.ogg'
		if("Gb2")	soundfile = 'sound/instruments/piano/Gb2.ogg'
		if("Gn2")	soundfile = 'sound/instruments/piano/Gn2.ogg'
		if("G#2")	soundfile = 'sound/instruments/piano/G#2.ogg'
		if("Ab2")	soundfile = 'sound/instruments/piano/Ab2.ogg'
		if("An2")	soundfile = 'sound/instruments/piano/An2.ogg'
		if("A#2")	soundfile = 'sound/instruments/piano/A#2.ogg'
		if("Bb2")	soundfile = 'sound/instruments/piano/Bb2.ogg'
		if("Bn2")	soundfile = 'sound/instruments/piano/Bn2.ogg'
		if("B#2")	soundfile = 'sound/instruments/piano/B#2.ogg'
		if("Cb3")	soundfile = 'sound/instruments/piano/Cb3.ogg'
		if("Cn3")	soundfile = 'sound/instruments/piano/Cn3.ogg'
		if("C#3")	soundfile = 'sound/instruments/piano/C#3.ogg'
		if("Db3")	soundfile = 'sound/instruments/piano/Db3.ogg'
		if("Dn3")	soundfile = 'sound/instruments/piano/Dn3.ogg'
		if("D#3")	soundfile = 'sound/instruments/piano/D#3.ogg'
		if("Eb3")	soundfile = 'sound/instruments/piano/Eb3.ogg'
		if("En3")	soundfile = 'sound/instruments/piano/En3.ogg'
		if("E#3")	soundfile = 'sound/instruments/piano/E#3.ogg'
		if("Fb3")	soundfile = 'sound/instruments/piano/Fb3.ogg'
		if("Fn3")	soundfile = 'sound/instruments/piano/Fn3.ogg'
		if("F#3")	soundfile = 'sound/instruments/piano/F#3.ogg'
		if("Gb3")	soundfile = 'sound/instruments/piano/Gb3.ogg'
		if("Gn3")	soundfile = 'sound/instruments/piano/Gn3.ogg'
		if("G#3")	soundfile = 'sound/instruments/piano/G#3.ogg'
		if("Ab3")	soundfile = 'sound/instruments/piano/Ab3.ogg'
		if("An3")	soundfile = 'sound/instruments/piano/An3.ogg'
		if("A#3")	soundfile = 'sound/instruments/piano/A#3.ogg'
		if("Bb3")	soundfile = 'sound/instruments/piano/Bb3.ogg'
		if("Bn3")	soundfile = 'sound/instruments/piano/Bn3.ogg'
		if("B#3")	soundfile = 'sound/instruments/piano/B#3.ogg'
		if("Cb4")	soundfile = 'sound/instruments/piano/Cb4.ogg'
		if("Cn4")	soundfile = 'sound/instruments/piano/Cn4.ogg'
		if("C#4")	soundfile = 'sound/instruments/piano/C#4.ogg'
		if("Db4")	soundfile = 'sound/instruments/piano/Db4.ogg'
		if("Dn4")	soundfile = 'sound/instruments/piano/Dn4.ogg'
		if("D#4")	soundfile = 'sound/instruments/piano/D#4.ogg'
		if("Eb4")	soundfile = 'sound/instruments/piano/Eb4.ogg'
		if("En4")	soundfile = 'sound/instruments/piano/En4.ogg'
		if("E#4")	soundfile = 'sound/instruments/piano/E#4.ogg'
		if("Fb4")	soundfile = 'sound/instruments/piano/Fb4.ogg'
		if("Fn4")	soundfile = 'sound/instruments/piano/Fn4.ogg'
		if("F#4")	soundfile = 'sound/instruments/piano/F#4.ogg'
		if("Gb4")	soundfile = 'sound/instruments/piano/Gb4.ogg'
		if("Gn4")	soundfile = 'sound/instruments/piano/Gn4.ogg'
		if("G#4")	soundfile = 'sound/instruments/piano/G#4.ogg'
		if("Ab4")	soundfile = 'sound/instruments/piano/Ab4.ogg'
		if("An4")	soundfile = 'sound/instruments/piano/An4.ogg'
		if("A#4")	soundfile = 'sound/instruments/piano/A#4.ogg'
		if("Bb4")	soundfile = 'sound/instruments/piano/Bb4.ogg'
		if("Bn4")	soundfile = 'sound/instruments/piano/Bn4.ogg'
		if("B#4")	soundfile = 'sound/instruments/piano/B#4.ogg'
		if("Cb5")	soundfile = 'sound/instruments/piano/Cb5.ogg'
		if("Cn5")	soundfile = 'sound/instruments/piano/Cn5.ogg'
		if("C#5")	soundfile = 'sound/instruments/piano/C#5.ogg'
		if("Db5")	soundfile = 'sound/instruments/piano/Db5.ogg'
		if("Dn5")	soundfile = 'sound/instruments/piano/Dn5.ogg'
		if("D#5")	soundfile = 'sound/instruments/piano/D#5.ogg'
		if("Eb5")	soundfile = 'sound/instruments/piano/Eb5.ogg'
		if("En5")	soundfile = 'sound/instruments/piano/En5.ogg'
		if("E#5")	soundfile = 'sound/instruments/piano/E#5.ogg'
		if("Fb5")	soundfile = 'sound/instruments/piano/Fb5.ogg'
		if("Fn5")	soundfile = 'sound/instruments/piano/Fn5.ogg'
		if("F#5")	soundfile = 'sound/instruments/piano/F#5.ogg'
		if("Gb5")	soundfile = 'sound/instruments/piano/Gb5.ogg'
		if("Gn5")	soundfile = 'sound/instruments/piano/Gn5.ogg'
		if("G#5")	soundfile = 'sound/instruments/piano/G#5.ogg'
		if("Ab5")	soundfile = 'sound/instruments/piano/Ab5.ogg'
		if("An5")	soundfile = 'sound/instruments/piano/An5.ogg'
		if("A#5")	soundfile = 'sound/instruments/piano/A#5.ogg'
		if("Bb5")	soundfile = 'sound/instruments/piano/Bb5.ogg'
		if("Bn5")	soundfile = 'sound/instruments/piano/Bn5.ogg'
		if("B#5")	soundfile = 'sound/instruments/piano/B#5.ogg'
		if("Cb6")	soundfile = 'sound/instruments/piano/Cb6.ogg'
		if("Cn6")	soundfile = 'sound/instruments/piano/Cn6.ogg'
		if("C#6")	soundfile = 'sound/instruments/piano/C#6.ogg'
		if("Db6")	soundfile = 'sound/instruments/piano/Db6.ogg'
		if("Dn6")	soundfile = 'sound/instruments/piano/Dn6.ogg'
		if("D#6")	soundfile = 'sound/instruments/piano/D#6.ogg'
		if("Eb6")	soundfile = 'sound/instruments/piano/Eb6.ogg'
		if("En6")	soundfile = 'sound/instruments/piano/En6.ogg'
		if("E#6")	soundfile = 'sound/instruments/piano/E#6.ogg'
		if("Fb6")	soundfile = 'sound/instruments/piano/Fb6.ogg'
		if("Fn6")	soundfile = 'sound/instruments/piano/Fn6.ogg'
		if("F#6")	soundfile = 'sound/instruments/piano/F#6.ogg'
		if("Gb6")	soundfile = 'sound/instruments/piano/Gb6.ogg'
		if("Gn6")	soundfile = 'sound/instruments/piano/Gn6.ogg'
		if("G#6")	soundfile = 'sound/instruments/piano/G#6.ogg'
		if("Ab6")	soundfile = 'sound/instruments/piano/Ab6.ogg'
		if("An6")	soundfile = 'sound/instruments/piano/An6.ogg'
		if("A#6")	soundfile = 'sound/instruments/piano/A#6.ogg'
		if("Bb6")	soundfile = 'sound/instruments/piano/Bb6.ogg'
		if("Bn6")	soundfile = 'sound/instruments/piano/Bn6.ogg'
		if("B#6")	soundfile = 'sound/instruments/piano/B#6.ogg'
		if("Cb7")	soundfile = 'sound/instruments/piano/Cb7.ogg'
		if("Cn7")	soundfile = 'sound/instruments/piano/Cn7.ogg'
		if("C#7")	soundfile = 'sound/instruments/piano/C#7.ogg'
		if("Db7")	soundfile = 'sound/instruments/piano/Db7.ogg'
		if("Dn7")	soundfile = 'sound/instruments/piano/Dn7.ogg'
		if("D#7")	soundfile = 'sound/instruments/piano/D#7.ogg'
		if("Eb7")	soundfile = 'sound/instruments/piano/Eb7.ogg'
		if("En7")	soundfile = 'sound/instruments/piano/En7.ogg'
		if("E#7")	soundfile = 'sound/instruments/piano/E#7.ogg'
		if("Fb7")	soundfile = 'sound/instruments/piano/Fb7.ogg'
		if("Fn7")	soundfile = 'sound/instruments/piano/Fn7.ogg'
		if("F#7")	soundfile = 'sound/instruments/piano/F#7.ogg'
		if("Gb7")	soundfile = 'sound/instruments/piano/Gb7.ogg'
		if("Gn7")	soundfile = 'sound/instruments/piano/Gn7.ogg'
		if("G#7")	soundfile = 'sound/instruments/piano/G#7.ogg'
		if("Ab7")	soundfile = 'sound/instruments/piano/Ab7.ogg'
		if("An7")	soundfile = 'sound/instruments/piano/An7.ogg'
		if("A#7")	soundfile = 'sound/instruments/piano/A#7.ogg'
		if("Bb7")	soundfile = 'sound/instruments/piano/Bb7.ogg'
		if("Bn7")	soundfile = 'sound/instruments/piano/Bn7.ogg'
		if("B#7")	soundfile = 'sound/instruments/piano/B#7.ogg'
		if("Cb8")	soundfile = 'sound/instruments/piano/Cb8.ogg'
		if("Cn8")	soundfile = 'sound/instruments/piano/Cn8.ogg'
		if("C#8")	soundfile = 'sound/instruments/piano/C#8.ogg'
		if("Db8")	soundfile = 'sound/instruments/piano/Db8.ogg'
		if("Dn8")	soundfile = 'sound/instruments/piano/Dn8.ogg'
		if("D#8")	soundfile = 'sound/instruments/piano/D#8.ogg'
		if("Eb8")	soundfile = 'sound/instruments/piano/Eb8.ogg'
		if("En8")	soundfile = 'sound/instruments/piano/En8.ogg'
		if("E#8")	soundfile = 'sound/instruments/piano/E#8.ogg'
		if("Fb8")	soundfile = 'sound/instruments/piano/Fb8.ogg'
		if("Fn8")	soundfile = 'sound/instruments/piano/Fn8.ogg'
		if("F#8")	soundfile = 'sound/instruments/piano/F#8.ogg'
		if("Gb8")	soundfile = 'sound/instruments/piano/Gb8.ogg'
		if("Gn8")	soundfile = 'sound/instruments/piano/Gn8.ogg'
		if("G#8")	soundfile = 'sound/instruments/piano/G#8.ogg'
		if("Ab8")	soundfile = 'sound/instruments/piano/Ab8.ogg'
		if("An8")	soundfile = 'sound/instruments/piano/An8.ogg'
		if("A#8")	soundfile = 'sound/instruments/piano/A#8.ogg'
		if("Bb8")	soundfile = 'sound/instruments/piano/Bb8.ogg'
		if("Bn8")	soundfile = 'sound/instruments/piano/Bn8.ogg'
		if("B#8")	soundfile = 'sound/instruments/piano/B#8.ogg'
		if("Cb9")	soundfile = 'sound/instruments/piano/Cb9.ogg'
		if("Cn9")	soundfile = 'sound/instruments/piano/Cn9.ogg'
		else		return

	//hearers(15, src) << sound(soundfile)
	var/turf/source = GET_TURF(src)
	for(var/mob/M in hearers(15, source))
		M.playsound_local(source, file(soundfile), 100, falloff = 5)

/obj/structure/device/piano/proc/playsong()
	do
		var/cur_oct[7]
		var/cur_acc[7]
		for(var/i = 1 to 7)
			cur_oct[i] = "3"
			cur_acc[i] = "n"

		for(var/line in song.lines)
			//to_world(line)
			for(var/beat in splittext(lowertext(line), ","))
				//to_world("beat: [beat]")
				var/list/notes = splittext(beat, "/")
				for(var/note in splittext(notes[1], "-"))
					//to_world("note: [note]")
					if(!playing || !anchored)//If the piano is playing, or is loose
						playing = 0
						return
					if(length(note) == 0)
						continue
					//to_world("Parse: [copytext(note,1,2)]")
					var/cur_note = text2ascii(note) - 96
					if(cur_note < 1 || cur_note > 7)
						continue
					for(var/i=2 to length(note))
						var/ni = copytext(note,i,i+1)
						if(!text2num(ni))
							if(ni == "#" || ni == "b" || ni == "n")
								cur_acc[cur_note] = ni
							else if(ni == "s")
								cur_acc[cur_note] = "#" // so shift is never required
						else
							cur_oct[cur_note] = ni
					playnote(uppertext(copytext(note,1,2)) + cur_acc[cur_note] + cur_oct[cur_note])
				if(length(notes) >= 2 && text2num(notes[2]))
					sleep(song.tempo / text2num(notes[2]))
				else
					sleep(song.tempo)
		if(repeat > 0)
			repeat-- //Infinite loops are baaaad.
	while(repeat > 0)
	playing = 0
	updateUsrDialog()

/obj/structure/device/piano/attack_hand(mob/user)
	if(!anchored)
		return

	usr.machine = src
	var/dat = "<HEAD><TITLE>Piano</TITLE></HEAD><BODY>"

	if(song)
		if(length(song.lines) && !(playing))
			dat += "<A href='byond://?src=\ref[src];play=1'>Play Song</A><BR><BR>"
			dat += "<A href='byond://?src=\ref[src];repeat=1'>Repeat Song: [repeat] times.</A><BR><BR>"
		if(playing)
			dat += "<A href='byond://?src=\ref[src];stop=1'>Stop Playing</A><BR>"
			dat += "Repeats left: [repeat].<BR><BR>"
	if(!edit)
		dat += "<A href='byond://?src=\ref[src];edit=2'>Show Editor</A><BR><BR>"
	else
		dat += "<A href='byond://?src=\ref[src];edit=1'>Hide Editor</A><BR>"
		dat += "<A href='byond://?src=\ref[src];newsong=1'>Start a New Song</A><BR>"
		dat += "<A href='byond://?src=\ref[src];import=1'>Import a Song</A><BR><BR>"
		if(song)
			var/calctempo = (10/song.tempo)*60
			dat += "Tempo : <A href='byond://?src=\ref[src];tempo=10'>-</A><A href='byond://?src=\ref[src];tempo=1'>-</A> [calctempo] BPM <A href='byond://?src=\ref[src];tempo=-1'>+</A><A href='byond://?src=\ref[src];tempo=-10'>+</A><BR><BR>"
			var/linecount = 0
			for(var/line in song.lines)
				linecount += 1
				dat += "Line [linecount]: [line] <A href='byond://?src=\ref[src];deleteline=[linecount]'>Delete Line</A> <A href='byond://?src=\ref[src];modifyline=[linecount]'>Modify Line</A><BR>"
			dat += "<A href='byond://?src=\ref[src];newline=1'>Add Line</A><BR><BR>"
		if(help)
			dat += "<A href='byond://?src=\ref[src];help=1'>Hide Help</A><BR>"
			dat += {"
					Lines are a series of chords, separated by commas (,), each with notes seperated by hyphens (-).<br>
					Every note in a chord will play together, with chord timed by the tempo.<br>
					<br>
					Notes are played by the names of the note, and optionally, the accidental, and/or the octave number.<br>
					By default, every note is natural and in octave 3. Defining otherwise is remembered for each note.<br>
					Example: <i>C,D,E,F,G,A,B</i> will play a C major scale.<br>
					After a note has an accidental placed, it will be remembered: <i>C,C4,C,C3</i> is C3,C4,C4,C3</i><br>
					Chords can be played simply by seperating each note with a hyphon: <i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					A pause may be denoted by an empty chord: <i>C,E,,C,G</i><br>
					To make a chord be a different time, end it with /x, where the chord length will be length<br>
					defined by tempo / x: <i>C,G/2,E/4</i><br>
					Combined, an example is: <i>E-E4/4,/2,G#/8,B/8,E3-E4/4</i>
					<br>
					Lines may be up to 50 characters.<br>
					A song may only contain up to 50 lines.<br>
					"}
		else
			dat += "<A href='byond://?src=\ref[src];help=2'>Show Help</A><BR>"
	dat += "</BODY></HTML>"
	user << browse(dat, "window=piano;size=700x300")
	onclose(user, "piano")

/obj/structure/device/piano/Topic(href, href_list)
	if(!in_range(src, usr) || issilicon(usr) || !anchored || !usr.canmove || usr.restrained())
		usr << browse(null, "window=piano;size=700x300")
		onclose(usr, "piano")
		return

	if(href_list["newsong"])
		song = new()
	else if(song)
		if(href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
			if(playing) return //So that people cant keep adding to repeat. If the do it intentionally, it could result in the server crashing.
			var/tempnum = input("How many times do you want to repeat this piece? (max:10)") as num|null
			if(tempnum > 10)
				tempnum = 10
			if(tempnum < 0)
				tempnum = 0
			repeat = round(tempnum)

		else if(href_list["tempo"])
			song.tempo += round(text2num(href_list["tempo"]))
			if(song.tempo < 1)
				song.tempo = 1

		else if(href_list["play"])
			if(song)
				playing = 1
				spawn() playsong()

		else if(href_list["newline"])
			var/newline = html_encode(input("Enter your line: ", "Piano") as text|null)
			if(!newline)
				return
			if(length(song.lines) > 50)
				return
			if(length(newline) > 50)
				newline = copytext(newline, 1, 50)
			song.lines.Add(newline)

		else if(href_list["deleteline"])
			var/num = round(text2num(href_list["deleteline"]))
			if(num > length(song.lines) || num < 1)
				return
			song.lines.Cut(num, num+1)

		else if(href_list["modifyline"])
			var/num = round(text2num(href_list["modifyline"]),1)
			var/content = html_encode(input("Enter your line: ", "Piano", song.lines[num]) as text|null)
			if(!content)
				return
			if(length(content) > 50)
				content = copytext(content, 1, 50)
			if(num > length(song.lines) || num < 1)
				return
			song.lines[num] = content

		else if(href_list["stop"])
			playing = 0

		else if(href_list["help"])
			help = text2num(href_list["help"]) - 1

		else if(href_list["edit"])
			edit = text2num(href_list["edit"]) - 1

		else if(href_list["import"])
			var/t = ""
			do
				t = html_encode(input(usr, "Please paste the entire song, formatted:", "[name]", t)  as message)
				if (!in_range(src, usr))
					return

				if(length(t) >= 3072)
					var/cont = input(usr, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
					if(cont == "no")
						break
			while(length(t) > 3072)

			//split into lines
			spawn()
				var/list/lines = splittext(t, "\n")
				var/tempo = 5
				if(copytext(lines[1],1,6) == "BPM: ")
					tempo = 600 / text2num(copytext(lines[1],6))
					lines.Cut(1,2)
				if(length(lines) > 50)
					usr << "Too many lines!"
					lines.Cut(51)
				var/linenum = 1
				for(var/l in lines)
					if(length(l) > 50)
						usr << "Line [linenum] too long!"
						lines.Remove(l)
					else
						linenum++
				song = new()
				song.lines = lines
				song.tempo = tempo
				updateUsrDialog()

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/structure/device/piano/attackby(obj/item/O, mob/user)
	if(iswrench(O))
		if(anchored)
			playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
			user << "\blue You begin to loosen \the [src]'s casters..."
			if(do_after(user, 40))
				user.visible_message( \
					"[user] loosens \the [src]'s casters.", \
					"\blue You have loosened \the [src]. Now it can be pulled somewhere else.", \
					"You hear a ratchet.")
				src.anchored = FALSE
		else
			playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
			user << "\blue You begin to tighten \the [src] to the floor..."
			if(do_after(user, 20))
				user.visible_message( \
					"[user] tightens \the [src]'s casters.", \
					"\blue You have tightened \the [src]'s casters. Now it can be played again.", \
					"You hear a ratchet.")
				src.anchored = TRUE
	else
		..()
