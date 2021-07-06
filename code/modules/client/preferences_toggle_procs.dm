//Toggles for preferences, normal clients
/client/verb/toggle_ghost_ears()
	set name = "Show/Hide Ghost Ears"
	set category = "Preferences"
	set desc = "Toggles between seeing all mob speech and nearby mob speech."

	var/pref_path = /datum/client_preference/ghost_ears

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear all mob speech as a ghost.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TGEars") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_vision()
	set name = "Show/Hide Ghost Vision"
	set category = "Preferences"
	set desc = "Toggles between seeing all mob emotes and nearby mob emotes."

	var/pref_path = /datum/client_preference/ghost_sight

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] see all emotes as a ghost.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TGVision") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_radio()
	set name = "Show/Hide Radio Chatter"
	set category = "Preferences"
	set desc = "Toggles between seeing all radio chat and nearby radio chatter."

	var/pref_path = /datum/client_preference/ghost_radio

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear all radios as a ghost.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TGRadio") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_deadchat()
	set name = "Show/Hide Deadchat"
	set category = "Preferences"
	set desc = "Toggles the dead chat channel."

	var/pref_path = /datum/client_preference/show_dsay

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear dead chat as a ghost.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TDeadChat") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ooc()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = "Toggles global out of character chat."

	var/pref_path = /datum/client_preference/show_ooc

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(/datum/client_preference/show_ooc)) ? "now" : "no longer"] hear global out of character chat.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_looc()
	set name = "Show/Hide LOOC"
	set category = "Preferences"
	set desc = "Toggles local out of character chat."

	var/pref_path = /datum/client_preference/show_looc

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear local out of character chat.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_typing()
	set name = "Show/Hide Typing Indicator"
	set category = "Preferences"
	set desc = "Toggles the speech bubble typing indicator."

	var/pref_path = /datum/client_preference/show_typing_indicator

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] have the speech indicator.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TTIND") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ahelp_sound()
	set name = "Toggle Admin Help Sound"
	set category = "Preferences"
	set desc = "Toggles the ability to hear a noise broadcasted when you get an admin message."

	var/pref_path = /datum/client_preference/holder/play_adminhelp_ping

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] receive noise from admin messages.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAHelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_lobby_music()
	set name = "Toggle Lobby Music"
	set category = "Preferences"
	set desc = "Toggles the music in the lobby."

	var/pref_path = /datum/client_preference/play_lobby_music

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear music in the lobby.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TLobMusic") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_admin_midis()
	set name = "Toggle Admin MIDIs"
	set category = "Preferences"
	set desc = "Toggles the music in the lobby."

	var/pref_path = /datum/client_preference/play_admin_midis

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear MIDIs from admins.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAMidis") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ambience()
	set name = "Toggle Ambience"
	set category = "Preferences"
	set desc = "Toggles the playing of ambience."

	var/pref_path = /datum/client_preference/play_ambiance

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear ambient noise.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAmbience") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_weather_sounds()
	set name = "Toggle Weather Sounds"
	set category = "Preferences"
	set desc = "Toggles the ability to hear weather sounds while on a planet."

	var/pref_path = /datum/client_preference/weather_sounds

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear weather sounds.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TWeatherSounds") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_supermatter_hum()
	set name = "Toggle SM Hum" // Avoiding using the full 'Supermatter' name to not conflict with the Setup-Supermatter adminverb.
	set category = "Preferences"
	set desc = "Toggles the ability to hear supermatter hums."

	var/pref_path = /datum/client_preference/supermatter_hum

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear a hum from the supermatter.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TSupermatterHum") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_jukebox()
	set name = "Toggle Jukebox"
	set category = "Preferences"
	set desc = "Toggles the playing of jukebox music."

	var/pref_path = /datum/client_preference/play_jukebox

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear jukebox music.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TJukebox") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_be_special(role in be_special_flags)
	set name = "Toggle SpecialRole Candidacy"
	set category = "Preferences"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."

	var/role_flag = be_special_flags[role]
	if(!role_flag)	return

	prefs.be_special ^= role_flag
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src,"You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible).")

	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_air_pump_hum()
	set name = "Toggle Air Pump Noise"
	set category = "Preferences"
	set desc = "Toggles Air Pumps humming"

	var/pref_path = /datum/client_preference/air_pump_noise

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear air pumps hum, start, and stop.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAirPumpNoise")

/client/verb/toggle_pickup_sounds()
	set name = "Toggle Picked Up Item Sounds"
	set category = "Preferences"
	set desc = "Toggles sounds when items are picked up or thrown."

	var/pref_path = /datum/client_preference/pickup_sounds

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear sounds when items are picked up or thrown.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb", "TPickupSounds")


