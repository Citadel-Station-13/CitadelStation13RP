/***********************************************************************************/
//Datum Variable Assignments to Reduce Redundant Code
/datum/gear/restricted          //BYOND refuses to stop shitting a brick and throwing warnings (even though it STILL WORKS!) if all variables are initialized with a null, so the captain gets a rubber ducky.
	display_name = "Captain's Companion"
	path = /obj/item/bikehorn/rubberducky
	slot = null                                   //At least you work as null.
	allowed_roles = list("Facility Director")     //This technically also works as null, but we're supposed to be role restricted so it's the captain's exclusive, special ducky.
	sort_category = "Role Restricted"

//*Single Departments
//Security
/datum/gear/restricted/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective", "Talon Guard")

/datum/gear/restricted/security/eyes
	slot = slot_glasses

/datum/gear/restricted/security/head
	slot = slot_head

/datum/gear/restricted/security/back
	slot = slot_back

/datum/gear/restricted/security/uniform
	slot = slot_w_uniform

/datum/gear/restricted/security/suit
	slot = slot_wear_suit

/datum/gear/restricted/security/shoes
	slot = slot_shoes

/datum/gear/restricted/security/accessory
	slot = slot_tie

//Medical
/datum/gear/restricted/medical
	allowed_roles = list("Medical Doctor", "Chief Medical Officer", "Chemist", "Paramedic", "Geneticist", "Psychiatrist", "Field Medic", "Talon Doctor")

/datum/gear/restricted/medical/eyes
	slot = slot_glasses

/datum/gear/restricted/medical/head
	slot = slot_head

/datum/gear/restricted/medical/back
	slot = slot_back

/datum/gear/restricted/medical/uniform
	slot = slot_w_uniform

/datum/gear/restricted/medical/suit
	slot = slot_wear_suit

/datum/gear/restricted/medical/shoes
	slot = slot_shoes

/datum/gear/restricted/medical/accessory
	slot = slot_tie

//Engineering
/datum/gear/restricted/engineering
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician", "Talon Engineer")

/datum/gear/restricted/engineering/eyes
	slot = slot_glasses

/datum/gear/restricted/engineering/head
	slot = slot_head

/datum/gear/restricted/engineering/back
	slot = slot_back

/datum/gear/restricted/engineering/uniform
	slot = slot_w_uniform

/datum/gear/restricted/engineering/suit
	slot = slot_wear_suit

/datum/gear/restricted/engineering/shoes
	slot = slot_shoes

/datum/gear/restricted/engineering/accessory
	slot = slot_tie

//Command
/datum/gear/restricted/command
	allowed_roles = list("Facility Director", "Head of Personnel", "Chief Medical Officer", "Head of Security", "Research Director", "Chief Engineer", "Command Secretary", "Talon Captain")

/datum/gear/restricted/command/eyes
	slot = slot_glasses

/datum/gear/restricted/command/head
	slot = slot_head

/datum/gear/restricted/command/uniform
	slot = slot_w_uniform

/datum/gear/restricted/command/suit
	slot = slot_wear_suit

/datum/gear/restricted/command/shoes
	slot = slot_shoes

/datum/gear/restricted/command/accessory
	slot = slot_tie

//Science
/datum/gear/restricted/science
	allowed_roles = list("Research Director", "Scientist", "Xenobiologist", "Roboticist", "Explorer", "Pathfinder")

/datum/gear/restricted/science/eyes
	slot = slot_glasses

/datum/gear/restricted/science/head
	slot = slot_head

/datum/gear/restricted/science/back
	slot = slot_back

/datum/gear/restricted/science/uniform
	slot = slot_w_uniform

/datum/gear/restricted/science/suit
	slot = slot_wear_suit

/datum/gear/restricted/science/shoes
	slot = slot_shoes

/datum/gear/restricted/science/accessory
	slot = slot_tie

//Supply
/datum/gear/restricted/supply
	allowed_roles = list("Shaft Miner", "Cargo Technician", "Quartermaster")

/datum/gear/restricted/supply/eyes
	slot = slot_glasses

/datum/gear/restricted/supply/uniform
	slot = slot_w_uniform

/datum/gear/restricted/supply/suit
	slot = slot_wear_suit

/datum/gear/restricted/supply/shoes
	slot = slot_shoes

/datum/gear/restricted/supply/accessory
	slot = slot_tie

//Service
/datum/gear/restricted/service
	allowed_roles = list("Head of Personnel", "Bartender", "Botanist", "Janitor", "Chef", "Librarian", "Chaplain")

/datum/gear/restricted/service/accessory
	slot = slot_tie

/datum/gear/restricted/service/suit
	slot = slot_wear_suit



