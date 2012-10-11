###
Break Command
###
class Break extends Command

	###
	Constructor
	###
	constructor: () ->
		super()


	###
	Method
	###


	###
	Getter / Setter
	###


	###
	Protected
	###
	_executeFunction: (command) ->
		@getParent()?.notifyBreak()
		@notifyComplete()

	_interruptFunction: (command) ->

	_destroyFunction: (command) ->


#export
Namespace('jpp.command').register('Break', Break)