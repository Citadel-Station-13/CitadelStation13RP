/mob/living/simple_mob/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit"
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	icon_living = "shade"
	icon_dead = "shade_dead"

	faction = "cult"
	intelligence_level = SA_HUMANOID

	maxHealth = 50
	health = 50
	speed = -1

	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"

	melee_damage_lower = 5
	melee_damage_upper = 15
	attack_armor_pen = 100	//It's a ghost/horror from beyond, I ain't gotta explain 100 AP
	attacktext = list("drained the life from")

	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	stop_automated_movement = 1
	wander = 0
	status_flags = 0

	speak_chance = 5
	universal_speak = 1
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")

	loot_list = list(/obj/item/ectoplasm = 100)

/mob/living/simple_mob/shade/cultify()
	return

/mob/living/simple_mob/shade/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/soulstone))
		var/obj/item/soulstone/S = O;
		S.transfer_soul("SHADE", src, user)
		return
	..()

/mob/living/simple_mob/shade/death()
	..()
	for(var/mob/M in viewers(src, null))
		if((M.client && !( M.blinded )))
			M.show_message("<span class='danger'>[src] lets out a contented sigh as their form unwinds.</span>")

	ghostize()
	qdel(src)
	return
