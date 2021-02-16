/mob/living/silicon/verb/clear_custom_holoform()
	set name = "Clear Custom Holoform"
	set desc = "Clear your current custom holoform"
	set category = "OOC"
	if(!client.prefs)
		to_chat(src, "<span class='boldwarning'>No preferences datum on your client, contact an admin/coder!</span>")
		return
	client.prefs.custom_holoform_icon = null
	client.prefs.cached_holoform_icons = null
	to_chat(src, "<span class='boldnotice'>Holoform removed.</span>")

/mob/living/silicon/verb/set_custom_holoform()
	set name = "Set Custom Holoform"
	set desc = "Set your custom holoform using your current preferences slot and a specified set of gear."
	if(!client.prefs)
		to_chat(src, "<span class='boldwarning'>No preferences datum on your client, contact an admin/coder!</span>")
		return
	if(client.prefs.last_custom_holoform > world.time - CUSTOM_HOLOFORM_DELAY)
		to_chat(src, "<span class='warning'>You are attempting to change custom holoforms too fast!</span>")

	var/icon/new_holoform = user_interface_custom_holoform(client)
	if(new_holoform)
		client.prefs.custom_holoform_icon = new_holoform
		client.prefs.cached_holoform_icons = null
		client.prefs.last_custom_holoform = world.time
		to_chat(src, "<span class='boldnotice'>Holoform set.</span>")

/mob/living/silicon/proc/attempt_set_custom_holoform()
	if(!client.prefs)
		to_chat(src, "<span class='boldwarning'>No preferences datum on your client, contact an admin/coder!</span>")
		return
	var/icon/new_holoform = user_interface_custom_holoform(client)
	client.prefs.last_custom_holoform = world.time
	if(new_holoform)
		client.prefs.custom_holoform_icon = new_holoform
		client.prefs.cached_holoform_icons = null
		to_chat(src, "<span class='boldnotice'>Holoform set.</span>")
		return TRUE
	return FALSE

/datum/action/innate/custom_holoform
	name = "Select Custom Holoform"
	desc = "Select one of your existing avatars to use as a holoform."
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "custom_holoform"
	required_mobility_flags = NONE

/datum/action/innate/custom_holoform/Trigger()
	if(!..())
		return FALSE
	var/mob/living/silicon/S = owner

	//if setting the holoform succeeds, attempt to set it as the current holoform for the pAI or AI
	if(S.attempt_set_custom_holoform())
		if(istype(S, /mob/living/silicon/pai))
			var/mob/living/silicon/pai/P = S
			P.chassis = "custom"
		else if(istype(S, /mob/living/silicon/ai))
			var/mob/living/silicon/ai/A = S
			if(A.client?.prefs?.custom_holoform_icon)
				A.holo_icon = A.client.prefs.get_filtered_holoform(HOLOFORM_FILTER_AI)
			else
				A.holo_icon = getHologramIcon(icon('icons/mob/ai.dmi', "female"))

	return TRUE