/client/verb/toggle_safe_firing()
	set name = "Toggle Gun Firing Intent Requirement"
	set category = "Preferences"
	set desc = "Toggles between safe and dangerous firing. Safe requires a non-help intent to fire, dangerous can be fired on help intent."

	var/pref_path = /datum/client_preference/safefiring
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src,"You will now use [(is_preference_enabled(/datum/client_preference/safefiring)) ? "safe" : "dangerous"] firearms firing.")

	feedback_add_details("admin_verb","TFiringMode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_mob_tooltips()
	set name = "Toggle Mob Tooltips"
	set category = "Preferences"
	set desc = "Toggles displaying name/species over mobs when moused over."

	var/pref_path = /datum/client_preference/mob_tooltips
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src,"You will now [(is_preference_enabled(/datum/client_preference/mob_tooltips)) ? "see" : "not see"] mob tooltips.")

	feedback_add_details("admin_verb","TMobTooltips") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_hear_instruments()
	set name = "Toggle Hear/Ignore Instruments"
	set category = "Preferences"
	set desc = "Hear In-game Instruments"

	var/pref_path = /datum/client_preference/instrument_toggle
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will [(is_preference_enabled(/datum/client_preference/instrument_toggle)) ? "now hear" : "no longer hear"] instruments being played.")

	feedback_add_details("admin_verb","THInstm") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_status_indicators()
	set name = "Toggle Status Indicators"
	set category = "Preferences"
	set desc = "Enable/Disable seeing status indicators over peoples' heads."

	var/pref_path = /datum/client_preference/status_indicators
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will now [(is_preference_enabled(/datum/client_preference/status_indicators)) ? "see" : "not see"] status indicators.")

	feedback_add_details("admin_verb","TStatusIndicators")

/client/verb/toggle_overhead_chat()
	set name = "Toggle Overhead Chat"
	set category = "Preferences"
	set desc = "Enable/Disable seeing overhead chat messages."

	var/pref_path = /datum/client_preference/overhead_chat
	toggle_preference(pref_path)
	SScharacter_setup.queue_preferences_save(prefs)

	to_chat(src, "You will now [(is_preference_enabled(/datum/client_preference/overhead_chat)) ? "see" : "not see"] overhead chat messages..")

	feedback_add_details("admin_verb","TOHChat")

//Toggles for Staff
//Developers

/client/proc/toggle_debug_logs()
	set name = "Toggle Debug Logs"
	set category = "Preferences"
	set desc = "Toggles debug logs."

	var/pref_path = /datum/client_preference/debug/show_debug_logs

	if(check_rights(R_ADMIN|R_DEBUG))
		toggle_preference(pref_path)
		to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] receive debug logs.")
		SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//Mods
/client/proc/toggle_attack_logs()
	set name = "Toggle Attack Logs"
	set category = "Preferences"
	set desc = "Toggles attack logs."

	var/pref_path = /datum/client_preference/mod/show_attack_logs

	if(check_rights(R_ADMIN|R_MOD))
		toggle_preference(pref_path)
		to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] receive attack logs.")
		SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/toggle_age_verification()
	set name = "Toggle age verification status"
	set category = "Debug"
	set desc = "Toggles your age verified status."

	var/pref_path = /datum/client_preference/debug/age_verified

	toggle_preference(pref_path)

	to_chat(src,"You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] be prompted to verify age.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAgeVerify") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/mob/living/carbon/human/verb/toggle_pain_msg()
	set name = "Toggle Pain Messages"
	set category = "Preferences"
	set desc = "Toggles pain messages."

	if(painmsg)
		src.painmsg = 0
	else
		src.painmsg = 1
	to_chat(src,"You will [ (painmsg) ? "now" : "no longer"] see your own pain messages.")
	feedback_add_details("admin_verb","painmsg") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/mob/living/carbon/human/verb/acting()
	set name = "Feign Impairment"
	set category = "IC"
	set desc = "Allows user to manually enable drunkenness, stutter, jitter, etc."

	var/list/choices = list("Drunkenness", "Stuttering", "Jittering")
	if(src.slurring >= 10 || src.stuttering >= 10 || src.jitteriness >= 100)
		var/disable = alert(src, "Stop performing impairment? (Do NOT abuse this)", "Impairments", "Yes", "No")
		if(disable == "Yes")
			acting_expiry()
			return

	var/impairment = input(src, "Select an impairment to perform:", "Impairments") as null|anything in choices
	if(!impairment)
		return
	var/duration = input(src,"Choose a duration to perform [impairment]. (1 - 60 seconds)","Duration in seconds",25) as num|null
	if(!isnum(duration))
		return
	if(duration > 60 && !check_rights(R_EVENT, 0)) // admins can do as they please
		to_chat(src, "Please choose a duration in seconds between 1 to 60.")
		return
	if(duration >= 1000) // unreachable code for anyone but admins who have set the number very high, logging for my sanity
		message_admins("[src] has set their [impairment] to [duration] via Feign Impairment.")
	if(duration >= 2000)
		to_chat(src, "Please choose a duration less than 2000.")
		return
	if(impairment == "Drunkenness")
		slurring = duration
	if(impairment == "Stuttering")
		stuttering = duration
	if(impairment == "Jittering")
		make_jittery(duration + 100)

	if(duration)
		addtimer(CALLBACK(src, .proc/acting_expiry), duration SECONDS)
		var/aduration = duration SECONDS / 10
		to_chat(src,"You will now performatively act as if you were experiencing [impairment] for [aduration] seconds. (Do NOT abuse this)")
	feedback_add_details("admin_verb","actimpaired") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/mob/living/carbon/human/proc/acting_expiry()
	to_chat(src,"You are no longer acting impaired.") // tick down from 1 to allow the effects to end 'naturally'
	slurring = 1
	stuttering = 1
	jitteriness = 1

