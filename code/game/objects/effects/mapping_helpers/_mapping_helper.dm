GLOBAL_GLOBL_LIST_NEW(mapping_helpers)

/obj/effect/mapping_helper
	icon = 'icons/effects/mapping_helpers.dmi'

/obj/effect/mapping_helper/New()
	SHOULD_CALL_PARENT(FALSE)

	GLOBL.mapping_helpers.Add(src)