/decl/hierarchy/skill
	name = "Placeholder Skill" // name of the skill
	var/desc = "A placeholder skill!" // detailed description of the skill
	var/field = "Misc" // the field under which the skill will be listed
	var/secondary = FALSE // secondary skills only have two levels and cost significantly less

// General
/decl/hierarchy/skill/general
	field = "General"

/decl/hierarchy/skill/general/management
	name = "Command"
	desc = "Your ability to manage and commandeer other crew members."

/decl/hierarchy/skill/general/eva
	name = "Extra-Vehicular Activity"
	desc = "This skill describes your skill and knowledge of space-suits and working in vacuum."
	secondary = TRUE

/decl/hierarchy/skill/general/pilot
	name = "Heavy Machinery Operation"
	desc = "Describes your experience and understanding of operating heavy machinery, which includes mechs and other large exosuits. Used in piloting mechs."

/decl/hierarchy/skill/general/botany
	name = "Botany"
	desc = "Describes how good a character is at growing and maintaining plants."

/decl/hierarchy/skill/general/cooking
	name = "Cooking"
	desc = "Describes a character's skill at preparing meals and other consumable goods. This includes mixing alcoholic beverages."

// Security
/decl/hierarchy/skill/security
	field = "Security"

/decl/hierarchy/skill/security/combat
	name = "Close Combat"
	desc = "This skill describes your training in hand-to-hand combat or melee weapon usage. While expertise in this area is rare in the era of firearms, experts still exist among athletes."

/decl/hierarchy/skill/security/weapons
	name = "Weapons Expertise"
	desc = "This skill describes your expertise with and knowledge of weapons. A low level in this skill implies knowledge of simple weapons, for example tazers and flashes. A high level in this skill implies knowledge of complex weapons, such as grenades, riot shields, pulse rifles or bombs. A low level in this skill is typical for security officers, a high level of this skill is typical for special agents and soldiers."

/decl/hierarchy/skill/security/forensics
	name = "Forensics"
	desc = "Describes your skill at performing forensic examinations and identifying vital evidence. Does not cover analytical abilities, and as such isn't the only indicator for your investigation skill. Note that in order to perform autopsy, the surgery skill is also required."

/decl/hierarchy/skill/security/law
	name = "NanoTrasen Law"
	desc = "Your knowledge of NanoTrasen law and procedures. This includes Space Law, as well as general station rulings and procedures. A low level in this skill is typical for security officers, a high level in this skill is typical for captains."
	secondary = TRUE

// Engineering
/decl/hierarchy/skill/engineering
	field = "Engineering"

/decl/hierarchy/skill/engineering/construction
	name = "Construction"
	desc = "Your ability to construct various buildings, such as walls, floors, tables and so on. Note that constructing devices such as APCs additionally requires the Electronics skill. A low level of this skill is typical for janitors, a high level of this skill is typical for engineers."

/decl/hierarchy/skill/engineering/electrical
	name = "Electrical Engineering"
	desc = "This skill describes your knowledge of electronics and the underlying physics. A low level of this skill implies you know how to lay out wiring and configure powernets, a high level of this skill is required for working complex electronic devices such as circuits or bots."

/decl/hierarchy/skill/engineering/atmos
	name = "Atmospherics"
	desc = "Describes your knowledge of piping, air distribution and gas dynamics."

/decl/hierarchy/skill/engineering/engines
	name = "Engines"
	desc = "Describes your knowledge of the various engine types common on space stations, such as the singularity or anti-matter engine."
	secondary = TRUE

// Science
/decl/hierarchy/skill/science
	field = "Science"

/decl/hierarchy/skill/science/methods
	name = "Science"
	desc = "Your experience and knowledge with scientific methods and processes."

/decl/hierarchy/skill/science/devices
	name = "Complex Devices"
	desc = "Describes the ability to assemble complex devices, such as computers, circuits, printers, robots or gas tank assemblies (bombs). Note that if a device requires electronics or programming, those skills are also required in addition to this skill."

/decl/hierarchy/skill/science/computer
	name = "Information Technology"
	desc = "Describes your understanding of computers, software and communication. Not a requirement for using computers, but definitely helps. Used in telecommunications and programming of computers and AIs."

/decl/hierarchy/skill/science/genetics
	name = "Genetics"
	desc = "Implies an understanding of how DNA works and the structure of the human DNA."

// Medical
/decl/hierarchy/skill/medical
	field = "Medical"

/decl/hierarchy/skill/medical/medicine
	name = "Medicine"
	desc = "Covers an understanding of the human body and medicine. At a low level, this skill gives a basic understanding of applying common types of medicine, and a rough understanding of medical devices like the health analyser. At a high level, this skill grants exact knowledge of all the medicine available on the station, as well as the ability to use complex medical devices like the body scanner or mass spectrometer."

/decl/hierarchy/skill/medical/anatomy
	name = "Anatomy"
	desc = "Gives you a detailed insight of the human body. A high skill in this is required to perform surgery. This skill may also help in examining alien biology."

/decl/hierarchy/skill/medical/virology
	name = "Virology"
	desc = "This skill implies an understanding of microorganisms and their effects on humans."

/decl/hierarchy/skill/medical/chemistry
	name = "Chemistry"
	desc = "Experience with mixing chemicals, and an understanding of what the effect will be. This doesn't cover an understanding of the effect of chemicals on the human body, as such the medical skill is also required for medical chemists."

/proc/calculate_skill_class(points, age)
	// skill classes describe how your character compares in total points
	if(points <= 0)
		return "Unconfigured"
	points -= min(round((age - 20) / 2.5), 4) // every 2.5 years after 20, one extra skillpoint
	if(age > 30)
		points -= round((age - 30) / 5) // every 5 years after 30, one extra skillpoint
	switch(points)
		if(1 to 3)
			return "Terrifying"
		if(4 to 6)
			return "Below Average"
		if(7 to 10)
			return "Average"
		if(11 to 14)
			return "Above Average"
		if(15 to 18)
			return "Exceptional"
		if(19 to 24)
			return "Genius"
		if(24 to 1000)
			return "God"

/proc/show_skill_window(mob/user, mob/living/carbon/human/M)
	if(!istype(M))
		return

	if(!length(M.skills))
		to_chat(user, "There are no skills to display.")
		return

	var/HTML = "<body>"
	HTML += "<b>Select your Skills</b><br>"
	HTML += "Current skill level: <b>[calculate_skill_class(M.used_skillpoints, M.age)]</b> ([M.used_skillpoints])<br>"
	HTML += "<table>"
	for(var/V in GLOBL.all_skills)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/decl/hierarchy/skill/S in GLOBL.all_skills[V])
			var/level = M.skills[S.type]
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			HTML += "<th><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Untrained\]</font></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				HTML += "<th></th>"
			else
				HTML += "<th><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Amateur\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[Trained\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Professional\]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=show_skills;size=600x800")

/mob/living/carbon/human/verb/show_skills()
	set category = PANEL_IC
	set name = "Show Own Skills"

	show_skill_window(src, src)