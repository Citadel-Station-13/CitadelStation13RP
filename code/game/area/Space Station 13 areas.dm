/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/

/*-----------------------------------------------------------------------------*/

/////////
//SPACE//
/////////

/area/space
	name = "\improper Space"
	icon_state = "space"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 0
	power_light = 0
	has_gravity = 0
	power_equip = 0
	power_environ = 0
	base_turf = /turf/space
	ambience = AMBIENCE_SPACE

/area/space/atmosalert()
	return

/area/space/fire_alert()
	return

/area/space/fire_reset()
	return

/area/space/readyalert()
	return

/area/space/partyalert()
	return

/area/arrival
	requires_power = 0

/area/arrival/start
	name = "\improper Arrival Area"
	icon_state = "start"

/area/admin
	name = "\improper Admin room"
	icon_state = "start"



////////////
//SHUTTLES//
////////////
// Shuttles only need starting area, movement is handled by landmarks
// All shuttles should now be under shuttle since we have smooth-wall code.

/area/shuttle
	requires_power = 0
	flags = RAD_SHIELDED
	sound_env = SMALL_ENCLOSED
	base_turf = /turf/space

/area/shuttle/arrival
	name = "\improper Arrival Shuttle"
	ambience = AMBIENCE_ARRIVALS

/area/shuttle/supply
	name = "\improper Supply Shuttle"
	icon_state = "shuttle2"

/area/shuttle/escape
	name = "\improper Emergency Shuttle"
	music = "music/escape.ogg"
	requires_power = 0

/area/shuttle/escape_pod1
	name = "\improper Escape Pod One"
	music = "music/escape.ogg"

/area/shuttle/escape_pod2
	name = "\improper Escape Pod Two"
	music = "music/escape.ogg"

/area/shuttle/escape_pod3
	name = "\improper Escape Pod Three"
	music = "music/escape.ogg"

/area/shuttle/escape_pod4
	name = "\improper Escape Pod Four"
	music = "music/escape.ogg"

/area/shuttle/escape_pod5
	name = "\improper Escape Pod Five"
	music = "music/escape.ogg"

/area/shuttle/escape_pod6
	name = "\improper Escape Pod Six"
	music = "music/escape.ogg"

/area/shuttle/large_escape_pod1
	name = "\improper Large Escape Pod One"
	music = "music/escape.ogg"

/area/shuttle/large_escape_pod2
	name = "\improper Large Escape Pod Two"
	music = "music/escape.ogg"

/area/shuttle/cryo
	name = "\improper Cryogenic Storage"

/area/shuttle/mining
	name = "\improper Mining Elevator"
	music = "music/escape.ogg"
	dynamic_lighting = 0
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen

/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "\improper Transport Shuttle CentCom"

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "\improper Transport Shuttle"

/area/shuttle/alien/base
	icon_state = "shuttle"
	name = "\improper Alien Shuttle Base"
	requires_power = 1

/area/shuttle/alien/mine
	icon_state = "shuttle"
	name = "\improper Alien Shuttle Mine"
	requires_power = 1

/area/shuttle/prison/
	name = "\improper Prison Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle"

/area/shuttle/prison/prison
	icon_state = "shuttle2"

/area/shuttle/specops/centcom
	name = "\improper Special Ops Shuttle"
	icon_state = "shuttlered"

/area/shuttle/specops/station
	name = "\improper Special Ops Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/syndicate_elite/mothership
	name = "\improper Merc Elite Shuttle"
	icon_state = "shuttlered"

/area/shuttle/syndicate_elite/station
	name = "\improper Merc Elite Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/administration/centcom
	name = "Centcom Large Bay (AS)"
	icon_state = "shuttlered"

/area/shuttle/administration/station
	name = "NSB Adephagia (AS)"
	icon_state = "shuttlered2"

/area/shuttle/administration/transit
	name = "Deep Space (AS)"
	icon_state = "shuttle"

/area/shuttle/administration/away_mission
	name = "Away Mission (AS)"
	icon_state = "shuttle"

/area/shuttle/trade
	name = "\improper Trade Station"
	icon_state = "red"
	dynamic_lighting = 0

/area/shuttle/thunderdome
	name = "honk"

/area/shuttle/research
	name = "\improper Research Elevator"
	music = "music/escape.ogg"
	dynamic_lighting = 0
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen

/area/shuttle/awaymission/home
	name = "NSB Adephagia (AM)"
	icon_state = "shuttle2"

/area/shuttle/awaymission/warp
	name = "Deep Space (AM)"
	icon_state = "shuttle"

/area/shuttle/awaymission/away
	name = "Away Mission (AM)"
	icon_state = "shuttle2"

/area/shuttle/awaymission/oldengbase
	name = "Old Construction Site (AM)"
	icon_state = "shuttle2"

/area/shuttle/belter
	name = "Belter Shuttle"
	icon_state = "shuttle2"

/area/shuttle/cruiser/cruiser
	name = "Small Cruiser Shuttle - Cruiser"
	icon_state = "blue2"
	base_turf = /turf/simulated/floor/tiled/techfloor

/area/shuttle/tether/surface
	name = "Tether Shuttle Landed"
	icon_state = "shuttle"
	base_turf = /turf/simulated/floor/reinforced

/area/shuttle/tether/station
	name = "Tether Shuttle Dock"
	icon_state = "shuttle2"

/area/shuttle/tether/transit
	name = "Tether Shuttle Transit"
	icon_state = "shuttle2"

/area/shuttle/cruiser/station
	name = "Small Cruiser Shuttle - Station"
	icon_state = "blue2"

// Excursion Shuttle
/area/shuttle/excursion
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/excursion/general
	name = "\improper Excursion Shuttle"

/area/shuttle/excursion/cockpit
	name = "\improper Excursion Shuttle Cockpit"

/area/shuttle/excursion/cargo
	name = "\improper Excursion Shuttle Cockpit"

// Pirate Skiff
/area/shuttle/pirate
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/pirate/general
	name = "\improper Pirate Skiff Shuttle"

/area/shuttle/pirate/cockpit
	name = "\improper Pirate Skiff Shuttle Cockpit"

/area/shuttle/pirate/cargo
	name = "\improper Pirate Skiff Shuttle Cockpit"

// Civilian Transport
/area/shuttle/civvie
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/civvie/general
	name = "\improper Civilian Transport"

/area/shuttle/civvie/cockpit
	name = "\improper Civilian Transport Cockpit"

// Mining Shuttle
/area/shuttle/mining_ship
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/mining_ship/general
	name = "\improper Mining Shuttle"

//Trade Ship
/area/shuttle/trade_ship
	requires_power = 1
	icon_state = "shuttle2"
	flags = RAD_SHIELDED

/area/shuttle/trade_ship/general
	name = "\improper Beruang Trade Shuttle"

/area/shuttle/trade_ship/cockpit
	name = "\improper Beruang Trade Shuttle Cockpit"

//EMT Shuttle
/area/shuttle/emt
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/emt/general
	name = "\improper EMT Shuttle"

/area/shuttle/emt/cockpit
	name = "\improper EMT Shuttle Cockpit"

// Tourbus
/area/shuttle/tourbus
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/tourbus/general
	name = "\improper Tour Bus"

/area/shuttle/tourbus/cockpit
	name = "\improper Tour Bus Cockpit"

/area/shuttle/tourbus/engines
	name = "\improper Tour Bus Engines"

// Antag
/area/antag/antag_base
	name = "\improper Syndicate Outpost"
	requires_power = 0
	dynamic_lighting = 0

// Antag Space Shuttle.	// Also Known as "ASS"
/area/shuttle/antag_space
	name = "\improper Syndicate PS"
	icon_state = "shuttle2"

// Antag ground 'shuttle'
/area/shuttle/antag_ground
	name = "\improper Syndicate LC"
	icon_state = "shuttle2"

//Merc shuttle
/area/shuttle/mercenary
	name = "\improper Mercenary Shuttle"

//Vox shuttle
/area/shuttle/skipjack
	name = "\improper Skipjack"
	icon_state = "shuttle2"

//Ninja shuttle
/area/shuttle/ninja
	name = "\improper Ninjacraft"
	icon_state = "shuttle2"

// New shuttles
/area/shuttle/administration/transit
	name = "Deep Space (AS)"
	icon_state = "shuttle"

/area/shuttle/administration/away_mission
	name = "Away Mission (AS)"
	icon_state = "shuttle"

/area/shuttle/awaymission/home
	name = "NSB Adephagia (AM)"
	icon_state = "shuttle2"

/area/shuttle/awaymission/warp
	name = "Deep Space (AM)"
	icon_state = "shuttle"

/area/shuttle/awaymission/away
	name = "Away Mission (AM)"
	icon_state = "shuttle2"

/area/shuttle/awaymission/oldengbase
	name = "Old Construction Site (AM)"
	icon_state = "shuttle2"

// Small Cruiser Areas
/area/shuttle/cruiser/cruiser
	name = "Small Cruiser Shuttle - Cruiser"
	icon_state = "blue2"
	base_turf = /turf/simulated/floor/tiled/techfloor
/area/shuttle/cruiser/station
	name = "Small Cruiser Shuttle - Station"
	icon_state = "blue2"

// ERT/Deathsquad Shuttle
/area/shuttle/specialops/centcom
	name = "Special Operations Shuttle - Centcom"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor/shuttle_ceiling
/area/shuttle/specialops/tether
	name = "Special Operations Shuttle - Tether"
	icon_state = "shuttlered"
/area/shuttle/specialops/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/east

// Tether Map has this shuttle
/area/shuttle/tether
	name = "Tether Shuttle"
	icon_state = "shuttle2"

// CENTCOM

/area/centcom
	name = "\improper CentCom"
	icon_state = "centcom"
	requires_power = 0
	dynamic_lighting = 0

/area/centcom/control
	name = "\improper CentCom Control"

/area/centcom/evac
	name = "\improper CentCom Emergency Shuttle"

/area/centcom/suppy
	name = "\improper CentCom Supply Shuttle"

/area/centcom/ferry
	name = "\improper CentCom Transport Shuttle"

/area/centcom/shuttle
	name = "\improper CentCom Administration Shuttle"

