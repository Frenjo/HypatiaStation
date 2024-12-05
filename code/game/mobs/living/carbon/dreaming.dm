/mob/living/carbon
	var/dreaming = FALSE

/mob/living/carbon/proc/dream()
	dreaming = TRUE
	spawn(0)
		for(var/i = rand(1, 4), i > 0, i--)
			to_chat(src, SPAN_INFO("<i>... [pick(GLOBL.all_dreams)] ...</i>"))
			sleep(rand(40, 70))
			if(paralysis <= 0)
				dreaming = FALSE
				return
		dreaming = FALSE
		return

/mob/living/carbon/proc/handle_dreams()
	if(prob(5) && !dreaming)
		dream()