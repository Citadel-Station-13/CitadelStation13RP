/obj/item/clothing/under/donator
	name = "base donator jumpsuit"
	desc = "Here for ease of use in the future when adding items."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'

/obj/item/clothing/suit/storage/toggle/labcoat/donator
	name = "base donator labcoat"
	desc = "Here for ease of use in the future when adding items."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'

/obj/item/clothing/suit/armor/vest/donator
	name = "base donator armor"
	desc = "Yet again just here for convenience, use it as a base for donator armour-style items."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/hooded/donator/bee_costume
	name = "bee costume"
	desc = "Bee the true Queen!"
	icon_state = "bee"
	item_state_slots = list(slot_r_hand_str = "bee", slot_l_hand_str = "bee")
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/donator/bee_hood

/obj/item/clothing/head/donator/bee_hood
	name = "bee hood"
	desc = "A hood attached to a bee costume."
	icon_state = "beehood"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	item_state_slots = list(slot_r_hand_str = "bee", slot_l_hand_str = "bee") //Does not exist -S2-
	body_parts_covered = HEAD

/obj/item/clothing/mask/red_mask
	name = "Explorer's Red Lensed Mask"
	desc = "A gas mask with red lenses."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	body_parts_covered = HEAD
	icon_state = "gas_mining"

/obj/item/clothing/suit/storage/toggle/labcoat/donator/blackredgold
	name = "Multicolor Coat"
	desc = "An oddly special looking coat with black, red, and gold"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	item_state = "redgoldjacket"
	icon_state = "redgoldjacket_w"

/obj/item/clothing/suit/storage/hooded/donator/hooded_cloak
	name = "Project: Zul-E"
	desc = "A standard version of a prototype cloak given out by Nanotrasen higher ups. It's surprisingly thick and heavy for a cloak despite having most of it's tech stripped. It also comes with a bluespace trinket which calls it's accompanying hat onto the user. A worn inscription on the inside of the cloak reads Fleuret ...the rest is faded away."
	icon_state = "zuliecloak_w"
	item_state = "zuliecloak"
	item_state_slots = list(slot_r_hand_str = "cloak", slot_l_hand_str = "cloak")
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/donator/bee_hood

/obj/item/clothing/head/donator/cloak_hood
	name = "cloak hood"
	desc = "A hood attached to a cloak."
	icon_state = "zuliehood"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	item_state_slots = list(slot_r_hand_str = "cloak", slot_l_hand_str = "cloak") //Does not exist -S2-
	body_parts_covered = HEAD
