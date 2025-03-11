GLOBAL_GLOBL_ALIST_NEW(all_jobs) // Associative list of all job types, minus borg and AI, indexed by name.
GLOBAL_GLOBL_LIST_INIT(all_centcom_jobs, list(
	"VIP Guest", "Custodian", "Thunderdome Overseer",
	"Intel Officer", "Medical Officer", "Death Commando",
	"Research Officer", "BlackOps Commander", "Supreme Commander"
))

GLOBAL_GLOBL_LIST_INIT(departments, list(
	"Command",
	"Medical",
	"Engineering",
	"Security",
	"Civilian",
	"Cargo"
))

GLOBAL_GLOBL_LIST_INIT(command_positions, list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer",
	"Quartermaster"
))

GLOBAL_GLOBL_LIST_INIT(engineering_positions, list(
	"Chief Engineer",
	"Station Engineer",
	"Atmospheric Technician",
	"Roboticist"	// Part of both science and engineering.
))

GLOBAL_GLOBL_LIST_INIT(medical_positions, list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Geneticist",	// Part of both medical and science.
	"Psychiatrist",
	"Chemist",
	"Security Paramedic"
))

GLOBAL_GLOBL_LIST_INIT(science_positions, list(
	"Research Director",
	"Scientist",
	"Geneticist",	// Part of both medical and science.
	"Roboticist",	// Part of both science and engineering.
	"Xenobiologist"
))

// Hypatia Edit
GLOBAL_GLOBL_LIST_INIT(cargo_positions, list(
	"Quartermaster",
	"Cargo Technician",
	"Mailman", // Re-added mailman. -Frenjo
	"Mining Foreman",
	"Shaft Miner"
))

// BS12 EDIT
GLOBAL_GLOBL_LIST_INIT(civilian_positions, list(
	"Head of Personnel",
	"Bartender",
	"Botanist",
	"Chef",
	"Janitor",
	"Librarian",
	"Lawyer",
	"Chaplain",
	"Clown", // Re-enabled clown and mime. -Frenjo
	"Mime",
	"Assistant"
))

GLOBAL_GLOBL_LIST_INIT(security_positions, list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer",
	"Security Paramedic"
))

GLOBAL_GLOBL_LIST_INIT(nonhuman_positions, list(
	"AI",
	"Cyborg",
	"pAI"
))