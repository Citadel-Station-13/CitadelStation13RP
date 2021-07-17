// the SMES
// stores power

GLOBAL_LIST_EMPTY(smeses)

#define SMESRATE 0.03333		//translates Watt into Kilowattminutes with respect to machinery schedule_interval ~(2s*1W*1min/60s)
#define SMESMAXCHARGELEVEL 250000
#define SMESMAXOUTPUT 250000

/obj/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = 1
	anchored = 1
	use_power = USE_POWER_OFF
	circuit = /obj/item/circuitboard/smes

	var/capacity = 5e6 // maximum charge
	var/charge = 1e6 // actual charge

	var/input_attempt = 0 			// 1 = attempting to charge, 0 = not attempting to charge
	var/inputting = 0 				// 1 = actually inputting, 0 = not inputting
	var/input_level = 50000 		// amount of power the SMES attempts to charge by
	var/input_level_max = 200000 	// cap on input_level
	var/input_available = 0 		// amount of charge available from input last tick

	var/output_attempt = 1 			// 1 = attempting to output, 0 = not attempting to output
	var/outputting = 1 				// 1 = actually outputting, 0 = not outputting
	var/output_level = 50000		// amount of power the SMES attempts to output
	var/output_level_max = 200000	// cap on output_level
	var/output_used = 0				// amount of power actually outputted. may be less than output_level if the powernet returns excess power

	//Holders for powerout event.
	var/powerout_holders_used = FALSE
	var/last_output_attempt	= 0
	var/last_input_attempt	= 0
	var/last_charge			= 0

	var/input_cut = 0
	var/input_pulsed = 0
	var/output_cut = 0
	var/output_pulsed = 0

	var/open_hatch = 0
	var/name_tag = null
	var/building_terminal = 0 		//Suggestions about how to avoid clickspam building several terminals accepted!
	var/obj/machinery/power/terminal/terminal = null
	var/should_be_mapped = 0 		// If this is set to 0 it will send out warning on New()
	var/grid_check = FALSE 			// If true, suspends all I/O.

	var/lastsolaralert = 0
	var/lastenginealert = 0
	var/lastcharge = 2e+007
	var/lastcheck = 0
	var/percentfull
	var/enginecheck1 = FALSE
	var/enginecheck2 = FALSE
	var/enginecheck3 = FALSE
	var/enginecheckv1 = 0
	var/enginecheckv3 = 0
	var/solarcheck1 = FALSE
	var/solarcheck2 = FALSE
	var/solarcheck3 = FALSE
	var/solarcheckv1 = 0
	var/solarcheckv3 = 0
	var/checkselect = 1

/obj/machinery/power/smes/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	var/smes_amt = min((amount * SMESRATE), charge)
	charge -= smes_amt
	return smes_amt / SMESRATE


/obj/machinery/power/smes/Initialize(mapload, newdir)
	. = ..()
	GLOB.smeses += src
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/power/smes/LateInitialize()
	. = ..()
	if(!powernet)
		connect_to_network()

	dir_loop:
		for(var/d in GLOB.cardinal)
			var/turf/T = get_step(src, d)
			for(var/obj/machinery/power/terminal/term in T)
				if(term && term.dir == turn(d, 180))
					terminal = term
					break dir_loop
	if(!terminal)
		stat |= BROKEN
		return
	terminal.master = src
	if(!terminal.powernet)
		terminal.connect_to_network()
	update_icon()
	if(!should_be_mapped)
		warning("Non-buildable or Non-magical SMES at [src.x]X [src.y]Y [src.z]Z")

/obj/machinery/power/smes/Destroy()
	GLOB.smeses -= src
	return ..()


/obj/machinery/power/smes/disconnect_terminal()
	if(terminal)
		terminal.master = null
		terminal = null
		return 1
	return 0

