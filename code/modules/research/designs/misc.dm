// Everything that didn't fit elsewhere

/datum/design/item/general/AssembleDesignName()
	..()
	name = "General purpose design ([item_name])"

/datum/design/item/general/communicator
	name = "Communicator"
	id = "communicator"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	materials = list(/datum/material/steel = 500, "glass" = 500)
	build_path = /obj/item/communicator
	sort_string = "TAAAA"

datum/design/item/general/laserpointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	id = "laser_pointer"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(/datum/material/steel = 100, "glass" = 50)
	build_path = /obj/item/laser_pointer
	sort_string = "TAABA"

/datum/design/item/general/translator
	name = "handheld translator"
	id = "translator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(/datum/material/steel = 3000, "glass" = 3000)
	build_path = /obj/item/universal_translator
	sort_string = "TAACA"

/datum/design/item/general/ear_translator
	name = "earpiece translator"
	id = "ear_translator"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)	//It's been hella miniaturized.
	materials = list(/datum/material/steel = 2000, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/universal_translator/ear
	sort_string = "TAACB"

/datum/design/item/general/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(/datum/material/steel = 1500, "silver" = 150, "glass" = 3000)
	build_path = /obj/item/lightreplacer
	sort_string = "TAADA"

/datum/design/item/illegal/AssembleDesignName()
	..()
	name = "Nonstandard design ([item_name])"

/datum/design/item/illegal/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(/datum/material/steel = 300, "glass" = 300)
	build_path = /obj/item/encryptionkey/binary
	sort_string = "TBAAA"

/datum/design/item/illegal/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(/datum/material/steel = 500)
	build_path = /obj/item/storage/box/syndie_kit/chameleon
	sort_string = "TBAAB"
