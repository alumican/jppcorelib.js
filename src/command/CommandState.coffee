###
CommandState
###
class CommandState
	@SLEEPING     = 0
	@EXECUTING    = 1
	@INTERRUPTING = 2


#jppexport('command', CommandState)
Namespace('jpp.command').register('CommandState', CommandState)