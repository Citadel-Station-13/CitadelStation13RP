GLOBAL_LIST_EMPTY(pai_list)
/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/pai.dmi'
	icon_state = "repairbot"
	density = FALSE
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	desc = "A generic pAI mobile hard-light holographics emitter. It seems to be deactivated."
	// weather_immunities = list("ash")
	health = 500
	maxHealth = 500
	layer = BELOW_MOB_LAYER
	can_pull_size = ITEMSIZE_SMALL
	can_pull_mobs = MOB_PULL_SAME
	mob_size = MOB_SMALL

	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)

	idcard_type = /obj/item/card/id
	/// Alow ID modifications to internal ID
	var/idaccessible = 0

	/// pais don't care about other speeds until movespeed mods are ported
	var/movement_speed = 2

	var/obj/item/instrument/piano_synth/internal_instrument
	// silicon_privileges = PRIVILEGES_PAI

#warn make communicator accessible
	var/obj/item/communicator/integrated/communicator	// Our integrated communicator.

	var/network = "ss13"
	var/obj/machinery/camera/current = null

	var/ram = 100	// Used as currency to purchase different abilities
	var/list/software = list()
	var/userDNA		// The DNA string of our assigned user
	var/obj/item/paicard/card	// The card we inhabit
	var/hacking = FALSE		//Are we hacking a door?

	var/speakStatement = "states"
	var/speakExclamation = "declares"
	var/speakDoubleExclamation = "alarms"
	var/speakQuery = "queries"

	var/obj/item/radio/headset			// The pAI's headset
	var/obj/item/pai_cable/cable		// The cable we produce and use when door or camera jacking

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	var/obj/item/pda/ai/pai/pda = null

	var/secHUD = 0			// Toggles whether the Security HUD is active or not
	var/medHUD = 0			// Toggles whether the Medical  HUD is active or not

	var/datum/data/record/medicalActive1		// Datacore record declarations for record software
	var/datum/data/record/medicalActive2

	var/datum/data/record/securityActive1		// Could probably just combine all these into one
	var/datum/data/record/securityActive2

	var/translator_on = 0 // keeps track of the translator module

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 100, >= 100 means the hack is complete and will be reset upon next check

	var/obj/item/integrated_signaler/signaler // AI's signaller

	var/encryptmod = FALSE
	var/holoform = FALSE
	var/canholo = TRUE
	var/obj/item/card/id/access_card = null
	var/chassis = "repairbot"
	var/dynamic_chassis
	var/dynamic_chassis_sit = FALSE			//whether we're sitting instead of resting spritewise
	var/dynamic_chassis_bellyup = FALSE		//whether we're lying down bellyup
	var/list/possible_chassis			//initialized in initialize.
	var/list/dynamic_chassis_icons		//ditto.
	var/list/chassis_pixel_offsets_x	//stupid dogborgs

	var/emitterhealth = 20
	var/emittermaxhealth = 20
	var/emitterregen = 0.25
	var/emitter_next_use = 0
	var/emitter_emp_cd = 300
	var/emittercd = 50
	var/emitteroverloadcd = 100

	var/radio_short = FALSE
	var/radio_short_cooldown = 3 MINUTES
	var/radio_short_timerid

	// mobility_flags = NONE
	var/brightness_power = 5

	var/icon/custom_holoform_icon

	var/static/list/possible_say_verbs = list(
		"says",
		"chirps",
		"barks",
		"states",
		"beeps",
		"clicks",
		"mewls",
		"poofs"
	)
	var/static/list/possible_exclaim_verbs = list(
		"exclaims",
		"declares",
		"woofs",
		"rings",
		"chirrups",
		"clacks",
		"mrowls",
		"buzzes"
	)
	var/static/list/possible_yell_verbs = list(
		"yells",
		"alarms",
		"screams",
		"screeches"
	)
	var/static/list/possible_ask_verbs = list(
		"asks",
		"inquires",
		"queries",
		"cheeps",
		"questions"
	)

/mob/living/silicon/pai/Destroy()
	QDEL_NULL(internal_instrument)
	if (loc != card)
		card.forceMove(drop_location())
	card.pai = null
	card.cut_overlays()
	card.add_overlay("pai-off")
	GLOB.pai_list -= src
	return ..()

