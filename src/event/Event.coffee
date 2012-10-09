###
Event
	@type
	@target
	@data
###
class Event
	@COMPLETE = 'complete'
	@OPEN     = 'open'
	@CLOSE    = 'close'
	@ERROR    = 'error'
	@CANCEL   = 'cancel'
	@RESIZE   = 'resize'
	@INIT     = 'init'
	@CONNECT  = 'connect'
	@PROGRESS = 'progress'
	@ADDED    = 'added'
	@REMOVED  = 'removed'
	@SELECT   = 'select'
	@FOCUS    = 'focus'
	@RENDER   = 'render'

	constructor: (@type, @target, @extra) ->


#export
Namespace('jpp.event').register('Event', Event)