/area/centcom/test
	name = "\improper CentCom Testing Facility"

/area/centcom/living
	name = "\improper CentCom Living Quarters"

/area/centcom/specops
	name = "\improper CentCom Special Ops"

/area/centcom/creed
	name = "Creed's Office"

/area/centcom/holding
	name = "\improper Holding Facility"

/area/centcom/terminal
	name = "\improper Docking Terminal"
	icon_state = "centcom_dock"
	ambience = AMBIENCE_ARRIVALS

/area/centcom/tram
	name = "\improper Tram Station"
	ambience = AMBIENCE_ARRIVALS

/area/centcom/security
	name = "\improper CentCom Security"
	icon_state = "centcom_security"

/area/centcom/medical
	name = "\improper CentCom Medical"
	icon_state = "centcom_medical"

/area/centcom/command
	name = "\improper CentCom Command" //Central Command Command totally isn't RAS Syndrome in action.
	icon_state = "centcom_command"
	ambience = AMBIENCE_HIGHSEC

/area/centcom/main_hall
	name = "\improper Main Hallway"
	icon_state = "centcom_hallway1"

/area/centcom/bar
	name = "\improper CentCom Bar"
	icon_state = "centcom_crew"

/area/centcom/restaurant
	name = "\improper CentCom Restaurant"
	icon_state = "centcom_crew"

/area/centcom/bathroom
	name = "\improper CentCom Bathroom"
	icon_state = "centcom_crew"
	sound_env = SMALL_ENCLOSED

//SYNDICATES

/area/syndicate_mothership
	name = "\improper Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 0
	ambience = AMBIENCE_HIGHSEC

/area/syndicate_mothership/control
	name = "\improper Mercenary Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "\improper Elite Mercenary Squad"
	icon_state = "syndie-elite"

//EXTRA

/area/asteroid					// -- TLE
	name = "\improper Moon"
	icon_state = "asteroid"
	requires_power = 0
	sound_env = ASTEROID

/area/asteroid/cave				// -- TLE
	name = "\improper Moon - Underground"
	icon_state = "cave"
	requires_power = 0
	sound_env = ASTEROID

/area/asteroid/artifactroom
	name = "\improper Moon - Artifact"
	icon_state = "cave"
	sound_env = SMALL_ENCLOSED

/area/asteroid/rogue
	var/asteroid_spawns = list()
	var/mob_spawns = list()
	var/shuttle_area //It would be neat if this were more dynamic, but eh.

/area/asteroid/rogue/zone1
	name = "Asteroid Belt Zone 1"
	icon_state = "red2"

/area/asteroid/rogue/zone2
	name = "Asteroid Belt Zone 2"
	icon_state = "blue2"

/area/asteroid/rogue/zone3
	name = "Asteroid Belt Zone 3"
	icon_state = "blue2"

/area/asteroid/rogue/zone4
	name = "Asteroid Belt Zone 4"
	icon_state = "red2"

/area/planet/clown
	name = "\improper Clown Planet"
	icon_state = "honk"
	requires_power = 0

/area/tdome
	name = "\improper Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	dynamic_lighting = 0
	sound_env = ARENA

/area/tdome/tdome1
	name = "\improper Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "\improper Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "\improper Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "\improper Thunderdome (Observer.)"
	icon_state = "purple"

//ENEMY

//names are used
/area/syndicate_station
	name = "\improper Independent Station"
	icon_state = "yellow"
	requires_power = 0
	flags = RAD_SHIELDED
	base_turf = /turf/space
	ambience = AMBIENCE_HIGHSEC

/area/syndicate_station/start
	name = "\improper Mercenary Forward Operating Base"
	icon_state = "yellow"

/area/syndicate_station/southwest
	name = "\improper south-west of SS13"
	icon_state = "southwest"

/area/syndicate_station/northwest
	name = "\improper north-west of SS13"
	icon_state = "northwest"

/area/syndicate_station/northeast
	name = "\improper north-east of SS13"
	icon_state = "northeast"

/area/syndicate_station/southeast
	name = "\improper south-east of SS13"
	icon_state = "southeast"

/area/syndicate_station/north
	name = "\improper north of SS13"
	icon_state = "north"

/area/syndicate_station/south
	name = "\improper south of SS13"
	icon_state = "south"

/area/syndicate_station/commssat
	name = "\improper south of the communication satellite"
	icon_state = "south"

/area/syndicate_station/mining
	name = "\improper northeast of the mining station"
	icon_state = "north"

/area/syndicate_station/arrivals_dock
	name = "\improper docked with station"
	icon_state = "shuttle"

/area/syndicate_station/maint_dock
	name = "\improper docked with station"
	icon_state = "shuttle"

/area/syndicate_station/transit
	name = "\improper hyperspace"
	icon_state = "shuttle"

/area/wizard_station
	name = "\improper Wizard's Den"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0
	ambience = AMBIENCE_OTHERWORLDLY

/area/skipjack_station
	name = "\improper Skipjack"
	icon_state = "yellow"
	requires_power = 0
	base_turf = /turf/space
	ambience = AMBIENCE_HIGHSEC

/area/skipjack_station/start
	name = "\improper Skipjack"
	icon_state = "yellow"

/area/skipjack_station/transit
	name = "\improper hyperspace"
	icon_state = "shuttle"

/area/skipjack_station/southwest_solars
	name = "\improper aft port solars"
	icon_state = "southwest"

/area/skipjack_station/northwest_solars
	name = "\improper fore port solars"
	icon_state = "northwest"

/area/skipjack_station/northeast_solars
	name = "\improper fore starboard solars"
	icon_state = "northeast"

/area/skipjack_station/southeast_solars
	name = "\improper aft starboard solars"
	icon_state = "southeast"

/area/skipjack_station/mining
	name = "\improper south of mining station"
	icon_state = "north"

//PRISON
/area/prison
	name = "\improper Prison Station"
	icon_state = "brig"
	ambience = AMBIENCE_HIGHSEC

/area/prison/arrival_airlock
	name = "\improper Prison Station Airlock"
	icon_state = "green"
	requires_power = 0

/area/prison/control
	name = "\improper Prison Security Checkpoint"
	icon_state = "security"

/area/prison/crew_quarters
	name = "\improper Prison Security Quarters"
	icon_state = "security"

/area/prison/rec_room
	name = "\improper Prison Rec Room"
	icon_state = "green"

/area/prison/closet
	name = "\improper Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/fore
	name = "\improper Prison Fore Hallway"
	icon_state = "yellow"

/area/prison/hallway/aft
	name = "\improper Prison Aft Hallway"
	icon_state = "yellow"

/area/prison/hallway/port
	name = "\improper Prison Port Hallway"
	icon_state = "yellow"

/area/prison/hallway/starboard
	name = "\improper Prison Starboard Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "\improper Prison Morgue"
	icon_state = "morgue"

/area/prison/medical_research
	name = "\improper Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/medical
	name = "\improper Prison Medbay"
	icon_state = "medbay"

/area/prison/solar
	name = "\improper Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "\improper Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "\improper Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"

/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"

////////////////////
//SPACE STATION 13//
////////////////////

/area
	ambience = AMBIENCE_GENERIC

//Maintenance

/area/maintenance
	flags = RAD_SHIELDED
	sound_env = TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	ambience = AMBIENCE_MAINTENANCE

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/atmos
	name = "Atmospherics Maintenance"
	icon_state = "fpmaint"

/area/maintenance/atmos/lower
	name = "\improper Lower Atmospherics Maintenance"

/area/maintenance/fpmaint
	name = "Fore Port Maintenance - 1"
	icon_state = "fpmaint"

/area/maintenance/fpmaint2
	name = "Fore Port Maintenance - 2"
	icon_state = "fpmaint"

/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance - 1"
	icon_state = "fsmaint"

/area/maintenance/fsmaint2
	name = "Fore Starboard Maintenance - 2"
	icon_state = "fsmaint"

/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/engi_shuttle
	name = "Engineering Shuttle Access"
	icon_state = "maint_e_shuttle"

/area/maintenance/engi_engine
	name = "Engine Maintenance"
	icon_state = "maint_engine"

/area/maintenance/asmaint2
	name = "Science Maintenance"
	icon_state = "asmaint"

/area/maintenance/apmaint
	name = "Cargo Engineering Maintenance"
	icon_state = "apmaint"

/area/maintenance/bridge
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/arrivals
	name = "Arrivals Maintenance"
	icon_state = "maint_arrivals"

/area/maintenance/bar
	name = "Bar Maintenance"
	icon_state = "maint_bar"

/area/maintenance/bar/lower
	name = "\improper Lower Bar Maintenance"

/area/maintenance/bar/catwalk
	name = "Bar Maintenance Catwalk"
	icon_state = "maint_bar"

/area/maintenance/central
	name = "Central Maintenance"
	icon_state = "maint_central"

/area/maintenance/cafe_dock
	name = "Cafeteria Dock Maintenance"
	icon_state = "maint_cafe_dock"

/area/maintenance/cargo
	name = "Cargo Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/cargo/mining
	name = "\improper Mining Maintenance"

/area/maintenance/cargo/mining/eva
	name = "\improper Mining EVA Maintenance"

/area/maintenance/trash_pit
	name = "\improper Trash Pit"

/area/maintenance/cargo_research
	name = "Cargo Research Maintenance"
	icon_state = "maint_cargo_research"

/area/maintenance/chapel
	name = "Chapel Maintenance"
	icon_state = "maint_chapel"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/engineering
	name = "Engineering Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/engineering/lower
	name = "\improper Engineering Lower Maintenance"

/area/maintenance/engineering/upper
	name = "\improper Engineering Upper Maintenance"

/area/maintenance/engineering/pumpstation
	name = "Engineering Pump Station"
	icon_state = "maint_pumpstation"

/area/maintenance/solars
	name = "\improper Solars Maintenance"

/area/maintenance/evahallway
	name = "\improper EVA Maintenance"
	icon_state = "maint_eva"

/area/maintenance/dormitory
	name = "Dormitory Maintenance"
	icon_state = "maint_dormitory"

/area/maintenance/holodeck
	name = "Holodeck Maintenance"
	icon_state = "maint_holodeck"

/area/maintenance/incinerator
	name = "\improper Incinerator"
	icon_state = "disposal"

