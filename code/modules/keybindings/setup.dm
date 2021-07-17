/client
	/// A rolling buffer of any keys held currently
	var/list/keys_held = list()
	/// These next two vars are to apply movement for keypresses and releases made while move delayed.
	/// Because discarding that input makes the game less responsive.
 	/// On next move, add this dir to the move that would otherwise be done
	var/next_move_dir_add
 	/// On next move, subtract this dir from the move that would otherwise be done
	var/next_move_dir_sub

// Set a client's focus to an object and override these procs on that object to let it handle keypresses
/datum/proc/key_down(key, client/user) // Called when a key is pressed down initially
	return

/datum/proc/key_up(key, client/user) // Called when a key is released
	return

/datum/proc/keyLoop(client/user) // Called once every frame
	set waitfor = FALSE
	return

/client/verb/fix_macros()
	set name = "Fix Keybindings"
	set desc = "Re-assert all your macros/keybindings."
	set category = "OOC"
	if(!SSinput.subsystem_initialized)
		to_chat(src, "<span class='warning'>Input hasn't been initialized yet. Wait a while.</span>")
		return
	log_debug("[src] reset their keybindings.")
	to_chat(src, "<span class='danger'>Force-reasserting all macros.</span>")
	set_macros(prefs)

// removes all the existing macros
/client/proc/erase_all_macros()
	var/erase_output = ""
	var/list/macro_set = params2list(winget(src, "default.*", "command")) // The third arg doesnt matter here as we're just removing them all
	for(var/k in 1 to length(macro_set))
		var/list/split_name = splittext(macro_set[k], ".")
		var/macro_name = "[split_name[1]].[split_name[2]]" // [3] is "command"
		erase_output = "[erase_output];[macro_name].parent=null"
	winset(src, null, erase_output)

/client/proc/apply_macro_set(name, list/macroset)
	ASSERT(name)
	ASSERT(islist(macroset))
	winclone(src, "default", name)
	for(var/i in 1 to length(macroset))
		var/key = macroset[i]
		var/command = macroset[key]
		winset(src, "[name]-[REF(key)]", "parent=[name];name=[key];command=[command]")

/client/proc/set_macros(datum/preferences/prefs_override = prefs)
	set waitfor = FALSE

	keys_held.Cut()

	outputKeepAlivePage()

	erase_all_macros()

	apply_macro_set(SKIN_MACROSET_HOTKEYS, SSinput.macroset_hotkey)
	apply_macro_set(SKIN_MACROSET_CLASSIC_HOTKEYS, SSinput.macroset_classic_hotkey)
	apply_macro_set(SKIN_MACROSET_CLASSIC_INPUT, SSinput.macroset_classic_input)

	set_hotkeys_preference()

/client/proc/set_hotkeys_preference(datum/preferences/prefs_override = prefs)
	if(prefs_override.hotkeys)
		winset(src, null, "map.focus=true input.background-color=[COLOR_INPUT_DISABLED] mainwindow.macro=[SKIN_MACROSET_HOTKEYS]")
	else
		winset(src, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED] mainwindow.macro=[SKIN_MACROSET_CLASSIC_INPUT]")

/client/proc/outputKeepAlivePage()
	src << browse("<script>function f(){window.location.href=\"?keepAlive=1\";};</script>", "window=keepAliveWindow")


/client/proc/keepAlive()
	src << output("", "keepAliveWindow:f")
