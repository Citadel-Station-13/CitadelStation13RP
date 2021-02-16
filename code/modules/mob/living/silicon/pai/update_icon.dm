/mob/living/silicon/pai/update_icon()
	if(chassis == "custom")			//Make sure custom exists if it's set to custom
		custom_holoform_icon = client?.prefs?.get_filtered_holoform(HOLOFORM_FILTER_PAI)
		if(!custom_holoform_icon)
			chassis = pick(possible_chassis - "custom")
	if(chassis == "dynamic")		//handle dynamic generated icons
		icon = dynamic_chassis_icons[dynamic_chassis]
		var/list/states = icon_states(icon)
		icon_state = ""
		if(resting)		//The next line is some bullshit but I can make it worse if you want and make it a single line instead of four.. :)
			if(dynamic_chassis_sit && ("sit" in states))
				icon_state = "sit"
			else if(dynamic_chassis_bellyup && ("bellyup" in states))
				icon_state = "bellyup"
			else if("rest" in states)
				icon_state = "rest"
		// rotate_on_lying = FALSE
	else if(chassis == "custom")
		icon = custom_holoform_icon
		icon_state = ""
		// rotate_on_lying = TRUE
	else
		icon = initial(icon)
		icon_state = "[chassis][resting? "_rest" : (stat == DEAD? "_dead" : "")]"
		// rotate_on_lying = FALSE
	pixel_x = ((chassis == "dynamic") && chassis_pixel_offsets_x[dynamic_chassis]) || 0
	update_transform()

#warn snowflake in laying down because baycode transform is a trash fire
//IMPORTANT: Multiple animate() calls do not stack well, so try to do them all at once if you can.
/*
/mob/living/update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/final_pixel_y = pixel_y
	var/changed = 0
	if(lying != lying_prev && rotate_on_lying)
		changed++
		ntransform.TurnTo(lying_prev,lying)
		if(lying == 0) //Lying to standing
			final_pixel_y = get_standard_pixel_y_offset()
		else //if(lying != 0)
			if(lying_prev == 0) //Standing to lying
				pixel_y = get_standard_pixel_y_offset()
				final_pixel_y = get_standard_pixel_y_offset(lying)
				if(dir & (EAST|WEST)) //Facing east or west
					setDir(pick(NORTH, SOUTH)) //So you fall on your side rather than your face or ass

	if(resize != RESIZE_DEFAULT_SIZE)
		changed++
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(changed)
		animate(src, transform = ntransform, time = 2, pixel_y = final_pixel_y, easing = EASE_IN|EASE_OUT)
		floating_need_update = TRUE
*/
