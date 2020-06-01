/obj/machinery/gateway
	name = "gateway"
	desc = "A mysterious gateway built by unknown hands.  It allows for faster than light travel to far-flung locations and even alternate realities."  //VOREStation Edit
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "off"
	density = TRUE
	anchored = TRUE
	var/active = FALSE

/obj/machinery/gateway/Initialize()
	update_icon()
	if(dir == SOUTH)
		density = FALSE
	. = ..()

/obj/machinery/gateway/update_icon()
	if(active)
		icon_state = "on"
		return
	icon_state = "off"

//this is da important part wot makes things go
/obj/machinery/gateway/centerstation
	density = TRUE
	icon_state = "offcenter"
	use_power = USE_POWER_IDLE

	//warping vars
	var/list/linked = list()
	var/ready = FALSE			//have we got all the parts for a gateway?
	var/wait = 0				//TTA - Time till activation (world.time + config_time_delay)
	var/obj/machinery/gateway/centeraway/awaygate = null

/obj/machinery/gateway/centerstation/Initialize()
	update_icon()
	wait = world.time + config_legacy.gateway_delay	//+ thirty minutes default
	awaygate = locate(/obj/machinery/gateway/centeraway)
	. = ..()
	density = TRUE //VOREStation Add

/obj/machinery/gateway/centerstation/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"
/* VOREStation Removal - Doesn't do anything
/obj/machinery/gateway/centerstation/New()
	density = 1
*/ //VOREStation Removal End

/obj/machinery/gateway/centerstation/process()
	if(stat & (NOPOWER))
		if(active)
			toggleoff()
		return
	if(active)
		use_power(5000)

/obj/machinery/gateway/centerstation/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in GLOB.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = FALSE
		toggleoff()
		break

	if(linked.len == 8)
		ready = TRUE

/obj/machinery/gateway/centerstation/proc/toggleon(mob/user)
	if(!ready || !powered() || linked.len != 8)
		return
	if(!awaygate)
		to_chat(user, "<span class='notice'>Error: No destination found. Please program gateway.</span>")
		return
	if(world.time < wait)
		to_chat(user, "<span class='notice'>Error: Warpspace triangulation in progress. Estimated time to completion: [DisplayTimeText(wait - world.time)].</span>")
		return
	if(!awaygate.calibrated && !LAZYLEN(awaydestinations)) //VOREStation Edit
		to_chat(user, "<span class='notice'>Error: Destination gate uncalibrated. Gateway unsafe to use without far-end calibration update.</span>")
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = TRUE
		G.update_icon()
	active = TRUE
	update_icon()

/obj/machinery/gateway/centerstation/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = FALSE
		G.update_icon()
	active = FALSE
	update_icon()

/obj/machinery/gateway/centerstation/attack_hand(mob/user)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()

//okay, here's the good teleporting stuff
/obj/machinery/gateway/centerstation/Bumped(atom/movable/M as mob|obj)
	if(!ready)
		return
	if(!active)
		return
	if(!awaygate)
		return

	use_power(5000)
	playsound(src, 'sound/effects/phasein.ogg', 100, TRUE)
	if(awaygate.calibrated)
		M.forceMove(get_step(awaygate.loc, SOUTH))
		M.setDir(SOUTH)
		return
	else
		var/obj/effect/landmark/dest = pick(awaydestinations)
		if(dest)
			M.forceMove(dest.loc)
			M.setDir(SOUTH)
		return

/obj/machinery/gateway/centerstation/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/multitool))
		if(!awaygate)
			awaygate = locate(/obj/machinery/gateway/centeraway)
			if(!awaygate) // We still can't find the damn thing because there is no destination.
				to_chat(user, "<span class='notice'>Error: Programming failed. No destination found.</span>")
				return
			to_chat(user, "<span class='notice'><b>Startup programming successful!</b></span>: A destination in another point of space and time has been detected.")
		else
			to_chat(user, "<font color='black'>The gate is already calibrated, there is no work for you to do here.</font>")
			return

/////////////////////////////////////Away////////////////////////


/obj/machinery/gateway/centeraway
	density = TRUE
	icon_state = "offcenter"
	use_power = USE_POWER_OFF
	var/calibrated = TRUE
	var/list/linked = list()	//a list of the connected gateway chunks
	var/ready = FALSE
	var/obj/machinery/gateway/centeraway/stationgate = null


/obj/machinery/gateway/centeraway/Initialize()
	update_icon()
	stationgate = locate(/obj/machinery/gateway/centerstation)
	. = ..()
	density = TRUE //VOREStation Add

/obj/machinery/gateway/centeraway/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"
/* // making it dense 3 times? a bit overkill...
/obj/machinery/gateway/centeraway/New()
	density = 1
*/
/obj/machinery/gateway/centeraway/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in GLOB.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = FALSE
		toggleoff()
		break

	if(linked.len == 8)
		ready = TRUE

/obj/machinery/gateway/centeraway/proc/toggleon(mob/user)
	if(!ready)
		return
	if(linked.len != 8)
		return
	if(!stationgate || !calibrated) // Vorestation edit. Not like Polaris ever touches this anyway.
		to_chat(user, "<span class='notice'>Error: No destination found. Please calibrate gateway.</span>")
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = TRUE
		G.update_icon()
	active = TRUE
	update_icon()


/obj/machinery/gateway/centeraway/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = FALSE
		G.update_icon()
	active = FALSE
	update_icon()

/obj/machinery/gateway/centeraway/attack_hand(mob/user)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()

/obj/machinery/gateway/centeraway/Bumped(atom/movable/M as mob|obj)
	if(!ready)
		return
	if(!active)
		return
	if(iscarbon(M))
		for(var/obj/item/implant/exile/E in M)//Checking that there is an exile implant in the contents
			if(E.imp_in == M)//Checking that it's actually implanted vs just in their pocket
				to_chat(M, "<font color='black'>The station gate has detected your exile implant and is blocking your entry.</font>")
				return
	M.forceMove(get_step(stationgate.loc, SOUTH))
	M.setDir(SOUTH)
	playsound(src, 'sound/effects/phasein.ogg', 100, TRUE)

/obj/machinery/gateway/centeraway/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/multitool))
		if(calibrated && stationgate)
			to_chat(user, "<font color='black'>The gate is already calibrated, there is no work for you to do here.</font>")
			return
		// VOREStation Add
		stationgate = locate(/obj/machinery/gateway/centerstation)
		if(!stationgate)
			to_chat(user, "<span class='notice'>Error: Recalibration failed. No destination found... That can't be good.</span>")
			return
		// VOREStation Add End
		else
			to_chat(user, "<font color='blue'><b>Recalibration successful!</b>:</font><font color='black'> This gate's systems have been fine tuned. Travel to this gate will now be on target.</font>")
			calibrated = TRUE
			return
