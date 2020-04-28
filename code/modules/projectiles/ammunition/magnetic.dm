/obj/item/magnetic_ammo
	name = "flechette magazine"
	desc = "A magazine containing steel flechettes."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "5.56"
	w_class = ITEMSIZE_SMALL
	matter = list(MATERIAL_ID_STEEL = 1800)
	origin_tech = list(TECH_COMBAT = 1)
	var/remaining = 9
	preserve_item = 1

/obj/item/magnetic_ammo/examine(mob/user)
	. = ..()
	to_chat(user, "There [(remaining == 1)? "is" : "are"] [remaining] flechette\s left!")