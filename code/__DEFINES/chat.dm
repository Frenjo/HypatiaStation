/*
 * Generic Chat Macros
*/
#define to_chat(target, message)	target << message
#define to_world(message)			to_chat(world, message)

/*
 * SPAN_X Macros
*/
#define SPAN(class, text)		"<span class='[class]'>[text]</span>"
#define SPAN_INFO(text)			SPAN("info", text)
#define SPAN_INFO_B(text)		SPAN_INFO("<B>[text]</B>")
#define SPAN_NOTICE(text)		SPAN("notice", text)
#define SPAN_WARNING(text)		SPAN("warning", text)
#define SPAN_DANGER(text)		SPAN("danger", text)
#define SPAN_ALIUM(text)		SPAN("alium", text)
#define SPAN_RADIOACTIVE(text)	SPAN_ALIUM("<B>[text]</B>")
#define SPAN_ALERT(text)		SPAN("alert", text)
#define SPAN_ERROR(text)		SPAN("error", text)
#define SPAN_DISARM(text)		SPAN("disarm", text)
#define SPAN_CAUTION(text)		SPAN("caution", text)
#define SPAN_MODERATE(text)		SPAN("moderate", text)

/*
 * Feedback Defines
 *
 * Any messages that appear more than four or five times can be put here for consistency.
 * From then on, we can look at what's here and see what other code might need refactoring.
 *
 * Hopefully with these, we can both:
 *	Simplify common feedback messages into simple defines.
 *	Ensure SPAN_X consistency across types of feedback messages.
 *
 * In these macros, T represents the target of the feedback - IE user, usr, src, etc...
 */
#define FEEDBACK_ERROR_GENERIC(T)			to_chat(T, SPAN_DANGER("ERROR"))
#define FEEDBACK_ACCESS_DENIED(T)			to_chat(T, SPAN_WARNING("Access denied."))
#define FEEDBACK_NOT_ENOUGH_DEXTERITY(T)	to_chat(T, SPAN_WARNING("You don't have the dexterity to use \the [src]!"))
// This is a generic one for things that don't have a custom message.
#define FEEDBACK_ALREADY_EMAGGED(T)			to_chat(T, SPAN_WARNING("\The [src] is already emagged!"))
#define FEEDBACK_MACHINE_UNRESPONSIVE(T)	to_chat(T, SPAN_INFO("\The [src] is unresponsive."))

// These will (hopefully) be removed when I get around to a construction overhaul...
// Because once that's done, this stuff will be more centralised and not all over the place.
#define FEEDBACK_DISCONNECT_MONITOR(T)				to_chat(T, SPAN_INFO("You disconnect the monitor."))
#define FEEDBACK_BROKEN_GLASS_FALLS(T)				to_chat(T, SPAN_INFO("The broken glass falls out."))
#define FEEDBACK_TOGGLE_CONTROLS_LOCK(USER, LOCKED)	to_chat(USER, SPAN_INFO("You [LOCKED ? "lock" : "unlock"] the controls on \the [src]."))
#define FEEDBACK_TOGGLE_MAINTENANCE_PANEL(USER, OPENED) \
USER.visible_message( \
	SPAN_INFO("[USER] [OPENED ? "open" : "close"]s the maintenance panel on \the [src]."), \
	SPAN_INFO("You [OPENED ? "open" : "close"] the maintenance panel on \the [src]."), \
	SPAN_INFO("You hear someone using a screwdriver.") \
)

#define FEEDBACK_GUN_NOT_ACTIVE_HAND(T) to_chat(T, SPAN_WARNING("You need your gun in your active hand to do that!"))

#define FEEDBACK_YOU_FEEL_BETTER(T) to_chat(T, SPAN_INFO("You feel better."))

#define FEEDBACK_SPEECH_ADMIN_DISABLED(T)	to_chat(T, SPAN_WARNING("Speech is currently admin-disabled."))
#define FEEDBACK_MOVEMENT_ADMIN_DISABLED(T)	to_chat(T, SPAN_WARNING("Movement is currently admin-disabled."))

#define FEEDBACK_COMMAND_ADMIN_ONLY(T) to_chat(T, SPAN_WARNING("Only administrators may use this command."))

#define FEEDBACK_CULT_SACRIFICE_ACCEPTED(T) to_chat(T, SPAN_WARNING("The Geometer of Blood accepts this sacrifice."))

/*
 * The following originally had two separate messages for speaking and emoting:
 *	"You cannot speak in IC (muted)."
 *	"You cannot send IC messages (muted)."
 *
 * I have no idea if that was the case for some special reason but I've merged them into one...
 * ... and am leaving this note in case it breaks anything later.
 *
 * They were both controlled by checking client.prefs.muted & MUTE_IC as far as I can see...
 * ... so I think it might have just been for flavour.
 */
#define FEEDBACK_IC_MUTED(T) to_chat(T, SPAN_WARNING("You cannot speak or send messages in IC (muted)."))

#define FEEDBACK_ANTAGONIST_GREETING_GUIDE(T) to_chat(T, "<font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>")