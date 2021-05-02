#if !defined(USING_MAP_DATUM)

	#include "penumbra_defines.dm"
	#include "penumbra_turfs.dm"
	#include "penumbra_areas.dm"
	#include "penumbra_shuttles.dm"
	//#include "penumbra_shuttle_defs.dm"
	#include "penumbra_nerada8.dm"

	//#include "submaps/_penumbra_submaps.dm"

	#define USING_MAP_DATUM /datum/map/penumbra

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Penumbra

#endif
