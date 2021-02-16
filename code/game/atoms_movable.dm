/atom/movable
	layer = OBJ_LAYER
	appearance_flags = TILE_BOUND|PIXEL_SCALE|KEEP_TOGETHER
	/// Whatever we're pulling.
	var/atom/movable/pulling
	/// If false makes [CanPass][/atom/proc/CanPass] call [CanPassThrough][/atom/movable/proc/CanPassThrough] on this type instead of using default behaviour
	var/generic_canpass = TRUE
	/// 0: not doing a diagonal move. 1 and 2: doing the first/second step of the diagonal move
	var/moving_diagonally = 0
	/// attempt to resume grab after moving instead of before. This is what atom/movable is pulling us during move-from-pulling.
	var/atom/movable/moving_from_pull
	/// Direction of our last move.
	var/last_move = NONE
	var/verb_say = "says"
	var/verb_ask = "asks"
	var/verb_exclaim = "exclaims"
	var/verb_whisper = "whispers"
	var/verb_yell = "yells"
	/// Which direction we're drifting
	var/inertia_dir = NONE
	/// Only set while drifting, last location we were while drifting
	var/atom/inertia_last_loc
	/// If we're moving from no-grav drifting
	var/inertia_moving = FALSE
	/// Next world.time we should move from no-grav drifting
	var/inertia_next_move = 0
	/// Delay between each drifting move.
	var/inertia_move_delay = 5
	/// Movement types, see __DEFINES/flags/movement.dm
	var/movement_type = GROUND
	/// The orbiter component of the thing we're orbiting.
	var/datum/component/orbiter/orbiting
	/// Our default glide_size.
	var/default_glide_size = 0

	var/anchored = 0
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source = null
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/mob/pulledby = null
	var/item_state = null // Used to specify the item state for the on-mob overlays.
	var/icon_scale_x = 1 // Used to scale icons up or down horizonally in update_transform().
	var/icon_scale_y = 1 // Used to scale icons up or down vertically in update_transform().
	var/icon_rotation = 0 // Used to rotate icons in update_transform()
	var/icon_expected_height = 32
	var/icon_expected_width = 32
	var/old_x = 0
	var/old_y = 0
	var/datum/riding/riding_datum //VOREStation Add - Moved from /obj/vehicle
	var/does_spin = TRUE // Does the atom spin when thrown (of course it does :P)

/atom/movable/Destroy()
	. = ..()
	if(reagents)
		qdel(reagents)
		reagents = null
	for(var/atom/movable/AM in contents)
		qdel(AM)
	var/turf/un_opaque
	if(opacity && isturf(loc))
		un_opaque = loc

	moveToNullspace()
	if(un_opaque)
		un_opaque.recalc_atom_opacity()
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null
	QDEL_NULL(riding_datum) //VOREStation Add

/atom/movable/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(locs && locs.len >= 2)	// If something is standing on top of us, let them pass.
		if(mover.loc in locs)
			. = TRUE
	return .

/////////////////////////////////////////////////////////////////

