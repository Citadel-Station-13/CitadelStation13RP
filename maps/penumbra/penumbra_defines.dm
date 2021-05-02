//Turfmakers
#define NERADA8_SET_ATMOS	initial_gas_mix = ATMOSPHERE_ID_NERADA8
#define NERADA8_TURF_CREATE(x)	x/nerada8/initial_gas_mix = ATMOSPHERE_ID_NERADA8;x/nerada8/outdoors=TRUE;x/nerada8/allow_gas_overlays = FALSE
#define NERADA8_TURF_CREATE_UN(x)	x/nerada8/initial_gas_mix=ATMOSPHERE_ID_NERADA8

//Normal map defs
#define Z_LEVEL_SURFACE_CAVES				1
#define Z_LEVEL_SURFACE_MAIN				2
#define Z_LEVEL_SURFACE_ROOF				3
//#define Z_LEVEL_CENTCOM						4

/datum/map/penumbra
	name = "Penumbra"
	full_name = "Penumbra Station"
	path = "penumbra"

	zlevel_datum_type = /datum/map_z_level/penumbra

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi' //CITADEL CHANGE: Ignore this line because it's going to be overriden in modular_citadel\maps\tether\tether_defines.dm

	holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_MAIN))

	station_name  = "Penumbra Station"
	station_short = "Penumbra"
	dock_name     = "Virgo-3B Colony"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Nerada"

	shuttle_docked_message = "The scheduled Orange Line tram to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Orange Line tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The tram will be arriving shortly. Those departing should proceed to the Orange Line tram station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The evacuation tram has arrived at the tram station. You have approximately %ETD% to board the tram."
	emergency_shuttle_leaving_dock = "The emergency tram has left the station. Estimate %ETA% until the shuttle arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule tram has been called. It will arrive at the tram station in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation tram has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_RESEARCH,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

	allowed_spawns = list("Arrivals Shuttle","Gateway","Cryogenic Storage","Cyborg Storage")
	spawnpoint_died = /datum/spawnpoint/arrivals
	spawnpoint_left = /datum/spawnpoint/arrivals
	spawnpoint_stayed = /datum/spawnpoint/cryo

	//meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)

	/*unit_test_exempt_areas = list(
		/area/tether/surfacebase/outside/outside1,
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/crew_quarters/sleep/Dorm_1/holo,
		/area/crew_quarters/sleep/Dorm_3/holo,
		/area/crew_quarters/sleep/Dorm_5/holo,
		/area/crew_quarters/sleep/Dorm_7/holo)
	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos/intake, // Outside,
		/area/rnd/external, //  Outside,
		/area/tether/surfacebase/mining_main/external, // Outside,
		/area/tether/surfacebase/mining_main/airlock, //  Its an airlock,
		/area/tether/surfacebase/emergency_storage/rnd,
		/area/tether/surfacebase/emergency_storage/atrium)*/

	/*lateload_z_levels = list(
		list("Tether - Misc","Tether - Ships","Tether - Underdark"), //Stock Tether lateload maps
		list("Alien Ship - Z1 Ship"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface")
		)*/

	lateload_single_pick = null //Nothing right now.

/*/datum/map/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1*/

// Short range computers see only the six main levels, others can see the surrounding surface levels.
/datum/map/penumbra/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz >= Z_LEVEL_SURFACE_CAVES && srcz <= Z_LEVEL_SURFACE_ROOF)
		return list(
			Z_LEVEL_SURFACE_CAVES,
			Z_LEVEL_SURFACE_MAIN,
			Z_LEVEL_SURFACE_ROOF)
	else
		return ..()

/datum/map_z_level/penumbra/surface_caves
	z = Z_LEVEL_SURFACE_CAVES
	name = "Caves"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks/nerada8
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/penumbra/surface_main
	z = Z_LEVEL_SURFACE_MAIN
	name = "Surface"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/penumbra/surface_roof
	z = Z_LEVEL_SURFACE_ROOF
	name = "Roof"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/open
	holomap_legend_x = 220
	holomap_legend_y = 160


// For making the 6-in-1 holomap, we calculate some offsets
#define PENUMBRA_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define PENUMBRA_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define PENUMBRA_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*PENUMBRA_MAP_SIZE) - PENUMBRA_HOLOMAP_CENTER_GUTTER) / 2) // 100
#define PENUMBRA_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*PENUMBRA_MAP_SIZE)) / 2) // 60

/*/datum/map_z_level/penumbra/centcom
	z = Z_LEVEL_CENTCOM
	name = "Colony"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
*/