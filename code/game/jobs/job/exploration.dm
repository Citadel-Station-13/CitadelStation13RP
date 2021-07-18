/obj/item/card/id/medical/sar
	assignment = "Field Medic"
	rank = "Field Medic"
	icon_state = "cyan"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)
	job_access_type = /datum/job/sar

/obj/item/card/id/explorer
	name = "identification card"
	desc = "A card issued to station exploration staff."
	icon_state = "cyan"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)

/obj/item/card/id/explorer/pilot
	assignment = "Pilot"
	rank = "Pilot"
	job_access_type = /datum/job/pilot

/obj/item/card/id/explorer/explorer
	assignment = "Explorer"
	rank = "Explorer"
	job_access_type = /datum/job/explorer

/obj/item/card/id/explorer/head
	name = "identification card"
	desc = "A card which represents discovery of the unknown."
	icon_state = "cyanGold"
	primary_color = rgb(47,189,189)
	secondary_color = rgb(127,223,223)


/obj/item/card/id/explorer/head/pathfinder
	assignment = "Pathfinder"
	rank = "Pathfinder"
	job_access_type = /datum/job/pathfinder

/datum/department/planetside
	name = DEPARTMENT_PLANET
	color = "#bab421"
	sorting_order = 2 // Same as cargo in importance.



/datum/job/pathfinder
	title = "Pathfinder"
	flag = PATHFINDER
	departments = list(DEPARTMENT_PLANET)
	departments_managed = list(DEPARTMENT_PLANET)
	sorting_order = 1 // above the other explorers
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	selection_color = "#d6d05c"
	idtype = /obj/item/card/id/explorer/head/pathfinder
	economic_modifier = 8
	minimal_player_age = 7
	pto_type = PTO_EXPLORATION

	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway, access_pathfinder)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway, access_pathfinder)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder
	job_description = "The Pathfinder's job is to lead and manage expeditions, and is the primary authority on all off-station expeditions."
	alt_titles = list("Expedition Lead" = /datum/alt_title/expedition_lead, "Exploration Manager" = /datum/alt_title/exploration_manager,
	"Lead Pioneer" = /datum/alt_title/pathfinder/pioneer)

/datum/alt_title/expedition_lead
	title = "Expedition Lead"

/datum/alt_title/exploration_manager
	title = "Exploration Manager"

/datum/alt_title/pathfinder/pioneer
	title = "Lead Pioneer"


/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Pathfinder and the Head of Personnel"
	idtype = /obj/item/card/id/explorer/pilot
	selection_color = "#515151"
	economic_modifier = 5
	minimal_player_age = 3
	pto_type = PTO_EXPLORATION
	access = list(access_pilot, access_external_airlocks)
	minimal_access = list(access_pilot, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/pilot
	job_description = "A Pilot flies the various shuttles in the Virgo-Erigone System."
	alt_titles = list("Co-Pilot" = /datum/alt_title/co_pilot, "Navigator" = /datum/alt_title/navigator)

/datum/alt_title/co_pilot
	title = "Co-Pilot"
	title_blurb = "A Co-Pilot is there primarily to assist main pilot as well as learn from them"

/datum/alt_title/navigator
	title = "Navigator"


/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	departments = list(DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Pathfinder and the Research Director"
	selection_color = "#999440"
	economic_modifier = 6
	pto_type = PTO_EXPLORATION
	idtype = /obj/item/card/id/explorer/explorer
	access = list(access_explorer, access_external_airlocks, access_research, access_pilot, access_gateway)
	minimal_access = list(access_explorer, access_external_airlocks, access_research, access_pilot, access_gateway)
	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An Explorer searches for interesting things, and returns them to the station."
	alt_titles = list("Surveyor" = /datum/alt_title/surveyor, "Offsite Scout" = /datum/alt_title/offsite_scout,
	"Field Scout" = /datum/alt_title/explorer/field_scout, "Pioneer" = /datum/alt_title/explorer/pioneer,
	"Jr. Explorer" = /datum/alt_title/explorer/junior)

/datum/alt_title/surveyor
	title = "Surveyor"

/datum/alt_title/offsite_scout
	title = "Offsite Scout"

/datum/alt_title/explorer/field_scout
	title = "Field Scout"

/datum/alt_title/explorer/pioneer
	title = "Pioneer"

/datum/alt_title/explorer/junior
	title = "Jr. Explorer"

/datum/job/sar
	title = "Field Medic"
	flag = SAR
	departments = list(DEPARTMENT_PLANET, DEPARTMENT_MEDICAL)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Pathfinder and the Chief Medical Officer"
	selection_color = "#999440"
	idtype = /obj/item/card/id/medical/sar
	economic_modifier = 6
	minimal_player_age = 3
	pto_type = PTO_EXPLORATION
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_eva, access_maint_tunnels, access_external_airlocks, access_pilot)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_pilot)
	outfit_type = /decl/hierarchy/outfit/job/medical/sar
	job_description = "A Field medic works as the field doctor of expedition teams."
	alt_titles = list("Expedition Medic" = /datum/alt_title/expedition_medic, "Search and Rescue" = /datum/alt_title/field_medic/sar)

/datum/alt_title/expedition_medic
	title = "Expedition Medic"

/datum/alt_title/field_medic/sar
	title = "Search and Rescue"
