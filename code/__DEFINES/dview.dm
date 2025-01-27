#define FOR_DVIEW(type, range, centre, invis_flags) \
	dview_mob.forceMove(centre); \
	dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))

#define END_FOR_DVIEW dview_mob.loc = null