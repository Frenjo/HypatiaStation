// Handles 515 compatibility for call vs call_ext.
#if DM_VERSION >= 515
	#define LIBCALL call_ext
#else
	#define LIBCALL call
#endif