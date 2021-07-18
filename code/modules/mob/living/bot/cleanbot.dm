/mob/living/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, it looks so excited!"
	icon_state = "cleanbot0"
	req_one_access = list(access_robotics, access_janitor)
	botcard_access = list(access_janitor)

	locked = 0 // Start unlocked so roboticist can set them to patrol.
	wait_if_pulled = 1
	min_target_dist = 0

	var/cleaning = 0
	var/screwloose = 0
	var/oddbutton = 0
	var/blood = 1
	var/list/target_types = list()

/mob/living/bot/cleanbot/Initialize(mapload)
	. = ..()
	get_targets()

/mob/living/bot/cleanbot/handleIdle()
	if(!screwloose && !oddbutton && prob(2))
		custom_emote(2, "makes an excited booping sound!")
		playsound(src.loc, 'sound/machines/synth_yes.ogg', 50, 0)

	if(screwloose && prob(5)) // Make a mess
		if(istype(loc, /turf/simulated))
			var/turf/simulated/T = loc
			T.wet_floor()

	if(oddbutton && prob(5)) // Make a big mess
		visible_message("Something flies out of [src]. It seems to be acting oddly.")
		var/obj/effect/decal/cleanable/blood/gibs/gib = new /obj/effect/decal/cleanable/blood/gibs(loc)
		// TODO - I have a feeling weakrefs will not work in ignore_list, verify this ~Leshana
		var/datum/weakref/g = WEAKREF(gib)
		ignore_list += g
		spawn(600)
			ignore_list -= g

/mob/living/bot/cleanbot/handlePanic()	// Speed modification based on alert level.
	. = 0
	switch(get_security_level())
		if("green")
			. = 0

		if("yellow")
			. = 1

		if("violet")
			. = 1

		if("orange")
			. = 1

		if("blue")
			. = 2

		if("red")
			. = 2

		if("delta")
			. = 2

	return .

/mob/living/bot/cleanbot/lookForTargets()
	for(var/obj/effect/decal/cleanable/D in view(world.view, src)) // There was some odd code to make it start with nearest decals, it's unnecessary, this works
		if(confirmTarget(D))
			target = D
			return

/mob/living/bot/cleanbot/confirmTarget(var/obj/effect/decal/cleanable/D)
	if(!..())
		return 0
	for(var/T in target_types)
		if(istype(D, T))
			return 1
	return 0

/mob/living/bot/cleanbot/handleAdjacentTarget()
	if(get_turf(target) == src.loc)
		UnarmedAttack(target)

/mob/living/bot/cleanbot/UnarmedAttack(var/obj/effect/decal/cleanable/D, var/proximity)
	if(!..())
		return

	if(!istype(D))
		return

	if(D.loc != loc)
		return

	busy = 1
	if(prob(20))
		custom_emote(2, "begins to clean up \the [D]")
	update_icons()
	var/cleantime = istype(D, /obj/effect/decal/cleanable/dirt) ? 10 : 50
	if(do_after(src, cleantime))
		if(istype(loc, /turf/simulated))
			var/turf/simulated/f = loc
			f.dirt = 0
		if(!D)
			return
		qdel(D)
		if(D == target)
			target = null
	busy = 0
	update_icons()

