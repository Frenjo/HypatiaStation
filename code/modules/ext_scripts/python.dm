/proc/ext_python(script, args, scriptsprefix = 1)
	if(scriptsprefix)
		script = "scripts/" + script

	if(world.system_type == MS_WINDOWS)
		script = replacetextx(script, "/", "\\")

	var/command = config.python_path + " " + script + " " + args

	return shell(command)
