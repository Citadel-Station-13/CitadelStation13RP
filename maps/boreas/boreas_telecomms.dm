// ### Preset machines  ###


// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/boreas/base_low
	id = "Base Relay 1"
	listening_level = Z_LEVEL_SURFACE_LOW
	autolinkers = list("bsl_relay")

/obj/machinery/telecomms/relay/preset/boreas/base_mid
	id = "Base Relay 2"
	listening_level = Z_LEVEL_SURFACE_MID
	autolinkers = list("bsm_relay")

/obj/machinery/telecomms/relay/preset/boreas/base_under
	id = "Base Relay 3"
	listening_level = Z_LEVEL_SURFACE_UNDER
	autolinkers = list("bsu_relay")

// The station of course needs relays fluff-wise to connect to ground station. But again, no multi-z so, we need one for each z level.
/*
/obj/machinery/telecomms/relay/preset/underdark
	id = "Mining Underground Relay"
	listening_level = Z_LEVEL_UNDERDARK
	autolinkers = list("ud_relay")
*/
// #### Hub ####
/obj/machinery/telecomms/hub/preset/boreas
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"bsl_relay", "bsm_relay", "bsu_relay", "tmp_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "explorer", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/boreas
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, EXP_FREQ)

/obj/machinery/telecomms/bus/preset_two/boreas
	freq_listening = list(SUP_FREQ, SRV_FREQ, EXP_FREQ)

/obj/machinery/telecomms/server/presets/service/boreas
	freq_listening = list(SRV_FREQ, EXP_FREQ)
	autolinkers = list("service", "explorer")

// Telecommunications Satellite
/area/boreas/surfacebase/tcomms
	name = "\improper Telecomms"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg')

/area/boreas/surfacebase/tcomms/entrance
	name = "\improper Telecomms Teleporter"
	icon_state = "tcomsatentrance"

/area/boreas/surfacebase/tcomms/foyer
	name = "\improper Telecomms Foyer"
	icon_state = "tcomsatfoyer"

/area/boreas/surfacebase/tcomms/storage
	name = "\improper Telecomms Storage"
	icon_state = "tcomsatwest"

/area/boreas/surfacebase/tcomms/computer
	name = "\improper Telecomms Control Room"
	icon_state = "tcomsatcomp"

/area/boreas/surfacebase/tcomms/chamber
	name = "\improper Telecomms Central Compartment"
	icon_state = "tcomsatcham"
	flags = BLUE_SHIELDED

/area/maintenance/substation/tcomms
	name = "\improper Telecomms Substation"

/area/maintenance/station/tcomms
	name = "\improper Telecoms Maintenance"

/datum/map/boreas/default_internal_channels()
	return list(
		num2text(PUB_FREQ) = list(),
		num2text(AI_FREQ)  = list(access_synth),
		num2text(ENT_FREQ) = list(),
		num2text(ERT_FREQ) = list(access_cent_specops),
		num2text(COMM_FREQ)= list(access_heads),
		num2text(ENG_FREQ) = list(access_engine_equip, access_atmospherics),
		num2text(MED_FREQ) = list(access_medical_equip),
		num2text(MED_I_FREQ)=list(access_medical_equip),
		num2text(SEC_FREQ) = list(access_security),
		num2text(SEC_I_FREQ)=list(access_security),
		num2text(SCI_FREQ) = list(access_tox,access_robotics,access_xenobiology),
		num2text(SUP_FREQ) = list(access_cargo),
		num2text(SRV_FREQ) = list(access_janitor, access_hydroponics),
		num2text(EXP_FREQ) = list(access_explorer)
	)

/obj/item/multitool/boreas_buffered
	name = "pre-linked multitool (boreas hub)"
	desc = "This multitool has already been linked to the Boreas telecomms hub and can be used to link multiple machines to the hub, including relays." //cit edit - it's not one use

/obj/item/multitool/boreas_buffered/Initialize()
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/boreas)
