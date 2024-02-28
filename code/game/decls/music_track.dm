/decl/music_track
	// The track's artist.
	var/artist
	// The track's name.
	var/title
	// The album the track is from.
	var/album
	// The track's file path.
	var/file_path

/decl/music_track/proc/play(listener)
	to_chat(listener, SPAN_INFO_B("Now Playing: [artist] - [title][isnotnull(album) ? " (from [album])" : ""]."))
	listener << sound(file_path, repeat = 0, wait = 0, volume = 85, channel = 1)

/decl/music_track/proc/stop(listener)
	to_chat(listener, SPAN_INFO_B("Music stopped."))
	listener << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

/decl/music_track/endless_space
	artist = "SolusLunes"
	title = "Endless Space (Expanded)"
	file_path = 'sound/music/space.ogg'

/decl/music_track/absconditus
	artist = "Joe Toscano"
	title = "Absconditus"
	album = "Minerva: Metastasis OST"
	file_path = 'sound/music/traitor.ogg'

/decl/music_track/robocop
	artist = "Jonathan Dunn"
	title = "RoboCop Title Theme (Game Boy)"
	file_path = 'sound/music/title2.ogg'

/decl/music_track/clouds_of_fire
	artist = "Hector/dMk"
	title = "Clouds of Fire"
	file_path = 'sound/music/clouds.s3m'

// Ground Control to Major Tom, this song is cool, what's going on?
/decl/music_track/space_oddity
	artist = "Chris Hadfield"
	title = "Space Oddity"
	file_path = 'sound/music/space_oddity.ogg'

// Halloween
// These need to be checked because licensing.
/decl/music_track/spooky_scary_skeletons
	artist = "Andrew Gold"
	title = "Spooky Scary Skeletons"
	file_path = 'sound/music/halloween/skeletons.ogg'

/decl/music_track/this_is_halloween
	artist = "Danny Elfman (Various)"
	title = "This Is Halloween"
	file_path = 'sound/music/halloween/halloween.ogg'

/decl/music_track/ghostbusters
	artist = "Ray Parker Jr."
	title = "Ghostbusters"
	file_path = 'sound/music/halloween/ghosts.ogg'