/area/maintenance/library
	name = "Library Maintenance"
	icon_state = "maint_library"

/area/maintenance/locker
	name = "Locker Room Maintenance"
	icon_state = "maint_locker"

/area/maintenance/medbay
	name = "Medbay Maintenance"
	icon_state = "maint_medbay"

/area/maintenance/medbay/aft
	name = "Medbay Maintenance - Aft"
	icon_state = "maint_medbay_aft"

/area/maintenance/medbay/fore
	name = "Medbay Maintenance - Fore"
	icon_state = "maint_medbay_fore"

/area/maintenance/medbay/virology
	name = "\improper Virology Maintenance"

/area/maintenance/pool
	name = "Pool Maintenance"
	icon_state = "maint_pool"

/area/maintenance/research
	name = "Research Maintenance"
	icon_state = "maint_research"

/area/maintenance/research/rnd
	name = "\improper RnD Maintenance"

/area/maintenance/research/lower
	name = "\improper Lower Research Maintenance"

/area/maintenance/research/port
	name = "Research Maintenance - Port"
	icon_state = "maint_research_port"

/area/maintenance/research/starboard
	name = "Research Maintenance - Starboard"
	icon_state = "maint_research_starboard"

/area/maintenance/research/starboard
	name = "Research Maintenance - Starboard"
	icon_state = "maint_research_cargo"

/area/maintenance/research/shuttle
	name = "Research Shuttle Dock Maintenance"
	icon_state = "maint_research_shuttle"

/area/maintenance/research/xenoflora
	name = "\improper Xenoflora Maintenance"

/area/maintenance/security
	name = "Security Maintenance"
	icon_state = "security"

/area/maintenance/security/lower
	name = "\improper Security Lower Maintenance"

/area/maintenance/security/upper
	name = "\improper Security Upper Maintenance"

/area/maintenance/security/port
	name = "Security Maintenance - Port"
	icon_state = "maint_security_port"

/area/maintenance/security/starboard
	name = "Security Maintenance - Starboard"
	icon_state = "maint_security_starboard"

/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

/area/maintenance/tool_storage
	name = "Tool Storage Maintenance"
	icon_state = "maint_tool_storage"

/area/maintenance/triumph_midpoint
	name = "\improper Triumph Midpoint Maint"

/area/maintenance/locker_room
	name = "\improper Locker Room Maintenance"

/area/maintenance/vacant_site
	name = "\improper Vacant Site Maintenance"

/area/maintenance/atrium
	name = "\improper Atrium Maintenance"

/area/maintenance/north
	name = "\improper North Maintenance"

/area/maintenance/south
	name = "\improper South Maintenance"

/area/maintenance/public_garden_maintenence
	name = "\improper Public Garden Maintenance"

/area/maintenance/elevator
	name = "\improper Elevator Maintenance"

/area/maintenance/micro
	name = "\improper Micro Maintenance"

/area/maintenance/ai
	name = "\improper AI Maintenance"
	sound_env = SEWER_PIPE


// SUBSTATIONS (Subtype of maint, that should let them serve as shielded area during radstorm)

/area/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_SUBSTATION

/area/maintenance/substation/engineering // Probably will be connected to engineering SMES room, as wires cannot be crossed properly without them sharing powernets.
	name = "Engineering Substation"

// No longer used:
/area/maintenance/substation/medical_science // Medbay and Science. Each has it's own separated machinery, but it originates from the same room.
	name = "Medical Research Substation"

/area/maintenance/substation/medical // Medbay
	name = "Medical Substation"

/area/maintenance/substation/research // Research
	name = "Research Substation"

/area/maintenance/substation/cafeteria_dock // Hydro, kitchen, docks, hotel
	name = "Cafeteria Dock Substation"

/area/maintenance/substation/civilian // Dorms, Lockerroom, Pool
	name = "Civilian Substation"

/area/maintenance/substation/civilian_east // Bar, kitchen, dorms, ...
	name = "Civilian East Substation"

/area/maintenance/substation/civilian_west // Cargo, PTS, locker room, probably arrivals, ...)
	name = "Civilian West Substation"

/area/maintenance/substation/cargo // Cargo
	name = "Cargo Substation"

/area/maintenance/substation/command // AI and central cluster. This one will be between HoP office and meeting room (probably).
	name = "Command Substation"

/area/maintenance/substation/dock // Bar, docks, hotel
	name = "Dock Substation"

/area/maintenance/substation/security // Security, Brig, Permabrig, etc.
	name = "Security Substation"

/area/maintenance/substation/outpost
	name = "Research Outpost Substation"

/area/maintenance/substation/medsec
	name = "\improper MedSec Substation"

/area/maintenance/substation/mining
	name = "\improper Mining Substation"

/area/maintenance/substation/bar
	name = "\improper Bar Substation"

/area/maintenance/substation/surface_atmos
	name = "\improper Surface Atmos Substation"


//Hallway

/area/hallway/primary/
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_GENERIC

/area/hallway/primary/fore
	name = "\improper Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "\improper Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "\improper Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "\improper Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central_one
	name = "\improper Central Primary Hallway - Fore"
	icon_state = "hallC1"

/area/hallway/primary/central_two
	name = "\improper Central Primary Hallway - Starboard"
	icon_state = "hallC2"

/area/hallway/primary/central_three
	name = "\improper Central Primary Hallway - Aft"
	icon_state = "hallC3"

/area/hallway/primary/central_four
	name = "\improper Central Primary Hallway - Port"
	icon_state = "hallC4"

/area/hallway/secondary/exit
	name = "\improper Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/construction
	name = "\improper Construction Area"
	icon_state = "construction"

/area/hallway/secondary/entry/fore
	name = "\improper Shuttle Dock Hallway - Mid"
	icon_state = "entry_1"

/area/hallway/secondary/entry/port
	name = "\improper Shuttle Dock Hallway - Port"
	icon_state = "entry_2"

/area/hallway/secondary/entry/starboard
	name = "\improper Shuttle Dock Hallway - Starboard"
	icon_state = "entry_3"

/area/hallway/secondary/entry/aft
	name = "\improper Shuttle Dock Hallway - Aft"
	icon_state = "entry_4"

/area/hallway/secondary/entry/D1
	name = "\improper Shuttle Dock Hallway - Dock One"
	icon_state = "entry_D1"
	base_turf = /turf/space

/area/hallway/secondary/entry/D2
	name = "\improper Shuttle Dock Hallway - Dock Two"
	icon_state = "entry_D2"
	base_turf = /turf/space

/area/hallway/secondary/entry/D2/arrivals
	name = "\improper Shuttle Dock Hallway - Dock Two"
	icon_state = "entry_D2"
	base_turf = /turf/space
	requires_power = 0

/area/hallway/secondary/entry/D3
	name = "\improper Shuttle Dock Hallway - Dock Three"
	icon_state = "entry_D3"
	base_turf = /turf/space

/area/hallway/secondary/entry/D4
	name = "\improper Shuttle Dock Hallway - Dock Four"
	icon_state = "entry_D4"

/area/hallway/secondary/entry/docking_lounge
	name = "\improper Docking Lounge"
	icon_state = "docking_lounge"

/area/hallway/secondary/escape/dock_escape_pod_hallway_port
	name = "\improper Dock Escape Pod Hallway Port"
	icon_state = "dock_escape_pod_hallway_port"

/area/hallway/secondary/escape/dock_escape_pod_hallway_starboard
	name = "\improper Dock Escape Pod Hallway Starboard"
	icon_state = "dock_escape_pod_hallway_starboard"

/area/hallway/secondary/escape/fore_port_escape_pod_hallway
	name = "\improper Fore Port Escape Pod Hallway"
	icon_state = "fore_port_escape_pod_hallway"

/area/hallway/secondary/escape/fore_escape_pod_hallway
	name = "\improper Fore Escape Pod Hallway"
	icon_state = "fore_escape_pod_hallway"

/area/hallway/secondary/escape/medical_escape_pod_hallway
	name = "\improper Medical Escape Pod Hallway"
	icon_state = "medical_escape_pod_hallway"

/area/hallway/secondary/cargo_hallway
	name = "Cargo Hallway"
	icon_state = "cargo_hallway"

/area/hallway/secondary/civilian_hallway_aft
	name = "Civilian Hallway Aft"
	icon_state = "aft_civilian_hallway"

/area/hallway/secondary/civilian_hallway_fore
	name = "Civilian Hallway Fore"
	icon_state = "fore_civilian_hallway"

/area/hallway/secondary/civilian_hallway_mid
	name = "Civilian Hallway Mid"
	icon_state = "mid_civilian_hallway"

/area/hallway/secondary/chapel_hallway
	name = "Chapel Hallway"
	icon_state = "chapel_hallway"

/area/hallway/secondary/cryostorage_hallway
	name = "Cryostorage Hallway"
	icon_state = "cryostorage_hallway"

/area/hallway/secondary/docking_hallway
	name = "Docking Hallway"
	icon_state = "docking_hallway"

/area/hallway/secondary/docking_hallway2
	name = "Secondary Docking Hallway"
	icon_state = "docking_hallway"

/area/hallway/secondary/engineering_hallway
	name = "Engineering Primary Hallway"
	icon_state = "engineering_primary_hallway"

/area/hallway/secondary/eva_hallway
	name = "EVA Hallway"
	icon_state = "eva_hallway"

/area/hallway/secondary/medical_emergency_hallway
	name = "Medical Emergency Hallway"
	icon_state = "medical_emergency_hallway"

/area/hallway/lower/third_south
	name = "Hallway Third Floor South"
	icon_state = "hallC1"

/area/hallway/lower/first_west
	name = "Hallway First Floor West"
	icon_state = "hallC1"

/area/hallway/station
	icon_state = "hallC1"

/area/hallway/station/atrium
	name = "Main Station Atrium"

/area/hallway/station/port
	name = "Main Port Hallway"

/area/hallway/station/starboard
	name = "Main Starboard Hallway"

/area/hallway/station/upper
	name = "Main Upper Hallway"

/area/hallway/station/docks
	name = "Docks Hallway"

//Command

/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = "signal"

/area/bridge/bridge_hallway
	name = "Bridge Hallway"
	icon_state = "bridge"

