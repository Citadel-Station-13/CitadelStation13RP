/turf/simulated/floor/outdoors/lava
	name = "lava"
	desc = "A pool of molten rock."
	description_info = "Molten rock is extremly dangerous, as it will cause massive harm to anything that touches it.<br>\
	A firesuit cannot fully protect from contact with molten rock."
	gender = PLURAL // So it says "That's some lava." on examine.
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "lava"
	edge_blending_priority = 4
	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA
	flags = TURF_HAS_EDGES
	movement_cost = 2

/turf/simulated/floor/outdoors/lava/indoors
	outdoors = TRUE

// For maximum pedantry.
/turf/simulated/floor/outdoors/lava/Initialize(mapload)
	if(!outdoors)
		name = "magma"
	update_icon()
	return ..()

/turf/simulated/floor/outdoors/lava/make_outdoors()
	..()
	name = "lava"

/turf/simulated/floor/outdoors/lava/make_indoors()
	..()
	name = "magma"

/turf/simulated/floor/outdoors/lava/update_icon()
	cut_overlays()
	..()
	update_icon_edge()

/turf/simulated/floor/outdoors/lava/Entered(atom/movable/AM)
	..()
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/floor/outdoors/lava/hitby(atom/movable/AM)
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/floor/outdoors/lava/process(delta_time)
	if(!burn_stuff())
		STOP_PROCESSING(SSobj, src)

/turf/simulated/floor/outdoors/lava/proc/is_safe()
	//if anything matching this typecache is found in the lava, we don't burn things
	var/static/list/lava_safeties_typecache = typecacheof(list(/obj/structure/catwalk))
	var/list/found_safeties = typecache_filter_list(contents, lava_safeties_typecache)
	return LAZYLEN(found_safeties)

/turf/simulated/floor/outdoors/lava/proc/burn_stuff(atom/movable/AM)
	. = FALSE

	if(is_safe())
		return FALSE

	var/thing_to_check = src
	if(AM)
		thing_to_check = list(AM)

	for(var/thing in thing_to_check)
		if(isobj(thing))
			var/obj/O = thing
			if(O.throwing)
				continue
			. = TRUE
			O.lava_act()

		else if(isliving(thing))
			var/mob/living/L = thing
			if(L.hovering || L.throwing) // Flying over the lava. We're just gonna pretend convection doesn't exist.
				continue
			. = TRUE
			L.lava_act()

// Lava that does nothing at all.
/turf/simulated/floor/outdoors/lava/harmless/burn_stuff(atom/movable/AM)
	return FALSE

// Tells AI mobs to not suicide by pathing into lava if it would hurt them.
/turf/simulated/floor/outdoors/lava/is_safe_to_enter(mob/living/L)
	if(!is_safe() && !L.hovering)
		return FALSE
	return ..()


/turf/simulated/floor/lava/phoron
	name = "liquid phoron"
	desc = "A pool of molten phoron."
	icon = 'icons/turf/flooring/lava.dmi'
	description_info = "Liquid phoron is an extremely dangerous form of the usually gaseous state of phoron, as it only forms under extreme heat and pressure."
	icon_state = "plava"
	light_range = 5
	light_power = 0.6
	light_color = LIGHT_COLOR_PLAVA
