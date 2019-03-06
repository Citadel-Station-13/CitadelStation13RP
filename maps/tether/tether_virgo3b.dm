var/datum/planet/virgo3b/planet_virgo3b = null

/datum/time/virgo3b
	seconds_in_day = 3 HOURS

/datum/planet/virgo3b
	name = "Virgo-3B"
	desc = "A mid-sized moon of the Virgo 3 gas giant, this planet has an atmosphere mainly comprised of phoron, with trace \
	amounts of both oxygen and nitrogen. Fortunately, the oxygen is not enough to be combustible in any meaningful way, however \
	the phoron is desirable by many corporations, including NanoTrasen."
	current_time = new /datum/time/virgo3b()
	expected_z_levels = list(
						Z_LEVEL_SURFACE_LOW,
						Z_LEVEL_SURFACE_MID,
						Z_LEVEL_SURFACE_HIGH,
						Z_LEVEL_SURFACE_MINE,
						Z_LEVEL_SOLARS
						)
	planetary_wall_type = /turf/unsimulated/wall/planetary/virgo3b

/datum/planet/virgo3b/New()
	..()
	planet_virgo3b = src
	weather_holder = new /datum/weather_holder/virgo3b(src)

/datum/planet/virgo3b/update_sun()
	..()
	var/datum/time/time = current_time
	var/length_of_day = time.seconds_in_day / 10 / 60 / 60
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	sun_position = distance_from_noon / noon
	sun_position = abs(sun_position - 1)

	var/low_brightness = null
	var/high_brightness = null

	var/low_color = null
	var/high_color = null
	var/min = 0

	switch(sun_position)
		if(0 to 0.40) // Night
			low_brightness = 0.2
			low_color = "#000066"

			high_brightness = 0.5
			high_color = "#66004D"
			min = 0

		if(0.40 to 0.50) // Twilight
			low_brightness = 0.6
			low_color = "#66004D"

			high_brightness = 0.8
			high_color = "#CC3300"
			min = 0.40

		if(0.50 to 0.70) // Sunrise/set
			low_brightness = 0.8
			low_color = "#CC3300"

			high_brightness = 0.9
			high_color = "#FF9933"
			min = 0.50

		if(0.70 to 1.00) // Noon
			low_brightness = 0.9
			low_color = "#DDDDDD"

			high_brightness = 1.0
			high_color = "#FFFFFF"
			min = 0.70

	var/lerp_weight = (abs(min - sun_position)) * 4
	var/weather_light_modifier = 1
	if(weather_holder && weather_holder.current_weather)
		weather_light_modifier = weather_holder.current_weather.light_modifier

	var/new_brightness = (Interpolate(low_brightness, high_brightness, weight = lerp_weight) ) * weather_light_modifier

	var/new_color = null
	if(weather_holder && weather_holder.current_weather && weather_holder.current_weather.light_color)
		new_color = weather_holder.current_weather.light_color
	else
		var/list/low_color_list = hex2rgb(low_color)
		var/low_r = low_color_list[1]
		var/low_g = low_color_list[2]
		var/low_b = low_color_list[3]

		var/list/high_color_list = hex2rgb(high_color)
		var/high_r = high_color_list[1]
		var/high_g = high_color_list[2]
		var/high_b = high_color_list[3]

		var/new_r = Interpolate(low_r, high_r, weight = lerp_weight)
		var/new_g = Interpolate(low_g, high_g, weight = lerp_weight)
		var/new_b = Interpolate(low_b, high_b, weight = lerp_weight)

		new_color = rgb(new_r, new_g, new_b)

	spawn(1)
		update_sun_deferred(2, new_brightness, new_color)


/datum/weather_holder/virgo3b
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/virgo3b/clear(),
		WEATHER_OVERCAST	= new /datum/weather/virgo3b/overcast(),
		WEATHER_LIGHT_SNOW	= new /datum/weather/virgo3b/light_snow(),
		WEATHER_SNOW		= new /datum/weather/virgo3b/snow(),
		WEATHER_BLIZZARD	= new /datum/weather/virgo3b/blizzard(),
		WEATHER_RAIN		= new /datum/weather/virgo3b/rain(),
		WEATHER_STORM		= new /datum/weather/virgo3b/storm(),
		WEATHER_HAIL		= new /datum/weather/virgo3b/hail(),
		WEATHER_BLOOD_MOON	= new /datum/weather/virgo3b/blood_moon()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 30,
		WEATHER_OVERCAST	= 30,
		WEATHER_LIGHT_SNOW	= 20,
		WEATHER_SNOW		= 5,
		WEATHER_BLIZZARD	= 5,
		WEATHER_RAIN		= 5,
		WEATHER_STORM		= 2.5,
		WEATHER_HAIL		= 2.5
		)

/datum/weather/virgo3b
	name = "virgo3b base"
	temp_high = 243.15 // -20c
	temp_low = 233.15  // -30c

/datum/weather/virgo3b/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR = 60,
		WEATHER_OVERCAST = 40
		)

/datum/weather/virgo3b/overcast
	name = "overcast"
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_CLEAR = 25,
		WEATHER_OVERCAST = 50,
		WEATHER_LIGHT_SNOW = 10,
		WEATHER_SNOW = 5,
		WEATHER_RAIN = 5,
		WEATHER_HAIL = 5
		)

/datum/weather/virgo3b/light_snow
	name = "light snow"
	icon_state = "snowfall_light"
	temp_high = 235
	temp_low = 	225
	light_modifier = 0.7
	transition_chances = list(
		WEATHER_OVERCAST = 20,
		WEATHER_LIGHT_SNOW = 50,
		WEATHER_SNOW = 25,
		WEATHER_HAIL = 5
		)

