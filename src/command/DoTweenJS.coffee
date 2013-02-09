###
DoTweenJS Command
###
class DoTweenJS extends Command

	###
	Constructor
	###
	constructor: (tweenProvider) ->
		super()
		@_tweenProvider = tweenProvider


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
	setTween: (tween) -> @_tween = tween; @


	###
	Protected
	###
	_executeFunction: (command) ->
		@_tween = @_tweenProvider()
		@_tween.loop = false
		@_tween.call(@_completeHandler)
		@_tween.play(@_tween)

	_interruptFunction: (command) ->
		@_cancel()

	_destroyFunction: (command) ->
		@_cancel()


#export
Namespace('jpp.command').register('DoTweenJS', DoTweenJS)