/mob/living/silicon/pai/Initialize()
	var/obj/item/paicard/P = loc
	START_PROCESSING(SSfastprocess, src)
	GLOB.pai_list += src
	make_laws()
	if(!istype(P)) //when manually spawning a pai, we create a card to put it into.
		var/newcardloc = P
		P = new /obj/item/paicard(newcardloc)
		P.setPersonality(src)
	forceMove(P)
	card = P
	signaler = new(src)
	if(!radio)
		radio = new /obj/item/radio/headset/silicon/pai(src)

	communicator = new(src)

	//PDA
	pda = new(src)
	spawn(5)
		pda.ownjob = "pAI Messenger"
		pda.owner = text("[]", src)
		pda.name = pda.owner + " (" + pda.ownjob + ")"

	possible_chassis = typelist(NAMEOF(src, possible_chassis), list("cat" = TRUE, "mouse" = TRUE, "monkey" = TRUE, "corgi" = FALSE,
									"fox" = FALSE, "repairbot" = TRUE, "rabbit" = TRUE, "borgi" = FALSE ,
									"parrot" = FALSE, "bear" = FALSE , "mushroom" = FALSE, "crow" = FALSE ,
									"fairy" = FALSE , "spiderbot" = FALSE))		//assoc value is whether it can be picked up.
	dynamic_chassis_icons = typelist(NAMEOF(src, dynamic_chassis_icons), initialize_dynamic_chassis_icons())
	chassis_pixel_offsets_x = typelist(NAMEOF(src, chassis_pixel_offsets_x), default_chassis_pixel_offsets_x())

	. = ..()

	var/datum/action/innate/pai/software/SW = new
	var/datum/action/innate/pai/shell/AS = new /datum/action/innate/pai/shell
	var/datum/action/innate/pai/chassis/AC = new /datum/action/innate/pai/chassis
	var/datum/action/innate/pai/rest/AR = new /datum/action/innate/pai/rest
	var/datum/action/innate/pai/light/AL = new /datum/action/innate/pai/light
	var/datum/action/innate/custom_holoform/custom_holoform = new /datum/action/innate/custom_holoform

// 	var/datum/action/language_menu/ALM = new

	SW.Grant(src)
	AS.Grant(src)
	AC.Grant(src)
	AR.Grant(src)
	AL.Grant(src)

//	ALM.Grant(src)

	//Default languages without universal translator software
	add_language(LANGUAGE_SOL_COMMON, 1)
	add_language(LANGUAGE_TRADEBAND, 1)
	add_language(LANGUAGE_GUTTER, 1)
	add_language(LANGUAGE_EAL, 1)
	add_language(LANGUAGE_TERMINUS, 1)
	add_language(LANGUAGE_SIGN, 0)

	custom_holoform.Grant(src)
	emitter_next_use = world.time + 10 SECONDS

/mob/living/silicon/pai/deployed/Initialize()
	. = ..()
	fold_out(TRUE)

/mob/living/silicon/pai/ComponentInitialize()
	. = ..()
//	if(possible_chassis[chassis])
//		AddElement(/datum/element/mob_holder, chassis, 'icons/mob/pai_item_head.dmi', 'icons/mob/pai_item_rh.dmi', 'icons/mob/pai_item_lh.dmi', ITEM_SLOT_HEAD)

/mob/living/silicon/pai/proc/process_hack()

	if(cable && cable.machine && istype(cable.machine, /obj/machinery/door) && cable.machine == hackdoor && get_dist(src, hackdoor) <= 1)
		hackprogress = clamp(hackprogress + 4, 0, 100)
	else
		temp = "Door Jack: Connection to airlock has been lost. Hack aborted."
		hackprogress = 0
		hacking = FALSE
		hackdoor = null
		return
	if(screen == "doorjack" && subscreen == 0) // Update our view, if appropriate
		paiInterface()
	if(hackprogress >= 100)
		hackprogress = 0
		var/obj/machinery/door/D = cable.machine
		D.open()
		hacking = FALSE

/mob/living/silicon/pai/make_laws()
	laws = new /datum/ai_laws/pai()
	return TRUE

/mob/living/silicon/pai/Login()
	..()
	usr << browse_rsc('html/paigrid.png')			// Go ahead and cache the interface resources as early as possible
	if(client)
		client.perspective = EYE_PERSPECTIVE
		if(holoform)
			client.eye = src
		else
			client.eye = card

/mob/living/silicon/pai/get_status_tab_items()
	. += ..()
	if(!stat)
		. += text("Emitter Integrity: [emitterhealth * (100/emittermaxhealth)]")
	else
		. += text("Systems nonfunctional")

/mob/living/silicon/pai/restrained(ignore_grab)
	. = FALSE

// See software.dm for Topic()

