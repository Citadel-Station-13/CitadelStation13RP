// Ensure the frequency is within bounds of what it should be sending/receiving at
/proc/sanitize_frequency(frequency, free = FALSE)
	frequency = round(frequency)
	if(free)
		. = clamp(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ) //MIN_FREE_FREQ, MAX_FREE_FREQ
	else
		. = clamp(frequency, PUBLIC_LOW_FREQ, PUBLIC_HIGH_FREQ) //MIN_FREQ, MAX_FREQ)
	if(!(. % 2)) // Ensure the last digit is an odd number
		. += 1

// Format frequency by moving the decimal.
/proc/format_frequency(frequency)
	frequency = text2num(frequency)
	return "[round(frequency / 10)].[frequency % 10]"

//Opposite of format, returns as a number
/proc/unformat_frequency(frequency)
	frequency = text2num(frequency)
	return frequency * 10
