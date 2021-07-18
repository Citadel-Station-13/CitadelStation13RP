/obj/item/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys"
	var/radio_desc = ""
	icon_state = "headset"
	item_state = null //To remove the radio's state
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away
	slot_flags = SLOT_EARS
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/ears.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/ears.dmi'
		)

	var/translate_binary = 0
	var/translate_hive = 0
	var/obj/item/encryptionkey/keyslot1 = null
	var/obj/item/encryptionkey/keyslot2 = null
	var/ks1type = null
	var/ks2type = null

	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

/obj/item/radio/headset/Initialize(mapload)
	. = ..()
	internal_channels.Cut()
	if(ks1type)
		keyslot1 = new ks1type(src)
	if(ks2type)
		keyslot2 = new ks2type(src)
	recalculateChannels(1)

/obj/item/radio/headset/Destroy()
	qdel(keyslot1)
	qdel(keyslot2)
	keyslot1 = null
	keyslot2 = null
	return ..()

/obj/item/radio/headset/list_channels(var/mob/user)
	return list_secure_channels()

/obj/item/radio/headset/examine(mob/user)
	. = ..()
	if(!radio_desc)
		return

	. += "The following channels are available:"
	. += radio_desc

/obj/item/radio/headset/handle_message_mode(mob/living/M as mob, message, channel)
	if (channel == "special")
		if (translate_binary)
			var/datum/language/binary = GLOB.all_languages["Robot Talk"]
			binary.broadcast(M, message)
		if (translate_hive)
			var/datum/language/hivemind = GLOB.all_languages["Hivemind"]
			hivemind.broadcast(M, message)
		return null

	return ..()

/obj/item/radio/headset/receive_range(freq, level, aiOverride = 0)
	if (aiOverride)
		return ..(freq, level)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.l_ear == src || H.r_ear == src)
			return ..(freq, level)
	return -1

/obj/item/radio/headset/get_worn_icon_state(var/slot_name)
	var/append = ""
	if(icon_override)
		switch(slot_name)
			if(slot_l_ear_str)
				append = "_l"
			if(slot_r_ear_str)
				append = "_r"

	return "[..()][append]"

/obj/item/radio/headset/syndicate
	origin_tech = list(TECH_ILLEGAL = 3)
	syndie = 1
	ks1type = /obj/item/encryptionkey/syndicate

/obj/item/radio/headset/syndicate/alt
	icon_state = "syndie_headset"
	item_state = "headset"
	origin_tech = list(TECH_ILLEGAL = 3)
	syndie = 1
	ks1type = /obj/item/encryptionkey/syndicate

/obj/item/radio/headset/raider
	origin_tech = list(TECH_ILLEGAL = 2)
	syndie = 1
	ks1type = /obj/item/encryptionkey/raider

/obj/item/radio/headset/raider/Initialize(mapload)
	. = ..()
	set_frequency(RAID_FREQ)

/obj/item/radio/headset/trader
	name = "trade headset"
	origin_tech = list(TECH_ILLEGAL = 2)
	syndie = 1
	adhoc_fallback = TRUE
	ks1type = /obj/item/encryptionkey/trader

/obj/item/radio/headset/trader/Initialize(mapload)
	. = ..()
	set_frequency(TRADE_FREQ)

/obj/item/radio/headset/binary
	origin_tech = list(TECH_ILLEGAL = 3)
	ks1type = /obj/item/encryptionkey/binary

/obj/item/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset"
	ks2type = /obj/item/encryptionkey/headset_sec

/obj/item/radio/headset/headset_sec/alt
	name = "security bowman headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset_alt"
	ear_protection = 1
	ks2type = /obj/item/encryptionkey/headset_sec

/obj/item/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to chat like girls."
	icon_state = "eng_headset"
	ks2type = /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_eng/alt
	name = "engineering bowman headset"
	desc = "When the engineers wish to chat like girls."
	icon_state = "eng_headset_alt"
	ks2type = /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists who cannot decide between departments."
	icon_state = "rob_headset"
	ks2type = /obj/item/encryptionkey/headset_rob

