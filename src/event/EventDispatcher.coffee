###
AS3 like EventDispatcher
###
class EventDispatcher

	constructor: (target = null) ->
		@_target = target ? @
		@_listeners = {}

	addEventListener: (type, listener) ->
		return @ unless typeof listener == 'function'
		@_listeners[type] ?= []
		for l in @_listeners[type]
			return @ if l == listener
		@_listeners[type].push(listener)
		@

	removeEventListener: (type, listener) ->
		return @ unless @hasEventListener(type)
		for l, i in @_listeners[type]
			@_listeners[type].splice(i, 1) if l == listener
		delete @_listeners[type] if @_listeners[type].length == 0
		@

	removeAllEventListeners: (type = '') ->
		if type == '' then @_listeners = {} else delete @_listeners[type]
		@

	hasEventListener: (type) ->
		return @_listeners[type]?

	dispatchEvent: (type, extra = null) ->
		return @ unless @hasEventListener(type)
		event = new Event(type, @_target, extra)
		for l in @_listeners[type]
			l.call(@_target, event)
		@


#export
Namespace('jpp.event').register('EventDispatcher', EventDispatcher)