/datum/weather/virgo3b/snow
	name = "moderate snow"
	icon_state = "snowfall_med"
	temp_high = 230
	temp_low = 220
	light_modifier = 0.5
	flight_failure_modifier = 5
	transition_chances = list(
		WEATHER_LIGHT_SNOW = 20,
		WEATHER_SNOW = 50,
		WEATHER_BLIZZARD = 20,
		WEATHER_HAIL = 5,
		WEATHER_OVERCAST = 5
		)

/datum/weather/virgo3b/snow/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(33))
						T.chill()

/datum/weather/virgo3b/blizzard
	name = "blizzard"
	icon_state = "snowfall_heavy"
	temp_high = 215
	temp_low = 200
	light_modifier = 0.3
	flight_failure_modifier = 10
	transition_chances = list(
		WEATHER_SNOW = 45,
		WEATHER_BLIZZARD = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)

/datum/weather/virgo3b/blizzard/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(50))
						T.chill()

/datum/weather/virgo3b/rain
	name = "rain"
	icon_state = "rain"
	light_modifier = 0.5
	effect_message = "<span class='warning'>Rain falls on you.</span>"

	transition_chances = list(
		WEATHER_OVERCAST = 25,
		WEATHER_LIGHT_SNOW = 10,
		WEATHER_RAIN = 50,
		WEATHER_STORM = 10,
		WEATHER_HAIL = 5
		)

/datum/weather/virgo3b/rain/process_effects()
	..()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll guard from rain
			if(istype(L.get_active_hand(), /obj/item/weapon/melee/umbrella))
				var/obj/item/weapon/melee/umbrella/U = L.get_active_hand()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain patters softly onto your umbrella</span>")
					continue
			else if(istype(L.get_inactive_hand(), /obj/item/weapon/melee/umbrella))
				var/obj/item/weapon/melee/umbrella/U = L.get_inactive_hand()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain patters softly onto your umbrella</span>")
					continue

			L.water_act(1)
			if(show_message)
				to_chat(L, effect_message)

/datum/weather/virgo3b/storm
	name = "storm"
	icon_state = "storm"
	light_modifier = 0.3
	flight_failure_modifier = 10


	transition_chances = list(
		WEATHER_RAIN = 45,
		WEATHER_STORM = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)

/datum/weather/virgo3b/storm/process_effects()
	..()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll get stolen by the wind
			if(istype(L.get_active_hand(), /obj/item/weapon/melee/umbrella))
				var/obj/item/weapon/melee/umbrella/U = L.get_active_hand()
				if(U.open)
					to_chat(L, "<span class='warning'>A gust of wind yanks the umbrella from your hand!</span>")
					L.drop_from_inventory(U)
					U.throw_at(get_edge_target_turf(U, pick(alldirs)), 8, 1, L)
			else if(istype(L.get_inactive_hand(), /obj/item/weapon/melee/umbrella))
				var/obj/item/weapon/melee/umbrella/U = L.get_inactive_hand()
				if(U.open)
					to_chat(L, "<span class='warning'>A gust of wind yanks the umbrella from your hand!</span>")
					L.drop_from_inventory(U)
					U.throw_at(get_edge_target_turf(U, pick(alldirs)), 8, 1, L)

			L.water_act(2)
			to_chat(L, "<span class='warning'>Rain falls on you, drenching you in water.</span>")

/datum/weather/virgo3b/hail
	name = "hail"
	icon_state = "hail"
	light_modifier = 0.3
	flight_failure_modifier = 15
	timer_low_bound = 2
	timer_high_bound = 5
	effect_message = "<span class='warning'>The hail smacks into you!</span>"

	transition_chances = list(
		WEATHER_RAIN = 45,
		WEATHER_STORM = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)

/datum/weather/virgo3b/hail/process_effects()
	..()
	for(var/humie in human_mob_list)
		var/mob/living/carbon/human/H = humie
		if(H.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(H)
			if(!T.outdoors)
				continue // They're indoors, so no need to pelt them with ice.

			// If they have an open umbrella, it'll guard from hail
			var/obj/item/weapon/melee/umbrella/U
			if(istype(H.get_active_hand(), /obj/item/weapon/melee/umbrella))
				U = H.get_active_hand()
			else if(istype(H.get_inactive_hand(), /obj/item/weapon/melee/umbrella))
				U = H.get_inactive_hand()
			if(U && U.open)
				if(show_message)
					to_chat(H, "<span class='notice'>Hail patters onto your umbrella.</span>")
				continue

			var/target_zone = pick(BP_ALL)
			var/amount_blocked = H.run_armor_check(target_zone, "melee")
			var/amount_soaked = H.get_armor_soak(target_zone, "melee")

			var/damage = rand(1,3)

			if(amount_blocked >= 30)
				continue // No need to apply damage. Hardhats are 30. They should probably protect you from hail on your head.
				//Voidsuits are likewise 40, and riot, 80. Clothes are all less than 30.

			if(amount_soaked >= damage)
				continue // No need to apply damage.

			H.apply_damage(damage, BRUTE, target_zone, amount_blocked, amount_soaked, used_weapon = "hail")
			if(prob(10))
				if(show_message)
					to_chat(H, effect_message)

/datum/weather/virgo3b/blood_moon
	name = "blood moon"
	light_modifier = 0.5
	light_color = "#FF0000"
	flight_failure_modifier = 25
	transition_chances = list(
		WEATHER_BLOODMOON = 100
		)
