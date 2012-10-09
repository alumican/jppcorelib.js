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
		@_setParent(commands...)
		@_commands = @getCommands().concat(commands)
		@

	insertCommand: (index, commands...) ->
		@_setParent(commands...)
		Array.prototype.splice.apply(@getCommands(), [index, 0].concat(commands))
		@

	_setParent: (commands...) ->
		c.setParent(@) for c in commands


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