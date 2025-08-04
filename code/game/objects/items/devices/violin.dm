//copy pasta of the space piano, don't hurt me -Pete

/obj/item/violin
	name = "space violin"
	desc = "A wooden musical instrument with four strings and a bow. \"The devil went down to space, he was looking for an assistant to grief.\""
	icon = 'icons/obj/musician.dmi'
	icon_state = "violin"
	item_state = "violin"
	force = 10
	var/datum/song/song
	var/playing = 0
	var/help = 0
	var/edit = 1
	var/repeat = 0

/obj/item/violin/proc/playnote(note as text)
	//to_world("Note: [note]")
	var/soundfile
	/*BYOND loads resource files at compile time if they are ''. This means you can't really manipulate them dynamically.
	Tried doing it dynamically at first but its more trouble than its worth. Would have saved many lines tho.*/
	switch(note)
		if("Cn1")	soundfile = 'sound/instruments/violin/Cn1.mid'
		if("C#1")	soundfile = 'sound/instruments/violin/C#1.mid'
		if("Db1")	soundfile = 'sound/instruments/violin/Db1.mid'
		if("Dn1")	soundfile = 'sound/instruments/violin/Dn1.mid'
		if("D#1")	soundfile = 'sound/instruments/violin/D#1.mid'
		if("Eb1")	soundfile = 'sound/instruments/violin/Eb1.mid'
		if("En1")	soundfile = 'sound/instruments/violin/En1.mid'
		if("E#1")	soundfile = 'sound/instruments/violin/E#1.mid'
		if("Fb1")	soundfile = 'sound/instruments/violin/Fb1.mid'
		if("Fn1")	soundfile = 'sound/instruments/violin/Fn1.mid'
		if("F#1")	soundfile = 'sound/instruments/violin/F#1.mid'
		if("Gb1")	soundfile = 'sound/instruments/violin/Gb1.mid'
		if("Gn1")	soundfile = 'sound/instruments/violin/Gn1.mid'
		if("G#1")	soundfile = 'sound/instruments/violin/G#1.mid'
		if("Ab1")	soundfile = 'sound/instruments/violin/Ab1.mid'
		if("An1")	soundfile = 'sound/instruments/violin/An1.mid'
		if("A#1")	soundfile = 'sound/instruments/violin/A#1.mid'
		if("Bb1")	soundfile = 'sound/instruments/violin/Bb1.mid'
		if("Bn1")	soundfile = 'sound/instruments/violin/Bn1.mid'
		if("B#1")	soundfile = 'sound/instruments/violin/B#1.mid'
		if("Cb2")	soundfile = 'sound/instruments/violin/Cb2.mid'
		if("Cn2")	soundfile = 'sound/instruments/violin/Cn2.mid'
		if("C#2")	soundfile = 'sound/instruments/violin/C#2.mid'
		if("Db2")	soundfile = 'sound/instruments/violin/Db2.mid'
		if("Dn2")	soundfile = 'sound/instruments/violin/Dn2.mid'
		if("D#2")	soundfile = 'sound/instruments/violin/D#2.mid'
		if("Eb2")	soundfile = 'sound/instruments/violin/Eb2.mid'
		if("En2")	soundfile = 'sound/instruments/violin/En2.mid'
		if("E#2")	soundfile = 'sound/instruments/violin/E#2.mid'
		if("Fb2")	soundfile = 'sound/instruments/violin/Fb2.mid'
		if("Fn2")	soundfile = 'sound/instruments/violin/Fn2.mid'
		if("F#2")	soundfile = 'sound/instruments/violin/F#2.mid'
		if("Gb2")	soundfile = 'sound/instruments/violin/Gb2.mid'
		if("Gn2")	soundfile = 'sound/instruments/violin/Gn2.mid'
		if("G#2")	soundfile = 'sound/instruments/violin/G#2.mid'
		if("Ab2")	soundfile = 'sound/instruments/violin/Ab2.mid'
		if("An2")	soundfile = 'sound/instruments/violin/An2.mid'
		if("A#2")	soundfile = 'sound/instruments/violin/A#2.mid'
		if("Bb2")	soundfile = 'sound/instruments/violin/Bb2.mid'
		if("Bn2")	soundfile = 'sound/instruments/violin/Bn2.mid'
		if("B#2")	soundfile = 'sound/instruments/violin/B#2.mid'
		if("Cb3")	soundfile = 'sound/instruments/violin/Cb3.mid'
		if("Cn3")	soundfile = 'sound/instruments/violin/Cn3.mid'
		if("C#3")	soundfile = 'sound/instruments/violin/C#3.mid'
		if("Db3")	soundfile = 'sound/instruments/violin/Db3.mid'
		if("Dn3")	soundfile = 'sound/instruments/violin/Dn3.mid'
		if("D#3")	soundfile = 'sound/instruments/violin/D#3.mid'
		if("Eb3")	soundfile = 'sound/instruments/violin/Eb3.mid'
		if("En3")	soundfile = 'sound/instruments/violin/En3.mid'
		if("E#3")	soundfile = 'sound/instruments/violin/E#3.mid'
		if("Fb3")	soundfile = 'sound/instruments/violin/Fb3.mid'
		if("Fn3")	soundfile = 'sound/instruments/violin/Fn3.mid'
		if("F#3")	soundfile = 'sound/instruments/violin/F#3.mid'
		if("Gb3")	soundfile = 'sound/instruments/violin/Gb3.mid'
		if("Gn3")	soundfile = 'sound/instruments/violin/Gn3.mid'
		if("G#3")	soundfile = 'sound/instruments/violin/G#3.mid'
		if("Ab3")	soundfile = 'sound/instruments/violin/Ab3.mid'
		if("An3")	soundfile = 'sound/instruments/violin/An3.mid'
		if("A#3")	soundfile = 'sound/instruments/violin/A#3.mid'
		if("Bb3")	soundfile = 'sound/instruments/violin/Bb3.mid'
		if("Bn3")	soundfile = 'sound/instruments/violin/Bn3.mid'
		if("B#3")	soundfile = 'sound/instruments/violin/B#3.mid'
		if("Cb4")	soundfile = 'sound/instruments/violin/Cb4.mid'
		if("Cn4")	soundfile = 'sound/instruments/violin/Cn4.mid'
		if("C#4")	soundfile = 'sound/instruments/violin/C#4.mid'
		if("Db4")	soundfile = 'sound/instruments/violin/Db4.mid'
		if("Dn4")	soundfile = 'sound/instruments/violin/Dn4.mid'
		if("D#4")	soundfile = 'sound/instruments/violin/D#4.mid'
		if("Eb4")	soundfile = 'sound/instruments/violin/Eb4.mid'
		if("En4")	soundfile = 'sound/instruments/violin/En4.mid'
		if("E#4")	soundfile = 'sound/instruments/violin/E#4.mid'
		if("Fb4")	soundfile = 'sound/instruments/violin/Fb4.mid'
		if("Fn4")	soundfile = 'sound/instruments/violin/Fn4.mid'
		if("F#4")	soundfile = 'sound/instruments/violin/F#4.mid'
		if("Gb4")	soundfile = 'sound/instruments/violin/Gb4.mid'
		if("Gn4")	soundfile = 'sound/instruments/violin/Gn4.mid'
		if("G#4")	soundfile = 'sound/instruments/violin/G#4.mid'
		if("Ab4")	soundfile = 'sound/instruments/violin/Ab4.mid'
		if("An4")	soundfile = 'sound/instruments/violin/An4.mid'
		if("A#4")	soundfile = 'sound/instruments/violin/A#4.mid'
		if("Bb4")	soundfile = 'sound/instruments/violin/Bb4.mid'
		if("Bn4")	soundfile = 'sound/instruments/violin/Bn4.mid'
		if("B#4")	soundfile = 'sound/instruments/violin/B#4.mid'
		if("Cb5")	soundfile = 'sound/instruments/violin/Cb5.mid'
		if("Cn5")	soundfile = 'sound/instruments/violin/Cn5.mid'
		if("C#5")	soundfile = 'sound/instruments/violin/C#5.mid'
		if("Db5")	soundfile = 'sound/instruments/violin/Db5.mid'
		if("Dn5")	soundfile = 'sound/instruments/violin/Dn5.mid'
		if("D#5")	soundfile = 'sound/instruments/violin/D#5.mid'
		if("Eb5")	soundfile = 'sound/instruments/violin/Eb5.mid'
		if("En5")	soundfile = 'sound/instruments/violin/En5.mid'
		if("E#5")	soundfile = 'sound/instruments/violin/E#5.mid'
		if("Fb5")	soundfile = 'sound/instruments/violin/Fb5.mid'
		if("Fn5")	soundfile = 'sound/instruments/violin/Fn5.mid'
		if("F#5")	soundfile = 'sound/instruments/violin/F#5.mid'
		if("Gb5")	soundfile = 'sound/instruments/violin/Gb5.mid'
		if("Gn5")	soundfile = 'sound/instruments/violin/Gn5.mid'
		if("G#5")	soundfile = 'sound/instruments/violin/G#5.mid'
		if("Ab5")	soundfile = 'sound/instruments/violin/Ab5.mid'
		if("An5")	soundfile = 'sound/instruments/violin/An5.mid'
		if("A#5")	soundfile = 'sound/instruments/violin/A#5.mid'
		if("Bb5")	soundfile = 'sound/instruments/violin/Bb5.mid'
		if("Bn5")	soundfile = 'sound/instruments/violin/Bn5.mid'
		if("B#5")	soundfile = 'sound/instruments/violin/B#5.mid'
		if("Cb6")	soundfile = 'sound/instruments/violin/Cb6.mid'
		if("Cn6")	soundfile = 'sound/instruments/violin/Cn6.mid'
		if("C#6")	soundfile = 'sound/instruments/violin/C#6.mid'
		if("Db6")	soundfile = 'sound/instruments/violin/Db6.mid'
		if("Dn6")	soundfile = 'sound/instruments/violin/Dn6.mid'
		if("D#6")	soundfile = 'sound/instruments/violin/D#6.mid'
		if("Eb6")	soundfile = 'sound/instruments/violin/Eb6.mid'
		if("En6")	soundfile = 'sound/instruments/violin/En6.mid'
		if("E#6")	soundfile = 'sound/instruments/violin/E#6.mid'
		if("Fb6")	soundfile = 'sound/instruments/violin/Fb6.mid'
		if("Fn6")	soundfile = 'sound/instruments/violin/Fn6.mid'
		if("F#6")	soundfile = 'sound/instruments/violin/F#6.mid'
		if("Gb6")	soundfile = 'sound/instruments/violin/Gb6.mid'
		if("Gn6")	soundfile = 'sound/instruments/violin/Gn6.mid'
		if("G#6")	soundfile = 'sound/instruments/violin/G#6.mid'
		if("Ab6")	soundfile = 'sound/instruments/violin/Ab6.mid'
		if("An6")	soundfile = 'sound/instruments/violin/An6.mid'
		if("A#6")	soundfile = 'sound/instruments/violin/A#6.mid'
		if("Bb6")	soundfile = 'sound/instruments/violin/Bb6.mid'
		if("Bn6")	soundfile = 'sound/instruments/violin/Bn6.mid'
		if("B#6")	soundfile = 'sound/instruments/violin/B#6.mid'
		if("Cb7")	soundfile = 'sound/instruments/violin/Cb7.mid'
		if("Cn7")	soundfile = 'sound/instruments/violin/Cn7.mid'
		if("C#7")	soundfile = 'sound/instruments/violin/C#7.mid'
		if("Db7")	soundfile = 'sound/instruments/violin/Db7.mid'
		if("Dn7")	soundfile = 'sound/instruments/violin/Dn7.mid'
		if("D#7")	soundfile = 'sound/instruments/violin/D#7.mid'
		if("Eb7")	soundfile = 'sound/instruments/violin/Eb7.mid'
		if("En7")	soundfile = 'sound/instruments/violin/En7.mid'
		if("E#7")	soundfile = 'sound/instruments/violin/E#7.mid'
		if("Fb7")	soundfile = 'sound/instruments/violin/Fb7.mid'
		if("Fn7")	soundfile = 'sound/instruments/violin/Fn7.mid'
		if("F#7")	soundfile = 'sound/instruments/violin/F#7.mid'
		if("Gb7")	soundfile = 'sound/instruments/violin/Gb7.mid'
		if("Gn7")	soundfile = 'sound/instruments/violin/Gn7.mid'
		if("G#7")	soundfile = 'sound/instruments/violin/G#7.mid'
		if("Ab7")	soundfile = 'sound/instruments/violin/Ab7.mid'
		if("An7")	soundfile = 'sound/instruments/violin/An7.mid'
		if("A#7")	soundfile = 'sound/instruments/violin/A#7.mid'
		if("Bb7")	soundfile = 'sound/instruments/violin/Bb7.mid'
		if("Bn7")	soundfile = 'sound/instruments/violin/Bn7.mid'
		if("B#7")	soundfile = 'sound/instruments/violin/B#7.mid'
		if("Cb8")	soundfile = 'sound/instruments/violin/Cb8.mid'
		if("Cn8")	soundfile = 'sound/instruments/violin/Cn8.mid'
		if("C#8")	soundfile = 'sound/instruments/violin/C#8.mid'
		if("Db8")	soundfile = 'sound/instruments/violin/Db8.mid'
		if("Dn8")	soundfile = 'sound/instruments/violin/Dn8.mid'
		if("D#8")	soundfile = 'sound/instruments/violin/D#8.mid'
		if("Eb8")	soundfile = 'sound/instruments/violin/Eb8.mid'
		if("En8")	soundfile = 'sound/instruments/violin/En8.mid'
		if("E#8")	soundfile = 'sound/instruments/violin/E#8.mid'
		if("Fb8")	soundfile = 'sound/instruments/violin/Fb8.mid'
		if("Fn8")	soundfile = 'sound/instruments/violin/Fn8.mid'
		if("F#8")	soundfile = 'sound/instruments/violin/F#8.mid'
		if("Gb8")	soundfile = 'sound/instruments/violin/Gb8.mid'
		if("Gn8")	soundfile = 'sound/instruments/violin/Gn8.mid'
		if("G#8")	soundfile = 'sound/instruments/violin/G#8.mid'
		if("Ab8")	soundfile = 'sound/instruments/violin/Ab8.mid'
		if("An8")	soundfile = 'sound/instruments/violin/An8.mid'
		if("A#8")	soundfile = 'sound/instruments/violin/A#8.mid'
		if("Bb8")	soundfile = 'sound/instruments/violin/Bb8.mid'
		if("Bn8")	soundfile = 'sound/instruments/violin/Bn8.mid'
		if("B#8")	soundfile = 'sound/instruments/violin/B#8.mid'
		if("Cb9")	soundfile = 'sound/instruments/violin/Cb9.mid'
		if("Cn9")	soundfile = 'sound/instruments/violin/Cn9.mid'
		else		return

	SOUND_TO(hearers(15, GET_TURF(src)), soundfile)