/obj/item/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon_state = "med_headset"
	ks2type = /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_med/alt
	name = "medical bowman headset"
	desc = "A headset for the trained staff of the medbay."
	icon_state = "med_headset_alt"
	ks2type = /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/headset_sci

/obj/item/radio/headset/headset_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science."
	icon_state = "med_headset"
	ks2type = /obj/item/encryptionkey/headset_medsci

/obj/item/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commanding channel."
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/headset_com

/obj/item/radio/headset/headset_adj //Citadel Add: Secretary headset with service and command.
	name = "secretary radio headset"
	desc = "A headset for those who serve command."
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/headset_adj

/obj/item/radio/headset/headset_com/alt
	name = "command bowman headset"
	desc = "A headset with a commanding channel."
	icon_state = "com_headset_alt"
	ear_protection = 1
	ks2type = /obj/item/encryptionkey/headset_com


/obj/item/radio/headset/heads/captain
	name = "Facility Director's headset"
	desc = "The headset of the boss."
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/heads/captain/alt
	name = "Facility Director's bowman headset"
	desc = "The headset of the boss."
	icon_state = "com_headset_alt"
	ear_protection = 1
	ks2type = /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/heads/captain/sfr
	name = "SFR headset"
	desc = "A headset belonging to a Sif Free Radio DJ. SFR, best tunes in the wilderness."
	icon_state = "com_headset_alt"
	ks2type = /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/heads/ai_integrated //No need to care about icons, it should be hidden inside the AI anyway.
	name = "\improper AI subspace transceiver"
	desc = "Integrated AI radio transceiver."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	ks2type = /obj/item/encryptionkey/heads/ai_integrated
	var/myAi = null    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via intellicard menu.

/obj/item/radio/headset/heads/ai_integrated/receive_range(freq, level)
	if (disabledAi)
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/radio/headset/heads/rd
	name = "research director's headset"
	desc = "Headset of the researching God."
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/heads/rd

/obj/item/radio/headset/heads/rd/alt
	name = "research director's bowman headset"
	desc = "Headset of the researching God."
	icon_state = "com_headset_alt"
	ear_protection = 1
	ks2type = /obj/item/encryptionkey/heads/rd

/obj/item/radio/headset/heads/hos
	name = "head of security's headset"
	desc = "The headset of the man who protects your worthless lifes."
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/heads/hos/alt
	name = "head of security's bowman headset"
	desc = "The headset of the man who protects your worthless lifes."
	icon_state = "com_headset_alt"
	ear_protection = 1
	ks2type = /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/heads/ce
	name = "chief engineer's headset"
	desc = "The headset of the guy who is in charge of morons"
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/heads/ce

/obj/item/radio/headset/heads/ce/alt
	name = "chief engineer's bowman headset"
	desc = "The headset of the guy who is in charge of morons"
	icon_state = "com_headset_alt"
	ear_protection = 1
	ks2type = /obj/item/encryptionkey/heads/ce

/obj/item/radio/headset/heads/cmo
	name = "chief medical officer's headset"
	desc = "The headset of the highly trained medical chief."
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/heads/cmo

/obj/item/radio/headset/heads/cmo/alt
	name = "chief medical officer's bowman headset"
	desc = "The headset of the highly trained medical chief."
	icon_state = "com_headset_alt"
	ear_protection = 1
	ks2type = /obj/item/encryptionkey/heads/cmo

/obj/item/radio/headset/heads/hop
	name = "head of personnel's headset"
	desc = "The headset of the guy who will one day be Facility Director."
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/heads/hop

/obj/item/radio/headset/heads/hop/alt
	name = "head of personnel's bowman headset"
	desc = "The headset of the guy who will one day be Facility Director."
	icon_state = "com_headset_alt"
	ear_protection = 1
	ks2type = /obj/item/encryptionkey/heads/hop

