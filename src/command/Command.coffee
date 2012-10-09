###
Command
###
class Command extends EventDispatcher

	###
	Constructor
	###
	constructor: (executeFunction = null, interruptFunction = null, destroyFunction = null) ->
		super()
		@setExecuteFunction(executeFunction);
		@setInterruptFunction(interruptFunction);
		@setDestroyFunction(destroyFunction);
		@_state = CommandState.SLEEPING
		@_parent = null


	###
	Method
	###
	execute: () ->
		Err.throw('Command.execute', 'Command is already executing.') if @_state > CommandState.SLEEPING
		@_state = CommandState.EXECUTING
		@getExecuteFunction().call(this, this)
		@

	interrupt: () ->
		Err.throw('Command.interrupt', 'Command is sleeping') if @_state < CommandState.EXECUTING
		@_state = CommandState.INTERRUPTING
		@getInterruptFunction().call(this, this)
		@

	destroy: () ->
		@_state = CommandState.SLEEPING
		@getDestroyFunction().call(this, this)
		@_parent = null
		@__executeFunction = null
		@__interruptFunction = null
		@__destroyFunction = null
		@

	notifyComplete: () ->
		switch @_state
			when CommandState.SLEEPING
				@

			when CommandState.EXECUTING
				@dispatchEvent(Event.COMPLETE)
				@destroy()
				@

			when CommandState.INTERRUPTING
				@dispatchEvent(Event.COMPLETE)
				@destroy()
				@


	###
	Getter / Setter
	###
	getExecuteFunction: () -> return @__executeFunction ? @_executeFunction
	setExecuteFunction: (f) -> @__executeFunction = f; @

	getInterruptFunction: () -> return @__interruptFunction ? @_interruptFunction
	setInterruptFunction: (f) -> @__interruptFunction = f; @

	getDestroyFunction: () -> return @__destroyFunction ? @_destroyFunction
	setDestroyFunction: (f) -> @__destroyFunction = f; @

	getState: () -> return @_state

	getParent: () -> return @_parent
	setParent: (parent) -> @_parent = parent


	###
	Protected
	###
	_executeFunction: (command) -> @notifyComplete()
	_interruptFunction: (command) ->
	_destroyFunction: (command) ->


#export
Namespace('jpp.command').register('Command', Command)