//Misc.
/datum/gear/restricted/misc
	allowed_roles = null

/datum/gear/restricted/misc/head
	slot = slot_head

/datum/gear/restricted/misc/uniform
	slot = slot_w_uniform

/datum/gear/restricted/misc/suit
	slot = slot_wear_suit

/datum/gear/restricted/misc/shoes
	slot = slot_shoes

/datum/gear/restricted/misc/accessory
	slot = slot_tie

//*Multi-Department Combinations (Aka Multi-Department Drifting)
//Security + Command
/datum/gear/restricted/sec_com
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective", "Facility Director", "Head of Personnel", "Internal Affairs Agent")

/datum/gear/restricted/sec_com/eyes
	slot = slot_glasses


//Engineering + Science + Supply
/datum/gear/restricted/eng_sci_supply
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician", "Scientist", "Xenobiologist",  "Roboticist", "Explorer", "Pathfinder", "Research Director", "Shaft Miner", "Cargo Technician", "Quartermaster")

/datum/gear/restricted/eng_sci_supply/eyes
	slot = slot_glasses


//Medical + Science
/datum/gear/restricted/med_sci
	allowed_roles = list("Research Director", "Scientist", "Xenobiologist", "Roboticist", "Explorer", "Pathfinder", "Medical Doctor", "Chief Medical Officer", "Chemist", "Paramedic", "Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/restricted/med_sci/head
	slot = slot_head

/datum/gear/restricted/med_sci/suit
	slot = slot_wear_suit
/***********************************************************************************/
//**Single-Department Items
//*Security
//Eyes
/datum/gear/restricted/security/eyes/hud
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security

/datum/gear/restricted/security/eyes/secpatch
	display_name = "Security HUD - Eyepatch"
	path = /obj/item/clothing/glasses/hud/security/eyepatch

/datum/gear/restricted/security/eyes/prescriptionsec
	display_name = "Security HUD - Prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription

/datum/gear/restricted/security/eyes/sunglasshud
	display_name = "Security HUD - Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/sechud

/datum/gear/restricted/security/eyes/aviator
	display_name = "Security HUD - Aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator

/datum/gear/restricted/security/eyes/aviator/prescription
	display_name = "Security HUD - Aviators, Prescription"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription

/datum/gear/restricted/security/eyes/arglasses_sec
	display_name = "Security AR-S Glasses"
	path = /obj/item/clothing/glasses/omnihud/sec

//Head
/datum/gear/restricted/security/head/beret
	display_name = "Security Beret - Red"
	path = /obj/item/clothing/head/beret/sec

/datum/gear/restricted/security/head/beret/naval
	display_name = "Security Beret - Naval"
	path = /obj/item/clothing/head/beret/sec/navy/officer

/datum/gear/restricted/security/head/beret/naval/warden
	display_name = "Security Warden Beret - Naval"
	path = /obj/item/clothing/head/beret/sec/navy/warden
	allowed_roles = list("Warden")

/datum/gear/restricted/security/head/beret/naval/hos
	display_name = "Security Head of Security Beret - Naval"
	path = /obj/item/clothing/head/beret/sec/navy/hos
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/head/beret/corporate
	display_name = "Security Beret - Corporate"
	path = /obj/item/clothing/head/beret/sec/corporate/officer

/datum/gear/restricted/security/head/beret/corporate/warden
	display_name = "Security Warden Beret - Corporate"
	path = /obj/item/clothing/head/beret/sec/corporate/warden
	allowed_roles = list("Warden")

/datum/gear/restricted/security/head/beret/corporate/hos
	display_name = "Security Head of Security Beret - Corporate"
	path = /obj/item/clothing/head/beret/sec/corporate/hos
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/head/cap
	display_name = "Security Cap"
	path = /obj/item/clothing/head/soft/sec

/datum/gear/restricted/security/head/cap/corporate
	display_name = "Security Cap - Corporate Security"
	path = /obj/item/clothing/head/soft/sec/corp

/datum/gear/restricted/security/head/cap/operations
	display_name = "Security Cap - Security Operations"
	path = /obj/item/clothing/head/operations/security

//Uniform
/datum/gear/restricted/security/uniform/skirt
	display_name = "Security Skirt"
	path = /obj/item/clothing/under/rank/security/skirt

/datum/gear/restricted/security/uniform/skirt/warden
	display_name = "Warden Skirt"
	path = /obj/item/clothing/under/rank/warden/skirt
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/skirt/hos
	display_name = "Head of Security Skirt"
	path = /obj/item/clothing/under/rank/head_of_security/skirt
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/skirt/detective
	display_name = "Detective Suit - Skirt"
	path = /obj/item/clothing/under/det/skirt
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/corporate
	display_name = "Security Uniform - Corporate"
	path = /obj/item/clothing/under/rank/security/corp

/datum/gear/restricted/security/uniform/corporate/detective
	display_name = "Detective Uniform - Corporate"
	path = /obj/item/clothing/under/det/corporate
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/corporate/warden //before this was changed it was called the corpwarsuit. shame there's no full borg in a hard rock cafe shirt.
	display_name = "Warden Uniform - Corporate"
	path = /obj/item/clothing/under/rank/warden/corp
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/corporate/hos
	display_name = "Head of Security Uniform - Corporate"
	path = /obj/item/clothing/under/rank/head_of_security/corp
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/navyblue
	display_name = "Security Uniform - Navy Blue"
	path = /obj/item/clothing/under/rank/security/navyblue

/datum/gear/restricted/security/uniform/navyblue/warden
	display_name = "Warden Uniform - Navy Blue"
	path = /obj/item/clothing/under/rank/warden/navyblue
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/navyblue/hos
	display_name = "Head of Security Uniform - Navy Blue"
	path = /obj/item/clothing/under/rank/head_of_security/navyblue
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/turtleneck
	display_name = "Security Turtleneck"
	path = /obj/item/clothing/under/rank/security/turtleneck

/datum/gear/restricted/security/uniform/turtleneck/alt
	display_name = "Security Turtleneck - Alternative"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/security

/datum/gear/restricted/security/uniform/bodysuit
	display_name = "Security Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitsec

/datum/gear/restricted/security/uniform/bodysuit/command
	display_name = "Security Command Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitseccom
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/coveralls
	display_name = "Security Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/security

/datum/gear/restricted/security/uniform/fatigues
	display_name = "Security Uniform - Fatigues" //You marine larper.
	path = /obj/item/clothing/under/solgov/utility/marine/security


//Back
/datum/gear/restricted/security/back/dufflebag
	display_name = "Security - Dufflebag"
	path = /obj/item/storage/backpack/dufflebag/sec
	cost = 2

//Suit
/datum/gear/restricted/security/suit/forensics
	display_name = "Detective Forensics - Red"
	path = /obj/item/clothing/suit/storage/forensics/red
	allowed_roles = list("Detective")

/datum/gear/restricted/security/suit/forensics/blue
	display_name = "Detective Forensics - Blue"
	path = /obj/item/clothing/suit/storage/forensics/blue
	allowed_roles = list("Detective")

/datum/gear/restricted/security/suit/forensics/long_red
	display_name = "Detective Forensics Long - Red"
	path = /obj/item/clothing/suit/storage/forensics/red/long
	allowed_roles = list("Detective")

/datum/gear/restricted/security/suit/forensics/long_blue
	display_name = "Detective Forensics Long - Blue"
	path = /obj/item/clothing/suit/storage/forensics/blue/long
	allowed_roles = list("Detective")

/datum/gear/restricted/security/suit/wintercoat
	display_name = "Security Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security

/datum/gear/restricted/security/suit/operations_coat
	display_name = "Security Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat

/datum/gear/restricted/security/suit/snowsuit
	display_name = "Security Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/security

/datum/gear/restricted/security/suit/department_jacket
	display_name = "Security Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket

//Depite being declared as an accessory, it is also equippable in the suit slot, and the sprite is so bulky that it "clips" through most suit slot items. Therefore, all loadout cloaks will default to the suit slot.
/datum/gear/restricted/security/suit/cloak
	display_name = "Security Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/security

/datum/gear/restricted/security/suit/cloak/hos
	display_name = "Head of Security Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hos
	allowed_roles = list("Head of Security")

//Depite being declared as an accessory, it is also equippable in the suit slot, and the sprite is so bulky that it "clips" through most suit slot items. Therefore, all loadout ponchos will default to the suit slot.
/datum/gear/restricted/security/suit/poncho
	display_name = "Security Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/security


//Shoes
/datum/gear/restricted/security/shoes/winterboots
	display_name = "Security - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/security


//*Medical
//Eyes
/datum/gear/restricted/medical/eyes/hud
	display_name = "Medical HUD"
	path = /obj/item/clothing/glasses/hud/health

/datum/gear/restricted/medical/eyes/eyepatch
	display_name = "Medical HUD Eyepatch"
	path = /obj/item/clothing/glasses/hud/health/eyepatch

/datum/gear/restricted/medical/eyes/prescriptionmed
	display_name = "Medical HUD - Prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription

/datum/gear/restricted/medical/eyes/aviator
	display_name = "Medical HUD - Aviators"
	path = /obj/item/clothing/glasses/hud/health/aviator

/datum/gear/restricted/medical/eyes/aviator/prescription
	display_name = "Medical HUD - Aviators, Prescription"
	path = /obj/item/clothing/glasses/hud/health/aviator/prescription

/datum/gear/restricted/medical/eyes/arglasses_med
	display_name = "Medical AR-M Glasses"
	path = /obj/item/clothing/glasses/omnihud/med

//Head
/datum/gear/restricted/medical/head/paramedic_cap
	display_name = "Medical Paramedic Cap"
	path = /obj/item/clothing/head/parahat

//Back
/datum/gear/restricted/medical/back/dufflebag
	display_name = "Medical Dufflebag"
	path = /obj/item/storage/backpack/dufflebag/med
	cost = 2

/datum/gear/restricted/medical/back/dufflebag/emt
	display_name = "Medical Dufflebag - EMT Variant"
	path = /obj/item/storage/backpack/dufflebag/emt

//Uniform
/datum/gear/restricted/medical/uniform/skirt
	display_name = "Medical Skirt"
	path = /obj/item/clothing/under/rank/medical/skirt

/datum/gear/restricted/medical/uniform/skirt/chem
	display_name = "Chemist Skirt"
	path = /obj/item/clothing/under/rank/chemist/skirt
	allowed_roles = list("Chief Medical Officer", "Chemist")

/datum/gear/restricted/medical/uniform/skirt/viro
	display_name = "Virologist Skirt"
	path = /obj/item/clothing/under/rank/virologist/skirt
	allowed_roles = list("Chief Medical Officer", "Medical Doctor")

/datum/gear/restricted/medical/uniform/skirt/cmo
	display_name = "Chief Medical Officer Skirt"
	path = /obj/item/clothing/under/rank/chief_medical_officer/skirt
	allowed_roles = list("Chief Medical Officer")

/datum/gear/restricted/medical/uniform/turtleneck
	display_name = "Medical Turtleneck"
	path = /obj/item/clothing/under/rank/medical/turtleneck

/datum/gear/restricted/medical/uniform/turtleneck/alt
	display_name = "Medical Turtleneck - Alternative"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/medical

/datum/gear/restricted/medical/uniform/coveralls
	display_name = "Medical Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/medical

/datum/gear/restricted/medical/uniform/fatigues
	display_name = "Medical Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/medical

/datum/gear/restricted/medical/uniform/paramedic
	display_name = "Medical Uniform - Paramedic Light"
	path = /obj/item/clothing/under/paramedunilight

/datum/gear/restricted/medical/uniform/paramedic/dark
	display_name = "Medical Uniform - Paramedic Dark"
	path = /obj/item/clothing/under/paramedunidark

/datum/gear/restricted/medical/uniform/paramedic/skirt
	display_name = "Medical Skirt - Paramedic Skirt Light"
	path = /obj/item/clothing/under/parameduniskirtlight

/datum/gear/restricted/medical/uniform/paramedic/skirt/dark
	display_name = "Medical Skirt - Paramedic Skirt Dark"
	path = /obj/item/clothing/under/parameduniskirtdark

/datum/gear/restricted/medical/uniform/bodysuit
	display_name = "Medical Bodysuit EMT"
	path = /obj/item/clothing/under/bodysuit/bodysuitemt

//Suit
/datum/gear/restricted/medical/suit/wintercoat
	display_name = "Medical Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical

/datum/gear/restricted/medical/suit/wintercoat/paramedic
	display_name = "Medical Winter Coat, Paramedic"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/para

/datum/gear/restricted/medical/suit/wintercoat/chemist
	display_name = "Medical Winter Coat, Chemist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/chemistry

/datum/gear/restricted/medical/suit/wintercoat/viro
	display_name = "Medical Winter Coat, Virologist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/viro

/datum/gear/restricted/medical/suit/wintercoat/genetics
	display_name = "Medical Winter Coat, Geneticist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/genetics

/datum/gear/restricted/medical/suit/wintercoat/cmo
	display_name = "Medical Winter Coat, CMO"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/restricted/medical/suit/surgical_apron
	display_name = "Medical Surgical Apron"
	path = /obj/item/clothing/suit/surgicalapron

/datum/gear/restricted/medical/suit/paramedic_jacket
	display_name = "Medical Paramedic Jacket"
	path = /obj/item/clothing/suit/toggle/paramed

/datum/gear/restricted/medical/suit/emt_vest
	display_name = "Medical EMT Vest"
	path = /obj/item/clothing/suit/toggle/labcoat/paramedic

/datum/gear/restricted/medical/suit/snowsuit
	display_name = "Medical Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/medical

/datum/gear/restricted/medical/suit/labcoat_emt
	display_name = "Medical Labcoat - EMT"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/emt

/datum/gear/restricted/medical/suit/department_jacket
	display_name = "Medical Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/med_dep_jacket

/datum/gear/restricted/medical/suit/cloak
	display_name = "Medical Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/medical

/datum/gear/restricted/medical/suit/cloak/cmo
	display_name = "Chief Medical Officer - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/restricted/medical/suit/poncho
	display_name = "Medical Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/medical


//Shoes
/datum/gear/restricted/medical/shoes/winterboots
	display_name = "Medical - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/medical

//Accessories
/datum/gear/restricted/medical/accessory/stethoscope
	display_name = "Medical - Stethoscope"
	path = /obj/item/clothing/accessory/stethoscope


//*Engineering
//Eyes
/datum/gear/restricted/engineering/eyes/arglasses_eng
	display_name = "Engineering AR-E Glasses"
	path = /obj/item/clothing/glasses/omnihud/eng

//Head
/datum/gear/restricted/engineering/head/beret
	display_name = "Engineering Beret"
	path = /obj/item/clothing/head/beret/engineering

/datum/gear/restricted/engineering/head/operations_cap
	display_name = "Engineering Cap - Engineering Operations"
	path = /obj/item/clothing/head/operations/engineering

//Back
/datum/gear/restricted/engineering/back/dufflebag
	display_name = "Engineering Dufflebag"
	path = /obj/item/storage/backpack/dufflebag/eng
	cost = 2

//Uniform
/datum/gear/restricted/engineering/uniform/ce_skirt
	display_name = "Chief Engineer Skirt"
	path = /obj/item/clothing/under/rank/chief_engineer/skirt
	allowed_roles = list("Chief Engineer")

/datum/gear/restricted/engineering/uniform/atmos_skirt
	display_name = "Atmospherics Skirt"
	path = /obj/item/clothing/under/rank/atmospheric_technician/skirt
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/restricted/engineering/uniform/eng_skirt
	display_name = "Engineering Skirt"
	path = /obj/item/clothing/under/rank/engineer/skirt

/datum/gear/restricted/engineering/uniform/bodysuit
	display_name = "Engineering Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuithazard

/datum/gear/restricted/engineering/uniform/turtleneck
	display_name = "Engineering Turtleneck"
	path = /obj/item/clothing/under/rank/engineer/turtleneck

/datum/gear/restricted/engineering/uniform/turtleneck/alt
	display_name = "Engineering Turtleneck - Alt"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/engineering

/datum/gear/restricted/engineering/uniform/coveralls
	display_name = "Engineering Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/engineering

/datum/gear/restricted/engineering/uniform/fatigues
	display_name = "Engineering Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/engineering

//Suit
/datum/gear/restricted/engineering/suit/wintercoat
	display_name = "Engineering Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering

/datum/gear/restricted/engineering/suit/wintercoat/atmos
	display_name = "Atmospherics Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/restricted/engineering/suit/wintercoat/ce
	display_name = "Chief Engineer's Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/restricted/engineering/suit/operations_coat
	display_name = "Engineering Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat/engineering

/datum/gear/restricted/engineering/suit/snowsuit
	display_name = "Engineering Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/engineering

/datum/gear/restricted/engineering/suit/department_jacket
	display_name = "Engineering Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket

/datum/gear/restricted/engineering/suit/cloak
	display_name = "Engineering Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/engineer

/datum/gear/restricted/engineering/suit/cloak/atmos
	display_name = "Atmospherics Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/atmos

/datum/gear/restricted/engineering/suit/cloak/ce
	display_name = "Chief Engineer - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/restricted/engineering/suit/poncho
	display_name = "Engineering Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/engineering

//Shoes
/datum/gear/restricted/engineering/shoes/winterboots
	display_name = "Engineering - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/engineering

/datum/gear/restricted/engineering/shoes/winterboots/atmos
	display_name = "Atmospherics Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")



