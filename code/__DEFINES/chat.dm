/*
 * SPAN_X Macros
*/
#define SPAN(CLASS, TEXT) "<span class='[CLASS]'>[TEXT]</span>"
#define SPAN_INFO(TEXT) SPAN("info", TEXT)
#define SPAN_INFO_B(TEXT) SPAN_INFO("<B>[TEXT]</B>")
#define SPAN_NOTICE(TEXT) SPAN("notice", TEXT)
#define SPAN_WARNING(TEXT) SPAN("warning", TEXT)
#define SPAN_DANGER(TEXT) SPAN("danger", TEXT)
#define SPAN_ALIUM(TEXT) SPAN("alium", TEXT)
#define SPAN_RADIOACTIVE(TEXT) SPAN("radioactive", TEXT)
#define SPAN_ALERT(TEXT) SPAN("alert", TEXT)
#define SPAN_ERROR(TEXT) SPAN("error", TEXT)
#define SPAN_DISARM(TEXT) SPAN("disarm", TEXT)
#define SPAN_CAUTION(TEXT) SPAN("caution", TEXT)
#define SPAN_MODERATE(TEXT) SPAN("moderate", TEXT)
#define SPAN_DEADSAY(TEXT) SPAN("deadsay", TEXT)

/*
 * Languages
 */
#define LANGUAGE_PREFIX_KEY ","