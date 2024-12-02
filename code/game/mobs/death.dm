/mob/proc/death(gibbed, deathmessage = "seizes up and falls limp...")
	if(stat == DEAD)
		return 0

	if(!gibbed)
		src.visible_message("<b>\The [src.name]</b> [deathmessage]")

	stat = DEAD

	update_canmove()

	layer = MOB_LAYER

	if(blind && client)
		blind.layer = 0

	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	drop_r_hand()
	drop_l_hand()

	if(healths)
		healths.icon_state = "health6"

	timeofdeath = world.time
	if(mind)
		mind.store_memory("Time of death: [worldtime2text()]", 0)
	GLOBL.living_mob_list.Remove(src)

	GLOBL.dead_mob_list |= src

	updateicon()

	global.PCticker?.mode?.check_win()

	return 1