//*Supply
//Eyes
/datum/gear/restricted/supply/eyes/material
	display_name = "(Supply) Optical Material Scanners"
	path = /obj/item/clothing/glasses/material

/datum/gear/restricted/supply/eyes/material/prescription
	display_name = "(Supply) Optical Material Scanners - Prescription"
	path = /obj/item/clothing/glasses/material/prescription

//Uniforms
/datum/gear/restricted/supply/uniform/jeans_qm
	display_name = "Quartermaster Jeans"
	path = /obj/item/clothing/under/rank/cargo/jeans
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/uniform/jeans_qm/female
	display_name = "Quartermaster Jeans - Female"
	path = /obj/item/clothing/under/rank/cargo/jeans/female

/datum/gear/restricted/supply/uniform/jeans_cargo
	display_name = "Cargo Jeans"
	path = /obj/item/clothing/under/rank/cargotech/jeans

/datum/gear/restricted/supply/uniform/jeans_cargo/female
	display_name = "Cargo Jeans - Female"
	path = /obj/item/clothing/under/rank/cargotech/jeans/female

/datum/gear/restricted/supply/uniform/skirt
	display_name = "Cargo Skirt"
	path = /obj/item/clothing/under/rank/cargotech/skirt

/datum/gear/restricted/supply/uniform/skirt/qm
	display_name = "Quartermaster Skirt"
	path = /obj/item/clothing/under/rank/cargo/skirt
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/uniform/bodysuit_miner
	display_name = "Mining Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitminer
	allowed_roles = list("Quartermaster", "Shaft Miner")

