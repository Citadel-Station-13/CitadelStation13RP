//Normal map defs
#define Z_LEVEL_SURFACE_UNDER				1
#define Z_LEVEL_SURFACE_LOW					2
#define Z_LEVEL_SURFACE_MID					3
#define Z_LEVEL_MISC						4
#define Z_LEVEL_CENTCOM						5
#define Z_LEVEL_MINING						6

/datum/map/boreas
	name = "Boreas"
	full_name = "Boreas PRC"
	path = "boreas"

	zlevel_datum_type = /datum/map_z_level/boreas

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

	admin_levels = list()
	sealed_levels = list()
	empty_levels = list()
	station_levels = list(Z_LEVEL_SURFACE_UNDER,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID)
	contact_levels = list(Z_LEVEL_SURFACE_UNDER,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID)
	player_levels = list(Z_LEVEL_SURFACE_UNDER,
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID)

	station_name  = "Boreas Phoron Research Center"
	station_short = "Boreas"
	dock_name     = "Boreas Mass Driver"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Nerada"



	shuttle_docked_message = "The mass driver is prepping for launch to the %dock_name% has arrived. It will depart in launch %ETD%."
	shuttle_leaving_dock = "The mass driver has fired. Estimate %ETA% until the pod arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The pod will be firing shortly. Those departing should proceed to the mass driver within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The evacuation pod has arrived at the tram station. You have approximately %ETD% to board the pod."
	emergency_shuttle_leaving_dock = "The evacuation pod has left the station. Estimate %ETA% until the pod arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule pod has been called. It will be ready to fire in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation pod has been cancelled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_ENGINEERING_OUTPOST,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_NORTHERN_STAR,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

	allowed_spawns = list("Tram Station","Gateway","Cryogenic Storage","Cyborg Storage")
	spawnpoint_died = /datum/spawnpoint/cryo
	spawnpoint_left = /datum/spawnpoint/cryo
	spawnpoint_stayed = /datum/spawnpoint/cryo
/*
	lateload_z_levels = list(
		list("Boreas - Misc","Boreas - Ships","Boreas - Underdark"), //Stock Boreas lateload maps
		list("Alien Ship - Z1 Ship"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface")
		)
	lateload_single_pick = null //Nothing right now.
*/
/datum/map/boreas/perform_map_generation()

//	seed_submaps(list(Z_LEVEL_SURFACE_LOW), 80, /area/boreas/surfacebase/outside/wilderness, /datum/map_template/surface/mountains_snow/normal)
//	seed_submaps(list(Z_LEVEL_SURFACE_LOW), 80, /area/boreas/surfacebase/outside/outside3, /datum/map_template/surface/mountains_snow/deep)
//	seed_submaps(list(Z_LEVEL_SURFACE_UNDER), 200, /area/boreas/surfacebase/outside/outside2, /datum/map_template/surface/mountains_snow/under)
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_MINING, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 3, 3, Z_LEVEL_MINING, world.maxx - 4, world.maxy - 4)         // Create the mining ore distribution map.
	new /datum/random_map/noise/ore(null, 3, 3, Z_LEVEL_SURFACE_UNDER, world.maxx - 4, world.maxy - 4)

	return 1

// Short range computers see only the three main levels, others can see the surrounding surface levels.
/datum/map/boreas/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz >= Z_LEVEL_SURFACE_UNDER && srcz <= Z_LEVEL_SURFACE_MID)
		return list(
			Z_LEVEL_SURFACE_UNDER,
			Z_LEVEL_SURFACE_LOW,
			Z_LEVEL_SURFACE_MID)
	else
		return list(srcz) //may prevent runtimes, but more importantly gives gps units a shortwave-esque function

/datum/map_z_level/boreas/under
	z = Z_LEVEL_SURFACE_UNDER
	name = "Underground"
	base_turf = /turf/simulated/floor/outdoors/snow/boreas
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/boreas/ground
	z = Z_LEVEL_SURFACE_LOW
	name = "Ground Floor"
	base_turf = /turf/simulated/mineral
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/boreas/second
	z = Z_LEVEL_SURFACE_MID
	name = "Second Floor"
	base_turf = /turf/simulated/open
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/boreas/colony
	z = Z_LEVEL_CENTCOM
	name = "Colony"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/boreas/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_z_level/boreas/mining
	z = Z_LEVEL_MINING
	name = "Mineral Deposit"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/floor/outdoors/rocks