/area/bridge/meeting_room
	name = "Heads of Staff Meeting Room"
	icon_state = "bridge"
	music = null
	sound_env = MEDIUM_SOFTFLOOR

/area/bridge/office
	name = "Official On-Site Office"
	icon_state = "bridge"
	music = null
	sound_env = MEDIUM_SOFTFLOOR

/area/triumph/station/public_meeting_room
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR

/area/crew_quarters/captain
	name = "Command - Facility Director's Office"
	icon_state = "captain"
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/heads/hop
	name = "Command - HoP's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/hor
	name = "Research - RD's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/chief
	name = "Engineering - CE's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/hos
	name = "Security - HoS' Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/cmo
	name = "Medbay - CMO's Office"
	icon_state = "head_quarters"

/area/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "courtroom"

/area/mint
	name = "Mint"
	icon_state = "green"

/area/comms
	name = "Communications Relay"
	icon_state = "tcomsatcham"

/area/server
	name = "Research Server Room"
	icon_state = "server"

//Civilian

/area/crew_quarters
	name = "Dormitories"
	icon_state = "Sleep"
	flags = RAD_SHIELDED
	ambience = AMBIENCE_GENERIC

/area/crew_quarters/toilet
	name = "Dormitory Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/sleep
	name = "Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_A1
	name = "Apartment A1"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_A2
	name = "\improper Apartment A2"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_A3
	name = "\improper Apartment A3"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_A4
	name = "\improper Apartment A4"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_A5
	name = "\improper Apartment A5"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_A6
	name = "\improper Apartment A6"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_A7
	name = "\improper Apartment A7`"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_A8
	name = "\improper Apartment A8"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_B1
	name = "\improper Apartment B1"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_B2
	name = "\improper Apartment B2"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Apartment_B3
	name = "\improper Apartment B3"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_1
	name = "\improper Dormitory Room 1"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_2
	name = "\improper Dormitory Room 2"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_3
	name = "\improper Dormitory Room 3"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_4
	name = "\improper Dormitory Room 4"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_5
	name = "\improper Dormitory Room 5"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_6
	name = "\improper Dormitory Room 6"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_7
	name = "\improper Dormitory Room 7"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_8
	name = "\improper Dormitory Room 8"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_9
	name = "\improper Dormitory Room 9"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_10
	name = "\improper Dormitory Room 10"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_11
	name = "\improper Dormitory Room 11"
	icon_state = "Sleep"

/area/crew_quarters/showers
	name = "\improper Unisex Showers"
	icon_state = "recreation_area_restroom"

/area/crew_quarters/sleep/maintDorm1
	name = "\improper Construction Dorm 1"
	icon_state = "Sleep"

/area/crew_quarters/sleep/maintDorm2
	name = "\improper Construction Dorm 2"
	icon_state = "Sleep"

/area/crew_quarters/sleep/maintDorm3
	name = "\improper Construction Dorm 3"
	icon_state = "Sleep"

/area/crew_quarters/sleep/maintDorm4
	name = "\improper Construction Dorm 4"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_1/holo
	name = "\improper Dorm 1 Holodeck"
	icon_state = "dk_yellow"

/area/crew_quarters/sleep/Dorm_3/holo
	name = "\improper Dorm 3 Holodeck"
	icon_state = "dk_yellow"

/area/crew_quarters/sleep/Dorm_5/holo
	name = "\improper Dorm 5 Holodeck"
	icon_state = "dk_yellow"

/area/crew_quarters/sleep/Dorm_7/holo
	name = "\improper Dorm 7 Holodeck"
	icon_state = "dk_yellow"

/area/holodeck/holodorm/source_basic
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_desert
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_seating
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_beach
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_garden
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_boxing
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_snow
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_space
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_off
	name = "\improper Holodeck Source"

/area/crew_quarters/sleep/CMO_quarters
	name = "\improper CMO Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep/RD_quarters
	name = "\improper RD Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep/CE_quarters
	name = "\improper CE Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep/HOS_quarters
	name = "\improper HOS Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep/HOP_quarters
	name = "\improper HOP Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_1
	name = "\improper Visitor Room 1"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_2
	name = "\improper Visitor Room 2"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_3
	name = "\improper Visitor Room 3"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_4
	name = "\improper Visitor Room 4"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_5
	name = "\improper Visitor Room 5"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_6
	name = "\improper Visitor Room 6"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_7
	name = "\improper Visitor Room 7"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_8
	name = "\improper Visitor Room 8"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_9
	name = "\improper Visitor Room 9"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_10
	name = "\improper Visitor Room 10"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_11
	name = "\improper Visitor Room 11"
	icon_state = "Sleep"

/area/crew_quarters/sleep/vistor_room_12
	name = "\improper Visitor Room 12"
	icon_state = "Sleep"

/area/crew_quarters/sleep/engi_wash
	name = "\improper Engineering Washroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/sleep/bedrooms
	name = "\improper Dormitory Bedroom One"
	icon_state = "Sleep"
	sound_env = SMALL_SOFTFLOOR

/area/crew_quarters/sleep/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "Sleep"

/area/crew_quarters/sleep/elevator
	name = "\improper Main Elevator"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male
	name = "\improper Male Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male/toilet_male
	name = "\improper Male Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/sleep_female
	name = "\improper Female Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_female/toilet_female
	name = "\improper Female Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/locker
	name = "\improper Locker Room"
	icon_state = "locker"

/area/crew_quarters/locker/locker_toilet
	name = "\improper Locker Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/locker/laundry_arrival
	name = "\improper Arrivals Laundry"

/area/crew_quarters/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"

/area/crew_quarters/longue_area
	name = "\improper Lounge" //VOREStation Edit - Muh speeling.
	icon_state = "recreation_area"

/area/crew_quarters/recreation_area
	name = "\improper Recreation Area"
	icon_state = "recreation_area"

/area/crew_quarters/recreation_area_hallway
	name = "\improper Recreation Area Hallway"
	icon_state = "recreation_area_hallway"

/area/crew_quarters/recreation_area_restroom
	name = "\improper Recreation Area Restroom"
	icon_state = "recreation_area_restroom"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/pool
	name = "\improper Pool"
	icon_state = "pool"

/area/crew_quarters/cafeteria
	name = "\improper Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/coffee_shop
	name = "\improper Coffee Shop"
	icon_state = "coffee_shop"

/area/crew_quarters/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/freezer
	name = "\improper Kitchen Freezer"

/area/crew_quarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR

/area/crew_quarters/barrestroom
	name = "\improper Cafeteria Restroom"
	icon_state = "bar"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/theatre
	name = "\improper Theatre"
	icon_state = "Theatre"
	sound_env = LARGE_SOFTFLOOR

/area/crew_quarters/visitor_lodging
 	name = "\improper Visitor Lodging"
 	icon_state = "visitor_lodging"

/area/crew_quarters/visitor_dining
 	name = "\improper Visitor Dining"
 	icon_state = "visitor_dinning"

/area/crew_quarters/visitor_laundry
 	name = "\improper Visitor Laundry"
 	icon_state = "visitor_laundry"

/area/crew_quarters/lounge
	name = "\improper Lounge"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR

/area/crew_quarters/lounge/kitchen
	name = "\improper Lounge Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/lounge/kitchen_freezer
	name = "\improper Lounge Kitchen Freezer"
	icon_state = "kitchen"

/area/crew_quarters/panic_shelter
	name = "\improper Panic Shelter"

/area/library
	name = "\improper Library"
	icon_state = "library"
	sound_env = LARGE_SOFTFLOOR
	lightswitch = 0

/area/library/study
	name = "\improper Library Private Study"

/area/library_conference_room
 	name = "\improper Library Conference Room"
 	icon_state = "library_conference_room"

/area/chapel
	ambience = AMBIENCE_CHAPEL

/area/chapel/main
	name = "\improper Chapel"
	icon_state = "chapel"
	sound_env = LARGE_ENCLOSED

/area/chapel/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"

/area/chapel/chapel_morgue
	name = "\improper Chapel Morgue"
	icon_state = "chapel_morgue"

/area/lawoffice
	name = "\improper Internal Affairs"
	icon_state = "law"

/area/holodeck_control
	name = "\improper Holodeck Control"
	icon_state = "holodeck_control"

/area/vacant
	flags = RAD_SHIELDED

/area/vacant/vacant_shop
	name = "\improper Vacant Shop"
	icon_state = "vacant_shop"

/area/vacant/vacant_site
	name = "\improper Vacant Site"
	icon_state = "vacant_site"

/area/vacant/vacant_site2
	name = "\improper Abandoned Locker Room"
	icon_state = "vacant_site"

/area/vacant/vacant_restaurant_upper
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"
	flags = null

/area/vacant/vacant_restaurant_lower
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"
	flags = null

/area/vacant/vacant_office
	name = "\improper Vacant Office"
	icon_state = "vacant_site"

/area/vacant/vacant_site/east
	name = "\improper East Base Vacant Site"

/area/vacant/vacant_library
	name = "\improper Atrium Construction Site"

/area/vacant/vacant_bar
	name = "\improper Vacant Bar"

/area/vacant/vacant_bar_upper
	name = "\improper Upper Vacant Bar"

/area/holodeck
	name = "\improper Holodeck"
	icon_state = "Holodeck"
	dynamic_lighting = 0
	sound_env = LARGE_ENCLOSED

/area/holodeck/alphadeck
	name = "\improper Holodeck Alpha"

/area/holodeck/source_plating
	name = "\improper Holodeck - Off"

/area/holodeck/source_emptycourt
	name = "\improper Holodeck - Empty Court"
	sound_env = ARENA

/area/holodeck/source_boxingcourt
	name = "\improper Holodeck - Boxing Court"
	sound_env = ARENA

/area/holodeck/source_basketball
	name = "\improper Holodeck - Basketball Court"
	sound_env = ARENA

/area/holodeck/source_thunderdomecourt
	name = "\improper Holodeck - Thunderdome Court"
	requires_power = 0
	sound_env = ARENA

/area/holodeck/source_courtroom
	name = "\improper Holodeck - Courtroom"
	sound_env = AUDITORIUM