/obj/machinery/power/smes/update_icon()
	overlays.Cut()
	if(stat & BROKEN)	return

	overlays += image('icons/obj/power.dmi', "smes-op[outputting]")

	if(inputting == 2)
		overlays += image('icons/obj/power.dmi', "smes-oc2")
	else if (inputting == 1)
		overlays += image('icons/obj/power.dmi', "smes-oc1")
	else
		if(input_attempt)
			overlays += image('icons/obj/power.dmi', "smes-oc0")

	var/clevel = chargedisplay()
	if(clevel>0)
		overlays += image('icons/obj/power.dmi', "smes-og[clevel]")
	return


/obj/machinery/power/smes/proc/chargedisplay()
	return round(5.5*charge/(capacity ? capacity : 5e6))

/obj/machinery/power/smes/process(delta_time)
	if(stat & BROKEN)	return

	//store machine state to see if we need to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = inputting
	var/last_onln = outputting

	//inputting
	if(input_attempt && (!input_pulsed && !input_cut) && !grid_check)
		var/target_load = min((capacity-charge)/SMESRATE, input_level)	// charge at set rate, limited to spare capacity
		var/actual_load = draw_power(target_load)						// add the load to the terminal side network
		charge += actual_load * SMESRATE								// increase the charge

		if (actual_load >= target_load) // Did we charge at full rate?
			inputting = 2
		else if (actual_load) // If not, did we charge at least partially?
			inputting = 1
		else // Or not at all?
			inputting = 0

	//outputting
	if(outputting && (!output_pulsed && !output_cut) && !grid_check)
		output_used = min( charge/SMESRATE, output_level)		//limit output to that stored

		charge -= output_used*SMESRATE		// reduce the storage (may be recovered in /restore() if excessive)

		add_avail(output_used)				// add output to powernet (smes side)

		if(output_used < 0.0001)			// either from no charge or set to 0
			outputting(0)
			investigate_log("lost power and turned <font color='red'>off</font>","singulo")
			log_game("SMES([x],[y],[z]) Power depleted.")
	else if(output_attempt && output_level > 0)
		outputting = 1
	else
		output_used = 0

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != outputting)
		update_icon()



// called after all power processes are finished
// restores charge level to smes if there was excess this ptick
/obj/machinery/power/smes/proc/restore()
	if(stat & BROKEN)
		return

	if(!outputting)
		output_used = 0
		return

	var/excess = powernet.netexcess		// this was how much wasn't used on the network last ptick, minus any removed by other SMESes

	excess = min(output_used, excess)				// clamp it to how much was actually output by this SMES last ptick

	excess = min((capacity-charge)/SMESRATE, excess)	// for safety, also limit recharge by space capacity of SMES (shouldn't happen)

	// now recharge this amount

	var/clev = chargedisplay()

	charge += excess * SMESRATE			// restore unused power
	powernet.netexcess -= excess		// remove the excess from the powernet, so later SMESes don't try to use it

	output_used -= excess

	if(clev != chargedisplay() ) //if needed updates the icons overlay
		update_icon()
	return

