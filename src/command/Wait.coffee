###
Wait Command
###
class Wait extends Command

	###
	Constructor
	###
	constructor: (time = 1) ->
		super()
		@_time = time
		@_timeoutId = -1


	###
	Method
	###
	_cancel: () ->
		clearTimeout(@_timeoutId) unless @_timeoutId == -1
		@_timeoutId = -1

	_completeHandler: (event) =>
		@notifyComplete()


	###
	Getter / Setter
	###
	getTime: () -> return @_time
	setTime: (time) -> @_time = time; @


	###
	Protected
	###
	_executeFunction: (command) ->
		@_timeoutId = setTimeout(@_completeHandler, @_time * 1000)

	_interruptFunction: (command) ->
		@_cancel()

	_destroyFunction: (command) ->
		@_cancel()


#jppexport('command', Wait)
Namespace('jpp.command').register('Wait', Wait)