/datum/gear/restricted/supply/uniform/turtleneck
	display_name = "Cargo Turtleneck"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/supply

/datum/gear/restricted/supply/uniform/coveralls
	display_name = "Cargo Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/supply

/datum/gear/restricted/supply/uniform/fatigues
	display_name = "Cargo Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/supply

//Suit
/datum/gear/restricted/supply/suit/snowsuit
	display_name = "Cargo Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/cargo

/datum/gear/restricted/supply/suit/wintercoat
	display_name = "Cargo Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo

/datum/gear/restricted/supply/suit/wintercoat/qm
	display_name = "Quartermaster's Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/qm
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/suit/wintercoat/mining
	display_name = "Mining Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	allowed_roles = list("Quartermaster", "Shaft Miner")

/datum/gear/restricted/supply/suit/department_jacket
	display_name = "Cargo Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/supply_dep_jacket

/datum/gear/restricted/supply/suit/cloak
	display_name = "Cargo Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cargo

/datum/gear/restricted/supply/suit/cloak/mining
	display_name = "Mining Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/mining

/datum/gear/restricted/supply/suit/cloak/qm
	display_name = "Quartermaster - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/qm
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/suit/poncho
	display_name = "Cargo Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/cargo



//Shoes
/datum/gear/restricted/supply/shoes/winterboots
	display_name = "Cargo Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/supply

