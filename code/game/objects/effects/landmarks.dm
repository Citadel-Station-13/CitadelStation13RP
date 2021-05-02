/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 100
	var/delete_me = 0

/obj/effect/landmark/New()
	..()
	tag = text("landmark*[]", name)
	invisibility = 101

	switch(name)			//some of these are probably obsolete
		if("monkey")
			monkeystart += loc
			delete_me = 1
			return
		if("start")
			newplayer_start += loc
			delete_me = 1
			return
		if("JoinLate") // Bit difference, since we need the spawn point to move.
			latejoin += src
		//	delete_me = 1
			return
		if("JoinLateGateway")
			latejoin_gateway += loc
			delete_me = 1
			return
		if("JoinLateElevator")
			latejoin_elevator += loc
			delete_me = 1
			return
		if("JoinLateCryo")
			latejoin_cryo += loc
			delete_me = 1
			return
		if("JoinLateCyborg")
			latejoin_cyborg += loc
			delete_me = 1
			return
		if("prisonwarp")
			prisonwarp += loc
			delete_me = 1
			return
		if("Holding Facility")
			holdingfacility += loc
		if("tdome1")
			tdome1 += loc
		if("tdome2")
			tdome2 += loc
		if("tdomeadmin")
			tdomeadmin += loc
		if("tdomeobserve")
			tdomeobserve += loc
		if("prisonsecuritywarp")
			prisonsecuritywarp += loc
			delete_me = 1
			return
		if("blobstart")
			blobstart += loc
			delete_me = 1
			return
		if("xeno_spawn")
			xeno_spawn += loc
			delete_me = 1
			return
		if("endgame_exit")
			endgame_safespawns += loc
			delete_me = 1
			return
		if("bluespacerift")
			endgame_exits += loc
			delete_me = 1
			return
		if("lavaland_entry")
			lavaland_entry += loc
			delete_me = 1
			return
		if("lavaland_exit")
			lavaland_exit += loc
			delete_me = 1
			return
	GLOB.landmarks_list += src
	return 1

/obj/effect/landmark/proc/delete()
	delete_me = 1

/obj/effect/landmark/Initialize()
	. = ..()
	if(delete_me)
		return INITIALIZE_HINT_QDEL

/obj/effect/landmark/Destroy(var/force = FALSE)
	if(delete_me || force)
		GLOB.landmarks_list -= src
		return ..()
	return QDEL_HINT_LETMELIVE

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/effect/landmark/start/New()
	..()
	tag = "start*[name]"
	invisibility = 101

	return 1

//Roundstart job landmarks for mapping. Why the fuck weren't these here to begin with and why is this so aids.
/obj/effect/landmark/default
	name = "FUCK"
	delete_me = 1

/obj/effect/landmark/default/New()
	latejoin += loc // Register this turf as fallback latejoin.
	..()

/obj/effect/landmark/late
	name = "JoinLate"

/obj/effect/landmark/late/lategateway
	name = "JoinLateGateway"

/obj/effect/landmark/late/lateelevator
	name = "JoinLateElevator"

/obj/effect/landmark/late/latecryo
	name = "JoinLateCryo"

/obj/effect/landmark/late/latecyborg
	name = "JoinLateCyborg"

/obj/effect/landmark/late/lateobserver
	name = "Observer-Start"

/obj/effect/landmark/holdingfacility
	name = "Holding Facility"

/obj/effect/landmark/monkey
	name = "monkey"

/obj/effect/landmark/prison
	name = "prisonwarp"

/obj/effect/landmark/thunderdome
	name = "tdomeobserve"

/obj/effect/landmark/thunderdome/one
	name = "tdome1"

/obj/effect/landmark/thunderdome/two
	name = "tdome2"

/obj/effect/landmark/thunderdome/admin
	name = "tdomeadmin"

/obj/effect/landmark/antags/blob
	name = "blobstart"

/obj/effect/landmark/antags/xeno
	name = "xeno_spawn"

/obj/effect/landmark/endgame
	name = "endgame_exit"

/obj/effect/landmark/endgameexit
	name = "bluespacerift"

/obj/effect/landmark/start/jobs/heads/captain
	name = "Facility Director"

/obj/effect/landmark/start/jobs/heads/hop
	name = "Head of Personnel"

/obj/effect/landmark/start/jobs/heads/hos
	name = "Head of Security"

/obj/effect/landmark/start/jobs/heads/ce
	name = "Chief Engineer"

/obj/effect/landmark/start/jobs/heads/rd
	name = "Research Director"

/obj/effect/landmark/start/jobs/heads/cmo
	name = "Chief Medical Officer"

/obj/effect/landmark/start/jobs/secretary
	name = "Command Secretary"

/obj/effect/landmark/start/jobs/engineer
	name = "Station Engineer"

/obj/effect/landmark/start/jobs/atmostech
	name = "Atmospheric Technician"

/obj/effect/landmark/start/jobs/doctor
	name = "Medical Doctor"

/obj/effect/landmark/start/jobs/geneticist
	name = "Geneticist"

