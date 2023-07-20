// Ensures the frequency is within bounds of what it should be sending/receiving at.
/proc/sanitize_frequency(f)
	f = round(f)
	f = max(1441, f) // 144.1
	f = min(1489, f) // 148.9
	if((f % 2) == 0) // Ensures the last digit is an odd number.
		f += 1
	return f

// Turns 1479 into 147.9.
/proc/format_frequency(f)
	return "[round(f / 10)].[f % 10]"

/proc/register_radio(source, old_frequency, new_frequency, radio_filter)
	RETURN_TYPE(/datum/radio_frequency)

	if(isnotnull(old_frequency))
		global.CTradio.remove_object(source, old_frequency)
	if(isnotnull(new_frequency))
		return global.CTradio.add_object(source, new_frequency, radio_filter)

	return null

/proc/unregister_radio(source, frequency)
	global.CTradio?.remove_object(source, frequency)