/datum/gear/restricted/supply/shoes/winterboots/mining
	display_name = "Mining Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/mining
	allowed_roles = list("Shaft Miner", "Quartermaster")






//*Science
//Head
/datum/gear/restricted/science/head/beret
	display_name = "Science Beret"
	path = /obj/item/clothing/head/beret/science

//Back
/datum/gear/restricted/science/back/dufflebag
	display_name = "Science Dufflebag"
	path = /obj/item/storage/backpack/dufflebag/sci
	cost = 2

//Uniform
/datum/gear/restricted/science/uniform/skirt
	display_name = "Science Skirt"
	path = /obj/item/clothing/under/rank/scientist/skirt

/datum/gear/restricted/science/uniform/skirt/roboticist
	display_name = "Roboticist Skirt"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Research Director", "Roboticist")

/datum/gear/restricted/science/uniform/turtleneck
	display_name = "Science Turtleneck"
	path = /obj/item/clothing/under/rank/scientist/turtleneck

/datum/gear/restricted/science/uniform/turtleneck/alt
	display_name = "Science Turtleneck - Alt"
	path = /obj/item/clothing/under/solgov/utility/sifguard/crew/research

/datum/gear/restricted/science/uniform/coveralls
	display_name = "Science Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/exploration

/datum/gear/restricted/science/uniform/fatigues
	display_name = "Science Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/exploration


