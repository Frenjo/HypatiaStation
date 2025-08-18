/obj/item/projectile/energy/beam
	invisibility = INVISIBILITY_MAXIMUM
	pass_flags = parent_type::pass_flags | PASS_FLAG_GLASS | PASS_FLAG_GRILLE

	damage = 20
	damage_type = BURN
	flag = "laser"
	eyeblur = 4

	hitscan = TRUE

	var/frequency = 1