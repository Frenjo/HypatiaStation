/decl/emote/synthetic/can_use_emote(mob/user)
	return issilicon(user) || (ishuman(user) && user:species == SPECIES_MACHINE)

/decl/emote/synthetic/beep
	key = "beep"
	message = " beeps."
	message_type = EMOTE_AUDIBLE
	accepts_target = TRUE

	sound_path = 'sound/machines/twobeep.ogg'
	sound_volume = 50

/decl/emote/synthetic/buzz
	key = "buzz"
	message = " buzzes."
	message_type = EMOTE_AUDIBLE
	accepts_target = TRUE

	sound_path = 'sound/machines/buzz-sigh.ogg'
	sound_volume = 50

/decl/emote/synthetic/buzz2
	key = "buzz2"
	message = " buzzes twice."
	message_type = EMOTE_AUDIBLE
	accepts_target = TRUE

	sound_path = 'sound/machines/buzz-two.ogg'
	sound_volume = 50

/decl/emote/synthetic/chime
	key = "chime"
	message = " chimes."
	message_type = EMOTE_AUDIBLE
	accepts_target = TRUE

	sound_path = 'sound/machines/chime.ogg'
	sound_volume = 50

/decl/emote/synthetic/halt
	key = "halt"
	message = "'s speakers screech, \"Halt! Security!\"."
	message_type = EMOTE_AUDIBLE

	sound_path = 'sound/voice/halt.ogg'
	sound_volume = 50

/decl/emote/synthetic/halt/can_use_emote(mob/user)
	return ..() && (isrobot(user) && istype(user:model, /obj/item/robot_model/security))

/decl/emote/synthetic/honk
	key = "honk"
	message = " honks."
	message_type = EMOTE_AUDIBLE
	accepts_target = TRUE

	sound_path = 'sound/items/bikehorn.ogg'
	sound_volume = 50
	sound_variance = TRUE

/decl/emote/synthetic/law
	key = "law"
	message = " shows its legal authorisation barcode."

	sound_path = 'sound/voice/biamthelaw.ogg'
	sound_volume = 50

/decl/emote/synthetic/law/can_use_emote(mob/user)
	return ..() && (isrobot(user) && istype(user:model, /obj/item/robot_model/security))

/decl/emote/synthetic/ping
	key = "ping"
	message = " pings."
	message_type = EMOTE_AUDIBLE
	accepts_target = TRUE

	sound_path = 'sound/machines/ping.ogg'
	sound_volume = 50

/decl/emote/synthetic/sad
	key = "sad"
	message = " plays a sad trombone..."
	message_type = EMOTE_AUDIBLE

	sound_path = 'sound/misc/sadtrombone.ogg'
	sound_volume = 50

/decl/emote/synthetic/warn
	key = "warn"
	message = " blares an alarm!"
	message_type = EMOTE_AUDIBLE

	sound_path = 'sound/machines/warning-buzzer.ogg'
	sound_volume = 50