/mob/living/silicon/pai/canUseTopic(atom/movable/M, be_close=FALSE, no_dextery=FALSE, no_tk=FALSE)
	if(be_close && !in_range(M, src))
		to_chat(src, "<span class='warning'>You are too far away!</span>")
		return FALSE
	return TRUE

/mob/proc/makePAI(delold)
	var/obj/item/paicard/card = new /obj/item/paicard(get_turf(src))
	var/mob/living/silicon/pai/pai = new /mob/living/silicon/pai(card)
	transfer_ckey(pai)
	pai.name = name
	card.setPersonality(pai)
	if(delold)
		qdel(src)

/datum/action/innate/pai
	name = "PAI Action"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	var/mob/living/silicon/pai/P

/datum/action/innate/pai/Trigger()
	if(!ispAI(owner))
		return 0
	P = owner

/datum/action/innate/pai/software
	name = "Software Interface"
	button_icon_state = "pai"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/software/Trigger()
	..()
	P.paiInterface()

/datum/action/innate/pai/shell
	name = "Toggle Holoform"
	button_icon_state = "pai_holoform"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/shell/Trigger()
	..()
	if(P.holoform)
		P.fold_in(FALSE)
	else
		P.fold_out()

/datum/action/innate/pai/chassis
	name = "Holochassis Appearance Composite"
	button_icon_state = "pai_chassis"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/chassis/Trigger()
	..()
	P.choose_chassis()

/datum/action/innate/pai/rest
	name = "Rest"
	button_icon_state = "pai_rest"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/rest/Trigger()
	..()
	P.lay_down()

/datum/action/innate/pai/light
	name = "Toggle Integrated Lights"
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "emp"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/light/Trigger()
	..()
	P.toggle_integrated_light()

/mob/living/silicon/pai/Process_Spacemove(movement_dir = 0)
	. = ..()
	if(!.)
		//add_movespeed_modifier(/datum/movespeed_modifier/pai_spacewalk)
		return TRUE
	//remove_movespeed_modifier(/datum/movespeed_modifier/pai_spacewalk)
	return TRUE

/mob/living/silicon/pai/examine(mob/user)
	. = ..()
	. += "A personal AI in holochassis mode. Its master ID string seems to be [master]."

///mob/living/silicon/pai/PhysicalLife()
/mob/living/silicon/pai/Life()
	. = ..()
	if(stat == DEAD)
		return
	if(cable)
		if(get_dist(src, cable) > 1)
			var/turf/T = get_turf(src.loc)
			T.visible_message("<span class='warning'>[src.cable] rapidly retracts back into its spool.</span>", "<span class='italics'>You hear a click and the sound of wire spooling rapidly.</span>")
			QDEL_NULL(cable)
			playsound(src.loc, 'sound/machines/click.ogg', 50, 1)

	handle_regular_hud_updates()
	handle_vision()
	handle_statuses()

///mob/living/silicon/pai/BiologicalLife()
//	if(!(. = ..()))
//		return
	silent = max(silent - 1, 0)
	if(hacking)
		process_hack()

/mob/living/silicon/pai/updatehealth()
	if(status_flags & GODMODE)
		return
	health = maxHealth - getBruteLoss() - getFireLoss()
	update_stat()

/mob/living/silicon/pai/process()
	emitterhealth = clamp((emitterhealth + emitterregen), -50, emittermaxhealth)

/obj/item/paicard/attackby(obj/item/W, mob/user, params)
	..()
	user.set_machine(src)
	var/encryption_key_stuff = W.tool_behaviour == TOOL_SCREWDRIVER || istype(W, /obj/item/encryptionkey)
	if(!encryption_key_stuff)
		return
	if(pai?.encryptmod)
		pai.radio.attackby(W, user, params)
	else
		to_chat(user, "Encryption Key ports not configured.")

/mob/living/silicon/pai/proc/short_radio()
	if(radio_short_timerid)
		deltimer(radio_short_timerid)
	radio_short = TRUE
	to_chat(src, "<span class='danger'>Your radio shorts out!</span>")
	radio_short_timerid = addtimer(CALLBACK(src, .proc/unshort_radio), radio_short_cooldown, flags = TIMER_STOPPABLE)

/mob/living/silicon/pai/proc/unshort_radio()
	radio_short = FALSE
	to_chat(src, "<span class='danger'>You feel your radio is operational once more.</span>")
	if(radio_short_timerid)
		deltimer(radio_short_timerid)

/mob/living/silicon/pai/proc/initialize_dynamic_chassis_icons()
	. = list()
	var/icon/curr		//for inserts

	//This is a horrible system and I wish I was not as lazy and did something smarter, like just generating a new icon in memory which is probably more efficient.

	//Basic /tg/ cyborgs
	.["Cyborg - Engineering (default)"] = process_holoform_icon_filter(icon('icons/mob/robots.dmi', "engineer"), HOLOFORM_FILTER_PAI, FALSE)
