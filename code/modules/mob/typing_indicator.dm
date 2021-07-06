/proc/generate_speech_bubble(var/bubble_loc, var/speech_state, var/set_layer = FLOAT_LAYER, list/show_to, duration)
	var/image/I = image('icons/mob/talk_vr.dmi')  //VOREStation Edit - talk_vr.dmi instead of talk.dmi for right-side icons
	for(var/client/C in show_to)
		C.images += I
	animate(I, transform = 0, alpha = 255, time = 0.2 SECONDS, easing = EASE_IN)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/fade_out, I, show_to), (duration - 0.5 SECONDS))

	return I

/mob/proc/init_typing_indicator(var/set_state = "typing")
	typing_indicator = new
	typing_indicator.appearance = generate_speech_bubble(null, set_state)
	typing_indicator.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)			//VOREStation Edit

/mob/proc/set_typing_indicator(var/state) //Leaving this here for mobs.

	if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
		if(typing_indicator)
			cut_overlay(typing_indicator, TRUE)
		return

	if(!typing_indicator)
		init_typing_indicator("[speech_bubble_appearance()]_typing")

	if(state && !typing)
		add_overlay(typing_indicator, TRUE)
		typing = TRUE
	else if(typing)
		cut_overlay(typing_indicator, TRUE)
		typing = FALSE

	if(shadow) //Multi-Z above-me shadows
		shadow.set_typing_indicator(state)

	return state

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	set_typing_indicator(TRUE)
	var/message = input("","say (text)") as text|null
	set_typing_indicator(FALSE)

	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	set_typing_indicator(TRUE)
	var/message = input("","me (text)") as message|null
	set_typing_indicator(FALSE)

	if(message)
		me_verb(message)