/area/holodeck/source_beach
	name = "\improper Holodeck - Beach"
	sound_env = PLAIN

/area/holodeck/source_burntest
	name = "\improper Holodeck - Atmospheric Burn Test"

/area/holodeck/source_wildlife
	name = "\improper Holodeck - Wildlife Simulation"

/area/holodeck/source_meetinghall
	name = "\improper Holodeck - Meeting Hall"
	sound_env = AUDITORIUM

/area/holodeck/source_theatre
	name = "\improper Holodeck - Theatre"
	sound_env = CONCERT_HALL

/area/holodeck/source_picnicarea
	name = "\improper Holodeck - Picnic Area"
	sound_env = PLAIN

/area/holodeck/source_snowfield
	name = "\improper Holodeck - Snow Field"
	sound_env = FOREST

/area/holodeck/source_desert
	name = "\improper Holodeck - Desert"
	sound_env = PLAIN

/area/holodeck/source_space
	name = "\improper Holodeck - Space"
	has_gravity = 0
	sound_env = SPACE

//Engineering

/area/engineering/
	name = "\improper Engineering"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING

/area/engineering/atmos
	name = "\improper Atmospherics"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_ATMOS
	)

/area/engineering/atmos/backup
	name = "\improper Backup Atmospherics"

/area/engineering/atmos/monitoring
	name = "\improper Atmospherics Monitoring Room"
	icon_state = "atmos_monitoring"
	sound_env = STANDARD_STATION

/area/engineering/atmos/storage
	name = "\improper Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/atmos/processing
	name = "Atmospherics Processing"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED

/area/engineering/atmos/intake
	name = "\improper Atmospherics Intake"
	icon_state = "atmos"
	sound_env = MOUNTAINS

/area/engineering/atmos/hallway
	name = "\improper Atmospherics Main Hallway"

/area/engineering/atmos/locker_room
	name = "\improper Engineering Atmos Locker Room"

/area/engineering/atmos/eva
	name = "\improper Engineering Atmos EVA"

/area/engineering/drone_fabrication
	name = "\improper Engineering Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_room
	name = "\improper Engine Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED

/area/engineering/engine_airlock
	name = "\improper Engine Room Airlock"
	icon_state = "engine"

/area/engineering/engine_monitoring
	name = "\improper Engine Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/engine_waste
	name = "\improper Engine Waste Handling"
	icon_state = "engine_waste"

/area/engineering/engineering_monitoring
	name = "\improper Engineering Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/foyer
	name = "\improper Engineering Foyer"
	icon_state = "engineering_foyer"

/area/engineering/foyer/lower
	name = "\improper Lower Enginering Foyer"

/area/engineering/engine_balcony
	name = "\improper Engine Room Balcony"

/area/engineering/foyer_mezzenine
	name = "\improper Engineering Mezzenine"

/area/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "engineering_storage"

/area/engineering/break_room
	name = "\improper Engineering Break Room"
	icon_state = "engineering_break"
	sound_env = MEDIUM_SOFTFLOOR

/area/engineering/break_room/lower
	name = "\improper Lower Enginering Surface Break Room"

/area/engineering/engine_eva
	name = "\improper Engine EVA"
	icon_state = "engine_eva"

/area/engineering/locker_room
	name = "\improper Engineering Locker Room"
	icon_state = "engineering_locker"

/area/engineering/workshop
	name = "\improper Engineering Workshop"
	icon_state = "engineering_workshop"

/area/engineering/aft_hallway
	name = "\improper Engineering Aft Hallway"
	icon_state = "engineering_aft_hallway"

/area/engineering/engine_gas
	name = "\improper Engine Gas Storage"
	icon_state = "engine_waste"

/area/engineering/engineering_airlock
	name = "\improper Engineering Airlock"
	icon_state = "engine_eva"

/area/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "engineering"

/area/engineering/hallway/lower
	name = "\improper Lower Engineering Hallway"

/area/engineering/shaft
	name = "\improper Engineering Electrical Shaft"
	icon_state = "substation"

/area/engineering/portnacelle
	name = "\improper Port Nacelle"
	icon_state = "engineering"
	sound_env = SMALL_ENCLOSED

/area/engineering/starboardnacelle
	name = "\improper Starboard Nacelle"
	icon_state = "engineering"
	sound_env = SMALL_ENCLOSED


//Solars

/area/solar
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 0
	ambience = AMBIENCE_SPACE

	auxport
		name = "\improper Fore Port Solar Array"
		icon_state = "panelsA"

	auxstarboard
		name = "\improper Fore Starboard Solar Array"
		icon_state = "panelsA"

	fore
		name = "\improper Fore Solar Array"
		icon_state = "yellow"

	aft
		name = "\improper Aft Solar Array"
		icon_state = "aft"

	starboard
		name = "\improper Aft Starboard Solar Array"
		icon_state = "panelsS"

	port
		name = "\improper Aft Port Solar Array"
		icon_state = "panelsP"

/area/maintenance/auxsolarport
	name = "Solar Maintenance - Fore Port"
	icon_state = "SolarcontrolP"
	sound_env = SMALL_ENCLOSED

/area/maintenance/starboardsolar
	name = "Solar Maintenance - Aft Starboard"
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED

/area/maintenance/portsolar
	name = "Solar Maintenance - Aft Port"
	icon_state = "SolarcontrolP"
	sound_env = SMALL_ENCLOSED

/area/maintenance/auxsolarstarboard
	name = "Solar Maintenance - Fore Starboard"
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED

/area/maintenance/foresolar
	name = "Solar Maintenance - Fore"
	icon_state = "SolarcontrolA"
	sound_env = SMALL_ENCLOSED

/area/assembly/chargebay
	name = "\improper Mech Bay"
	icon_state = "mechbay"

/area/assembly/showroom
	name = "\improper Robotics Showroom"
	icon_state = "showroom"

/area/assembly/robotics
	name = "\improper Robotics Lab"
	icon_state = "robotics"

/area/assembly/robotics/surgery
	name = "\improper Robotics Surgery"
	icon_state = "surgery"

/area/assembly/assembly_line //Derelict Assembly Line
	name = "\improper Assembly Line"
	icon_state = "ass_line"
	power_equip = 0
	power_light = 0
	power_environ = 0

//Teleporter

/area/teleporter
	name = "\improper Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/teleporter/departing
	name = "\improper Long-Range Teleporter"

/area/gateway
	name = "\improper Gateway"
	icon_state = "teleporter"
	music = "signal"

/area/gateway/prep_room
	name = "\improper Gateway Prep Room"

/area/AIsattele
	name = "\improper AI Satellite Teleporter Room"
	icon_state = "teleporter"
	music = "signal"

//MedBay

/area/medical
	name = "\improper Medical"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay
	name = "\improper Medbay Hallway - Port"
	icon_state = "medbay"

/area/medical/resleeving
	name = "Resleeving Lab"
	icon_state = "genetics"

//Medbay is a large area, these additional areas help level out APC load.
/area/medical/medbay2
	name = "\improper Medbay Hallway - Starboard"
	icon_state = "medbay2"

/area/medical/medbay3
	name = "\improper Medbay Hallway - Fore"
	icon_state = "medbay3"

/area/medical/medbay4
	name = "\improper Medbay Hallway - Aft"
	icon_state = "medbay4"

/area/medical/biostorage
	name = "\improper Secondary Storage"
	icon_state = "medbay2"

/area/medical/reception
	name = "\improper Medbay Reception"
	icon_state = "medbay"

/area/medical/medbay_emt_bay
	name = "\improper Medical EMT Bay"
	icon_state = "medbay_emt_bay"

/area/medical/medbay_primary_storage
	name = "\improper Medbay Primary Storage"
	icon_state = "medbay_primary_storage"

/area/medical/psych
	name = "\improper Psych Room"
	icon_state = "medbay3"

/area/medical/psych/psych_1
	name = "\improper Psych Room 1"

/area/medical/psych/psych_2
	name = "\improper Psych Room 2"

/area/crew_quarters/medbreak
	name = "\improper Break Room"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/crew_quarters/medbreak/surgery
	name = "\improper Surgeon Break Room"
	icon_state = "medbay2"

/area/crew_quarters/medical_restroom
	name = "\improper Medbay Restroom"
	icon_state = "medbay_restroom"
	ambience = AMBIENCE_ATMOS
	)

/area/medical/patients_rooms
	name = "\improper Patient's Rooms"
	icon_state = "patients"

/area/medical/ward
	name = "\improper Recovery Ward"
	icon_state = "patients"

/area/medical/patient_a
	name = "\improper Patient A"
	icon_state = "medbay_patient_room_a"

/area/medical/patient_b
	name = "\improper Patient B"
	icon_state = "medbay_patient_room_b"

/area/medical/patient_c
	name = "\improper Patient C"
	icon_state = "medbay_patient_room_c"

/area/medical/patient_d
	name = "\improper Patient D"
	icon_state = "medbay_patient_room_d"

/area/medical/patient_e
	name = "\improper Patient E"
	icon_state = "medbay_patient_room_e"

/area/medical/patient_wing
	name = "\improper Patient Wing"
	icon_state = "patients"

/area/medical/cmostore
	name = "\improper Secure Storage"
	icon_state = "CMO"

/area/medical/robotics
	name = "\improper Robotics"
	icon_state = "medresearch"

/area/medical/virology
	name = "\improper Virology"
	icon_state = "virology"

/area/medical/virologyaccess
	name = "\improper Virology Access"
	icon_state = "virology"

/area/medical/virologyisolation
	name = "\improper Virology Isolation"
	icon_state = "virology"

/area/medical/recoveryrestroom
	name = "\improper Recovery Room Restroom"
	icon_state = "virology"

/area/medical/morgue
	name = "\improper Morgue"
	icon_state = "morgue"

/area/medical/chemistry
	name = "\improper Chemistry"
	icon_state = "chem"

/area/medical/surgery
	name = "\improper Operating Theatre 1"
	icon_state = "surgery"

/area/medical/surgery2
	name = "\improper Operating Theatre 2"
	icon_state = "surgery"

/area/medical/surgeryobs
	name = "\improper Operation Observation Room"
	icon_state = "surgery"

/area/medical/genetics
	name = "\improper Genetics Lab"
	icon_state = "genetics"
