/**
 * Underground ores use perlin gen.
 * Currently depends on a planet existing, or a ztrait setting us to certain ore datas.
 *
 * Why is this on /turf and not, say, /turf/floor?
 * Simple
 * /simulated as a concept sucks and should die, and I'm from /tg/. Deal with it.
 * If I can't have my /open you all suffer.
 *
 * Also on a more realistic note, it's because if you build a wall on a turf it should keep its resources, and because un-doing a wall shouldn't generate new resources.
 */
/turf
	/// Underground ores: null if it's fully excavated. FALSE if it'll never have any. TRUE if it has yet to generate. List is made at time of need/generation.
	/// ALL accesses should be using procs. This lets us control access and ensure lazylist-like functionality.
	VAR_PRIVATE/list/underground_ores = FALSE

/**
 * Gets what we should have for our underground ores.
 * Fails if any of the following are true:
 * - There's no planet for us to ask for ore data, and the ztrait override doesn't exist.
 * - Underground ores are fully excavated
 * - We shouldn't have any ores in the first place.
 *
 * WARNING: Returned list, if any, is referenced, not copied. Any edits WILL reflect onto the turf.
 * Make sure you know what you're doing.
 */
/turf/proc/generate_underground_ores()
	PRIVATE_PROC(TRUE)
	if(!underground_ores)
		return
	// already there
	if(islist(underground_ores))
		return underground_ores
	var/datum/underground_ore_data/D = get_underground_ore_data()
	if(!D)
		return
	var/list/generated = D.generate(src)
	underground_ores = generated
	return generated

/**
 * Fully excavate and drop our ores.
 */
/turf/proc/fully_excavate_underground_ores(atom/drop_at, divisor = 1)
	if(!drop_at)
		drop_at = src
	var/list/acquired = generate_underground_ores()
	if(!acquired)
		return
	for(var/path in acquired)
		var/amount = acquired[path]
		for(var/i in 1 to min(CEILING(amount / divisor, 1), 100))
			new path(drop_at)
	underground_ores = null

/**
 * Gets amount of a typepath of ore
 */
/turf/proc/get_underground_ore_amount(path)
	generate_underground_ores()
	return (underground_ores && underground_ores[path]) || 0

/**
 * Gets a list copy of underground ores
 */
/turf/proc/get_underground_ores()
	var/list/L = generate_underground_ores()
	if(L)
		return L.Copy()
	return list()

/**
 * Gets a random ore from us to a target location and decrement.
 * Returns the ore item or null.
 */
/turf/proc/excavate_random_underground_ore(atom/drop_at)
	var/list/L = generate_underground_ores()
	if(!L)
		return
	var/path = pick(L)
	new path(drop_at)
	L[path]--
	if(!L[path])
		L -= path
	if(!L.len)
		underground_ores = null
