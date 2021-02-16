/mob/proc/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/whispering = 0)
	return

/mob/proc/whisper_wrapper()
	var/message = input("","whisper (text)") as text|null
	if(message)
		whisper(message)

/mob/proc/subtle_wrapper()
	var/message = input("","subtle (text)") as message|null
	if(message)
		me_verb_subtle(message)

/mob/verb/whisper(message as text)
	set name = "Whisper"
	set category = "IC"

	usr.say(message,whispering=1)

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"

	set_typing_indicator(FALSE)
	usr.say(message)

/mob/verb/me_verb(message as message)
	set name = "Me"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<font color='red'>Speech is currently admin-disabled.</font>")
		return

	//VOREStation Edit Start
	if(muffled)
		return me_verb_subtle(message)
	message = sanitize_or_reflect(message,src) //VOREStation Edit - Reflect too-long messages (within reason)
	//VOREStation Edit End

	set_typing_indicator(FALSE)
	if(use_me)
		usr.emote("me",usr.emote_type,message)
	else
		usr.emote(message)

/mob/proc/say_dead(var/message)
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(!client)
		return // Clientless mobs shouldn't be trying to talk in deadchat.

	if(!src.client.holder)
		if(!config_legacy.dsay_allowed)
			to_chat(src, "<span class='danger'>Deadchat is globally muted.</span>")
			return

	if(!is_preference_enabled(/datum/client_preference/show_dsay))
		to_chat(usr, "<span class='danger'>You have deadchat muted.</span>")
		return

	message = say_emphasis(message)

	say_dead_direct("[pick("complains","moans","whines","laments","blubbers")], <span class='message'>\"[message]\"</span>", src)

/mob/proc/say_understands(var/mob/other,var/datum/language/speaking = null)

	if (src.stat == DEAD)
		return 1

	//Universal speak makes everything understandable, for obvious reasons.
	else if(src.universal_speak || src.universal_understand)
		return 1

	//Languages are handled after.
	if (!speaking)
		if(!other)
			return 1
		if(other.universal_speak)
			return 1
		if(isAI(src) && ispAI(other))
			return 1
		if (istype(other, src.type) || istype(src, other.type))
			return 1
		return 0

	if(speaking.flags & INNATE)
		return 1

	//Language check.
	for(var/datum/language/L in src.languages)
		if(speaking.name == L.name)
			return 1

	return 0

/*
   ***Deprecated***
   let this be handled at the hear_say or hear_radio proc
   This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
   robot_talk() proc.
   There is no language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/proc/say_quote(var/message, var/datum/language/speaking = null)
	var/overrode = speaking.get_spoken_verb(copytext_char(message, length(message)))
	if(overrode)
		return overrode
	return say_mod(message)

/mob/proc/emote(var/act, var/type, var/message)
	if(act == "me")
		return custom_emote(type, message)

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(var/text)
	var/ending = copytext_char(text, length_char(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(var/message, var/standard_mode="headset")
	if(length_char(message) >= 1 && copytext_char(message,1,2) == ";")
		return standard_mode

	if(length_char(message) >= 2)
		var/channel_prefix = copytext_char(message, 1 ,3)
		return department_radio_keys[channel_prefix]

	return null

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(var/message)
	var/prefix = copytext_char(message,1,2)
	// This is for audible emotes
	if(length_char(message) >= 1 && prefix == "!")
		return GLOB.all_languages["Noise"]

	if(length_char(message) >= 2 && is_language_prefix(prefix))
		var/language_prefix = lowertext(copytext_char(message, 2 ,3))
		var/datum/language/L = GLOB.language_keys[language_prefix]
		if (can_speak(L))
			return L
		else
			return GLOB.all_languages[LANGUAGE_GIBBERISH]
	return null
