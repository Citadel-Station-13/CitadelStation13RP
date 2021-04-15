// ### Preset machines  ###


// #### Relays ####
// Telecomms doesn't know about connected z-levels, so we need relays even for the other surface levels.
/obj/machinery/telecomms/relay/preset/triumph/deck_one
	id = "Deck Relay 1"
	listening_level = Z_LEVEL_DECK_ONE
	autolinkers = list("tb1_relay")

/obj/machinery/telecomms/relay/preset/centcom/triumph/deck_one
	listening_level = Z_LEVEL_DECK_ONE

/obj/machinery/telecomms/relay/preset/triumph/deck_two
	id = "Deck Relay 2"
	listening_level = Z_LEVEL_DECK_TWO
	autolinkers = list("tb2_relay")

/obj/machinery/telecomms/relay/preset/centcom/triumph/deck_two
	listening_level = Z_LEVEL_DECK_TWO

/obj/machinery/telecomms/relay/preset/triumph/deck_three
	id = "Deck Relay 3"
	listening_level = Z_LEVEL_DECK_THREE
	autolinkers = list("tb3_relay")

/obj/machinery/telecomms/relay/preset/centcom/triumph/deck_three
	listening_level = Z_LEVEL_DECK_THREE

/obj/machinery/telecomms/relay/preset/triumph/deck_four
	id = "Deck Relay 4"
	listening_level = Z_LEVEL_DECK_FOUR
	autolinkers = list("tb4_relay")

/obj/machinery/telecomms/relay/preset/centcom/triumph/deck_four
	listening_level = Z_LEVEL_DECK_FOUR

// #### Hub ####
/obj/machinery/telecomms/hub/preset/triumph
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub",
		"tb1_relay", "tb2_relay", "tb3_relay", "tb4_relay","c_relay", "m_relay", "r_relay", "sci_o_relay", "ud_relay",
		"science", "medical", "supply", "service", "common", "command", "engineering", "security", "explorer", "unused",
		"hb_relay", "receiverA", "broadcasterA"
	)

/obj/machinery/telecomms/receiver/preset_right/triumph
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, EXP_FREQ)

/obj/machinery/telecomms/bus/preset_two/triumph
	freq_listening = list(SUP_FREQ, SRV_FREQ, EXP_FREQ)

/obj/machinery/telecomms/server/presets/service/triumph
	freq_listening = list(SRV_FREQ, EXP_FREQ)
	autolinkers = list("service", "explorer")

// Telecommunications Satellite
/area/tether/surfacebase/tcomms
	name = "\improper Telecomms"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg')

/area/tether/surfacebase/tcomms/entrance
	name = "\improper Telecomms Teleporter"
	icon_state = "tcomsatentrance"

/area/tether/surfacebase/tcomms/foyer
	name = "\improper Telecomms Foyer"
	icon_state = "tcomsatfoyer"

/area/tether/surfacebase/tcomms/storage
	name = "\improper Telecomms Storage"
	icon_state = "tcomsatwest"

/area/tether/surfacebase/tcomms/computer
	name = "\improper Telecomms Control Room"
	icon_state = "tcomsatcomp"

/area/tether/surfacebase/tcomms/chamber
	name = "\improper Telecomms Central Compartment"
	icon_state = "tcomsatcham"

/area/maintenance/substation/tcomms
	name = "\improper Telecomms Substation"

/area/maintenance/station/tcomms
	name = "\improper Telecoms Maintenance"

/datum/map/tether/default_internal_channels()
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

/obj/item/multitool/triumph_buffered
	name = "pre-linked multitool (tether hub)"
	desc = "This multitool has already been linked to the Tether telecomms hub and can be used to configure one (1) relay."

/obj/item/multitool/triumph_buffered/Initialize(mapload)
	. = ..()
	buffer = locate(/obj/machinery/telecomms/hub/preset/triumph)
