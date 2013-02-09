###
Trace Command
###
class Trace extends Command

	###
	Constructor
	###
	constructor: (message) ->
		super()
		@_message = message


	###
	Method
	###


	###
	Getter / Setter
	###
	getMessage: () -> return @_message
	setMessage: (message) -> @_message = message; @


	###
	Protected
	###
	_executeFunction: (command) ->
		console.log(@_message)
		@notifyComplete()

	_interruptFunction: (command) ->

	_destroyFunction: (command) ->
		@_message = null


#export
Namespace('jpp.command').register('Trace', Trace)