//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		if(M.buckled == src)
			return // Don't hit the thing we're buckled to.
		M.hitby(src,speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.last_move)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		src.throwing = 0
		var/turf/T = hit_atom
		T.hitby(src,speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(var/speed)
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src) continue
			if(istype(A,/mob/living))
				if(A:lying) continue
				src.throw_impact(A,speed)
			if(isobj(A))
				if(!A.density || A.throwpass)
					continue
				// Special handling of windows, which are dense but block only from some directions
				if(istype(A, /obj/structure/window))
					var/obj/structure/window/W = A
					if (!W.is_fulltile() && !(turn(src.last_move, 180) & A.dir))
						continue
				// Same thing for (closed) windoors, which have the same problem
				else if(istype(A, /obj/machinery/door/window) && !(turn(src.last_move, 180) & A.dir))
					continue
				src.throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range, speed, thrower)
	if(!target || !src)
		return 0
	if(target.z != src.z)
		return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target
	src.throwing = 1
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf
	src.pixel_z = 0
	if(usr)
		if(HULK in usr.mutations)
			src.throwing = 2 // really strong throw!

	var/dist_travelled = 0
	var/dist_since_sleep = 0
	var/area/a = get_area(src.loc)

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH

	var/error
	var/major_dir
	var/major_dist
	var/minor_dir
	var/minor_dist
	if(dist_x > dist_y)
		error = dist_x/2 - dist_y
		major_dir = dx
		major_dist = dist_x
		minor_dir = dy
		minor_dist = dist_y
	else
		error = dist_y/2 - dist_x
		major_dir = dy
		major_dist = dist_y
		minor_dir = dx
		minor_dist = dist_x

	while(src && target && src.throwing && istype(src.loc, /turf) \
		  && ((abs(target.x - src.x)+abs(target.y - src.y) > 0 && dist_travelled < range) \
		  	   || (a && a.has_gravity == 0) \
			   || istype(src.loc, /turf/space)))
		// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
		var/atom/step
		if(error >= 0)
			step = get_step(src, major_dir)
			error -= minor_dist
		else
			step = get_step(src, minor_dir)
			error += major_dist
		if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			break
		src.Move(step)
		hit_check(speed)
		dist_travelled++
		dist_since_sleep++
		if(dist_since_sleep >= speed)
			dist_since_sleep = 0
			sleep(1)
		a = get_area(src.loc)
		// and yet it moves
		if(src.does_spin)
			src.SpinAnimation(speed = 4, loops = 1)

	//done throwing, either because it hit something or it finished moving
	if(isobj(src)) src.throw_impact(get_turf(src),speed)
	src.throwing = 0
	src.thrower = null
	src.throw_source = null
	fall()


//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/New()
	for(var/x in src.verbs)
		src.verbs -= x
	..()

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/proc/touch_map_edge()
	if(z in GLOB.using_map.sealed_levels)
		return

	if(GLOB.using_map.use_overmap)
		overmap_spacetravel(get_turf(src), src)
		return

	var/move_to_z = src.get_transit_zlevel()
	if(move_to_z)
		var/new_z = move_to_z
		var/new_x
		var/new_y

		if(x <= TRANSITIONEDGE)
			new_x = world.maxx - TRANSITIONEDGE - 2
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + 1))
			new_x = TRANSITIONEDGE + 1
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			new_y = world.maxy - TRANSITIONEDGE -2
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + 1))
			new_y = TRANSITIONEDGE + 1
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		if(SSticker && istype(SSticker.mode, /datum/game_mode/nuclear))	// Only really care if the game mode is nuclear
			var/datum/game_mode/nuclear/G = SSticker.mode
			G.check_nuke_disks()

		var/turf/T = locate(new_x, new_y, new_z)
		if(istype(T))
			forceMove(T)

//by default, transition randomly to another zlevel
/atom/movable/proc/get_transit_zlevel()
	var/list/candidates = GLOB.using_map.accessible_z_levels.Copy()
	candidates.Remove("[src.z]")

	if(!candidates.len)
		return null
	return text2num(pickweight(candidates))

// Returns the current scaling of the sprite.
// Note this DOES NOT measure the height or width of the icon, but returns what number is being multiplied with to scale the icons, if any.
/atom/movable/proc/get_icon_scale_x()
	return icon_scale_x

/atom/movable/proc/get_icon_scale_y()
	return icon_scale_y

/atom/movable/proc/update_transform()
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Turn(icon_rotation)
	src.transform = M

// Use this to set the object's scale.
/atom/movable/proc/adjust_scale(new_scale_x, new_scale_y)
	if(isnull(new_scale_y))
		new_scale_y = new_scale_x
	if(new_scale_x != 0)
		icon_scale_x = new_scale_x
	if(new_scale_y != 0)
		icon_scale_y = new_scale_y
	update_transform()

/atom/movable/proc/adjust_rotation(new_rotation)
	icon_rotation = new_rotation
	update_transform()

// Called when touching a lava tile.
/atom/movable/proc/lava_act()
	fire_act(null, 10000, 1000)

//Called when touching an acid pool.
/atom/movable/proc/acid_act()
	acid_act(null, 500, 50)

//Called when touching a blood pool.
/atom/movable/proc/blood_act()
	acid_act(null, 500, 50)

/**
  * Sets our movement type.
  */
/atom/movable/proc/set_movement_type(new_movetype)
	movement_type = new_movetype