/*
	.["Cyborg - Engineering (loaderborg)"] = process_holoform_icon_filter(icon('modular_citadel/icons/mob/robots.dmi', "loaderborg"), HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Engineering (handyeng)"] = process_holoform_icon_filter(icon('modular_citadel/icons/mob/robots.dmi', "handyeng"), HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Engineering (sleekeng)"] = process_holoform_icon_filter(icon('modular_citadel/icons/mob/robots.dmi', "sleekeng"), HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Engineering (marinaeng)"] = process_holoform_icon_filter(icon('modular_citadel/icons/mob/robots.dmi', "marinaENG"), HOLOFORM_FILTER_PAI, FALSE)
*/
	.["Cyborg - Medical (default)"] = process_holoform_icon_filter(icon('icons/mob/robots.dmi', "medical"), HOLOFORM_FILTER_PAI, FALSE)
/*
	.["Cyborg - Medical (marinamed)"] = process_holoform_icon_filter(icon('modular_citadel/icons/mob/robots.dmi', "marinaMD"), HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Medical (eyebotmed)"] = process_holoform_icon_filter(icon('modular_citadel/icons/mob/robots.dmi', "eyebotmed"), HOLOFORM_FILTER_PAI, FALSE)
*/
	.["Cyborg - Security (default)"] = process_holoform_icon_filter(icon('icons/mob/robots.dmi', "sec"), HOLOFORM_FILTER_PAI, FALSE)
/*
	.["Cyborg - Security (sleeksec)"] = process_holoform_icon_filter(icon('modular_citadel/icons/mob/robots.dmi', "sleeksec"), HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Security (marinasec)"] = process_holoform_icon_filter(icon('modular_citadel/icons/mob/robots.dmi', "marinasec"), HOLOFORM_FILTER_PAI, FALSE)
*/
	.["Cyborg - Clown (default)"] = process_holoform_icon_filter(icon('icons/mob/robots.dmi', "clown"), HOLOFORM_FILTER_PAI, FALSE)

	//Citadel dogborgs
/* All disabled. wanna enable them? Go through and check the icon states, c'ause I can't be arsed to.
	//Engi
	curr = icon('icons/mob/widerobot_vr.dmi', "valeeng")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valeeng-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valeeng-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valeeng-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Engineering (dog - valeeng)"] = curr
	curr = icon('icons/mob/widerobot_vr.dmi', "pupdozer")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "pupdozer-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "pupdozer-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "pupdozer-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Engineering (dog - pupdozer)"] = curr
	//Med
	curr = icon('icons/mob/widerobot_vr.dmi', "medihound")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "medihound-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "medihound-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "medihound-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Medical (dog - medihound)"] = curr
	curr = icon('icons/mob/widerobot_vr.dmi', "medihounddark")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "medihounddark-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "medihounddark-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "medihounddark-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Medical (dog - medihounddark)"] = curr
	curr = icon('icons/mob/widerobot_vr.dmi', "valemed")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valemed-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valemed-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valemed-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Medical (dog - valemed)"] = curr
	//Sec
	curr = icon('icons/mob/widerobot_vr.dmi', "k9")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "k9-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "k9-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "k9-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Security (dog - k9)"] = curr
	curr = icon('icons/mob/widerobot_vr.dmi', "k9dark")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "k9dark-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "k9dark-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "k9dark-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Security (dog - k9dark)"] = curr
	curr = icon('icons/mob/widerobot_vr.dmi', "valesec")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valesec-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valesec-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valesec-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Security (dog - valesec)"] = curr
	//Service
	curr = icon('icons/mob/widerobot_vr.dmi', "valeserv")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valeserv-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valeserv-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valeserv-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Service (dog - valeserv)"] = curr
	curr = icon('icons/mob/widerobot_vr.dmi', "valeservdark")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valeservdark-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valeservdark-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valeservdark-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Service (dog - valeservdark)"] = curr
	//Sci
	curr = icon('icons/mob/widerobot_vr.dmi', "valesci")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valesci-rest"), "rest")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valesci-sit"), "sit")
	curr.Insert(icon('icons/mob/widerobot_vr.dmi', "valesci-bellyup"), "bellyup")
	process_holoform_icon_filter(curr, HOLOFORM_FILTER_PAI, FALSE)
	.["Cyborg - Science (dog - valesci)"] = curr
	//Misc
	.["Cyborg - Misc (dog - blade)"] = process_holoform_icon_filter(icon('icons/mob/widerobot_vr.dmi', "blade"), HOLOFORM_FILTER_PAI, FALSE)
*/

	// Gorillas
	.["Gorilla (standing)"] = process_holoform_icon_filter(icon('icons/mob/gorilla.dmi', "standing"), HOLOFORM_FILTER_PAI, FALSE)
	.["Gorilla (crawling)"] = process_holoform_icon_filter(icon('icons/mob/gorilla.dmi', "crawling"), HOLOFORM_FILTER_PAI, FALSE)