//Will return 1 on failure
/obj/machinery/power/smes/proc/make_terminal(const/mob/user)
	if (user.loc == loc)
		to_chat(user, "<span class='warning'>You must not be on the same tile as the [src].</span>")
		return 1

	//Direction the terminal will face to
	var/tempDir = get_dir(user, src)
	switch(tempDir)
		if (NORTHEAST, SOUTHEAST)
			tempDir = EAST
		if (NORTHWEST, SOUTHWEST)
			tempDir = WEST
	var/turf/tempLoc = get_step(src, reverse_direction(tempDir))
	if (istype(tempLoc, /turf/space))
		to_chat(user, "<span class='warning'>You can't build a terminal on space.</span>")
		return 1
	else if (istype(tempLoc))
		if(!tempLoc.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating first.</span>")
			return 1
	to_chat(user, "<span class='notice'>You start adding cable to the [src].</span>")
	if(do_after(user, 50))
		terminal = new /obj/machinery/power/terminal(tempLoc)
		terminal.setDir(tempDir)
		terminal.master = src
		terminal.connect_to_network()
		return 0
	return 1


/obj/machinery/power/smes/draw_power(var/amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0


/obj/machinery/power/smes/attack_ai(mob/user)
	add_hiddenprint(user)
	ui_interact(user)

/obj/machinery/power/smes/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)


/obj/machinery/power/smes/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.is_screwdriver())
		if(!open_hatch)
			open_hatch = 1
			to_chat(user, "<span class='notice'>You open the maintenance hatch of [src].</span>")
			playsound(src, W.usesound, 50, 1)
			return 0
		else
			open_hatch = 0
			to_chat(user, "<span class='notice'>You close the maintenance hatch of [src].</span>")
			playsound(src, W.usesound, 50, 1)
			return 0

	if (!open_hatch)
		to_chat(user, "<span class='warning'>You need to open access hatch on [src] first!</span>")
		return 0

	if(istype(W, /obj/item/stack/cable_coil) && !terminal && !building_terminal)
		building_terminal = 1
		var/obj/item/stack/cable_coil/CC = W
		if (CC.get_amount() < 10)
			to_chat(user, "<span class='warning'>You need more cables.</span>")
			building_terminal = 0
			return 0
		if (make_terminal(user))
			building_terminal = 0
			return 0
		building_terminal = 0
		CC.use(10)
		user.visible_message(\
				"<span class='notice'>[user.name] has added cables to the [src].</span>",\
				"<span class='notice'>You added cables to the [src].</span>")
		stat = 0
		return 0

	else if(W.is_wirecutter() && terminal && !building_terminal)
		building_terminal = 1
		var/turf/tempTDir = terminal.loc
		if (istype(tempTDir))
			if(!tempTDir.is_plating())
				to_chat(user, "<span class='warning'>You must remove the floor plating first.</span>")
			else
				to_chat(user, "<span class='notice'>You begin to cut the cables...</span>")
				playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 50 * W.toolspeed))
					if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
						var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
						s.set_up(5, 1, src)
						s.start()
						building_terminal = 0
						if(usr.stunned)
							return 0
					new /obj/item/stack/cable_coil(loc,10)
					user.visible_message(\
						"<span class='notice'>[user.name] cut the cables and dismantled the power terminal.</span>",\
						"<span class='notice'>You cut the cables and dismantle the power terminal.</span>")
					qdel(terminal)
		building_terminal = 0
		return 0
	return 1

/obj/machinery/power/smes/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Smes", name)
		ui.open()

/obj/machinery/power/smes/ui_data()
	var/list/data = list(
		"capacity" = capacity,
		"capacityPercent" = round(100.0*charge/capacity, 0.1),
		"charge" = charge,
		"inputAttempt" = input_attempt,
		"inputting" = inputting,
		"inputLevel" = input_level,
		"inputLevel_text" = DisplayPower(input_level),
		"inputLevelMax" = input_level_max,
		"inputAvailable" = getTerminalPower(),
		"outputAttempt" = output_attempt,
		"outputting" = outputting,
		"outputLevel" = round(output_level, 0.1),
		"outputLevel_text" = DisplayPower(output_level),
		"outputLevelMax" = round(output_level_max),
		"outputUsed" = round(output_used, 0.1),
	)
	return data

/obj/machinery/power/smes/ui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("tryinput")
			inputting(!input_attempt)
			update_icon()
			. = TRUE
		if("tryoutput")
			outputting(!output_attempt)
			update_icon()
			. = TRUE
		if("input")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "min")
				target = 0
				. = TRUE
			else if(target == "max")
				target = input_level_max
				. = TRUE
			else if(adjust)
				target = input_level + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				input_level = clamp(target, 0, input_level_max)
		if("output")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "min")
				target = 0
				. = TRUE
			else if(target == "max")
				target = output_level_max
				. = TRUE
			else if(adjust)
				target = output_level + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				output_level = clamp(target, 0, output_level_max)

