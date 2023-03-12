// Security level severities.
#define SEC_LEVEL_GREEN		0
#define SEC_LEVEL_YELLOW	1
#define SEC_LEVEL_BLUE		2
#define SEC_LEVEL_RED		3
#define SEC_LEVEL_DELTA		4

// Security level datum helper.
#define IS_SEC_LEVEL(X)		istype(GLOBL.security_level, X)