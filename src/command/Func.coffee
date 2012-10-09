###
Func Command
###
class Func extends Command

	###
	Constructor
	###
	constructor: (func = null, args = []) ->
		super()
		@_func = func
		@_args = args


	###
	Method
	###


	###
	Getter / Setter
	###
	getFunction: () -> return @_func
	setFunction: (func) -> @_func = func; @

	getArguments: () -> return @_args
	setArguments: (args) -> @_args = args; @


	###
	Protected
	###
	_executeFunction: (command) ->
		@_func?(@_args...)
		@notifyComplete()

	_interruptFunction: (command) ->

	_destroyFunction: (command) ->
		@_func = null
		@_args = null


#jppexport('command', Func)
Namespace('jpp.command').register('Func', Func)