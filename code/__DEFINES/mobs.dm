#define ALIEN_SELECT_AFK_BUFFER 1 // How many minutes that a person can be AFK before not being allowed to be an alien.

//mob/var/stat things
#define CONSCIOUS	0
#define UNCONSCIOUS	1
#define DEAD		2

//Bitflags defining which status effects could be or are inflicted on a mob
#define CANSTUN		BITFLAG(0)
#define CANWEAKEN	BITFLAG(1)
#define CANPARALYSE	BITFLAG(2)
#define CANPUSH		BITFLAG(3)
#define LEAPING		BITFLAG(4)
#define GODMODE		BITFLAG(5)
#define FAKEDEATH	BITFLAG(6) // Replaces stuff like changeling.changeling_fakedeath
#define DISFIGURED	BITFLAG(7) // I'll probably move this elsewhere if I ever get wround to writing a bitflag mob-damage system
#define XENO_HOST	BITFLAG(8) // Tracks whether we're gonna be a baby alien's mummy.

//Grab levels
#define GRAB_PASSIVE	1
#define GRAB_AGGRESSIVE	2
#define GRAB_NECK		3
#define GRAB_UPGRADING	4
#define GRAB_KILL		5

#define AI_CAMERA_LUMINOSITY 6

#define BORGMESON	BITFLAG(0)
#define BORGTHERM	BITFLAG(1)
#define BORGXRAY	BITFLAG(2)

#define HOSTILE_STANCE_IDLE			1
#define HOSTILE_STANCE_ALERT		2
#define HOSTILE_STANCE_ATTACK		3
#define HOSTILE_STANCE_ATTACKING	4
#define HOSTILE_STANCE_TIRED		5

#define LEFT	1
#define RIGHT	2

//Pulse levels, very simplified
#define PULSE_NONE		0	//so !M.pulse checks would be possible
#define PULSE_SLOW		1	//<60 bpm
#define PULSE_NORM		2	//60-90 bpm
#define PULSE_FAST		3	//90-120 bpm
#define PULSE_2FAST		4	//>120 bpm
#define PULSE_THREADY	5	//occurs during hypovolemic shock

//proc/get_pulse methods
#define GETPULSE_HAND	0	//less accurate (hand)
#define GETPULSE_TOOL	1	//more accurate (med scanner, sleeper, etc)

//These are used Bump() code for living mobs, in the mob_bump_flag, mob_swap_flags, and mob_push_flags vars to determine whom can bump/swap with whom.
#define HUMAN			BITFLAG(0)
#define MONKEY			BITFLAG(1)
#define ALIEN			BITFLAG(2)
#define ROBOT			BITFLAG(3)
#define SLIME			BITFLAG(4)
#define SIMPLE_ANIMAL	BITFLAG(5)
#define ALLMOBS			(HUMAN | MONKEY | ALIEN | ROBOT | SLIME | SIMPLE_ANIMAL)

#define AGE_MIN 17			//youngest a character can be
#define AGE_MAX 85			//oldest a character can be

// Incapacitation flags, used by the mob/proc/incapacitated() proc
#define INCAPACITATION_RESTRAINED			1
#define INCAPACITATION_BUCKLED_PARTIALLY	2
#define INCAPACITATION_BUCKLED_FULLY		4

#define INCAPACITATION_DEFAULT	(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_FULLY)
#define INCAPACITATION_ALL		(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_PARTIALLY | INCAPACITATION_BUCKLED_FULLY)

#define TK_MAXRANGE 15