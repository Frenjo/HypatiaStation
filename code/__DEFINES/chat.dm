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
 */
#define FEEDBACK_ACCESS_DENIED SPAN_WARNING("Access denied.")
#define FEEDBACK_NOT_ENOUGH_DEXTERITY SPAN_WARNING("You don't have the dexterity to use \the [src]!")

// These two will (hopefully) be removed when I get around to a construction overhaul...
// Because once that's done, this stuff will be more centralised and not all over the place.
#define FEEDBACK_DISCONNECT_MONITOR SPAN_INFO("You disconnect the monitor.")
#define FEEDBACK_BROKEN_GLASS_FALLS SPAN_INFO("The broken glass falls out.")