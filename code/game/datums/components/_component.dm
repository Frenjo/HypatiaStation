/datum/component
	VAR_PRIVATE/datum/_parent_datum = null // The datum that this component is attached to.

/datum/component/New(datum/parent_datum, ...)
	. = ..()
	var/datum/component/existing_component = parent_datum.GetExactComponent(type)
	if(isnotnull(existing_component))
		qdel(src)
		return

	_parent_datum = parent_datum
	LAZYADD(parent_datum.datum_components, src)

/datum/component/Destroy()
	if(isnotnull(_parent_datum))
		LAZYREMOVE(_parent_datum.datum_components, src)
		_parent_datum = null
	return ..()