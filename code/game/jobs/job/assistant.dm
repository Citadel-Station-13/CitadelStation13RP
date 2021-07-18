//////////////////////////////////
//			Assistant
//////////////////////////////////
/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	departments = list(DEPARTMENT_CIVILIAN)
	sorting_order = -1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

	outfit_type = /decl/hierarchy/outfit/job/assistant
	alt_titles = list("Visitor" = /datum/alt_title/visitor, "Server" = /datum/alt_title/server, "Morale Officer" = /datum/alt_title/morale_officer)

/datum/job/assistant/get_access()
	if(config_legacy.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

/datum/job/assistant		// Visitor
	title = USELESS_JOB
	supervisors = "nobody! You don't work here"
	timeoff_factor = 0

/datum/job/assistant/New()
	..()
	if(config)
		total_positions = config_legacy.limit_visitors
		spawn_positions = config_legacy.limit_visitors

/datum/job/assistant/get_access()
	return list()

/datum/alt_title/visitor
	title = "Visitor"
	title_outfit = /decl/hierarchy/outfit/job/assistant/visitor

/datum/alt_title/server
	title = "Server"
	title_outfit = /decl/hierarchy/outfit/job/service/server

/datum/alt_title/morale_officer
	title = "Morale Officer"
