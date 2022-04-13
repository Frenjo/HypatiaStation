/var/list/assistant_occupations = list()

/var/list/command_positions = list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer",
	"Quartermaster"
)

/var/list/engineering_positions = list(
	"Chief Engineer",
	"Station Engineer",
	"Atmospheric Technician",
)

/var/list/medical_positions = list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Geneticist",	//Part of both medical and science
	"Psychiatrist",
	"Chemist",
	"Security Paramedic"
)

/var/list/science_positions = list(
	"Research Director",
	"Scientist",
	"Geneticist",	//Part of both medical and science
	"Roboticist",
	"Xenobiologist"
)

//Hypatia Edit
/var/list/cargo_positions = list(
	"Quartermaster",
	"Cargo Technician",
	"Mining Foreman",
	"Shaft Miner",
)

//BS12 EDIT
/var/list/civilian_positions = list(
	"Head of Personnel",
	"Bartender",
	"Botanist",
	"Chef",
	"Janitor",
	"Librarian",
	"Lawyer",
	"Mailman", // Re-added mailman. -Frenjo
	"Chaplain",
	"Clown", // Re-enabled clown and mime. -Frenjo
	"Mime",
	"Assistant"
)

/var/list/security_positions = list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer",
	"Security Paramedic"
)

/var/list/nonhuman_positions = list(
	"AI",
	"Cyborg",
	"pAI"
)

/proc/guest_jobbans(job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)
			continue
		occupations += job

	return occupations

/proc/get_alternate_titles(job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(!J)
			continue
		if(J.title == job)
			titles = J.alt_titles

	return titles