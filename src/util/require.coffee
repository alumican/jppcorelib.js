#load external scripts
require = (params...) ->
	command = new Serial()
	for param in params
		if typeof param is 'string'
			c = new RequireScript(param)
			command.addCommand(c)
		else
			command.addCommand(param)
	command.execute()


#export
Namespace('jpp.util').register('require', require)
