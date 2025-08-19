
//gimmicky hack to collect particles and direct them into the field
/obj/effect/rust_particle_catcher
	icon = 'icons/effects/effects.dmi'
	density = FALSE
	anchored = TRUE
	layer = 4
	var/obj/effect/rust_em_field/parent
	var/mysize = 0

	invisibility = INVISIBILITY_MAXIMUM

/*/obj/effect/rust_particle_catcher/New()
	for(var/obj/machinery/rust/em_field/field in range(6))
		parent = field
	if(!parent)
		del(src)*/

/obj/effect/rust_particle_catcher/process()
	if(!parent)
		qdel(src)

/obj/effect/rust_particle_catcher/proc/SetSize(var/newsize)
	name = "collector [newsize]"
	mysize = newsize
	UpdateSize()

/obj/effect/rust_particle_catcher/proc/AddParticles(var/name, var/quantity = 1)
	if(parent && parent.size >= mysize)
		parent.AddParticles(name, quantity)
		return 1
	return 0

/obj/effect/rust_particle_catcher/proc/UpdateSize()
	if(parent.size >= mysize)
		density = TRUE
		//invisibility = 0
		name = "collector [mysize] ON"
	else
		density = FALSE
		//invisibility = INVISIBILITY_MAXIMUM
		name = "collector [mysize] OFF"

/obj/effect/rust_particle_catcher/bullet_act(var/obj/projectile/Proj)
	if(Proj.flag != "bullet" && parent)
		parent.AddEnergy(Proj.damage * 20, 0, 1)
		update_icon()
	return 0

/obj/effect/rust_particle_catcher/Bumped(atom/AM)
	if(ismob(AM) && density && prob(10))
		to_chat(AM, SPAN_WARNING("A powerful force pushes you back."))
	..()
