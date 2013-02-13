trace = (messages...) ->
	return if typeof console is 'undefined' or typeof console.log is 'undefined'
	console.log(messages.join(' '));


#export
Namespace('jpp.util').register('trace', trace).use()
