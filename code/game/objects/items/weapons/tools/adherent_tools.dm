/obj/item/weldingtool/electric/crystal
	name = "crystalline arc welder"
	desc = "A crystalline welding tool of an alien make."
	icon_state = "crystal_welder"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)
	cell_type = null
	charge_cost = null

/obj/item/weldingtool/electric/crystal/attackby(var/obj/item/W, var/mob/user)
	return
/*
/obj/item/weldingtool/electric/crystal/on_update_icon()
	icon_state = welding ? "crystal_welder_on" : "crystal_welder"
	item_state = welding ? "crystal_tool_lit"  : "crystal_tool"
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/weldingtool/electric/crystal/attack_hand(var/mob/living/carbon/human/user)
	if(user.species.name == SPECIES_ADHERENT)
		.=..()
	else
		to_chat(usr, "You can't pick that up!")

/obj/item/weldingtool/electric/crystal/attack_self(mob/user)
	var/mob/living/carbon/human/adherent = loc
	if(istype(adherent))
		setWelding(!welding, user)
	else
		return

/obj/item/weldingtool/electric/crystal/get_fuel(mob/user)
	return user.nutrition

/obj/item/weldingtool/electric/crystal/get_max_fuel(mob/user)
	return 0
*/
/obj/item/weldingtool/electric/crystal/get_fuel(var/mob/living/carbon/human/user)
//	. = 0
	var/mob/living/carbon/human/adherent = loc
	var/mob/living/carbon/human/H = src.loc
	if(istype(adherent))
		return H.nutrition

/obj/item/weldingtool/electric/crystal/remove_fuel(var/amount, var/mob/living/carbon/human/user)
//	. = 0
	var/mob/living/carbon/human/adherent = loc
	var/mob/living/carbon/human/H = src.loc
	if(istype(adherent))
		if(H.nutrition >= amount)
			H.nutrition = H.nutrition - amount
			return 1
	// else
	// 	to_chat(src, "You aren't able to use this!")
	// 	return

/obj/item/tool/wirecutters/crystal
	name = "crystalline shears"
	desc = "A crystalline shearing tool of an alien make."
	icon_state = "crystal_wirecutter"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/tool/wirecutters/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)

/obj/item/tool/screwdriver/crystal
	name = "crystalline screwdriver"
	desc = "A crystalline screwdriving tool of an alien make."
	icon_state = "crystal_screwdriver"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/tool/screwdriver/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)

/obj/item/tool/crowbar/crystal
	name = "crystalline prytool"
	desc = "A crystalline prying tool of an alien make."
	icon_state = "crystal_crowbar"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/tool/crowbar/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)

/obj/item/tool/wrench/crystal
	name = "crystalline wrench"
	desc = "A crystalline wrenching tool of an alien make."
	icon_state = "crystal_wrench"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/tool/wrench/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)

/obj/item/multitool/crystal
	name = "crystalline multitool"
	desc = "A crystalline energy patterning tool of an alien make."
	icon_state = "crystal_multitool"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	matter = list(MATERIAL_CRYSTAL = 1250)

/obj/item/storage/belt/utility/crystal
	name = "crystalline tool harness"
	desc = "A segmented belt of strange crystalline material."
	icon_state = "utilitybelt_crystal"
	item_state = "utilitybelt_crystal"

/obj/item/storage/belt/utility/crystal/Initialize()
	new /obj/item/multitool/crystal(src)
	new /obj/item/tool/wrench/crystal(src)
	new /obj/item/tool/crowbar/crystal(src)
	new /obj/item/tool/screwdriver/crystal(src)
	new /obj/item/tool/wirecutters/crystal(src)
	new /obj/item/weldingtool/electric/crystal(src)
	update_icon()
	. = ..()

/obj/item/storage/toolbox/crystal
	name = "crystalline toolbox"
	desc = "A translucent toolbox made out of an odd crystalline material that is surprisingly light."
	icon_state = "crystal"
	item_state = "toolbox_crystal"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 3)

/obj/item/storage/toolbox/crystal/Initialize()
	new /obj/item/multitool/crystal(src)
	new /obj/item/tool/wrench/crystal(src)
	new /obj/item/tool/crowbar/crystal(src)
	new /obj/item/tool/screwdriver/crystal(src)
	new /obj/item/tool/wirecutters/crystal(src)
	new /obj/item/weldingtool/electric/crystal(src)
	update_icon()
	. = ..()
