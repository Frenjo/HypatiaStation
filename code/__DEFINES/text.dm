//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
#define MAX_MESSAGE_LEN			1024
#define MAX_PAPER_MESSAGE_LEN	3072
#define MAX_BOOK_MESSAGE_LEN	9216
#define MAX_NAME_LEN			26

// Macro from Lummox used to get height from a MeasureText proc
#define WXH_TO_HEIGHT(X) text2num(copytext(X, findtextEx(X, "x") + 1))