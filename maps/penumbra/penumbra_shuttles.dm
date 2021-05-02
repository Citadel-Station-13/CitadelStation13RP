//Write your own shit later major


/*
/datum/shuttle/ferry/emergency
	var/tag_door_station = "escape_shuttle_hatch_station"
	var/tag_door_offsite = "escape_shuttle_hatch_offsite"
	var/frequency = 1380 // Why this frequency? BECAUSE! Thats what someone decided once.
	var/datum/radio_frequency/radio_connection

/datum/shuttle/ferry/emergency/escape
	name = "Escape"
	location = 1 // At offsite
	warmup_time = 10
	area_offsite = /area/shuttle/escape/centcom
	area_station = /area/shuttle/escape/station
	area_transition = /area/shuttle/escape/transit
	docking_controller_tag = "escape_shuttle"
	dock_target_station = "escape_dock"
	dock_target_offsite = "centcom_dock"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/datum/shuttle/ferry/emergency/init_docking_controllers()
	docking_controller_tag = null
	dock_target_station = null
	dock_target_offsite = null
	radio_connection = radio_controller.add_object(src, frequency, null)
	..()

/datum/shuttle/ferry/emergency/dock()
	..()
	// Open Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)

/datum/shuttle/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	area_offsite = /area/supply/dock
	area_station = /area/supply/station
	docking_controller_tag = "supply_shuttle"
	dock_target_station = "cargo_bay"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

*/