/area/medical/surgeryprep
	name = "\improper Pre-Op Prep Room"
	icon_state = "surgery"

/area/medical/surgery_hallway
	name = "\improper Surgery Hallway"
	icon_state = "surgery_hallway"

/area/medical/surgery_storage
	name = "\improper Surgery Storage"
	icon_state = "surgery_storage"

/area/medical/cryo
	name = "\improper Cryogenics"
	icon_state = "cryo"

/area/medical/exam_room
	name = "\improper Exam Room"
	icon_state = "exam_room"

/area/medical/exam_room/exam_1
	name = "\improper Exam Room 1"

/area/medical/exam_room/exam_2
	name = "\improper Exam Room 2"

/area/medical/genetics_cloning
	name = "\improper Cloning Lab"
	icon_state = "cloning"

/area/medical/sleeper
	name = "\improper Emergency Treatment Centre"
	icon_state = "exam_room"

/area/medical/first_aid_station_starboard
	name = "\improper Starboard First-Aid Station"
	icon_state = "medbay2"

/area/medical/first_aid_station
	name = "\improper Port First-Aid Station"
	icon_state = "medbay2"

/area/medical/psych_ward
	name = "\improper Psych Ward"
	icon_state = "psych_ward"

//Security

/area/security/main
	name = "\improper Security Office"
	icon_state = "security"

/area/security/lobby
	name = "\improper Security Lobby"
	icon_state = "security"

/area/security/brig
	name = "\improper Security - Brig"
	icon_state = "brig"

/area/security/brig/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/security/prison
	name = "\improper Security - Prison Wing"
	icon_state = "sec_prison"

/area/security/prison/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/security/warden
	name = "\improper Security - Warden's Office"
	icon_state = "Warden"

/area/security/armoury
	name = "\improper Security - Armory"
	icon_state = "armory"
	ambience = AMBIENCE_HIGHSEC
	flags = BLUE_SHIELDED

/area/security/briefing_room
	name = "\improper Security - Briefing Room"
	icon_state = "brig"

/area/security/evidence_storage
	name = "\improper Security - Equipment Storage"
	icon_state = "security_equipment_storage"

/area/security/evidence_storage
	name = "\improper Security - Evidence Storage"
	icon_state = "evidence_storage"

/area/security/interrogation
	name = "\improper Security - Interrogation"
	icon_state = "interrogation"

/area/security/riot_control
	name = "\improper Security - Riot Control"
	icon_state = "riot_control"

/area/security/detectives_office
	name = "\improper Security - Forensic Office"
	icon_state = "detective"
	sound_env = MEDIUM_SOFTFLOOR

/area/security/range
	name = "\improper Security - Firing Range"
	icon_state = "firingrange"

/area/security/security_aid_station
	name = "\improper Security - Security Aid Station"
	icon_state = "security_aid_station"

/area/security/security_bathroom
	name = "\improper Security - Restroom"
	icon_state = "security_bathroom"
	sound_env = SMALL_ENCLOSED

/area/security/security_cell_hallway
	name = "\improper Security - Cell Hallway"
	icon_state = "security_cell_hallway"

/area/security/security_equiptment_storage
	name = "\improper Security - Equipment Storage"
	icon_state = "security_equip_storage"

/area/security/security_lockerroom
	name = "\improper Security - Locker Room"
	icon_state = "security_lockerroom"

/area/security/security_processing
	name = "\improper Security - Security Processing"
	icon_state = "security_processing"

/area/security/tactical
	name = "\improper Security - Tactical Equipment"
	icon_state = "Tactical"
	ambience = AMBIENCE_HIGHSEC
	flags = BLUE_SHIELDED

/area/security/hallway
	name = "\improper Security Hallway"
	icon_state = "security"

/area/security/hallwayaux
	name = "\improper Security Armory Hallway"
	icon_state = "security"

/area/security/forensics
	name = "\improper Forensics Lab"
	icon_state = "security"

/area/security/breakroom
	name = "\improper Security Breakroom"
	icon_state = "security"

/area/security/brig/visitation
	name = "\improper Visitation"
	icon_state = "security"

/area/security/brig/bathroom
	name = "\improper Brig Bathroom"
	icon_state = "security"

/area/security/armory/blue
	name = "\improper Armory - Blue"
	icon_state = "armory"

/area/security/armory/red
	name = "\improper Armory - Red"
	icon_state = "red2"

/area/security/observation
	name = "\improper Brig Observation"
	icon_state = "riot_control"

/area/security/eva
	name = "\improper Security EVA"
	icon_state = "security_equip_storage"

/area/security/recstorage
	name = "\improper Brig Recreation Storage"
	icon_state = "brig"

/area/security/training
	name = "\improper Training & Briefing Room"
	icon_state = "security"

/area/security/hanger
	name = "\improper Security Hanger"
	icon_state = "security_equip_storage"

/area/security/visitor
	name = "\improper Security Visitor Room"
	icon_state = "security"


/*
	New()
		..()

		spawn(10) //let objects set up first
			for(var/turf/turfToGrayscale in src)
				if(turfToGrayscale.icon)
					var/icon/newIcon = icon(turfToGrayscale.icon)
					newIcon.GrayScale()
					turfToGrayscale.icon = newIcon
				for(var/obj/objectToGrayscale in turfToGrayscale) //1 level deep, means tables, apcs, locker, etc, but not locker contents
					if(objectToGrayscale.icon)
						var/icon/newIcon = icon(objectToGrayscale.icon)
						newIcon.GrayScale()
						objectToGrayscale.icon = newIcon
*/

/area/security/nuke_storage
	name = "\improper Vault"
	icon_state = "nuke_storage"
	ambience = AMBIENCE_HIGHSEC
	flags = BLUE_SHIELDED

/area/security/checkpoint
	name = "\improper Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint2
	name = "\improper Security - Arrival Checkpoint"
	icon_state = "security"
	ambience = AMBIENCE_ARRIVALS

/area/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint1"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint1"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint1"

/area/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint1"

/area/security/vacantoffice
	name = "\improper Vacant Office"
	icon_state = "security"

/area/security/vacantoffice2
	name = "\improper Vacant Office"
	icon_state = "security"

/area/janitor/
	name = "\improper Custodial Closet"
	icon_state = "janitor"

/area/hydroponics
	name = "\improper Hydroponics"
	icon_state = "hydro"

/area/hydroponics/cafegarden
	name = "\improper Cafeteria Garden"
	icon_state = "cafe_garden"

/area/hydroponics/garden
	name = "\improper Garden"
	icon_state = "garden"

// SUPPLY

/area/quartermaster
	name = "\improper Quartermasters"
	icon_state = "quart"

/area/quartermaster/office
	name = "\improper Cargo Office"
	icon_state = "quartoffice"

/area/quartermaster/storage
	name = "\improper Cargo Bay"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/quartermaster/foyer
	name = "\improper Cargo Bay Foyer"
	icon_state = "quartstorage"

/area/quartermaster/warehouse
	name = "\improper Cargo Warehouse"
	icon_state = "quartstorage"

/area/quartermaster/qm
	name = "\improper Cargo - Quartermaster's Office"
	icon_state = "quart"

/area/quartermaster/delivery
	name = "\improper Cargo - Delivery Office"
	icon_state = "quart"

/area/quartermaster/miningdock
	name = "\improper Cargo Mining Dock"
	icon_state = "mining"

/area/quartermaster/belterdock
	name = "\improper Cargo Belter Access"
	icon_state = "mining"

// SCIENCE

/area/rnd/research
	name = "\improper Research and Development"
	icon_state = "research"

/area/rnd/research_foyer
	name = "\improper Research Foyer"
	icon_state = "research_foyer"

/area/rnd/research_foyer_auxiliary
	name = "\improper Research Foyer Auxiliary"
	icon_state = "research_foyer_aux"

/area/rnd/research_restroom
	name = "\improper Research Restroom"
	icon_state = "research_restroom"
	sound_env = SMALL_ENCLOSED

/area/rnd/research_storage
	name = "\improper Research Storage"
	icon_state = "research_storage"

/area/rnd/docking
	name = "\improper Research Dock"
	icon_state = "research_dock"

/area/rnd/lab
	name = "\improper Research Lab"
	icon_state = "toxlab"

/area/rnd/rdoffice
	name = "\improper Research Director's Office"
	icon_state = "head_quarters"

/area/rnd/supermatter
	name = "\improper Supermatter Lab"
	icon_state = "toxlab"

/area/rnd/xenobiology
	name = "\improper Xenobiology Lab"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/xenoflora_storage
	name = "\improper Xenoflora Storage"
	icon_state = "xeno_f_store"

/area/rnd/xenobiology/xenoflora
	name = "\improper Xenoflora Lab"
	icon_state = "xeno_f_lab"

/area/rnd/xenobiology/xenoflora/lab_atmos
	name = "\improper Xenoflora Atmospherics Lab"

/area/rnd/storage
	name = "\improper Toxins Storage"
	icon_state = "toxstorage"

/area/rnd/test_area
	name = "\improper Toxins Test Area"
	icon_state = "toxtest"

/area/rnd/mixing
	name = "\improper Toxins Mixing Room"
	icon_state = "toxmix"

/area/rnd/misc_lab
	name = "\improper Miscellaneous Research"
	icon_state = "toxmisc"

/area/rnd/workshop
	name = "\improper Workshop"
	icon_state = "sci_workshop"

/area/toxins/server
	name = "\improper Server Room"
	icon_state = "server"

/area/rnd/research/testingrange
	name = "\improper Weapons Testing Range"
	icon_state = "firingrange"

/area/rnd/outpost
	name = "\improper Research Outpost Hallway"
	icon_state = "research"

/area/rnd/breakroom
	name = "\improper Research Break Room"
	icon_state = "research"

/area/rnd/reception_desk
	name = "\improper Research Reception Desk"
	icon_state = "research"

/area/rnd/lockers
	name = "\improper Research Locker Room"
	icon_state = "research"

/area/rnd/external
	name = "\improper Research External Access"
	icon_state = "research"

/area/rnd/hallway
	name = "\improper Research Lower Hallway"
	icon_state = "research"

