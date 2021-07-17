// RCON REMOTE CONTROL CONSOLE
//
// Last Change 15.07.2021 by LordME
//
// Allows remote operation of electrical systems on station (SMESs and Breaker Boxes)

/obj/machinery/computer/rcon
	name = "\improper RCON console"
	desc = "Console used to remotely control machinery on the station."
	icon_keyboard = "power_key"
	icon_screen = "ai_fixer" //VOREStation Edit
	light_color = "#a97faa"
	circuit = /obj/item/circuitboard/rcon_console
	req_one_access = list(access_engine)
	var/current_tag = null
	var/datum/tgui_module/rcon/rcon

/obj/machinery/computer/rcon/Initialize(mapload)
	. = ..()
	rcon = new(src)

/obj/machinery/computer/rcon/Destroy()
	QDEL_NULL(rcon)
	return ..()

// Proc: attack_hand()
// Parameters: 1 (user - Person which clicked this computer)
// Description: Opens UI of this machine.
/obj/machinery/computer/rcon/attack_hand(var/mob/user as mob)
	..()
	ui_interact(user)

//Proc: ui_interact()
//Parameters: 2 (usual tgUI parameters)
//Description: Opens the UI for the RCON console, found in rcon.dm
/obj/machinery/computer/rcon/ui_interact(mob/user, datum/tgui/ui)
	rcon.ui_interact(user, ui)

/obj/machinery/computer/rcon/update_icon()
	..()
	if(!(stat & (NOPOWER|BROKEN)))
		overlays += image(icon, "ai-fixer-empty", overlay_layer) //VOREStation Edit