//Suit
/datum/gear/restricted/science/suit/wintercoat
	display_name = "Science Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science

/datum/gear/restricted/science/suit/wintercoat/rd
	display_name = "Research Director's Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science/rd
	allowed_roles = list("Research Director")

/datum/gear/restricted/science/suit/wintercoat/robotics
	display_name = "Robotics Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science/robotics


/datum/gear/restricted/science/suit/snowsuit
	display_name = "Science Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/science

/datum/gear/restricted/science/suit/labcoat
	display_name = "Research Labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/science

/datum/gear/restricted/science/suit/labcoat/roboticist
	display_name = "Research Labcoat - Robotics"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/robotics
	allowed_roles = list("Research Director", "Roboticist")

/datum/gear/restricted/science/suit/labcoat/rd
	display_name = "Research Labcoat - Research Director"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	allowed_roles = list("Research Director")

/datum/gear/restricted/science/suit/department_jacket
	display_name = "Science Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/sci_dep_jacket

/datum/gear/restricted/science/suit/cloak
	display_name = "Science Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/research

/datum/gear/restricted/science/suit/cloak/rd
	display_name = "Research Director - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/rd
	allowed_roles = list("Research Director")

/datum/gear/restricted/science/suit/poncho
	display_name = "Science Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/science


//Shoes
/datum/gear/restricted/science/shoes/winterboots
	display_name = "Science - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/science


