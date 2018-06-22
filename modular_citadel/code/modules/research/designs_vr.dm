/datum/design/item/nif
	sort_string = "HABBB"

/datum/design/item/nif/bioadap
	name = "bioadaptive nanite implant framework"
	id = "bionif"
	req_tech = list(TECH_MAGNET = 6, TECH_BLUESPACE = 5, TECH_MATERIAL = 6, TECH_ENGINEERING = 6, TECH_DATA = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 10000, "uranium" = 8000, "diamond" = 7000)
	build_path = /obj/item/device/nif/bioadap
	sort_string = "HABBC"
