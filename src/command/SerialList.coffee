###
SerialList
###
class SerialList extends CommandList

	###
	Constructor
	###
	constructor: (commands...) ->
		super(commands...)
		@_currentCommand = null
		@_position = 0


	###
	Method
	###
	addCommand: (commands...) ->
		super(commands...)
		@

	insertCommand: (commands...) ->
		super(@_position + 1, commands...)
		@

	_next: () ->
		@_currentCommand = @getCommandByIndex(@_position)
		@_currentCommand.addEventListener(Event.COMPLETE, @_completeHandler)
		@_currentCommand.execute()

	_completeHandler: (event) =>
		@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
		@_currentCommand = null
		if ++@_position >= @getLength() then @notifyComplete() else @_next()


	###
	Getter / Setter
	###
	getPosition: () -> return @_position


	###
	Protected
	###
	_executeFunction: (command) ->
		@_position = 0
		@_next()

	_interruptFunction: (command) ->
		@_currentCommand?.interrupt()
		@_position = 0
		super(command)

	_destroyFunction: (command) ->
		if @_currentCommand?
			@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
			@_currentCommand.destroy()
		@_currentCommand = null
		@_position = 0
		super(command)


#jppexport('command', SerialList)
Namespace('jpp.command').register('SerialList', SerialList)