/obj/item/radio/headset/headset_mine
	name = "mining radio headset"
	desc = "Headset used by miners. Has inbuilt short-band radio for when comms are down."
	icon_state = "mine_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the QM and his slaves."
	icon_state = "cargo_headset"
	ks2type = /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_cargo/alt
	name = "supply bowman headset"
	desc = "A bowman headset used by the QM and his slaves."
	icon_state = "cargo_headset_alt"
	ks2type = /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping the station full, happy and clean."
	icon_state = "srv_headset"
	ks2type = /obj/item/encryptionkey/headset_service

/obj/item/radio/headset/ert
	name = "emergency response team radio headset"
	desc = "The headset of the boss's boss."
	icon_state = "com_headset"
	centComm = 1
//	freerange = 1
	ks2type = /obj/item/encryptionkey/ert

/obj/item/radio/headset/ert/alt
	name = "emergency response team bowman headset"
	desc = "The headset of the boss's boss."
	icon_state = "com_headset_alt"
	ear_protection = 1
//	freerange = 1
	ks2type = /obj/item/encryptionkey/ert

/obj/item/radio/headset/omni		//Only for the admin intercoms
	ks2type = /obj/item/encryptionkey/omni

/obj/item/radio/headset/ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."
	icon_state = "com_headset"
	ks2type = /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/mmi_radio
	name = "brain-integrated radio"
	desc = "MMIs and synthetic brains are often equipped with these."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	var/mmiowner = null
	var/radio_enabled = 1

/obj/item/radio/headset/mmi_radio/receive_range(freq, level)
	if (!radio_enabled || istype(src.loc.loc, /mob/living/silicon) || istype(src.loc.loc, /obj/item/organ/internal))
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/radio/headset/attackby(obj/item/W as obj, mob/user as mob)
//	..()
	user.set_machine(src)
	if(!(W.is_screwdriver() || istype(W, /obj/item/encryptionkey)))
		return

	if(W.is_screwdriver())
		if(keyslot1 || keyslot2)


			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null


			if(keyslot1)
				var/turf/T = get_turf(user)
				if(T)
					keyslot1.loc = T
					keyslot1 = null



			if(keyslot2)
				var/turf/T = get_turf(user)
				if(T)
					keyslot2.loc = T
					keyslot2 = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption keys in the headset!")
			playsound(src, W.usesound, 50, 1)

		else
			to_chat(user, "This headset doesn't have any encryption keys!  How useless...")

	if(istype(W, /obj/item/encryptionkey/))
		if(keyslot1 && keyslot2)
			to_chat(user, "The headset can't hold another key!")
			return

		if(!keyslot1)
			user.drop_item()
			W.loc = src
			keyslot1 = W

		else
			user.drop_item()
			W.loc = src
			keyslot2 = W


		recalculateChannels()

	return


/obj/item/radio/headset/proc/recalculateChannels(var/setDescription = 0)
	src.channels = list()
	src.translate_binary = 0
	src.translate_hive = 0
	src.syndie = 0

	if(keyslot1)
		for(var/ch_name in keyslot1.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] = keyslot1.channels[ch_name]

		if(keyslot1.translate_binary)
			src.translate_binary = 1

		if(keyslot1.translate_hive)
			src.translate_hive = 1

		if(keyslot1.syndie)
			src.syndie = 1

	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] = keyslot2.channels[ch_name]

		if(keyslot2.translate_binary)
			src.translate_binary = 1

		if(keyslot2.translate_hive)
			src.translate_hive = 1

		if(keyslot2.syndie)
			src.syndie = 1


	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	if(setDescription)
		setupRadioDescription()

/obj/item/radio/headset/proc/setupRadioDescription()
	var/radio_text = ""
	for(var/i = 1 to channels.len)
		var/channel = channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "[key] - [channel]"
		if(i != channels.len)
			radio_text += ", "

	radio_desc = radio_text

