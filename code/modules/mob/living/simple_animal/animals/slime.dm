/mob/living/simple_mob/old_slime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	tt_desc = "Amorphidae proteus"
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey baby slime"
	icon_living = "grey baby slime"
	icon_dead = "grey baby slime dead"

	maxHealth = 100
	health = 100

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"

	speak_chance = 1
	speak_emote = list("chirps")
	emote_see = list("jiggles", "bounces in place")

	var/color = "grey"

/mob/living/simple_mob/old_slime/science
	name = "Kendrick"
	color = "rainbow"
	icon_state = "rainbow baby slime"
	icon_living = "rainbow baby slime"
	icon_dead = "rainbow baby slime dead"

/mob/living/simple_animal/slime/science/Initialize()
	. = ..()
	overlays.Cut()
	overlays += "aslime-:33"

/mob/living/simple_mob/adultslime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey adult slime"
	icon_living = "grey adult slime"
	icon_dead = "grey baby slime dead"

	maxHealth = 200
	health = 200

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"

	speak_chance = 1
	emote_see = list("jiggles", "bounces in place")

	var/color = "grey"

/mob/living/simple_mob/adultslime/New()
	..()
	overlays += "aslime-:33"

/mob/living/simple_mob/adultslime/death()
	var/mob/living/simple_mob/old_slime/S1 = new /mob/living/simple_mob/old_slime (src.loc)
	S1.icon_state = "[src.color] baby slime"
	S1.icon_living = "[src.color] baby slime"
	S1.icon_dead = "[src.color] baby slime dead"
	S1.color = "[src.color]"
	var/mob/living/simple_mob/old_slime/S2 = new /mob/living/simple_mob/old_slime (src.loc)
	S2.icon_state = "[src.color] baby slime"
	S2.icon_living = "[src.color] baby slime"
	S2.icon_dead = "[src.color] baby slime dead"
	S2.color = "[src.color]"
	qdel(src)