/obj/effect/landmark/start/jobs/psyche
	name = "Psychiatrist"

/obj/effect/landmark/start/jobs/chemist
	name = "Chemist"

/obj/effect/landmark/start/jobs/paramed
	name = "Paramedic"

/obj/effect/landmark/start/jobs/fieldmed
	name = "Field Medic"

/obj/effect/landmark/start/jobs/scientist
	name = "Scientist"

/obj/effect/landmark/start/jobs/robo
	name = "Roboticist"

/obj/effect/landmark/start/jobs/xenobio
	name = "Xenobiologist"

/obj/effect/landmark/start/jobs/explorer
	name = "Explorer"

/obj/effect/landmark/start/jobs/pathfinder
	name = "Pathfinder"

/obj/effect/landmark/start/jobs/heads/QM //Let me believe
	name = "Quartermaster"

/obj/effect/landmark/start/jobs/cargotech
	name = "Cargo Technician"

/obj/effect/landmark/start/jobs/miner
	name = "Shaft Miner"

/obj/effect/landmark/start/jobs/bartender
	name = "Bartender"

/obj/effect/landmark/start/jobs/botanist
	name = "Botanist"

/obj/effect/landmark/start/jobs/chef
	name = "Chef"

/obj/effect/landmark/start/jobs/janitor
	name = "Janitor"

/obj/effect/landmark/start/jobs/librarian
	name = "Librarian"

/obj/effect/landmark/start/jobs/lawyer
	name = "Lawyer"

/obj/effect/landmark/start/jobs/chaplain
	name = "Chaplain"

/obj/effect/landmark/start/jobs/pilot
	name = "Pilot"

/obj/effect/landmark/start/jobs/visitor
	name = "Visitor"

/obj/effect/landmark/start/jobs/intern
	name = "Intern"

/obj/effect/landmark/start/jobs/warden
	name = "Warden"

/obj/effect/landmark/start/jobs/detective
	name = "Detective"

/obj/effect/landmark/start/jobs/secoff
	name = "Security Officer"

/obj/effect/landmark/start/jobs/ai
	name = "AI"

/obj/effect/landmark/start/jobs/cyborg
	name = "Cyborg"

/obj/effect/landmark/start/jobs/pai
	name = "pAI"

/obj/effect/landmark/virtual_reality
	name = "virtual_reality"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/effect/landmark/virtual_reality/New()
	..()
	tag = "virtual_reality*[name]"
	invisibility = 101
	return 1

//Costume spawner landmarks
/obj/effect/landmark/costume/New() //costume spawner, selects a random subclass and disappears

	var/list/options = typesof(/obj/effect/landmark/costume)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	delete_me = 1

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/New()
	new /obj/item/clothing/suit/chickensuit(src.loc)
	new /obj/item/clothing/head/chicken(src.loc)
	new /obj/item/reagent_containers/food/snacks/egg(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/gladiator/New()
	new /obj/item/clothing/under/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)
	qdel(src)

/obj/effect/landmark/costume/madscientist/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/toggle/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/gglasses(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/elpresidente/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/boots/jackboots(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/nyangirl/New()
	new /obj/item/clothing/under/schoolgirl(src.loc)
	new /obj/item/clothing/head/kitty(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/maid/New()
	new /obj/item/clothing/under/skirt(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/butler/New()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/scratch/New()
	new /obj/item/clothing/gloves/white(src.loc)
	new /obj/item/clothing/shoes/white(src.loc)
	new /obj/item/clothing/under/scratch(src.loc)
	if (prob(30))
		new /obj/item/clothing/head/cueball(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/highlander/New()
	new /obj/item/clothing/under/kilt(src.loc)
	new /obj/item/clothing/head/beret(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/prig/New()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/plaguedoctor/New()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/plaguedoctorhat(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/nightowl/New()
	new /obj/item/clothing/under/owl(src.loc)
	new /obj/item/clothing/mask/gas/owl_mask(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/waiter/New()
	new /obj/item/clothing/under/waiter(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(src.loc)
	new /obj/item/clothing/suit/storage/apron(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/pirate/New()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/commie/New()
	new /obj/item/clothing/under/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/imperium_monk/New()
	new /obj/item/clothing/suit/imperium_monk(src.loc)
	if (prob(25))
		new /obj/item/clothing/mask/gas/cyborg(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/holiday_priest/New()
	new /obj/item/clothing/suit/holidaypriest(src.loc)
	qdel(src)

/obj/effect/landmark/costume/marisawizard/fake/New()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/cutewitch/New()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/witchwig(src.loc)
	new /obj/item/staff/broom(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/fakewizard/New()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/staff/(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/sexyclown/New()
	new /obj/item/clothing/mask/gas/sexyclown(src.loc)
	new /obj/item/clothing/under/sexyclown(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/sexymime/New()
	new /obj/item/clothing/mask/gas/sexymime(src.loc)
	new /obj/item/clothing/under/sexymime(src.loc)
	delete_me = 1
