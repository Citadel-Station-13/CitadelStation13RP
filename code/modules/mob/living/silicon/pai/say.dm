/mob/living/silicon/pai/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/whispering = 0)
	if(silent)
		to_chat(src, "<span class='warning'>Communication circuits remain unitialized.</span>")
	else
		..(message)

/mob/living/silicon/pai/binarycheck()
	return FALSE

/*
/mob/living/silicon/pai/radio(message, message_mode, list/spans, language)
	if((message_mode == "robot") || (message_mode in GLOB.radiochannels))
		if(radio_short)
			to_chat(src, "<span class='warning'>Your radio is shorted out!</span>")
			return ITALICS | REDUCE_RANGE
	return ..()
*/
