/*
*	Here is where any supply packs
*	that don't belong elsewhere live.
*/


/datum/supply_pack/misc
	group = "Miscellaneous"

/datum/supply_pack/randomised/misc
	group = "Miscellaneous"

/datum/supply_pack/misc/rations
	name = "Emergency LiquidFood Rations"
	contains = list(
	/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 10
	)
	cost = 5
	containertype = /obj/structure/closet/crate/freezer
	containername = "emergency rations"

/datum/supply_pack/misc/phoronoid
	name  = "Spare Phoronoid containment suits"
	contains = list(
	/obj/item/clothing/suit/space/plasman = 3,
	/obj/item/clothing/head/helmet/space/plasman = 3,
	/obj/item/clothing/mask/breath = 3,
	/obj/item/weapon/tank/vox = 3,
	)
	cost = 40
	containername = "spare phoronoid suits"


/datum/supply_pack/randomised/misc/card_packs
	num_contained = 5
	contains = list(
			/obj/item/weapon/pack/cardemon,
			/obj/item/weapon/pack/spaceball,
			/obj/item/weapon/deck/holder
			)
	name = "Trading Card Crate"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "cards crate"

/datum/supply_pack/misc/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "EFTPOS scanner"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "EFTPOS crate"

/datum/supply_pack/misc/chaplaingear
	name = "Chaplain equipment"
	contains = list(
			/obj/item/clothing/under/rank/chaplain,
			/obj/item/clothing/shoes/black,
			/obj/item/clothing/suit/nun,
			/obj/item/clothing/head/nun_hood,
			/obj/item/clothing/suit/storage/hooded/chaplain_hoodie,
			/obj/item/clothing/suit/storage/hooded/chaplain_hoodie/whiteout,
			/obj/item/clothing/suit/holidaypriest,
			/obj/item/clothing/under/wedding/bride_white,
			/obj/item/weapon/storage/backpack/cultpack,
			/obj/item/weapon/storage/fancy/candle_box = 3
			)
	cost = 10
	containertype = "/obj/structure/closet/crate"
	containername = "Chaplain equipment crate"

/datum/supply_pack/misc/hoverpod
	name = "Hoverpod Shipment"
	contains = list()
	cost = 80
	containertype = /obj/structure/largecrate/hoverpod
	containername = "Hoverpod Crate"

/datum/supply_pack/randomised/misc/webbing
	name = "Webbing crate"
	num_contained = 4
	contains = list(
			/obj/item/clothing/accessory/storage/black_vest,
			/obj/item/clothing/accessory/storage/brown_vest,
			/obj/item/clothing/accessory/storage/white_vest,
			/obj/item/clothing/accessory/storage/black_drop_pouches,
			/obj/item/clothing/accessory/storage/brown_drop_pouches,
			/obj/item/clothing/accessory/storage/white_drop_pouches,
			/obj/item/clothing/accessory/storage/webbing
			)
	cost = 10
	containertype = "/obj/structure/closet/crate"
	containername = "Webbing crate"

/datum/supply_pack/misc/holoplant
	name = "Holoplant Pot"
	contains = list(/obj/machinery/holoplant/shipped)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Holoplant crate"
