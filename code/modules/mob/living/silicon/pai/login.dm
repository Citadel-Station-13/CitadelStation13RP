/mob/living/silicon/pai/Login()
	. = ..()
	// Vorestation Edit: Meta Info for pAI
	if (client.prefs)
		ooc_notes = client.prefs.metadata
