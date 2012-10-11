###
Return Command
###
class Return extends Command

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
		@getParent()?.notifyReturn()
		@notifyComplete()

	_interruptFunction: (command) ->

	_destroyFunction: (command) ->


#export
Namespace('jpp.command').register('Return', Return)