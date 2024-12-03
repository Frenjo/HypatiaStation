/*
 * For the love of god use these when adding a new configuration entry.
 */
#define CONFIG_ENTRY(TYPE, VALUE, DESCRIPTION, CATEGORY, VALUE_TYPE) \
/decl/configuration_entry/##TYPE \
{ \
	name = #TYPE; \
	description = DESCRIPTION; \
	\
	category = CATEGORY; \
	\
	value = VALUE; \
	value_type = VALUE_TYPE; \
}
// This one's the same as above except it has a null description value.
#define CONFIG_ENTRY_UNDESCRIBED(TYPE, VALUE, CATEGORY, VALUE_TYPE) CONFIG_ENTRY(TYPE, VALUE, null, CATEGORY, VALUE_TYPE)

/decl/configuration_entry
	var/name = null
	var/list/description = null

	var/category = CATEGORY_NONE_DEFAULT

	var/value = null
	var/value_type = TYPE_NONE