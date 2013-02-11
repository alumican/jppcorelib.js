###
Serial
###
class Serial extends CommandList

	###
	Constructor
	###
	constructor: (commands...) ->
		super(commands...)
		@_currentCommand = null
		@_position = 0
		@_isPaused = false
		@_isCompleteOnPaused = false


	###
	Method
	###
	addCommand: (commands...) ->
		super(commands...)
		@

	insertCommand: (commands...) ->
		super(@_position + 1, commands...)
		@

	#pause: (withChildren = false) ->
	#	return if @_isPaused
	#	@_isPaused = true
	#	@_currentCommand.pause(true) if withChildren and @_currentCommand instanceof Serial

	#resume: () ->
	#	return if not @_isPaused
	#	@_isPaused = false
	#	if @_isCompleteOnPaused
	#		@_isCompleteOnPaused = false
	#		@_updatePosition()

	_next: () ->
		@_currentCommand = @getCommandByIndex(@_position)
		@_currentCommand.addEventListener(Event.COMPLETE, @_completeHandler)
		@_currentCommand.execute()

	_completeHandler: (event) =>
		@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
		@_currentCommand = null
		#if @_isPaused
		#	@_isCompleteOnPaused = true
		#else
		#	@_updatePosition()
		if ++@_position >= @getLength() then @notifyComplete() else @_next() #pause実装したら消す

	#_updatePosition: () ->
	#	if ++@_position >= @getLength() then @notifyComplete() else @_next()

	notifyBreak: () ->
		if @_currentCommand?.getState() == CommandState.EXECUTING
			@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
			@_currentCommand.interrupt()
		@notifyComplete()

	notifyReturn: () ->
		if @_currentCommand?.getState() == CommandState.EXECUTING
			@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
			@_currentCommand.interrupt()
		@getParent()?.notifyReturn()
		@destroy()


	###
	Getter / Setter
	###
	getPosition: () -> return @_position
	#getIsPaused: () -> return @_isPaused


	###
	Protected
	###
	_executeFunction: (command) ->
		@_position = 0
		if @getLength() > 0 then @_next() else @notifyComplete()

	_interruptFunction: (command) ->
		if @_currentCommand?
			@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
			@_currentCommand.interrupt()
		@_currentCommand = null
		@_position = 0
		super(command)

	_destroyFunction: (command) ->
		if @_currentCommand?
			@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
			@_currentCommand.destroy()
		@_currentCommand = null
		@_position = 0
		@_isPaused = false
		@_isCompleteOnPaused = false
		super(command)


#export
Namespace('jpp.command').register('Serial', Serial)
