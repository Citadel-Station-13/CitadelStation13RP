//Based on the ERT setup

var/global/hire_nebula = 0
var/can_call_traders = 1

//I'm disabling this for now, until Overmaps/Nebula Gas is reinstated.

/*
/client/proc/trader_ship()
	set name = "Hire Nebula Gas Employees"
	set category = "Special Verbs"
	set desc = "Invite players to work at the local Nebula Gas station."

	if(!holder)
		to_chat(usr, "<span class='danger'>Only administrators may use this command.</span>")
		return
	if(!SSticker)
		to_chat(usr, "<span class='danger'>The game hasn't started yet!</span>")
		return
	if(SSticker.current_state == 1)
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		return
	if(alert("Do you want to hire Nebula Gas attendants?",,"Yes","No") != "Yes")
		return
	if(get_security_level() == "red") // Allow admins to reconsider if the alert level is Red
		switch(alert("The station is in red alert. Do you still want to hire traders?",,"Yes","No"))
			if("No")
				return
	if(hire_nebula)
		to_chat(usr, "<span class='danger'>Looks like somebody beat you to it!</span>")
		return

	message_admins("[key_name_admin(usr)] is hiring Nebula Gas attendants.", 1)
	log_admin("[key_name(usr)] used Hire Nebula Gas Employees.")
	trigger_trader_visit()

client/verb/JoinTraders()

	set name = "Join as Nebula Gas Employee"
	set category = "IC"

	if(!MayRespawn(1))
		to_chat(usr, "<span class='warning'>You cannot join the traders.</span>")
		return

	if(istype(usr,/mob/observer/dead) || istype(usr,/mob/new_player))
		if(traders.current_antagonists.len >= traders.hard_cap)
			to_chat(usr, "The number of trader slots is already full!")
			return
		traders.create_default(usr)
	else
		to_chat(usr, "You need to be an observer or new player to use this.")

proc/trigger_trader_visit()
	if(!can_call_traders)
		return
	if(hire_nebula)
		return

	command_announcement.Announce("Local scans indicate active commercial interest: Nebula Gas Food Mart.", "[station_name()] Traffic Control")

	can_call_traders = 0 // Only one call per round.
	hire_nebula = 1

	sleep(600 * 5)
*/
