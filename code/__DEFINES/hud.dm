// Space Parallax
#define PARALLAX_STAR_AMOUNT			849
#define PARALLAX_BLUESPACE_STAR_AMOUNT	1000
#define PARALLAX_SPACE		0
#define PARALLAX_BLUESPACE	1

// For secHUDs, medHUDs and variants. The number is the location of the image on the list hud_list of humans.
#define HEALTH_HUD		"health" // a simple line rounding the mob's number health
#define STATUS_HUD		"status" // alive, dead, diseased, etc.
#define ID_HUD			"id" // the job asigned to your ID
#define WANTED_HUD		"wanted" // wanted, released, parroled, security status
#define IMPSHIELD_HUD	"mindshield" // Mindshield implant
#define IMPLOYAL_HUD	"loyalty" // Loyalty implant
#define IMPCHEM_HUD		"chemical" // chemical implant
#define IMPTRACK_HUD	"tracking" // tracking implant
#define SPECIALROLE_HUD "antag" // AntagHUD image
#define STATUS_HUD_OOC	"status_ooc" // STATUS_HUD without virus db check for someone being ill.

#define APPEARANCE_UI_IGNORE_ALPHA	RESET_COLOR | RESET_TRANSFORM | NO_CLIENT_COLOR | RESET_ALPHA
#define APPEARANCE_UI				RESET_COLOR | RESET_TRANSFORM | NO_CLIENT_COLOR