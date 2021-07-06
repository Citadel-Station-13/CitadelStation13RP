var/list/floating_chat_colors = list()

/atom/movable
	var/list/stored_chat_text

/atom/movable/proc/animate_chat(message, var/datum/language/speaking = null, small, list/show_to, duration)
	set waitfor = FALSE

	// Get rid of any URL schemes that might cause BYOND to automatically wrap something in an anchor tag
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	message = replacetext(message, url_scheme, "")

	var/static/regex/html_metachars = new(@"&[A-Za-z]{1,7};", "g")
	message = replacetext(message, html_metachars, "")

	var/style	//additional style params for the message
	var/fontsize = 4
	if(small)
		fontsize = 2
	var/limit = 160
	if(copytext_char(message, length_char(message) - 1) == "!!")
		fontsize = 8
		limit = 160
		style += "font-weight: bold;"

	if(length_char(message) > limit)
		message = "[copytext_char(message, 1, limit)]..."

	if(!floating_chat_colors[src])
		floating_chat_colors[src] = get_random_colour(0,160,230)
	style += "color: [floating_chat_colors[src]];"

	// create 2 messages, one that appears if you know the language, and one that appears when you don't know the language
	var/image/understood = generate_floating_text(src, capitalize(message), style, fontsize, duration, show_to)
	var/image/gibberish = speaking ? generate_floating_text(src, speaking.scramble(message), style, fontsize, duration, show_to) : understood

	for(var/client/C in show_to)
		if(!C.mob.is_deaf() && C.is_preference_enabled(/datum/client_preference/overhead_chat))
			if(C.mob.say_understands(null, speaking))
				C.images += understood
			else
				C.images += gibberish

/proc/generate_floating_text(atom/movable/holder, message, style, size, duration, show_to)
	var/image/I = image(null, holder)
	I.plane = PLANE_PLAYER_HUD
	I.layer = PLANE_PLAYER_HUD_ITEMS
	I.alpha = 15
	I.maptext_width = 160
	I.maptext_height = 64
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	I.pixel_x = -round(I.maptext_width/2) + 16

	//style = "font: 'Small Fonts'; -dm-text-outline: 1px black; font-size: [size]px; [style]"

	I.maptext = "<center><span style=\"[style] font: 'Small Fonts'; -dm-text-outline: 1px black; \">[message]</span></center>"
	animate(I, 1, alpha = 255, pixel_y = 16)

	for(var/image/old in holder.stored_chat_text)
		animate(old, 2, pixel_y = old.pixel_y + 8)
	LAZYADD(holder.stored_chat_text, I)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_floating_text, holder, I), duration + 16)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_images_from_clients, I, show_to), duration + 18)

	return I

/proc/remove_floating_text(atom/movable/holder, image/I)
	animate(I, 2, pixel_y = I.pixel_y + 10, alpha = 0)
	LAZYREMOVE(holder.stored_chat_text, I)