/area/rnd/anomaly_lab
	name = "\improper Anomaly Lab"
	icon_state = "research"

/area/rnd/anomaly_lab/containment_one
	name = "\improper Anomaly Lab - Containment One"
	icon_state = "research"

/area/rnd/anomaly_lab/containment_two
	name = "\improper Anomaly Lab - Containment Two"
	icon_state = "research"

/area/rnd/xenoarch_storage
	name = "\improper Xenoarch Storage"
	icon_state = "research"

// Research Outpost
/area/rnd/outpost/airlock
	name = "\improper Research Outpost Airlock"
	icon_state = "green"

/area/rnd/outpost/eva
	name = "Research Outpost EVA Storage"
	icon_state = "eva"

/area/rnd/outpost/chamber
	name = "\improper Research Outpost Burn Chamber"
	icon_state = "engine"

/area/rnd/outpost/atmos
	name = "Research Outpost Atmospherics"
	icon_state = "atmos"

/area/rnd/outpost/storage
	name = "\improper Research Outpost Gas Storage"
	icon_state = "toxstorage"

/area/rnd/outpost/mixing
	name = "\improper Research Outpost Gas Mixing"
	icon_state = "toxmix"

/area/rnd/outpost/heating
	name = "\improper Research Outpost Gas Heating"
	icon_state = "toxmix"

/area/rnd/outpost/testing_lab
	name = "\improper Research Outpost Testing Lab"
	icon_state = "toxtest"

/area/rnd/outpost/hallway/resarch_outpost_northern_hallway
	name = "\improper Outpost - Northern Hallway"
	icon_state = "dk_yellow"

/area/rnd/outpost/hallway/resarch_outpost_eastern_hallway
	name = "\improper Outpost - Eastern Hallway"
	icon_state = "dk_yellow"

/area/rnd/outpost/hallway/resarch_outpost_southern_hallway
	name = "\improper Outpost - Southern Hallway"
	icon_state = "dk_yellow"

/area/rnd/outpost/hallway/resarch_outpost_western_hallway
	name = "\improper Outpost - Western Hallway"
	icon_state = "dk_yellow"

/area/rnd/outpost/hallway/resarch_outpost_storage_hallway
	name = "\improper Outpost - Hallway Storage"
	icon_state = "dk_yellow"

/area/rnd/outpost/crew_quarters/sleep/Dorm_1
	name = "\improper Outpost - Dorms 1"
	icon_state = "Sleep"

/area/rnd/outpost/crew_quarters/sleep/Dorm_2
	name = "\improper Outpost - Dorms 2"
	icon_state = "Sleep"

/area/rnd/outpost/crew_quarters/sleep/Dorm_3
	name = "\improper Outpost - Dorms 3"
	icon_state = "Sleep"

/area/rnd/outpost/medical/first_aid_south_west
	name = "\improper Outpost - First Aid South West"
	icon_state = "blue"

/area/rnd/outpost/storage/tools
	name = "\improper Outpost - Tool Storage"
	icon_state = "storage"

/area/rnd/outpost/toxins_canister_icyhoot
	name = "\improper Toxins Lab - Canister Heating and Cooling"
	icon_state = "research"

/area/rnd/outpost/simulator
	name = "\improper Toxins Lab - Explosive Effect Simulator"
	icon_state = "research"

/area/rnd/outpost/toxins_burn_chamber
	name = "\improper Toxins Lab - Burn Chamber"
	icon_state = "research"

/area/rnd/outpost/engineering/eva_atmospherics
	name = "\improper Outpost - EVA-Atmospherics"
	icon_state = "green"

/area/rnd/outpost/storage/surface_eva
	name = "\improper Outpost - Surface EVA"
	icon_state = "green"

/area/rnd/outpost/storage/surface_eva_storage
	name = "\improper Outpost - Surface EVA Storage"
	icon_state = "green"

/area/rnd/outpost/substation
	name = "\improper Outpost - Substation"

/area/rnd/outpost/breakroom
	name = "\improper Outpost - Breakroom"
	icon_state = "research"

/area/rnd/outpost/crew_quarters/showers
	name = "\improper Outpost - Crew Showers"
	icon_state = "recreation_area_restroom"

/area/rnd/outpost/materials_lab
	name = "\improper Outpost - Materials Lab"
	icon_state = "red"

/area/rnd/outpost/telescience_lab
	name = "\improper Outpost - Telescience Lab"
	icon_state = "yellow"

/area/rnd/outpost/toxins_mixing_lab
	name = "\improper Outpost - Toxins Lab"
	icon_state = "purple"

/area/rnd/outpost/atmospherics
	name = "\improper Outpost - Atmospherics"
	icon_state = "research"

/area/rnd/outpost/materials_chamber
	name = "\improper Materials - Chamber"
	icon_state = "red"

//Storage

/area/storage/tools
	name = "Auxiliary Tool Storage"
	icon_state = "storage"

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/storage/art
	name = "Art Supply Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/surface_eva
	icon_state = "storage"
	name = "\improper Surface EVA"

/area/storage/surface_eva/external
	name = "\improper Surface EVA Access"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency_storage/emergency
	name = "Starboard Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency_storage/emergency2
	name = "Port Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency_storage/emergency3
	name = "Central Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency_storage/emergency4
	name = "Civilian Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency_storage/emergency5
	name = "Dock Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency_storage/emergency6
	name = "Cargo Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = 0
	name = "\improper Test Room"
	icon_state = "storage"

//DJSTATION

/area/djstation
	name = "\improper Listening Post"
	icon_state = "LP"
	ambience = AMBIENCE_TECH_RUINS

/area/djstation/solars
	name = "\improper Listening Post Solars"
	icon_state = "LPS"
	ambience = AMBIENCE_TECH_RUINS

//DERELICT

/area/derelict
	name = "\improper Derelict Station"
	icon_state = "storage"
	ambience = AMBIENCE_RUINS

/area/derelict/hallway/primary
	name = "\improper Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "\improper Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "\improper Derelict Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "\improper Derelict Control Room"
	icon_state = "bridge"

/area/derelict/secret
	name = "\improper Derelict Secret Room"
	icon_state = "library"

/area/derelict/bridge/access
	name = "Derelict Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "\improper Derelict Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "\improper Derelict Solar Control"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "\improper Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "\improper Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "\improper Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "\improper Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/ship
	name = "\improper Abandoned Ship"
	icon_state = "yellow"

/area/solar/derelict_starboard
	name = "\improper Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "\improper Derelict Aft Solar Array"
	icon_state = "aft"

/area/derelict/singularity_engine
	name = "\improper Derelict Singularity Engine"
	icon_state = "engine"

//HALF-BUILT STATION (REPLACES DERELICT IN BAYCODE, ABOVE IS LEFT FOR DOWNSTREAM)

/area/shuttle/constructionsite
	name = "\improper Construction Site Shuttle"
	icon_state = "yellow"
	dynamic_lighting = 0
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen

/area/shuttle/constructionsite/station
	name = "\improper Construction Site Shuttle"

/area/shuttle/constructionsite/site
	name = "\improper Construction Site Shuttle"

/area/constructionsite
	name = "\improper Construction Site"
	icon_state = "storage"

/area/constructionsite/storage
	name = "\improper Construction Site Storage Area"

/area/constructionsite/science
	name = "\improper Construction Site Research"

/area/constructionsite/bridge
	name = "\improper Construction Site Bridge"
	icon_state = "bridge"

/area/constructionsite/maintenance
	name = "\improper Construction Site Maintenance"
	icon_state = "yellow"

/area/constructionsite/hallway/aft
	name = "\improper Construction Site Aft Hallway"
	icon_state = "hallP"

/area/constructionsite/hallway/fore
	name = "\improper Construction Site Fore Hallway"
	icon_state = "hallS"

/area/constructionsite/atmospherics
	name = "\improper Construction Site Atmospherics"
	icon_state = "green"

/area/constructionsite/medical
	name = "\improper Construction Site Medbay"
	icon_state = "medbay"

/area/constructionsite/ai
	name = "\improper Construction Computer Core"
	icon_state = "ai"

/area/constructionsite/engineering
	name = "\improper Construction Site Engine Bay"
	icon_state = "engine"

/area/solar/constructionsite
	name = "\improper Construction Site Solars"
	icon_state = "aft"

/area/constructionsite/teleporter
	name = "Construction Site Teleporter"
	icon_state = "yellow"


//area/constructionsite
//	name = "\improper Construction Site Shuttle"

//area/constructionsite
//	name = "\improper Construction Site Shuttle"


//Construction

/area/construction
	name = "\improper Engineering Construction Area"
	icon_state = "yellow"

/area/construction/supplyshuttle
	name = "\improper Supply Shuttle"
	icon_state = "yellow"

/area/construction/quarters
	name = "\improper Engineer's Quarters"
	icon_state = "yellow"

/area/construction/qmaint
	name = "Maintenance"
	icon_state = "yellow"

/area/construction/hallway
	name = "\improper Hallway"
	icon_state = "yellow"

/area/construction/solars
	name = "\improper Solar Panels"
	icon_state = "yellow"

/area/construction/solarscontrol
	name = "\improper Solar Panel Control"
	icon_state = "yellow"

/area/construction/Storage
	name = "Construction Site Storage"
	icon_state = "yellow"

/area/construction/observation
	name = "\improper Abandoned Observation Lounge"
	icon_state = "yellow"

//AI

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"
	ambience = AMBIENCE_HIGHSEC

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency/eva
	name = "Emergency EVA"
	icon_state = "storage"

/area/ai_upload
	name = "\improper AI Upload Chamber"
	icon_state = "ai_upload"
	ambience = AMBIENCE_AI

/area/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_AI

/area/ai_server_room
	name = "Messaging Server Room"
	icon_state = "ai_server"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_AI

/area/ai
	name = "\improper AI Chamber"
	icon_state = "ai_chamber"
	ambience = AMBIENCE_AI

/area/ai/foyer
	name = "\improper AI Core Access"

/area/ai_cyborg_station
	name = "\improper Cyborg Station"
	icon_state = "ai_cyborg"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_AI

/area/aisat
	name = "\improper AI Satellite"
	icon_state = "ai"
	ambience = AMBIENCE_AI