/mob/living/silicon/pai/proc/default_chassis_pixel_offsets_x()
	. = list()
	//Engi
	.["Cyborg - Engineering (dog - valeeng)"] = -16
	.["Cyborg - Engineering (dog - pupdozer)"] = -16
	//Med
	.["Cyborg - Medical (dog - medihound)"] = -16
	.["Cyborg - Medical (dog - medihounddark)"] = -16
	.["Cyborg - Medical (dog - valemed)"] = -16
	//Sec
	.["Cyborg - Security (dog - k9)"] = -16
	.["Cyborg - Security (dog - valesec)"] = -16
	.["Cyborg - Security (dog - k9dark)"] = -16
	//Service
	.["Cyborg - Service (dog - valeserv)"] = -16
	.["Cyborg - Service (dog - valeservdark)"] = -16
	//Sci
	.["Cyborg - Security (dog - valesci)"] = -16
	//Misc
	.["Cyborg - Misc (dog - blade)"] = -16

/mob/living/silicon/pai/verb/suicide()
	set hidden = 1
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(confirm == "Yes")
		var/turf/T = get_turf(src.loc)
		T.visible_message("<span class='notice'>[src] flashes a message across its screen, \"Wiping core files. Please acquire a new personality to continue using pAI device functions.\"</span>", null, \
		 "<span class='notice'>[src] bleeps electronically.</span>")

		suicide_log()

		death(0)
	else
		to_chat(src, "Aborting suicide attempt.")

/mob/living/silicon/pai/verb/allowmodification()
	set name = "Change Access Modifcation Permission"
	set category = "pAI Commands"
	set desc = "Allows people to modify your access or block people from modifying your access."

	if(idaccessible == 0)
		idaccessible = 1
		to_chat(src, "<span class='notice'>You allow access modifications.</span>")

	else
		idaccessible = 0
		to_chat(src, "<span class='notice'>You block access modfications.</span>")

// No binary for pAIs.
/mob/living/silicon/pai/binarycheck()
	return 0

/mob/living/silicon/pai/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/card/id/ID = W.GetID()
	if(ID)
		if (idaccessible == 1)
			switch(alert(user, "Do you wish to add access to [src] or remove access from [src]?",,"Add Access","Remove Access", "Cancel"))
				if("Add Access")
					idcard.access |= ID.access
					to_chat(user, "<span class='notice'>You add the access from the [W] to [src].</span>")
					return
				if("Remove Access")
					idcard.access = list()
					to_chat(user, "<span class='notice'>You remove the access from [src].</span>")
					return
				if("Cancel")
					return
		else if (istype(W, /obj/item/card/id) && idaccessible == 0)
			to_chat(user, "<span class='notice'>[src] is not accepting access modifcations at this time.</span>")
			return

/mob/living/silicon/pai/verb/choose_verb_say()
	set category = "pAI Commands"
	set name = "Choose Say Verb"

	var/choice = input(usr,"What theme would you like to use for your speech verbs?") as null|anything in possible_say_verbs
	if(!choice)
		return
	verb_say = choice

/mob/living/silicon/pai/verb/choose_verb_ask()
	set category = "pAI Commands"
	set name = "Choose Ask Verb"

	var/choice = input(usr,"What theme would you like to use for your speech verbs?") as null|anything in possible_ask_verbs
	if(!choice)
		return
	verb_ask = choice

/mob/living/silicon/pai/verb/choose_verb_yell()
	set category = "pAI Commands"
	set name = "Choose Yell Verb"

	var/choice = input(usr,"What theme would you like to use for your speech verbs?") as null|anything in possible_yell_verbs
	if(!choice)
		return
	verb_yell = choice

/mob/living/silicon/pai/verb/choose_verb_exclaim()
	set category = "pAI Commands"
	set name = "Choose Exclaim Verb"

	var/choice = input(usr,"What theme would you like to use for your speech verbs?") as null|anything in possible_exclaim_verbs
	if(!choice)
		return
	verb_exclaim = choice