/*
/obj/machinery/power/smes/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(stat & BROKEN)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["nameTag"] = name_tag
	data["storedCapacity"] = round(100.0*charge/capacity, 0.1)
	data["storedCapacityAbs"] = round(charge/(1000*60), 0.1)
	data["storedCapacityMax"] = round(capacity/(1000*60))
	data["charging"] = inputting
	data["chargeMode"] = input_attempt
	data["chargeLevel"] = round(input_level/1000, 0.1)
	data["chargeMax"] = round(input_level_max/1000)
	if (terminal && terminal.powernet)
		data["chargeLoad"] = round(terminal.powernet.avail/1000, 0.1)
	else
		data["chargeLoad"] = 0
	data["outputOnline"] = output_attempt
	data["outputLevel"] = round(output_level/1000, 0.1)
	data["outputMax"] = round(output_level_max/1000)
	data["outputLoad"] = round(output_used/1000, 0.1)

	if(outputting)
		data["outputting"] = 2			// smes is outputting
	else if(!outputting && output_attempt)
		data["outputting"] = 1			// smes is online but not outputting because it's charge level is too low
	else
		data["outputting"] = 0			// smes is not outputting

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "smes.tmpl", "SMES Unit", 540, 380)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/smes/buildable/main/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if (!ui)
		ui = new(user, src, ui_key, "smesmain.tmpl", "SMES Unit", 540, 405)
		ui.set_auto_update(1)
	..()
*/
/obj/machinery/power/smes/proc/getTerminalPower()
	if (terminal && terminal.powernet)//checks if the SMES has a terminal, and if that terminal has a powernet.
		. = round(terminal.powernet.avail, 0.1)
	else
		. = 0
	return .

/obj/machinery/power/smes/proc/Percentage()
	return round(100.0*charge/capacity, 0.1)

/obj/machinery/power/smes/Topic(href, href_list)
	if(..())
		return 1

	if( href_list["cmode"] )
		inputting(!input_attempt)
		update_icon()

	else if( href_list["online"] )
		outputting(!output_attempt)
		update_icon()
	else if( href_list["input"] )
		switch( href_list["input"] )
			if("min")
				input_level = 0
			if("max")
				input_level = input_level_max
			if("set")
				input_level = (input(usr, "Enter new input level (0-[input_level_max/1000] kW)", "SMES Input Power Control", input_level/1000) as num) * 1000
		input_level = max(0, min(input_level_max, input_level))	// clamp to range

	else if( href_list["output"] )
		switch( href_list["output"] )
			if("min")
				output_level = 0
			if("max")
				output_level = output_level_max
			if("set")
				output_level = (input(usr, "Enter new output level (0-[output_level_max/1000] kW)", "SMES Output Power Control", output_level/1000) as num) * 1000
		output_level = max(0, min(output_level_max, output_level))	// clamp to range

	else if( href_list["mute"] )
		lastsolaralert = world.time + 12000
		lastenginealert = world.time + 12000

	investigate_log("input/output; <font color='[input_level>output_level?"green":"red"][input_level]/[output_level]</font> | Output-mode: [output_attempt?"<font color='green'>on</font>":"<font color='red'>off</font>"] | Input-mode: [input_attempt?"<font color='green'>auto</font>":"<font color='red'>off</font>"] by [usr.key]","singulo")
	log_game("SMES([x],[y],[z]) [key_name(usr)] changed settings: I:[input_level]([input_attempt]), O:[output_level]([output_attempt])")
	return 1


/obj/machinery/power/smes/proc/ion_act()
	if(src.z in GLOB.using_map.station_levels)
		if(prob(1)) //explosion
			for(var/mob/M in viewers(src))
				M.show_message("<font color='red'>The [src.name] is making strange noises!</font>", 3, "<font color='red'>You hear sizzling electronics.</font>", 2)
			sleep(10*pick(4,5,6,7,10,14))
			var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread()
			smoke.set_up(3, 0, src.loc)
			smoke.attach(src)
			smoke.start()
			explosion(src.loc, -1, 0, 1, 3, 1, 0)
			qdel(src)
			return
		if(prob(15)) //Power drain
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(prob(25))
				emp_act(1)
			else if(prob(25))
				emp_act(2)
			else if(prob(25))
				emp_act(3)
			else
				emp_act(4)
		if(prob(5)) //smoke only
			var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread()
			smoke.set_up(3, 0, src.loc)
			smoke.attach(src)
			smoke.start()

