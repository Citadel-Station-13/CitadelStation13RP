/obj/item/text_to_speech
	name = "TTS device"
	desc = "A device that speaks an inputted message. Given to crew which can not speak properly or at all."
	icon = 'icons/obj/integrated_electronics/electronic_setups.dmi'
	icon_state = "setup_small"
	w_class = ITEMSIZE_SMALL
	var/named

/obj/item/text_to_speech/attack_self(mob/user as mob)
	if(user.incapacitated(INCAPACITATION_KNOCKDOWN) || user.incapacitated(INCAPACITATION_DISABLED)) // EDIT: We can use the device only if we are not in certain types of incapacitation. We don't want chairs stopping us from texting!!
		to_chat(user, "You cannot activate the device in your state.")
		return

	if(!named)
		to_chat(user, "You input your name into the device.")
		name = "[initial(name)] ([user.real_name])"
		desc = "[initial(desc)] This one is assigned to [user.real_name]."
		named = 1
		/* //Another way of naming the device. Gives more freedom, but could lead to issues.
		device_name = copytext(sanitize(input(user, "What would you like to name your device? You must input a name before the device can be used.", "Name your device", "") as null|text),1,MAX_NAME_LEN)
		name = "[initial(name)] - [device_name]"
		named = 1
		*/

	var/message = sanitize(input(user,"Choose a message to relay to those around you.") as text|null)
	if(message)
		var/obj/item/text_to_speech/O = src
		audible_message("[icon2html(thing = O, target = world)] \The [O.name] states, \"[message]\"")

/obj/item/text_to_speech/AltClick(mob/user) // QOL Change
	attack_self(user)
