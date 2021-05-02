//Simulated
NERADA8_TURF_CREATE(/turf/simulated/open)
/turf/simulated/open/nerada8
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf

/turf/simulated/open/nerada8/New()
	..()
	if(outdoors)
		SSplanets.addTurf(src)

/turf/simulated/mineral/nerada8
	icon_state = "icerock"
	rock_side_icon_state = "ice_side"

/turf/simulated/mineral/nerada8/snow
	icon_state = "snowrock"
	rock_side_icon_state = "snow_side"

NERADA8_TURF_CREATE(/turf/simulated/floor)

/turf/simulated/floor/penumbra
	NERADA8_SET_ATMOS

/turf/simulated/floor/penumbra/nerada8_indoors
	NERADA8_SET_ATMOS

/turf/simulated/floor/outdoors/penumbra
	NERADA8_SET_ATMOS

/turf/simulated/floor/outdoors/snow/nerada8
	NERADA8_SET_ATMOS
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/nerada8,
		/turf/simulated/floor/outdoors/dirt/nerada8
		)

/turf/simulated/floor/outdoors/dirt/nerada8
	NERADA8_SET_ATMOS
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/nerada8
		)

/turf/simulated/floor/outdoors/rocks/nerada8
	NERADA8_SET_ATMOS

/*
/turf/simulated/floor/nerada8_indoors/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	return 0

NERADA8_TURF_CREATE(/turf/simulated/floor/reinforced)
NERADA8_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
NERADA8_TURF_CREATE(/turf/simulated/floor/outdoors/snow)
NERADA8_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
NERADA8_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
NERADA8_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
/turf/simulated/floor/outdoors/grass/sif
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/nerada8,
		/turf/simulated/floor/outdoors/dirt/nerada8
		)



// Overriding these for the sake of submaps that use them on other planets.
// This means that mining on tether base and space is oxygen-generating, but solars and mining should use the virgo3b subtype
/turf/simulated/mineral
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C
/turf/simulated/floor/outdoors
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C
/turf/simulated/floor/water
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C

/turf/simulated/mineral/vacuum
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB
/turf/simulated/mineral/floor/vacuum
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB

NERADA8_TURF_CREATE(/turf/simulated/mineral)
NERADA8_TURF_CREATE(/turf/simulated/mineral/floor)
*/
	//This proc is responsible for ore generation on surface turfs
/turf/simulated/mineral/nerada8/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 20,
			"carbon" = 20,
			"diamond" = 1,
			"gold" = 8,
			"silver" = 8,
			"phoron" = 18))
	else
		mineral_name = pickweight(list(
			"uranium" = 5,
			"platinum" = 5,
			"hematite" = 35,
			"carbon" = 35,
			"gold" = 3,
			"silver" = 3,
			"phoron" = 25))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/turf/simulated/mineral/nerada8/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 10,
			"carbon" = 10,
			"diamond" = 4,
			"gold" = 15,
			"silver" = 15))
	else
		mineral_name = pickweight(list(
			"uranium" = 7,
			"platinum" = 7,
			"hematite" = 28,
			"carbon" = 28,
			"diamond" = 2,
			"gold" = 7,
			"silver" = 7))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()


//GROSS COPY PASTED CODE FOR TESTING SHIT, FIX IT LATER OR YOU HAVE LIGMA

/turf/simulated/mineral/update_icon(var/update_neighbors)

	cut_overlays()

	//We are a wall (why does this system work like this??)
	if(density)
		if(mineral)
			name = "[mineral.display_name] deposit"
		else
			name = "rock"

		icon = 'icons/turf/walls.dmi'
		icon_state = "icerock"

		//Apply overlays if we should have borders
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src,direction)
			if(istype(T) && !T.density)
				add_overlay(get_cached_border("ice_side",direction,icon,"ice_side"))

			if(archaeo_overlay)
				add_overlay(archaeo_overlay)

			if(excav_overlay)
				add_overlay(excav_overlay)

	//We are a sand floor
	else
		name = "frosty ground"
		icon = 'icons/turf/flooring/asteroid.dmi'
		icon_state = "snowrock"

		if(sand_dug)
			add_overlay("dug_overlay")

		//Apply overlays if there's space
		for(var/direction in GLOB.cardinal)
			if(istype(get_step(src, direction), /turf/space) && !istype(get_step(src, direction), /turf/space/cracked_asteroid))
				add_overlay(get_cached_border("asteroid_edge",direction,icon,"asteroid_edges", 0))

			//Or any time
			else
				var/turf/T = get_step(src, direction)
				if(istype(T) && T.density)
					add_overlay(get_cached_border("ice_side",direction,'icons/turf/walls.dmi',"ice_side"))

		if(overlay_detail)
			add_overlay('icons/turf/flooring/decals.dmi',overlay_detail)

		if(update_neighbors)
			for(var/direction in GLOB.alldirs)
				if(istype(get_step(src, direction), /turf/simulated/mineral))
					var/turf/simulated/mineral/M = get_step(src, direction)
					M.update_icon()

//Unsimulated
/turf/unsimulated/wall/planetary/nerada8
	name = "impassable rock"
	desc = "A deep bedrock of frozen stone. There's no way you could dig through this.."
	alpha = 0xFF
	icon_state = "icerock"
	NERADA8_SET_ATMOS

/turf/unsimulated/wall/planetary/nerada8/aberrant
	name = "thick aberrant mass"
	desc = "Dormant, tough aberrant mass. Seems impossible to cut through."
	icon_state = "alienvault"

/*
/turf/unsimulated/mineral/nerada8
	blocks_air = TRUE

/turf/unsimulated/floor/steel
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel"


/turf/unsimulated/wall
	blocks_air = 1

/turf/unsimulated/wall/planetary
	blocks_air = 0
*/
