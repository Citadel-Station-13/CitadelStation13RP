#define UT_NORMAL 1
#define UT_VACUUM 2
#define UT_NORMAL_COLD 3

/datum/unit_test/zas_area_test
	var/area_path = null
	var/expectation = UT_NORMAL

/datum/unit_test/zas_area_test/proc/test_air_in_area(area/test_area, expectation = UT_NORMAL)
	var/test_result = list("result" = FALSE, "msg" = "")
	var/area/A = locate(test_area)

	if(!istype(A, test_area))
		test_result["msg"] = "Unable to get test area: [test_area]"
		return test_result

	var/list/GM_checked = list()

	for(var/turf/simulated/T in A)
		if(!istype(T) || isnull(T.zone) || istype(T, /turf/simulated/floor/airless) || istype(T,/turf/simulated/shuttle/plating/airless))
			continue
		if(T.zone.air in GM_checked)
			continue

		var/t_msg = "Turf: [T] |  Location: [T.x] // [T.y] // [T.z]"

		var/datum/gas_mixture/GM = T.return_air()
		var/pressure = GM.return_pressure()
		var/temp = GM.temperature

		switch(expectation)
			if(UT_VACUUM)
				if(pressure > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result

			if(UT_NORMAL || UT_NORMAL_COLD)
				if(abs(pressure - ONE_ATMOSPHERE) > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result

				if(expectation == UT_NORMAL)
					if(abs(temp - T20C) > 10)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

				if(expectation == UT_NORMAL_COLD)
					if(temp > 120)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

		GM_checked.Add(GM)

	if(GM_checked.len)
		test_result["result"] = TRUE
		test_result["msg"] = "Checked [GM_checked.len] zones"
	else
		test_result["msg"] = "No zones checked."

	return test_result

/datum/unit_test/zas_area_test/Run()
	var/list/test = test_air_in_area(area_path, expectation)

	if(!test["result"])
		log_test(test["msg"])
		log_test("[ASCII_YELLOW]This ZAS test does not count as a failure, but please fix these if possible![ASCII_RESET]")
	return TRUE

/datum/unit_test/zas_area_test/supply_centcomm
	area_path = /area/supply/dock

/datum/unit_test/zas_area_test/emergency_shuttle
	area_path = /area/shuttle/escape/centcom

/datum/unit_test/zas_area_test/ai_chamber
	area_path = /area/ai

// VOREStation Edit - We don't have this anymore - Tether
// /datum/unit_test/zas_area_test/mining_shuttle_at_station
// 	name = "ZAS: Mining Shuttle (Station)"
// 	area_path = /area/shuttle/mining/station

/datum/unit_test/zas_area_test/cargo_maint
	area_path = /area/maintenance/cargo

// VOREStation Edit - We don't have this anymore - Tether
// /datum/unit_test/zas_area_test/eng_shuttle
// 	name = "ZAS: Construction Site Shuttle (Station)"
// 	area_path = /area/shuttle/constructionsite/station

/datum/unit_test/zas_area_test/virology
	area_path = /area/medical/virology

/datum/unit_test/zas_area_test/xenobio
	area_path = /area/rnd/xenobiology

/datum/unit_test/zas_area_test/mining_area
	area_path = /area/mine/explored
	expectation = UT_VACUUM

/datum/unit_test/zas_area_test/cargo_bay
	area_path = /area/quartermaster/storage

#undef UT_NORMAL
#undef UT_VACUUM
#undef UT_NORMAL_COLD
