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