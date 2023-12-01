/*
File: Options
*/
// Ascii values of characters
#define ASCII_A_UPPERCASE 65
#define ASCII_Z_UPPERCASE 90
#define ASCII_A_LOWERCASE 97
#define ASCII_Z_LOWERCASE 122
#define ASCII_DOLLAR 36 // $
#define ASCII_ZERO 48
#define ASCII_NINE 57
#define ASCII_UNDERSCORE 95 // _

/*
	Class: n_scriptOptions
*/
/n_scriptOptions/proc/CanStartID(char) //returns true if the character can start a variable, function, or keyword name (by default letters or an underscore)
	if(!isnum(char))
		char = text2ascii(char)
	return (char in ASCII_A_UPPERCASE to ASCII_Z_UPPERCASE) || (char in ASCII_A_LOWERCASE to ASCII_Z_LOWERCASE) || char == ASCII_UNDERSCORE || char == ASCII_DOLLAR

/n_scriptOptions/proc/IsValidIDChar(char) //returns true if the character can be in the body of a variable, function, or keyword name (by default letters, numbers, and underscore)
	if(!isnum(char))
		char = text2ascii(char)
	return CanStartID(char) || IsDigit(char)

/n_scriptOptions/proc/IsDigit(char)
	if(!isnum(char))
		char = text2ascii(char)
	return char in ASCII_ZERO to ASCII_NINE

/n_scriptOptions/proc/IsValidID(id) //returns true if all the characters in the string are okay to be in an identifier name
	if(!CanStartID(id)) //don't need to grab first char in id, since text2ascii does it automatically
		return 0
	if(length(id) == 1)
		return 1
	for(var/i = 2 to length(id))
		if(!IsValidIDChar(copytext(id, i, i + 1)))
			return 0
	return 1

#undef ASCII_A_UPPERCASE
#undef ASCII_Z_UPPERCASE
#undef ASCII_A_LOWERCASE
#undef ASCII_Z_LOWERCASE
#undef ASCII_DOLLAR
#undef ASCII_ZERO
#undef ASCII_NINE
#undef ASCII_UNDERSCORE

/*
	Class: nS_Options
	An implementation of <n_scriptOptions> for the n_Script language.
*/
/n_scriptOptions/nS_Options
	var/list/symbols = list("(", ")", "\[", "]", ";", ",", "{", "}")	//scanner - Characters that can be in symbols
/*
Var: keywords
An associative list used by the parser to parse keywords. Indices are strings which will trigger the keyword when parsed and the
associated values are <nS_Keyword> types of which the <n_Keyword.Parse()> proc will be called.
*/
	var/list/keywords = list(
		"if"		= /n_Keyword/nS_Keyword/kwIf,		"else"	= /n_Keyword/nS_Keyword/kwElse,
		"while"		= /n_Keyword/nS_Keyword/kwWhile,	"break"	= /n_Keyword/nS_Keyword/kwBreak,
		"continue"	= /n_Keyword/nS_Keyword/kwContinue,
		"return"	= /n_Keyword/nS_Keyword/kwReturn,	"def"	= /n_Keyword/nS_Keyword/kwDef
	)

	var/list/assign_operators = list(
		"=" = null,	"&=" = "&",
		"|=" = "|", "`=" = "`",
		"+=" = "+", "-=" = "-",
		"*=" = "*", "/=" = "/",
		"^=" = "^",
		"%=" = "%"
	)

	var/list/unary_operators = list(
		"!" = /node/expression/_operator/unary/LogicalNot,
		"~" = /node/expression/_operator/unary/BitwiseNot,
		"-" = /node/expression/_operator/unary/Minus
	)

	var/list/binary_operators = list(
		"=="	= /node/expression/_operator/binary/Equal,			"!="	= /node/expression/_operator/binary/NotEqual,
		">"		= /node/expression/_operator/binary/Greater,			"<"		= /node/expression/_operator/binary/Less,
		">="	= /node/expression/_operator/binary/GreaterOrEqual,	"<="	= /node/expression/_operator/binary/LessOrEqual,
		"&&"	= /node/expression/_operator/binary/LogicalAnd,		"||"	= /node/expression/_operator/binary/LogicalOr,
		"&"		= /node/expression/_operator/binary/BitwiseAnd,		"|"		= /node/expression/_operator/binary/BitwiseOr,
		"`"		= /node/expression/_operator/binary/BitwiseXor,		"+"		= /node/expression/_operator/binary/Add,
		"-"		= /node/expression/_operator/binary/Subtract,		"*"		= /node/expression/_operator/binary/Multiply,
		"/"		= /node/expression/_operator/binary/Divide,			"^"		= /node/expression/_operator/binary/Power,
		"%"		= /node/expression/_operator/binary/Modulo
	)

/n_scriptOptions/nS_Options/New()
	. = ..()
	for(var/O in assign_operators + binary_operators + unary_operators)
		if(!symbols.Find(O))
			symbols += O