/area/aisat_interior
	name = "\improper AI Satellite"
	icon_state = "ai"
	ambience = AMBIENCE_AI // The lack of inheritence hurts my soul.

/area/AIsatextFP
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	dynamic_lighting = 0
	ambience = AMBIENCE_AI

/area/AIsatextFS
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	dynamic_lighting = 0
	ambience = AMBIENCE_AI

/area/AIsatextAS
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	dynamic_lighting = 0
	ambience = AMBIENCE_AI

/area/AIsatextAP
	name = "\improper AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	dynamic_lighting = 0
	ambience = AMBIENCE_AI

/area/NewAIMain
	name = "\improper AI Main New"
	icon_state = "storage"
	ambience = AMBIENCE_AI



//Misc

/area/alien
	name = "\improper Alien base"
	icon_state = "yellow"
	flags = RAD_SHIELDED
	requires_power = 0

/area/alien/unknown
	icon_state = "red2"
/area/alien/unknown/dorm1
	name = "Unknown Dorm 1"
/area/alien/unknown/dorm2
	name = "Unknown Dorm 2"
/area/alien/unknown/dorm3
	name = "Unknown Dorm 3"
/area/alien/unknown/dorm4
	name = "Unknown Dorm 4"

/area/beach
	name = "Keelin's private beach"
	icon_state = "yellow"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = 0

/area/wreck
	ambience = AMBIENCE_RUINS

/area/wreck/ai
	name = "\improper AI Chamber"
	icon_state = "ai"
	ambience = AMBIENCE_TECH_RUINS

/area/wreck/main
	name = "\improper Wreck"
	icon_state = "storage"

/area/wreck/engineering
	name = "\improper Power Room"
	icon_state = "engine"
	ambience = AMBIENCE_TECH_RUINS

/area/wreck/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	ambience = AMBIENCE_TECH_RUINS

/area/generic
	name = "Unknown"
	icon_state = "storage"

/area/bigship
	name = "Bigship"
	requires_power = 0
	flags = RAD_SHIELDED
	sound_env = SMALL_ENCLOSED
	base_turf = /turf/space
	icon_state = "red2"

/area/bigship/teleporter
	name = "Bigship Teleporter Room"

/area/houseboat
	name = "Small Cruiser"
	requires_power = 0
	flags = RAD_SHIELDED
	base_turf = /turf/space
	icon_state = "red2"
	lightswitch = TRUE

/area/houseboat/holodeck_area
	name = "Small Cruiser - Holodeck"
	icon_state = "blue2"

/area/houseboat/holodeck
	name = "Don't use this"
	icon_state = "blue2"
/area/houseboat/holodeck/off
	name = "Small Cruiser Holo - Off"
/area/houseboat/holodeck/beach
	name = "Small Cruiser Holo - Beach"
/area/houseboat/holodeck/snow
	name = "Small Cruiser Holo - Snow"
/area/houseboat/holodeck/desert
	name = "Small Cruiser Holo - Desert"
/area/houseboat/holodeck/picnic
	name = "Small Cruiser Holo - Picnic"
/area/houseboat/holodeck/thunderdome
	name = "Small Cruiser Holo - Thunderdome"
/area/houseboat/holodeck/basketball
	name = "Small Cruiser Holo - Basketball"
/area/houseboat/holodeck/gaming
	name = "Small Cruiser Holo - Gaming Table"
/area/houseboat/holodeck/space
	name = "Small Cruiser Holo - Space"
/area/houseboat/holodeck/bunking
	name = "Small Cruiser Holo - Bunking"

// Telecommunications Satellite
/area/tcommsat/
	ambience = AMBIENCE_ENGINEERING

/area/tcommsat/entrance
	name = "\improper Telecomms Teleporter"
	icon_state = "tcomsatentrance"

/area/tcommsat/chamber
	name = "\improper Telecomms Central Compartment"
	icon_state = "tcomsatcham"

/area/tcomsat
	name = "\improper Telecomms Satellite"
	icon_state = "tcomsatlob"
	ambience = AMBIENCE_ENGINEERING

/area/tcomfoyer
	name = "\improper Telecomms Foyer"
	icon_state = "tcomsatfoyer"
	ambience = AMBIENCE_ENGINEERING

/area/tcomwest
	name = "\improper Telecommunications Satellite West Wing"
	icon_state = "tcomsatwest"
	ambience = AMBIENCE_ENGINEERING

/area/tcomeast
	name = "\improper Telecommunications Satellite East Wing"
	icon_state = "tcomsateast"
	ambience = AMBIENCE_ENGINEERING

/area/tcommsat/computer
	name = "\improper Telecomms Control Room"
	icon_state = "tcomsatcomp"

/area/tcommsat/lounge
	name = "\improper Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"

/area/tcommsat/powercontrol
	name = "\improper Telecommunications Power Control"
	icon_state = "tcomsatwest"


//Exploration areas
/area/exploration
	name = "\improper Exploration Foyer"
	icon_state = "purple"

/area/exploration/excursion_dock
	name = "\improper Excursion Shuttle Dock"
	icon_state = "hangar"

/area/exploration/explorer_prep
	name = "\improper Explorer Prep Room"
	icon_state = "locker"

/area/exploration/meeting
	name = "\improper Explorer Meeting Room"
	icon_state = "northeast"

/area/exploration/showers
	name = "\improper Explorer Showers"
	icon_state = "restrooms"

/area/exploration/medical
	name = "\improper Exploration Med Station"
	icon_state = "medbay"

/area/exploration/pathfinder_office
	name = "\improper Pathfinder's Office"


//Elevator areas
// Used for creating the exchange areas.
/area/turbolift
	name = "Turbolift"
	base_turf = /turf/simulated/open
	requires_power = 0
	sound_env = SMALL_ENCLOSED

	var/lift_floor_label = null
	var/lift_floor_name = null
	var/lift_announce_str = "Ding!"
	var/arrival_sound = 'sound/machines/ding.ogg'
	var/delay_time = 2 SECONDS
	forced_ambience = list('sound/music/elevator.ogg')
	dynamic_lighting = FALSE //Temporary fix for elevator lighting

	requires_power = FALSE

/area/turbolift/t_ship/level1
	name = "Deck 1"
	lift_floor_label = "Deck 1"
	lift_floor_name = "Engineering, Reactor, Telecomms, Trash Pit, Atmospherics"
	lift_announce_str = "Arriving at Deck 1."
	base_turf = /turf/simulated/floor/plating


/area/turbolift/t_ship/level2
	name = "Deck 2"
	lift_floor_label = "Deck 2"
	lift_floor_name = "Dorms, Cargo, Mining, Bar, Cafe, Solars, Shops"
	lift_announce_str = "Arriving at Deck 2."

/area/turbolift/t_ship/level3
	name = "Deck 3"
	lift_floor_label = "Deck 3"
	lift_floor_name = "Medical, Science, Holo Deck, Teleporter"
	lift_announce_str = "Arriving at Deck 3."

/area/turbolift/t_ship/level4
	name = "Deck 4"
	lift_floor_label = "Deck 4"
	lift_floor_name = "Exploration, Arrivals & Departures, Security, Command, Chapel, Sauna, Docking Arm, Library, Garden, Tool Storage"
	lift_announce_str = "Arriving at Deck 4."


//Debug/Code areas

/area/airtunnel1/	// referenced in airtunnel.dm:759

/area/dummy/		// Referenced in engine.dm:261

/area/triumph/surfacebase
	name = "Triumph Debug Surface"

/area/triumph/transit
	name = "Triumph Debug Transit"
	requires_power = 0

/area/triumph/space
	name = "Triumph Debug Space"
	requires_power = 0


//Z-Transit areas (Stairs, elevators, automated shuttles)
/area/station/stairs_one
	name = "\improper Station Stairwell First Floor"
	icon_state = "dk_yellow"
/area/station/stairs_two
	name = "\improper Station Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/triumph/station/stairs_three
	name = "\improper Station Stairwell Third Floor"
	icon_state = "dk_yellow"

/area/triumph/station/stairs_four
	name = "\improper Station Stairwell Fourth Floor"
	icon_state = "dk_yellow"
/area/triumph/station/dock_one
	name = "\improper Dock One"
	icon_state = "dk_yellow"
/area/triumph/station/dock_two
	name = "\improper Dock Two"
	icon_state = "dk_yellow"

/////////////////////////////////////////////////////////////////////
/*
 Lists of areas to be used with is_type_in_list.
 Used in gamemodes code at the moment. --rastaf0
*/

// CENTCOM
var/list/centcom_areas = list (
	/area/centcom,
	/area/shuttle/escape/centcom,
	/area/shuttle/escape_pod1/centcom,
	/area/shuttle/escape_pod2/centcom,
	/area/shuttle/escape_pod3/centcom,
	/area/shuttle/escape_pod5/centcom,
	/area/shuttle/transport1/centcom,
	/area/shuttle/administration/centcom,
	/area/shuttle/specops/centcom,
)

//SPACE STATION 13
var/list/the_station_areas = list (
	/area/shuttle/arrival,
	/area/shuttle/escape/station,
	/area/shuttle/escape_pod1/station,
	/area/shuttle/escape_pod2/station,
	/area/shuttle/escape_pod3/station,
	/area/shuttle/escape_pod5/station,
	/area/shuttle/mining/station,
	/area/shuttle/transport1/station,
	// /area/shuttle/transport2/station,
	/area/shuttle/prison/station,
	/area/shuttle/administration/station,
	/area/shuttle/specops/station,
	/area/maintenance,
	/area/hallway,
	/area/bridge,
	/area/crew_quarters,
	/area/holodeck,
	/area/mint,
	/area/library,
	/area/chapel,
	/area/lawoffice,
	/area/engineering,
	/area/solar,
	/area/assembly,
	/area/teleporter,
	/area/medical,
	/area/security,
	/area/quartermaster,
	/area/janitor,
	/area/hydroponics,
	/area/rnd,
	/area/storage,
	/area/construction,
	/area/ai_monitored/storage/eva,
	/area/ai_monitored/storage/secure,
	/area/ai_monitored/storage/emergency,
	/area/ai_upload,
	/area/ai_upload_foyer,
	/area/ai
)