/mob/living/bot/cleanbot/explode()
	on = 0
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/reagent_containers/glass/bucket(Tsec)
	new /obj/item/assembly/prox_sensor(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/bot/cleanbot/update_icons()
	if(busy)
		icon_state = "cleanbot-c"
	else
		icon_state = "cleanbot[on]"

/mob/living/bot/cleanbot/attack_hand(var/mob/user)
	var/dat
	dat += "<TT><B>Automatic Station Cleaner v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];operation=start'>[on ? "On" : "Off"]</A><BR>"
	dat += "Behaviour controls are [locked ? "locked" : "unlocked"]<BR>"
	dat += "Maintenance panel is [open ? "opened" : "closed"]"
	if(!locked || issilicon(user))
		dat += "<BR>Cleans Blood: <A href='?src=\ref[src];operation=blood'>[blood ? "Yes" : "No"]</A><BR>"
		if(GLOB.using_map.bot_patrolling)
			dat += "<BR>Patrol station: <A href='?src=\ref[src];operation=patrol'>[will_patrol ? "Yes" : "No"]</A><BR>"
	if(open && !locked)
		dat += "Odd looking screw twiddled: <A href='?src=\ref[src];operation=screw'>[screwloose ? "Yes" : "No"]</A><BR>"
		dat += "Weird button pressed: <A href='?src=\ref[src];operation=oddbutton'>[oddbutton ? "Yes" : "No"]</A>"

	user << browse("<HEAD><TITLE>Cleaner v1.0 controls</TITLE></HEAD>[dat]", "window=autocleaner")
	onclose(user, "autocleaner")
	return

/mob/living/bot/cleanbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(href_list["operation"])
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
		if("blood")
			blood = !blood
			get_targets()
		if("patrol")
			will_patrol = !will_patrol
			patrol_path = null
		if("screw")
			screwloose = !screwloose
			to_chat(usr, "<span class='notice'>You twiddle the screw.</span>")
		if("oddbutton")
			oddbutton = !oddbutton
			to_chat(usr, "<span class='notice'>You press the weird button.</span>")
	attack_hand(usr)

/mob/living/bot/cleanbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!screwloose || !oddbutton)
		if(user)
			to_chat(user, "<span class='notice'>The [src] buzzes and beeps.</span>")
			playsound(src.loc, 'sound/machines/buzzbeep.ogg', 50, 0)
		oddbutton = 1
		screwloose = 1
		return 1

/mob/living/bot/cleanbot/proc/get_targets()
	target_types = list()

	target_types += /obj/effect/decal/cleanable/blood/oil
	target_types += /obj/effect/decal/cleanable/vomit
	target_types += /obj/effect/decal/cleanable/crayon
	target_types += /obj/effect/decal/cleanable/liquid_fuel
	target_types += /obj/effect/decal/cleanable/mucus
	target_types += /obj/effect/decal/cleanable/dirt

	if(blood)
		target_types += /obj/effect/decal/cleanable/blood

/* Assembly */

/obj/item/bucket_sensor
	desc = "It's a bucket. With a sensor attached."
	name = "proxy bucket"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "bucket_proxy"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	var/created_name = "Cleanbot"

