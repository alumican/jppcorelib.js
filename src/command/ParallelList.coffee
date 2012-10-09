###
ParallelList
###
class ParallelList extends CommandList

	###
	Constructor
	###
	constructor: (commands...) ->
		super(commands...)
		@_completeCount = 0


	###
	Method
	###
	addCommand: (commands...) ->
		super(commands...)
		@

	insertCommand: (commands...) ->
		super(@getLength(), commands...)
		@

	_completeHandler: (event) =>
		@notifyComplete() if ++@_completeCount >= @getLength()


	###
	Getter / Setter
	###
	getCompleteCount: () -> return @_completeCount


	###
	Protected
	###
	_executeFunction: (command) ->
		@_completeCount = 0
		for c in @getCommands()
			c.addEventListener(Event.COMPLETE, @_completeHandler)
			c.execute()


	_interruptFunction: (command) ->
		c.interrupt() for c in @getCommands()
		super(command)

	_destroyFunction: (command) ->
		for c in @getCommands()
			c.removeEventListener(Event.COMPLETE, @_completeHandler)
			c.destroy()
		@_completeCount = 0
		super(command)


#jppexport('command', ParallelList)
Namespace('jpp.command').register('ParallelList', ParallelList)