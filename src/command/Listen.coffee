###
Listen Command
###
class Listen extends Command

	###
	Constructor
	###
	constructor: (type = null, dispatcher = null) ->
		super()
		@_type = type
		@_dispatcher = dispatcher


	###
	Method
	###
	_handler: (event) =>
		@notifyComplete()


	###
	Getter / Setter
	###
	getType: () -> return @_type
	setType: (type) -> @_type = type; @

	getDispatcher: () -> return @_dispatcher
	setDispatcher: (dispatcher) -> @_dispatcher = dispatcher; @

	###
	Protected
	###
	_executeFunction: (command) ->
		@_dispatcher?.addEventListener(@_type, @_handler) if @_type?

	_interruptFunction: (command) ->
		@_dispatcher?.removeEventListener(@_type, @_handler) if @_type?

	_destroyFunction: (command) ->
		@_dispatcher?.removeEventListener(@_type, @_handler) if @_type?
		@_type = null
		@_dispatcher = null


#export
Namespace('jpp.command').register('Listen', Listen)