//Headset _vr port
/obj/item/radio/headset/centcom
	name = "centcom radio headset"
	desc = "The headset of the boss's boss."
	icon_state = "cent_headset"
	item_state = "headset"
	centComm = 1
	ks2type = /obj/item/encryptionkey/ert

/obj/item/radio/headset/centcom/alt
	name = "centcom bowman headset"
	icon_state = "com_headset_alt"
	ear_protection = 1

/obj/item/radio/headset/nanotrasen
	name = "\improper NT radio headset"
	desc = "The headset of a Nanotrasen corporate employee."
	icon_state = "nt_headset"
	centComm = 1
	ks2type = /obj/item/encryptionkey/ert

/obj/item/radio/headset
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/ears.dmi',
						SPECIES_WEREBEAST = 'icons/mob/species/werebeast/ears.dmi',
						SPECIES_VOX = 'icons/mob/species/vox/ears.dmi')

/obj/item/radio/headset/mob_headset	//Adminbus headset for simplemob shenanigans.
	name = "nonhuman radio implant"
	desc = "An updated, modular intercom that requires no hands to operate. Takes encryption keys"

/obj/item/radio/headset/mob_headset/receive_range(freq, level)
		return ..(freq, level)


/obj/item/radio/headset/mob_headset/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/state = interactive_state)
	ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430, state = interactive_state)
	..()

/obj/item/radio/headset/mob_headset/afterattack(var/atom/movable/target, mob/living/user, proximity)
	if(!proximity)
		return
	if(istype(target,/mob/living/simple_mob))
		var/mob/living/simple_mob/M = target
		if(!M.mob_radio)
			forceMove(M)
			M.mob_radio = src
			return
		if(M.mob_radio)
			M.mob_radio.forceMove(M.loc)
			M.mob_radio = null
			return
	..()

//Headsets from the Southern Cross files.
/obj/item/radio/headset/pilot
	name = "pilot's headset"
	desc = "A headset used by pilots, has access to supply and explorer channels."
	icon_state = "pilot_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/encryptionkey/pilot

/obj/item/radio/headset/pilot/alt
	name = "pilot's bowman headset"
	desc = "A bowman headset used by pilots, has access to supply and explorer channels."
	icon_state = "pilot_headset_alt"

/obj/item/radio/headset/explorer
	name = "explorer's headset"
	desc = "Headset used by explorers for exploring. Access to the explorer channel."
	icon_state = "exp_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/encryptionkey/explorer

/obj/item/radio/headset/explorer/alt
	name = "explorer's bowman headset"
	desc = "Bowman headset used by explorers for exploring. Access to the explorer channel."
	icon_state = "exp_headset_alt"

/obj/item/radio/headset/sar
	name = "sar radio headset"
	desc = "A headset for search and rescue."
	icon_state = "sar_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/encryptionkey/sar

/obj/item/radio/headset/sar/alt
	name = "sar radio bowman headset"
	desc = "A bowman headset for search and rescue."
	icon_state = "sar_headset_alt"

/obj/item/radio/headset/pathfinder
	name = "pathfinder's headset"
	desc = "Headset used by Pathfinders for coordinating and executing expeditions."
	icon_state = "exp_headset_path"
	adhoc_fallback = TRUE
	ks2type = /obj/item/encryptionkey/pathfinder

/obj/item/radio/headset/pathfinder/alt
	name = "pathfinder's bowman headset"
	desc = "Headset used by Pathfinders for coordinating and executing expeditions."
	icon_state = "exp_headset_path_alt"
	ear_protection = 1

//Headset SC _vr files
/obj/item/radio/headset/volunteer
	name = "volunteer's headset"
	desc = "A headset used by volunteers to expedition teams, has access to the exploration channel."
	icon_state = "pilot_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/encryptionkey/pilot

/obj/item/radio/headset/talon
	name = "talon headset"
	desc = "A headset for communication between the crew of the ITV Talon."
	adhoc_fallback = TRUE
	icon_state = "pilot_headset"
	ks2type = /obj/item/encryptionkey/talon
