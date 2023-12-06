//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = TRUE
	if(isnotnull(CONFIG_GET(wikiurl)))
		if(alert("This will open the wiki in your browser. Are you sure?", , "Yes", "No") == "No")
			return
		to_chat(src, link(CONFIG_GET(wikiurl)))
	else
		to_chat(src, SPAN_WARNING("The wiki URL is not set in the server configuration."))
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = TRUE
	if(isnotnull(CONFIG_GET(forumurl)))
		if(alert("This will open the forum in your browser. Are you sure?", , "Yes", "No") == "No")
			return
		to_chat(src, link(CONFIG_GET(forumurl)))
	else
		to_chat(src, SPAN_WARNING("The forum URL is not set in the server configuration."))
	return

//rules and donate cloned from HypatiaStationOld --TwistedAkai

//#define RULES_FILE "config/rules.html"
/client/verb/rules() //This is better --Numbers
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = TRUE

	var/rules = {"
		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="http://hypatiastation.net/viewtopic.php?f=2&t=204&view=print" frameborder="0" id="main_frame"></iframe>		</body>

		</html>"}

	//src << browse(file(RULES_FILE), "window=rules;size=480x320")
	src << browse(rules, "window=rules;size=920x820") //:)
//#undef RULES_FILE

/client/verb/donate()
	set name = "donate"
	set desc = "Donate to the server."
	set hidden = TRUE
	if(isnotnull(CONFIG_GET(donateurl)))
		if(alert("This will open the donation URL in your browser. Are you sure?", , "Yes", "No") == "No")
			return
		to_chat(src, link(CONFIG_GET(donateurl)))
	else
		to_chat(src, SPAN_WARNING("The donation URL is not set in the server configuration."))
	return

/client/verb/hotkeys_help()
	set category = PANEL_OOC
	set name = "hotkeys-help"

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tt = say
\tx = swap-hand
\tz = activate held object (or y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	to_chat(src, hotkey_mode)
	to_chat(src, other)
	if(holder)
		to_chat(src, admin)