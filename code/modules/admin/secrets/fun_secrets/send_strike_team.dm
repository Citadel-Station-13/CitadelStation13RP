/datum/admin_secret_item/fun_secret/send_strike_team
	name = "Send Strike Team"

/datum/admin_secret_item/fun_secret/send_strike_team/can_execute(var/mob/user)
	if(!SSticker) return FALSE
	return ..()

/datum/admin_secret_item/fun_secret/send_strike_team/execute(var/mob/user)
	. = ..()
	if(.)
		return user.client.strike_team()
