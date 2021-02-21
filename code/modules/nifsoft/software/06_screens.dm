/datum/nifsoft/crewmonitor
	name = "Crew Monitor"
	desc = "A link to the local crew monitor sensors. Useful for finding people in trouble."
	list_pos = NIF_MEDMONITOR
	access = access_medical
	cost = 625
	p_drain = 0.025

/datum/nifsoft/crewmonitor/activate()
	. = ..()
	if(.)
		GLOB.crewmonitor.show(nif.human, src)
		return TRUE

/datum/nifsoft/crewmonitor/stat_text()
	return "Show Monitor"

/datum/nifsoft/alarmmonitor
	name = "Alarm Monitor"
	desc = "A link to the local alarm monitors. Useful for detecting alarms in a pinch."
	list_pos = NIF_ENGMONITOR
	access = access_engine
	cost = 625
	p_drain = 0.025
	var/datum/nano_module/alarm_monitor/engineering/arscreen

/datum/nifsoft/alarmmonitor/New()
	..()
	arscreen = new(nif)

/datum/nifsoft/alarmmonitor/Destroy()
		QDEL_NULL(arscreen)
		return ..()

/datum/nifsoft/alarmmonitor/activate()
	if((. = ..()))
		arscreen.nano_ui_interact(nif.human,"main",null,1,nif_state)
		return TRUE

/datum/nifsoft/alarmmonitor/stat_text()
	return "Show Monitor"
