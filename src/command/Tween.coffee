###
Tween Command
###
class Tween extends Command

	###
	Constructor
	###
	constructor: (target, to, from = null, time = 1, easing = Easing.Linear, onStart = null, onUpdate = null, onComplete = null) ->
		super()
		@_target = target
		@_to = to
		@_from = from
		@_time = time
		@_easing = easing
		@_onStart = onStart
		@_onUpdate = onUpdate
		@_onComplete = onComplete
		@_intervalId = -1
		@_tRatio = 0
		@_vRatio = 0
		@_startTime


	###
	Method
	###
	_cancel: () ->
		clearInterval(@_intervalId) unless @_intervalId == -1
		@_intervalId = -1

	_apply: (ratio) ->
		@_tRatio = ratio
		@_vRatio = @_easing(0, @_tRatio, 0, 1, 1)
		for key, value1 of @_to
			value0 = @_from[key]
			@_target[key] = value0 + (value1 - value0) * @_vRatio

	_intervalHandler: (event) =>
		t = (new Date().getTime() - @_startTime) / 1000
		if t < @_time
			@_apply(t / @_time)
			@_onUpdate?()
		else
			@_apply(1)
			@_onUpdate?()
			@_onComplete?()
			@_cancel()
			@notifyComplete()


	###
	Getter / Setter
	###
	getTarget: () -> return @_target
	setTarget: (target) -> @_target = target; @

	getTo: () -> return @_to
	setTo: (to) -> @_to = to; @

	getFrom: () -> return @_from
	setFrom: (from) -> @_from = from; @

	getTime: () -> return @_time
	setTime: (time) -> @_time = time; @

	getEasing: () -> return @_easing
	setEasing: (easing) -> @_easing = easing; @

	getOnStart: () -> return @_onStart
	setOnStart: (onStart) -> @_onStart = onStart; @

	getOnUpdate: () -> return @_onUpdate
	setOnUpdate: (onUpdate) -> @_onUpdate = onUpdate; @

	getOnComplete: () -> return @_onComplete
	setOnComplete: (onComplete) -> @_onComplete = onComplete; @

	getRatio: () -> return @_vRatio
	getTimeRatio: () -> return @_tRatio


	###
	Protected
	###
	_executeFunction: (command) ->
		@_from ?= {}
		@_from[key] ?= @_target[key] for key, value1 of @_to
		if @_time > 0
			@_intervalId = setInterval(@_intervalHandler, 10)
			@_startTime = new Date().getTime()
			@_apply(0)
			@_onStart?()
		else
			@_apply(0)
			@_onStart?()
			@_apply(1)
			@_onUpdate?()
			@_onComplete?()
			@notifyComplete()

	_interruptFunction: (command) ->
		@_cancel()

	_destroyFunction: (command) ->
		@_cancel()


#export
Namespace('jpp.command').register('Tween', Tween)