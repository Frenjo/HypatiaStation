//MedBay
/area/medical
	icon_state = "medbay"

/area/medical/medbay
	name = "\improper Medbay"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

//Medbay is a large area, these additional areas help level out APC load.
/area/medical/medbay2
	name = "\improper Medbay"
	icon_state = "medbay2"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

/area/medical/medbay3
	name = "\improper Medbay"
	icon_state = "medbay3"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

/area/medical/medbay4
	name = "\improper Medbay"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

/area/medical/main_storage
	name = "\improper Medbay Storage"

/area/medical/icu
	name = "\improper Intensive Care Unit"

/area/medical/dormitories
	name = "\improper Medbay Dormitories"

/area/medical/biostorage
	name = "\improper Secondary Storage"
	icon_state = "medbay2"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

/area/medical/reception
	name = "\improper Medbay Reception"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

/area/medical/psych
	name = "\improper Psych Room"
	icon_state = "medbay3"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

/area/medical/break_room
	name = "\improper Medical Break Room"
	icon_state = "medbay3"
	ambience = list(
		'sound/ambience/signal.ogg'
	)

/area/medical/patients_rooms
	name = "\improper Patient's Rooms"
	icon_state = "patients"

/area/medical/ward
	name = "\improper Medbay Patient Ward"
	icon_state = "patients"

/area/medical/patient_a
	name = "\improper Isolation A"
	icon_state = "patients"

/area/medical/patient_b
	name = "\improper Isolation B"
	icon_state = "patients"

/area/medical/patient_c
	name = "\improper Isolation C"
	icon_state = "patients"

/area/medical/iso_access
	name = "\improper Isolation Access"
	icon_state = "patients"

/area/medical/cmostore
	name = "\improper Secure Storage"
	icon_state = "CMO"

/area/medical/virology
	name = "\improper Virology"
	icon_state = "virology"

/area/medical/morgue
	name = "\improper Morgue"
	icon_state = "morgue"
	ambience = list(
		'sound/ambience/ambimo1.ogg',
		'sound/ambience/ambimo2.ogg',
		'sound/music/main.ogg'
	)

/area/medical/chemistry
	name = "\improper Chemistry"
	icon_state = "chem"

/area/medical/surgery
	icon_state = "surgery"

/area/medical/surgery/one
	name = "\improper Operating Theatre One"

/area/medical/surgery/two
	name = "\improper Operating Theatre Two"

/area/medical/surgery/observation
	name = "\improper Surgery Observation"

/area/medical/cryo
	name = "\improper Cryogenics"
	icon_state = "cryo"

/area/medical/exam_room
	name = "\improper Exam Room"
	icon_state = "exam_room"

/area/medical/genetics
	name = "\improper Genetics Lab"
	icon_state = "genetics"

/area/medical/genetics_cloning
	name = "\improper Cloning Lab"
	icon_state = "cloning"

/area/medical/sleeper
	name = "\improper Medical Treatment Center"
	icon_state = "exam_room"

//Toxins
// Actually Research but apparently it's internally called toxins so we'll roll with it.
/area/toxins
	icon_state = "toxlab"

/area/research/hallway
	name = "\improper Research Division"
	icon_state = "medresearch"

/area/toxins/lab
	name = "\improper Research and Development"

/area/toxins/hallway
	name = "\improper Research Lab"

/area/toxins/breakroom
	name = "\improper Science Break Room"

/area/toxins/xenobiology
	name = "\improper Xenobiology Lab"

/area/toxins/storage
	name = "\improper Science Storage"
	icon_state = "toxstorage"

/area/toxins/test_area
	name = "\improper Toxins Test Area"
	icon_state = "toxtest"

/area/toxins/mixing
	name = "\improper Toxins Mixing Room"
	icon_state = "toxmix"

/area/toxins/misc_lab
	name = "\improper Miscellaneous Research"
	icon_state = "toxmisc"

/area/toxins/telesci
	name = "\improper Telescience Lab"
	icon_state = "toxmisc"

/area/research/server
	name = "\improper Research Server Room"
	icon_state = "server"

// Robotics
/area/robotics/lab
	name = "\improper Robotics Lab"
	icon_state = "ass_line"

/area/robotics/chargebay
	name = "\improper Mech Bay"
	icon_state = "mechbay"

/area/robotics/showroom
	name = "\improper Robotics Showroom"
	icon_state = "showroom"