//*Command
//Eyes
/datum/gear/restricted/command/eyes/arglasses_com
	display_name = "Command AR-B glasses"
	path = /obj/item/clothing/glasses/omnihud/all
	cost = 2

//Head
/datum/gear/restricted/command/head/cap
	display_name = "Command Cap - Command Operations"
	path = /obj/item/clothing/head/operations

/datum/gear/restricted/command/head/cap/bridge_officer
	display_name = "Command Cap - Bridge Officer"
	path = /obj/item/clothing/head/bocap

/datum/gear/restricted/command/head/hat
	display_name = "Command Hat - Bridge Officer"
	path = /obj/item/clothing/head/bohat

//Uniform
/datum/gear/restricted/command/uniform/coveralls
	display_name = "Command Uniform - Coveralls"
	path = /obj/item/clothing/under/solgov/utility/fleet/command

/datum/gear/restricted/command/uniform/hop_dress
	display_name = "Head of Personnel Uniform - Dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/restricted/command/uniform/hop_hr
	display_name = "Head of Personnel Uniform - HR Director"
	path = /obj/item/clothing/under/dress/dress_hr
	allowed_roles = list("Head of Personnel")

/datum/gear/restricted/command/uniform/cap_dress
	display_name = "Facility Director Uniform - Dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Facility Director")

/datum/gear/restricted/command/uniform/turtleneck
	display_name = "Command Uniform - Turtleneck"
	path = /obj/item/clothing/under/solgov/utility/sifguard/officer/crew

/datum/gear/restricted/command/uniform/bridge_officer
	display_name = "Bridge Officer Uniform"
	path = /obj/item/clothing/under/bridgeofficer
	allowed_roles = list("Command Secretary")

/datum/gear/restricted/command/uniform/bridge_officer/skirt
	display_name = "Bridge Officer Skirt"
	path = /obj/item/clothing/under/bridgeofficerskirt
	allowed_roles = list("Command Secretary")

/datum/gear/restricted/command/uniform/fatigues
	display_name = "Command Uniform - Fatigues"
	path = /obj/item/clothing/under/solgov/utility/marine/command

/datum/gear/restricted/command/uniform/bodysuit
	display_name = "Command Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitcommand

//Suit
/datum/gear/restricted/command/suit/operations_coat
	display_name = "Command Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat/command

/datum/gear/restricted/command/suit/snowsuit
	display_name = "Command Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/command

/datum/gear/restricted/command/suit/parade_jacket
	display_name = "Command Parade Jacket"
	path = /obj/item/clothing/suit/storage/ecdress_ofcr

/datum/gear/restricted/command/suit/dress_jacket
	display_name = "Command Dress Jacket"
	path = /obj/item/clothing/suit/storage/bridgeofficer

/datum/gear/restricted/command/suit/wintercoat_captain
	display_name = "Facility Director - Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	allowed_roles = list("Facility Director")

/datum/gear/restricted/command/suit/wintercoat_hop
	display_name = "Head of Personnel - Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/restricted/command/suit/cloak
	display_name = "Facility Director - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/captain
	allowed_roles = list("Facility Director")

/datum/gear/restricted/command/suit/cloak/hop
	display_name = "Head of Personnel - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hop
	allowed_roles = list("Head of Personnel")

//Shoes
/datum/gear/restricted/command/shoes/winterboots
	display_name = "Facility Director - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/command
	allowed_roles = list("Facility Director")



//*Service (Poor Service and their ONE item)
/datum/gear/restricted/service/suit/cloak
	display_name = "Service - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/service



//**Multi-Department Items
//*Engineering + Science + Supply
//Eyes
/datum/gear/restricted/eng_sci_supply/eyes/meson
	display_name = "(Engineering/Science/Supply) Optical Meson Scanners"
	path = /obj/item/clothing/glasses/meson

/datum/gear/restricted/eng_sci_supply/eyes/meson/prescription
	display_name = "(Engineering/Science/Supply) Optical Meson Scanners - Prescription"
	path = /obj/item/clothing/glasses/meson/prescription

/datum/gear/restricted/eng_sci_supply/eyes/meson/eyepatch
	display_name = "(Engineering/Science/Supply) Optical Meson Eyepatch"
	path = /obj/item/clothing/glasses/hud/engi/eyepatch

/datum/gear/restricted/eng_sci_supply/eyes/aviator
	display_name = "(Engineering/Science/Supply) Optical Meson Scanners - Aviators"
	path = /obj/item/clothing/glasses/meson/aviator

/datum/gear/restricted/eng_sci_supply/eyes/aviator/prescription
	display_name = "(Engineering/Science/Supply) Optical Meson Scanners - Aviators, Prescription"
	path = /obj/item/clothing/glasses/meson/aviator/prescription