/obj/item/bucket_sensor/attackby(var/obj/item/W, var/mob/user)
	..()
	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm) || (istype(W, /obj/item/organ/external/arm) && ((W.name == "robotic left arm") || (W.name == "robotic right arm"))))
		user.drop_item()
		qdel(W)
		var/turf/T = get_turf(loc)
		var/mob/living/bot/cleanbot/A = new /mob/living/bot/cleanbot(T)
		A.name = created_name
		to_chat(user, "<span class='notice'>You add the robot arm to the bucket and sensor assembly. Beep boop!</span>")
		user.drop_from_inventory(src)
		qdel(src)

	else if(istype(W, /obj/item/stack/material/steel))
		var/obj/item/stack/material/steel/M = W
		if(M.amount >= 5)
			if(user.drop_item(M))
				M.use(5)
				var/turf/T = get_turf(loc)
				var/mob/living/bot/cleanbot/roomba/A = new /mob/living/bot/cleanbot/roomba(T)
				A.name = created_name
				to_chat(user, "<span class='notice'>You add the metal sheets onto and around the bucket and sensor assembly. Beep boop!</span>")
				user.drop_from_inventory(src)
				qdel(src)

	else if(istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t

//Port of Roombas and the Roomba Maid from /vg/station.

/mob/living/bot/cleanbot/roomba
	desc = "A small, plate-like cleaning robot. It looks quite concerned."
	icon_state = "roombot0"
	var/created_name = "Roombot"
	var/armed = 0
	var/coolingdown = 0
	var/attackcooldown = 0

/mob/living/bot/cleanbot/roomba/attackby(var/obj/item/W, mob/user)
	if(istype(W, /obj/item/material/kitchen/utensil/fork) && !armed && user.a_intent != INTENT_HARM)
		if(user.drop_item(W))
			qdel(W)
			to_chat(user, "<span class='notice'>You attach \the [W] to \the [src]. It looks increasingly concerned about its current situation.</span>")
			armed++
	else if(istype(W, /obj/item/flame/lighter) && armed == 1 && user.a_intent != INTENT_HARM)
		if(user.drop_item(W))
			qdel(W)
			to_chat(user, "<span class='notice'>You attach \the [W] to \the [src]. It appears to roll its sensor in disappointment before carrying on with its work.</span>")
			armed++
			icon_state = "roombot_battle[on]"

	else if (istype(W, /obj/item/clothing/head/headband/maid))
		var/mob/living/bot/cleanbot/roomba/meido/M = new(get_turf(src))

		if(name != initial(name))
			M.name = name
		else
			name = "maidbot"

	else
		. = ..()

/mob/living/bot/cleanbot/roomba/Crossed(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		annoy(L)
	..()

/mob/living/bot/cleanbot/roomba/proc/attack_cooldown()
	coolingdown = TRUE
	spawn(attackcooldown)
		coolingdown = FALSE

/mob/living/bot/cleanbot/roomba/proc/annoy(var/mob/living/L)
	if(coolingdown == FALSE)
		switch(armed)
			if(1)
				L.visible_message("<span class = 'warning'>\The [src] [pick("prongs","pokes","pricks")] \the [L]", "<span class = 'warning'>The little shit, \the [src], stabs you with its attached fork!</span>")
				var/damage = rand(1,5)
				L.adjustBruteLoss(damage)
			if(2)
				L.visible_message("<span class = 'warning'>\The [src] prongs and singes \the [L]</span>", "<span class = 'warning'>The little shit, \the [src], singes and stabs you with its attached fork and lighter!</span>")
				var/damage = rand(3,12)
				L.adjustBruteLoss(damage)
				L.adjustFireLoss(damage/2)
		attack_cooldown()

/mob/living/bot/cleanbot/roomba/update_icons()
	if(busy)
		icon_state = "roombot-c"
	else
		icon_state = "roombot[on]"

/mob/living/bot/cleanbot/roomba/meido
	name = "maidbot"
	desc = "A small, plate-like cleaning robot. It looks quite concerned. This one has a frilly headband attached to the top."
	icon_state = "maidbot0"
	armed = 0

/mob/living/bot/cleanbot/roomba/meido/attackby(var/obj/item/W, mob/user)
	if(istype(W, /obj/item/material/kitchen/utensil/fork) || istype(W, /obj/item/flame/lighter))
		to_chat(user, "<span class='notice'>\The [src] buzzes and recoils at \the [W]. Perhaps it would prefer something more refined?</span>")
		return
	else if (istype(W, /obj/item/clothing/head/headband/maid))
		to_chat(user, "<span class='notice'>\The [src] is already wearing one of those!</span>")
		return
	else if(W.type == /obj/item/material/knife && !armed && user.a_intent != INTENT_HARM)
		if(user.drop_item(W))
			qdel(W)
			to_chat(user, "<span class='notice'>\the [src] extends a tiny arm from a hidden compartment and grasps \the [W]. Its light blinks excitedly for a moment before returning to normal.</span>")
			armed++
			icon_state = "maidbot_battle[on]"
	else
		. = ..()

/mob/living/bot/cleanbot/roomba/meido/update_icons()
	if(busy)
		icon_state = "maidbot-c"
	else
		icon_state = "maidbot[on]"

/mob/living/bot/cleanbot/roomba/meido/annoy(var/mob/living/L)
	if(!coolingdown && armed)
		L.visible_message("<span class = 'warning'>\The [src] [pick("jabs","stabs","pokes")] \the [L]", "<span class = 'warning'>The little shit, \the [src], stabs you with its knife!</span>")
		L.adjustBruteLoss(rand(4,8))
	attack_cooldown()
