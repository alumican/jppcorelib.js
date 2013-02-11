###
JqueryAnimate Command
###
class JqueryAnimate extends Command

	###
	Constructor
	###
	constructor: (target, params, options = null) ->
		super()
		@_target = target
		@_params = params
		@_options = options
		@_isTweening = false


	###
	Method
	###
	_completeHandler: (p...) =>
		@_isTweening = false
		@_originalComplete.apply(@_target, p) if @_originalComplete isnt null
		@notifyComplete()

	_cancel: () ->
		return if not @_isTweening
		@_isTweening = false
		@_target.stop()


	###
	Getter / Setter
	###
	getTarget: () -> return @_target
	setTarget: (target) -> @_target = target; @

	getParams: () -> return @_params
	setParams: (params) -> @_params = params; @

	getOptions: () -> return @_options
	setOptions: (options) -> @_options = options; @

	###
	Protected
	###
	_executeFunction: (command) ->
		return if @_isTweening
		@_isTweening = true

		@_originalComplete = @_options.complete ? null
		options = Obj.clone(@_options)
		options.complete = @_completeHandler
		
		@_target.animate(@_params, options)

	_interruptFunction: (command) ->
		@_cancel()

	_destroyFunction: (command) ->
		@_cancel()


#export
Namespace('jpp.command').register('JqueryAnimate', JqueryAnimate)
