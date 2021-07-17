/**
 * Datums that hold data necessary for perlin gen of underground ores.
 */
/datum/underground_ore_data
	/// Ore list. ore type = threshold.
	var/list/ores = list(

	)
	/// Ore amounts
	var/list/ore_amount_low = list(

	)
	/// Ore amounts
	var/list/ore_amount_high = list(

	)
	/// Generated seeds
	var/list/seeds = list()
	/// Static seeds: ore type = seed (number)
	var/list/static_seeds
	/// Perlin zoom
	var/zoom = UNDERGROUND_ORES_PERLIN_ZOOM
	/// Perlin drift randomization
	var/drift = 0
	/// Perlin zoom override for ores
	var/list/zoom_override

/datum/underground_ore_data/New()
	for(var/path in ores)
		seeds[path] = (static_seeds && static_seeds[path]) || rand(1, 1000000)

/**
 * Gets the ore list for a turf.
 */
/datum/underground_ore_data/proc/generate(turf/T)

