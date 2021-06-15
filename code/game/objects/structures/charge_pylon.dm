/obj/structure/adherent_pylon
	name = "electron reservoir"
	desc = "A tall, crystalline pylon that pulses with electricity."
	icon = 'icons/obj/machines/adherent.dmi'
	icon_state = "pedestal"
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	var/next_use

/obj/structure/adherent_pylon/attack_ai(var/mob/living/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/adherent_pylon/attack_hand(var/mob/living/user)
	charge_user(user)

/obj/structure/adherent_pylon/proc/charge_user(var/mob/living/user)
	if(next_use > world.time) return
	next_use = world.time + 10
	var/mob/living/carbon/human/H = user

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message("<span class='warning'>There is a loud crack and the smell of ozone as \the [user] touches \the [src].</span>")

	playsound(loc, 'sound/effects/snap_a.ogg', 50, 1)

	if(istype(H) && H.species.name == SPECIES_ADHERENT && H.nutrition < 450)
		H.nutrition = 400
		return
	if(isrobot(user))
		user.apply_damage(150, BURN, def_zone = BP_TORSO)
		visible_message("<span class='danger'>Electricity arcs off [user] as it touches \the [src]!</span>")
		to_chat(user, "<span class='danger'><b>You detect damage to your components!</b></span>")
	else if(istype(H) && H.species.name != SPECIES_ADHERENT)
		user.electrocute_act(100, src, def_zone = BP_TORSO)
		visible_message("<span class='danger'>\The [user] has been shocked by \the [src]!</span>")
	user.throw_at(get_step(user,get_dir(src,user)), 5, 10)


/obj/structure/adherent_pylon/Bumped(atom/AM)
	if(ishuman(AM))
		charge_user(AM)

/obj/structure/adherent_pylon/hitby(atom/AM)
	. =..()
	if(ishuman(AM))
		charge_user(AM)
