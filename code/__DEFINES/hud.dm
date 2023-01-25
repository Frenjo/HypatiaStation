// Space Parallax
#define PARALLAX_STAR_AMOUNT			849
#define PARALLAX_BLUESPACE_STAR_AMOUNT	1000
#define PARALLAX_SPACE		0
#define PARALLAX_BLUESPACE	1

// For secHUDs, medHUDs and variants. The number is the location of the image on the list hud_list of humans.
#define HEALTH_HUD		1 // a simple line rounding the mob's number health
#define STATUS_HUD		2 // alive, dead, diseased, etc.
#define ID_HUD			3 // the job asigned to your ID
#define WANTED_HUD		4 // wanted, released, parroled, security status
#define IMPLOYAL_HUD	5 // loyality implant
#define IMPCHEM_HUD		6 // chemical implant
#define IMPTRACK_HUD	7 // tracking implant
#define SPECIALROLE_HUD 8 // AntagHUD image
#define STATUS_HUD_OOC	9 // STATUS_HUD without virus db check for someone being ill.

#define APPEARANCE_UI_IGNORE_ALPHA	RESET_COLOR | RESET_TRANSFORM | NO_CLIENT_COLOR | RESET_ALPHA
#define APPEARANCE_UI				RESET_COLOR | RESET_TRANSFORM | NO_CLIENT_COLOR