/obj/machinery/power/smes/proc/inputting(var/do_input)
	input_attempt = do_input
	if(!input_attempt)
		inputting = 0

/obj/machinery/power/smes/proc/outputting(var/do_output)
	output_attempt = do_output
	if(!output_attempt)
		outputting = 0

/obj/machinery/power/smes/emp_act(severity)
	inputting(rand(0,1))
	outputting(rand(0,1))
	output_level = rand(0, output_level_max)
	input_level = rand(0, input_level_max)
	charge -= 1e6/severity
	if (charge < 0)
		charge = 0
	update_icon()
	..()

/obj/machinery/power/smes/magical
	name = "magical power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. Magically produces power."
	capacity = 9000000
	output_level = 250000
	should_be_mapped = 1

/obj/machinery/power/smes/magical/process(delta_time)
	charge = 5000000
	..()

/obj/machinery/power/smes/buildable/main
	name = "main smes"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. This is the main one for facility power."
	charge = 2e7
	input_level = 500000
	output_level = 1000000

/obj/machinery/power/smes/buildable/main/process(delta_time)

	percentfull = 100.0*charge/capacity

	if(percentfull > 30)
		solarcheck1 = FALSE
		solarcheck2 = FALSE
		solarcheck3 = FALSE

	if(percentfull > 20)
		enginecheck1 = FALSE
		enginecheck2 = FALSE
		enginecheck3 = FALSE

	if(percentfull < 30 && percentfull > 20  && charge < lastcharge)
		switch(checkselect)
			if(1)
				solarcheck1 = TRUE
				checkselect = 2
				solarcheckv1 = charge
			if(2)
				solarcheck2 = TRUE
				checkselect = 3
			if(3)
				solarcheck3 = TRUE
				checkselect = 4
				solarcheckv3 = charge
			if(4)
				checkselect = 1
				solarcheck1 = FALSE
				solarcheck2 = FALSE
				solarcheck3 = FALSE
				enginecheck1 = FALSE
				enginecheck2 = FALSE
				enginecheck3 = FALSE

	if(percentfull < 20 && charge < lastcharge)
		switch(checkselect)
			if(1)
				enginecheck1 = TRUE
				checkselect = 2
				enginecheckv1 = charge
			if(2)
				enginecheck2 = TRUE
				checkselect = 3
			if(3)
				enginecheck3= TRUE
				checkselect = 4
				enginecheckv3 = charge
			if(4)
				checkselect = 1
				enginecheck1 = FALSE
				enginecheck2 = FALSE
				enginecheck3 = FALSE
				solarcheck1 = FALSE
				solarcheck2 = FALSE
				solarcheck3 = FALSE

	if(solarcheck1 && solarcheck2 && solarcheck3 == TRUE && solarcheckv1 > solarcheckv3 && world.time >= lastsolaralert)
		GLOB.global_announcer.autosay("WARNING: Main Facility SMES unit now under 30 percent charge and seems to be discharging. Non-Engineering personnel are advised to set up solars if not already done.", "SMES Monitor")
		lastsolaralert = world.time + 1800

	if(enginecheck1 && enginecheck2 && enginecheck3 == TRUE && enginecheckv1 > enginecheckv3 && world.time >= lastenginealert)
		GLOB.global_announcer.autosay("WARNING: Main Facility SMES unit now under 20 percent charge and seems to be discharging. Non-Engineering personnel are now advised to attempt engine startup procedures if not already being done.", "SMES Monitor")
		lastenginealert = world.time + 1800

	if(lastcheck <= world.time ||lastcheck == 0)
		lastcharge = charge
		lastcheck = world.time + 20
	..()


/obj/machinery/power/smes/buildable/engine
	name = "engine smes"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. This is the one dedicated to the engine."
	charge = 2e6
	input_level = 100000
	output_level = 200000