//*Security + Command
//Eyes
/datum/gear/restricted/sec_com/eyes/shades
	display_name = "(Security/Command) Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses

/datum/gear/restricted/sec_com/eyes/shades_big
	display_name = "(Security/Command) Sunglasses, Fat"
	path = /obj/item/clothing/glasses/sunglasses/big

/datum/gear/restricted/sec_com/eyes/aviators
	display_name = "(Security/Command) Sunglasses, Aviators"
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/restricted/sec_com/eyes/prescriptionsun
	display_name = "(Security/Command) Sunglasses, Presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription


//*Medical + Science
/datum/gear/restricted/med_sci/head/cap
	display_name = "(Medical/Science) MedSci Operations Cap"
	path = /obj/item/clothing/head/operations/medsci

/datum/gear/restricted/med_sci/suit/operations_jacket
	display_name = "(Medical/Science) MedSci Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat/medsci
/***********************************************************************************************/
//**Misc. Roles
//*Pilot
/datum/gear/restricted/misc/head/pilot
	display_name = "Pilot Helmet"
	path = /obj/item/clothing/head/pilot/alt
	allowed_roles = list("Pilot")

/datum/gear/restricted/misc/uniform/pilot
	display_name = "Pilot Uniform"
	path = /obj/item/clothing/under/rank/pilot2
	allowed_roles = list("Pilot")

//*Bartender
/datum/gear/restricted/misc/uniform/bartender_skirt
	display_name = "Bartender Uniform - Skirt"
	path = /obj/item/clothing/under/rank/bartender/skirt
	allowed_roles = list("Bartender")

/datum/gear/restricted/misc/uniform/bartender_btc
	display_name = "Bartender Uniform - BTC"
	path = /obj/item/clothing/under/btcbartender
	allowed_roles = list("Bartender")

/datum/gear/restricted/misc/suit/wintercoat_bartender
	display_name = "Bartender Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/bar
	allowed_roles = list("Bartender")

//*Internal Affairs Agent
/datum/gear/restricted/misc/uniform/iaskirt
	display_name = "Internal Affairs Uniform - Skirt"
	path = /obj/item/clothing/under/rank/internalaffairs/skirt
	allowed_roles = list("Internal Affairs Agent")

//*Janitor
/datum/gear/restricted/misc/uniform/janitor_alt
	display_name = "Janitor Jumpsuit - Alt"
	path = /obj/item/clothing/under/rank/janitor/starcon
	allowed_roles = list("Janitor")

/datum/gear/restricted/misc/shoes/janitor
	display_name = "Janitor Galoshes - Black"
	path = /obj/item/clothing/shoes/galoshes/citadel/black
	allowed_roles = list("Janitor")

/datum/gear/restricted/janitor/wintercoat
	display_name = "Janitor's Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/janitor
	allowed_roles = list("Janitor")

/datum/gear/restricted/misc/shoes/janitor/alt
	display_name = "Janitor Galoshes - Dark-Purple"
	path = /obj/item/clothing/shoes/galoshes/citadel/starcon
	allowed_roles = list("Janitor")
	cost = 2

//*Exploration
/datum/gear/restricted/misc/uniform/bodysuit_explo/command
	display_name = "Exploration Command Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitexplocom
	allowed_roles = list("Research Director","Pathfinder")

/datum/gear/restricted/misc/uniform/bodysuit_explo
	display_name = "Exploration Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitexplo
	allowed_roles =list("Research Director", "Pathfinder", "Explorer", "Field Medic", "Pilot")

/datum/gear/restricted/misc/suit/wintercoat_field_medic
	display_name = "Field Medic Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	allowed_roles =list("Field Medic")

//*Botany
/datum/gear/restricted/misc/suit/wintercoat_hydroponics
	display_name = "Hydroponics Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	allowed_roles = list("Botanist")

/datum/gear/restricted/misc/shoes/winterboots_hydroponics
	display_name = "Hydroponics Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/hydro
	allowed_roles = list("Botanist")


//*This clusterfuck of access combinations
/datum/gear/restricted/misc/accessory/holster
	display_name = "(Command/Security/Exploration) Holster - Selection"
	path = /obj/item/clothing/accessory/holster
	allowed_roles = list("Facility Director", "Head of Personnel", "Chief Medical Officer", "Head of Security", "Research Director", "Chief Engineer", "Command Secretary", "Security Officer", "Warden", "Head of Security", "Detective", "Field Medic", "Explorer", "Pathfinder", "Pilot")

/datum/gear/restricted/misc/accessory/holster/New()
	..()
	var/list/holsters = list()
	for(var/holster in typesof(/obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster_type = holster
		holsters[initial(holster_type.name)] = holster_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(holsters, /proc/cmp_text_asc))
