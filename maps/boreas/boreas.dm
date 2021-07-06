#if !defined(USING_MAP_DATUM)

	#include "boreas_defines.dm"
	#include "boreas_turfs.dm"
	#include "boreas_things.dm"
	#include "boreas_shuttle_defs.dm"
	#include "boreas_shuttles.dm"
	#include "boreas_telecomms.dm"
	#include "boreas_areas.dm"

	#if !AWAY_MISSION_TEST //Don't include these for just testing away missions
		#include "../../_maps/map_files/boreas/boreas-1.dmm"
		#include "../../_maps/map_files/boreas/boreas-2.dmm"
		#include "../../_maps/map_files/boreas/boreas-3.dmm"
		#include "../../_maps/map_files/boreas/boreas-colony.dmm"
		#include "../../maps/boreas/boreas-mining.dmm"
		#include "../../maps/boreas/boreas-misc.dmm"
	#endif

//	#include "submaps/_boreas_submaps.dm"

	#define USING_MAP_DATUM /datum/map/boreas

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring boreas

#endif
