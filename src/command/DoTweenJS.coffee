###
DoTweenJS Command
###
class DoTweenJS extends Command

	###
	Constructor
	###
	constructor: (tween) ->
		super()
		@setTween(tween)


	###
	Method
	###
	_completeHandler: (tween) =>
		@_cancel()
		@notifyComplete()

	_cancel: () ->
		@_tween.pause(@_tween)


	###
	Getter / Setter
	###
	getTween: () -> return @_tween
	setTween: (tween) ->
		@_tween = tween
		@_tween.loop = false
		@_tween.pause(@_tween)
		@_tween.call(@_completeHandler)
		@


	###
	Protected
	###
	_executeFunction: (command) ->
		@_tween.play(@_tween)

	_interruptFunction: (command) ->
		@_cancel()

	_destroyFunction: (command) ->
		@_cancel()


#export
Namespace('jpp.command').register('DoTweenJS', DoTweenJS)
