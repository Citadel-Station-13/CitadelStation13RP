/mob/living/simple_animal/hostile/jelly
	name = "jelly blob"
	desc = "Some sort of undulating blob of slime!"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "jelly_dead"
	icon_living = "jelly"
	icon_state = "jelly"

	faction = "virgo2"
	maxHealth = 50
	health = 50

	melee_damage_lower = 5
	melee_damage_upper = 15

	speak_chance = 2
	emote_hear = list("squishes","spluts","splorts","sqrshes","makes slime noises")
	emote_see = list("undulates quietly")

// Activate Noms!
/mob/living/simple_animal/hostile/jelly
	vore_active = 1
	vore_pounce_chance = 0
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS // Hungry little bastards.
	vore_stomach_name = "Jelly core"
	vore_stomach_flavor = "You're trapped deep inside the core of the slime creature, it's mass squeezing and rippling around your own body. It slowly kneads you back and forth while at the same time keeping your forcefully restrained and in place as the mass seems under your attire wherever it can, down to your skin and leaving a tingling warmth everywhere it squishes. Even against your struggles and resistance, the creature seems bent on assimilating your form into it's own by any means possible!"