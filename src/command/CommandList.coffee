###
CommandList
###
class CommandList extends Command

	###
	Constructor
	###
	constructor: (commands...) ->
		super()
		@_commands = []
		@addCommand(commands...)


	###
	Method
	###
	addCommand: (commands...) ->
		@_setParent(commands)
		@_commands = @getCommands().concat(commands)
		@

	insertCommand: (index, commands...) ->
		@_setParent(commands)
		Array.prototype.splice.apply(@getCommands(), [index, 0].concat(commands))
		@

	addCommandArray: (commands) ->
		@addCommand(commands...)
		@

	insertCommandArray: (index, commands) ->
		@insertCommand(commands...)
		@

	_setParent: (commands) ->
		i = 0
		for c in commands
			commands[i] = c = new Func(c) if typeof(c) is 'function'
			c.setParent(@)
			++i

	notifyBreak: () ->
	notifyReturn: () ->

	###
	Getter / Setter
	###
	getCommandByIndex: (index) -> return @_commands[index]
	getCommands: () -> return @_commands
	getLength: () -> return @_commands.length


	###
	Protected
	###
	_executeFunction: (command) -> @notifyComplete()
	_interruptFunction: (command) ->
	_destroyFunction: (command) -> @_commands = []


#export
Namespace('jpp.command').register('CommandList', CommandList)
