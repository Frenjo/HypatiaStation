// Sets up the new browser output with collapsing functionality for identical strings.
/client/New()
	. = ..()
	src << output({"
[script]
<script type='text/javascript'>
	function append(msg, newline = true)
	{
		var toAppend = newline ? '<br>' + msg : msg;
		document.getElementById('chatOutput').innerHTML += toAppend;
		var scrollingElement = (document.scrollingElement || document.body);
		scrollingElement.scrollTop = scrollingElement.scrollHeight;
	}

	function replace(msg, count)
	{
		var replacing = document.getElementById('chatOutput').innerHTML;
		var countText = ' <sup><span class=\\'notice\\'><i>x ' + count + '</i></span></sup>';
		var indexToReplace = count > 2 ? (replacing.length - (msg.length + countText.length)) : (replacing.length - msg.length);
		if(count == 10 || count == 100 || count == 1000)
			indexToReplace += 4
		msg += countText;
		document.getElementById('chatOutput').innerHTML = replacing.substring(0, indexToReplace);
		append(msg, false);
	}
</script>
<div id='chatOutput'></div>
"}, "outputwindow.output");