/obj/item/violin/proc/playsong()
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
					if(!playing || !isliving(loc))//If the violin is playing, or isn't held by a person
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
					playnote(uppertext(copytext(note, 1, 2)) + cur_acc[cur_note] + cur_oct[cur_note])
				if(length(notes) >= 2 && text2num(notes[2]))
					sleep(song.tempo / text2num(notes[2]))
				else
					sleep(song.tempo)
		if(repeat > 0)
			repeat-- //Infinite loops are baaaad.
	while(repeat > 0)
	playing = 0

/obj/item/violin/attack_self(mob/user)
	if(!isliving(user) || user.stat || user.restrained() || user.lying)
		return
	user.set_machine(src)

	var/dat = "<HEAD><TITLE>Violin</TITLE></HEAD><BODY>"

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
			var/calctempo = (10 / song.tempo) * 60
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
	SHOW_BROWSER(user, dat, "window=violin;size=700x300")
	onclose(user, "violin")

/obj/item/violin/Topic(href, href_list)
	if(!in_range(src, usr) || issilicon(usr) || !isliving(usr) || !usr.canmove || usr.restrained())
		CLOSE_BROWSER(usr, "window=violin;size=700x300")
		onclose(usr, "violin")
		return

	if(href_list["newsong"])
		song = new()
	else if(song)
		if(href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
			if(playing)
				return //So that people cant keep adding to repeat. If the do it intentionally, it could result in the server crashing.
			var/tempnum = input("How many times do you want to repeat this piece? (max: 10)") as num|null
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
			var/newline = html_encode(input("Enter your line: ", "violin") as text|null)
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
			song.lines.Cut(num, num + 1)

		else if(href_list["modifyline"])
			var/num = round(text2num(href_list["modifyline"]), 1)
			var/content = html_encode(input("Enter your line: ", "violin", song.lines[num]) as text|null)
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
				t = html_encode(input(usr, "Please paste the entire song, formatted:", "[name]", t) as message)
				if(!in_range(src, usr))
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
				if(copytext(lines[1], 1, 6) == "BPM: ")
					tempo = 600 / text2num(copytext(lines[1], 6))
					lines.Cut(1, 2)
				if(length(lines) > 50)
					to_chat(usr, "Too many lines!")
					lines.Cut(51)
				var/linenum = 1
				for(var/l in lines)
					if(length(l) > 50)
						to_chat(usr, "Line [linenum] too long!")
						lines.Remove(l)
					else
						linenum++
				song = new()
				song.lines = lines
				song.tempo = tempo

	add_fingerprint(usr)
	for(var/mob/M in viewers(1, loc))
		if((M.client && M.machine == src))
			attack_self(M)
	return