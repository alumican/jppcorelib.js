###
Namespace
###
class Namespace
	constructor: (path) ->
		return _printError("Namespace('#{path}'), '#{path}' is invalid.") unless Namespace._validatePath(path)
		return new _NamespaceObject(path)

	###
	STATIC PRIVATE MEMBER
	###
	Namespace._spaces = {}
	Namespace._separator = '.'
	Namespace._defaultScope = window
	Namespace._regSeparator = if Namespace._separator.match(/[\[\]\-^$.+*?{}\\]/) != null then "\\#{Namespace._separator}" else Namespace._separator
	Namespace._regPath = new RegExp("^[0-9a-zA-Z]+(#{Namespace._regSeparator}[0-9a-zA-Z]+)*$")

	###
	STATIC PRIVATE METHOD
	###
	Namespace._getSpace = (path) -> return Namespace._spaces[path]
	Namespace._setSpace = (path) -> return Namespace._spaces[path] ?= {};
	Namespace._existSpace = (path) -> return Namespace._spaces[path]?;
	Namespace._validatePath = (path) -> return path? && Namespace._regPath.test(path)
	Namespace._print = (message) -> console?.log?(message)
	Namespace._printError = (func, message) -> Namespace._print("###ERROR### at #{func} : #{message}")

	###
	STATIC PUBLIC METHOD
	###

	#名前空間上のオブジェクトを列挙する(デバッグ用)
	Namespace.enumerate = () -> Namespace._print(Namespace._spaces)



###
NamespaceObject (Internal)
###
class _NamespaceObject
	constructor: (path) ->
		@_path = path
		@_names = @_path.split(Namespace._separator);
		@_space = Namespace._getSpace(@_path);
		@_scope = Namespace._defaultScope;

	###
	PUBLIC METHOD
	###

	#名前空間にオブジェクトを登録する
	register: (classname, object, ignoreConflict = false) ->

		#argument error
		unless classname? && object?
			Namespace._printError("Namespace('#{@_path}').register", 'one of arguments is not defined')
			return @

		#register object to namespace
		@_allocate()
		if ignoreConflict || !@_space[classname]?
			@_space[classname] = object
			return @

		#conflict error
		Namespace._printError("Namespace('#{@_path}').register", "'#{classname}' is already registered.")
		return @

	#名前空間上のクラスをインポートする
	import: (classname = '*') ->
		@_allocate()

		#import();
		#import('*');
		if classname == '*'
			@_extern(key) for key, object of @_space
			return @

		#import(['Hoge', 'Fuga']);
		if classname instanceof Array
			@_extern(key) for key in classname
			return @

		#import('Moja');
		if @_space[classname]?
			@_extern(classname)
			return @

		#argument error
		Namespace._printError("Namespace('#{@_path}').import", "'#{classname}' is not defined")
		return @

	#名前空間を取得する
	exist: () -> return Namespace._existSpace(@_path)

	#名前空間を利用する
	use: () ->
		@_allocate()
		ns = @_scope
		ns = ns[name] ?= {} for name in @_names
		ns[key] = object for key, object of @_space
		return @

	#スコープを変更する
	scope: (scope = Namespace._defaultScope) ->
		@_scope = scope
		return @

	#パスを取得する
	getPath: () -> return @_path

	###
	PRIVATE MEMBER
	###
	_allocate: () ->
		return if Namespace._existSpace(@_path)
		@_space = Namespace._setSpace(@_path)

		#allocate subspace
		n = @_names.length
		i = 1
		while i < n
			Namespace._setSpace(@_names.slice(0, i).join('.'))
			++i

	_extern: (classname) ->
		@_scope[classname] = @_space[classname]


#export myself
Namespace('jpp.util').register('Namespace', Namespace).use()
###
Error Util
###
class Err
	Err.build = (at, text = '') -> return new Error("Error at #{at}" + (" : #{text}" unless text == ''))
	Err.throw = (at, text = '') -> throw Err.build(at, text)


#export
Namespace('jpp.util').register('Err', Err)
###
Number Util
###
class Num

	#constant
	Num.PI   = Math.PI;
	Num.PI2  = Num.PI * 2
	Num.PI_2 = Num.PI / 2
	Num.PI_3 = Num.PI / 3
	Num.PI_4 = Num.PI / 4
	Num.PI_6 = Num.PI / 6

	#convert degree to radian
	Num.toRadian = (degree) ->
		return degree * PI / 180

	#convert radian to degree
	Num.toDegree = (radian) ->
		return radian * 180 / PI

	#calc distance from dx dy
	Num.dist = (dx, dy, squared = true) ->
		if squared then return Math.sqrt(dx * dx + dy * dy) else return dx * dx + dy * dy

	#calc distance from x0 x1 y0 y1
	Num.dist2 = (x0, y0, x1, y1, squared = true) ->
		return dist(x1 - x0, y1 - y0, squared)

	#値を指定区間内に丸める
	Num.map = (value, srcMin, srcMax, dstMin, dstMax) ->
		value = srcMin if value < srcMin
		value = srcMax if value > srcMax
		return (value - srcMin) * (dstMax - dstMin) / (srcMax - srcMin) + dstMin

	#2点(p1, p2)をd1:d2に内分する点を求める
	Num.internallyDividing = (p1, p2, d1, d2) ->
		if p1 == p2 then return p1 else return (d2 * p1 + d1 * p2) / (d1 + d2)

	#2点(p1, p2)をd1:d2に外分する点を求める
	Num.externallyDividing = (p1, p2, d1, d2) ->
		if p1 == p2 then return p1 else return (d2 * p1 - d1 * p2) / (d2 - d1)

	#符号を求める
	Num.sign = (value) ->
		return value < 0 ? -1 : 1

	#ランダムに選ぶ
	Num.choose = (args...) ->
		return args[Math.floor(Math.random() * args.length)]

	#value1とvalue2をratio1:ratio2の割合で混合する
	Num.combine = (value1, value2, ratio1, ratio2 = null) ->
		if ratio1 > 1 then ratio2 ?= 1 else ratio2 ?= 1 - ratio1
		t = ratio1 + ratio2
		return value1 * ratio1 / t + value2 * (1 - ratio1 / t)

	#[min, max)の範囲の値をランダムに選択する
	Num.range = (min, max) ->
		return Math.random() * (max - min) + min

#export
Namespace('jpp.util').register('Num', Num)
###
Array Util
###
class Arr

	Arr.sequence = (size, start = 0, step = 1) ->
		a = []
		i = 0
		while i < size
			a[i] = i * step
			++i
		return a

	Arr.choose = (array, splice = false) ->
		index = Math.floor(Math.random() * array.length)
		if splice then return array.splice(index, 1)[0] else return array[index]

	Arr.shuffle = (array, overwrite = false) ->
		array = array.concat() if overwrite
		i = n = array.length
		while (i--)
			t = Math.floor(Math.random() * i)
			tmp = array[i]
			array[i] = array[t]
			array[t] = tmp
		return array


#export
Namespace('jpp.util').register('Arr', Arr)
###
Easing
###
class Easing

	###
	Linear
	###
	Easing.Linear = (x, t, b, c, d) ->
		return c * t / d + b

	###
	Quad
	###
	Easing.easeInQuad = (x, t, b, c, d) ->
		return c * (t /= d) * t + b

	Easing.easeOutQuad = (x, t, b, c, d) ->
		return (-c) * (t /= d) * (t - 2) + b

	Easing.easeInOutQuad = (x, t, b, c, d) ->
		return c / 2 * t * t + b if (t /= d / 2) < 1
		return (-c) / 2 * ((--t) * (t - 2) - 1) + b

	###
	Cubic
	###
	Easing.easeInCubic = (x, t, b, c, d) ->
		return c * (t /= d) * t * t + b

	Easing.easeOutCubic = (x, t, b, c, d) ->
		return c * ((t = t / d - 1) * t * t + 1) + b

	Easing.easeInOutCubic = (x, t, b, c, d) ->
		return c / 2 * t * t * t + b if (t /= d / 2) < 1
		return c / 2 * ((t -= 2) * t * t + 2) + b

	###
	Quart
	###
	Easing.easeInQuart = (x, t, b, c, d) ->
		return c * (t /= d) * t * t * t + b

	Easing.easeOutQuart = (x, t, b, c, d) ->
		return (-c) * ((t = t / d - 1) * t * t * t - 1) + b

	Easing.easeInOutQuart = (x, t, b, c, d) ->
		return c / 2 * t * t * t * t + b if (t /= d / 2) < 1
		return (-c) / 2 * ((t -= 2) * t * t * t - 2) + b

	###
	Quint
	###
	Easing.easeInQuint = (x, t, b, c, d) ->
		return c * (t /= d) * t * t * t * t + b

	Easing.easeOutQuint = (x, t, b, c, d) ->
		return c * ((t = t / d - 1) * t * t * t * t + 1) + b

	Easing.easeInOutQuint = (x, t, b, c, d) ->
		return c / 2 * t * t * t * t * t + b if (t /= d / 2) < 1
		return c / 2 * ((t -= 2) * t * t * t * t + 2) + b

	###
	Sine
	###
	Easing.easeInSine = (x, t, b, c, d) ->
		return (-c) * Math.cos(t / d * (Math.PI / 2)) + c + b

	Easing.easeOutSine = (x, t, b, c, d) ->
		return c * Math.sin(t / d * (Math.PI / 2)) + b

	Easing.easeInOutSine = (x, t, b, c, d) ->
		return (-c) / 2 * (Math.cos(Math.PI * t / d) - 1) + b

	###
	Expo
	###
	Easing.easeInExpo = (x, t, b, c, d) ->
		return b if t == 0
		return c * Math.pow(2, 10 * (t / d - 1)) + b

	Easing.easeOutExpo = (x, t, b, c, d) ->
		return b + c if t == d
		return c * (-Math.pow(2, -10 * t / d) + 1) + b

	Easing.easeInOutExpo = (x, t, b, c, d) ->
		return b if t == 0
		return b + c if t == d
		return c / 2 * Math.pow(2, 10 * (t - 1)) + b if (t /= d / 2) < 1
		return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b

	###
	Circ
	###
	Easing.easeInCirc = (x, t, b, c, d) ->
		return (-c) * (Math.sqrt(1 - (t /= d) * t) - 1) + b

	Easing.easeOutCirc = (x, t, b, c, d) ->
		return c * Math.sqrt(1 - (t = t / d - 1) * t) + b

	Easing.easeInOutCirc = (x, t, b, c, d) ->
		return (-c) / 2 * (Math.sqrt(1 - t * t) - 1) + b if (t /= d / 2) < 1
		return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b

	###
	Elastic
	###
	Easing.easeInElastic = (x, t, b, c, d) ->
		s = 1.70158
		p = 0
		a = c
		return b if t == 0
		return b + c if (t /= d) == 1
		p = d * 0.3 if p == 0
		if a < Math.abs(c)
			a = c
			s = p / 4
		else
			s = p / (2 * Math.PI) * Math.asin(c / a)
		return (-a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p )) + b

	Easing.easeOutElastic = (x, t, b, c, d) ->
		s = 1.70158
		p = 0
		a = c
		return b if t == 0
		return b + c if (t /= d) == 1
		p = d * 0.3 if p == 0
		if a < Math.abs(c)
			a = c
			s = p / 4
		else
			s = p / (2 * Math.PI) * Math.asin(c / a)
		return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p ) + c + b

	Easing.easeInOutElastic = (x, t, b, c, d) ->
		s = 1.70158
		p = 0
		a = c
		return b if t == 0
		return b + c if (t /= d / 2) == 2
		p = d * (0.3 * 1.5) if p == 0
		if (a < Math.abs(c))
			a = c
			s = p / 4
		else
			s = p / (2 * Math.PI) * Math.asin(c / a)
		return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b if t < 1
		return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * 0.5 + c + b

	###
	Back
	###
	Easing.easeInBack = (x, t, b, c, d, s = 1.70158) ->
		return c * (t /= d) * t * ((s + 1) * t - s) + b

	Easing.easeOutBack = (x, t, b, c, d, s = 1.70158) ->
		return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b

	Easing.easeInOutBack = (x, t, b, c, d, s = 1.70158) ->
		return c / 2 * (t * t * (((s *= 1.525) + 1) * t - s)) + b if (t /= d / 2) < 1
		return c / 2 * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2) + b

	###
	Bounce
	###
	Easing.easeInBounce = (x, t, b, c, d) ->
		return c - Easing.easeOutBounce(x, d - t, 0, c, d) + b

	Easing.easeOutBounce = (x, t, b, c, d) ->
		if (t /= d) < (1 / 2.75)
			return c * (7.5625 * t * t) + b
		else if t < (2 / 2.75)
			return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b
		else if t < (2.5 / 2.75)
			return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b
		else
			return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b

	Easing.easeInOutBounce = (x, t, b, c, d) ->
		return Easing.easeInBounce(x, t * 2, 0, c, d) * 0.5 + b if t < d / 2
		return Easing.easeOutBounce(x, t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b


#export
Namespace('jpp.util').register('Easing', Easing)
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
###
CommandState
###
class CommandState
	@SLEEPING     = 0
	@EXECUTING    = 1
	@INTERRUPTING = 2


#export
Namespace('jpp.command').register('CommandState', CommandState)
###
Command
###
class Command extends EventDispatcher

	###
	Constructor
	###
	constructor: (executeFunction = null, interruptFunction = null, destroyFunction = null) ->
		super()
		@setExecuteFunction(executeFunction);
		@setInterruptFunction(interruptFunction);
		@setDestroyFunction(destroyFunction);
		@_state = CommandState.SLEEPING
		@_self = this
		@_parent = null


	###
	Method
	###
	execute: () ->
		Err.throw('Command.execute', 'Command is already executing.') if @_state > CommandState.SLEEPING
		@_state = CommandState.EXECUTING
		@getExecuteFunction().call(this, this)
		@

	interrupt: () ->
		if @_state == CommandState.EXECUTING
			@_state = CommandState.INTERRUPTING
			@getInterruptFunction().call(this, this)
		@

	destroy: () ->
		@_state = CommandState.SLEEPING
		@getDestroyFunction().call(this, this)
		@_parent = null
		@__executeFunction = null
		@__interruptFunction = null
		@__destroyFunction = null
		@

	notifyComplete: () ->
		switch @_state
			when CommandState.SLEEPING
				@

			when CommandState.EXECUTING
				@dispatchEvent(Event.COMPLETE)
				@destroy()
				@

			when CommandState.INTERRUPTING
				@dispatchEvent(Event.COMPLETE)
				@destroy()
				@


	###
	Getter / Setter
	###
	getExecuteFunction: () -> return @__executeFunction ? @_executeFunction
	setExecuteFunction: (f) -> @__executeFunction = f; @

	getInterruptFunction: () -> return @__interruptFunction ? @_interruptFunction
	setInterruptFunction: (f) -> @__interruptFunction = f; @

	getDestroyFunction: () -> return @__destroyFunction ? @_destroyFunction
	setDestroyFunction: (f) -> @__destroyFunction = f; @

	getState: () -> return @_state

	getSelf: () -> return @_self

	getParent: () -> return @_parent
	setParent: (parent) -> @_parent = parent


	###
	Protected
	###
	_executeFunction: (command) -> @notifyComplete()
	_interruptFunction: (command) ->
	_destroyFunction: (command) ->


#export
Namespace('jpp.command').register('Command', Command)

###
CommandList
###
class CommandList extends Command

	###
	Constructor
	###
	constructor: (commands...) ->
		super()
		@_commands = []
		@addCommand(commands...)


	###
	Method
	###
	addCommand: (commands...) ->
		@_setParent(commands)
		@_commands = @getCommands().concat(commands)
		@

	insertCommand: (index, commands...) ->
		@_setParent(commands)
		Array.prototype.splice.apply(@getCommands(), [index, 0].concat(commands))
		@

	addCommandArray: (commands) ->
		@addCommand(commands...)
		@

	insertCommandArray: (index, commands) ->
		@insertCommand(commands...)
		@

	_setParent: (commands) ->
		i = 0
		for c in commands
			commands[i] = c = new Func(c) if typeof(c) is 'function'
			c.setParent(@)
			++i

	notifyBreak: () ->
	notifyReturn: () ->

	###
	Getter / Setter
	###
	getCommandByIndex: (index) -> return @_commands[index]
	getCommands: () -> return @_commands
	getLength: () -> return @_commands.length


	###
	Protected
	###
	_executeFunction: (command) -> @notifyComplete()
	_interruptFunction: (command) ->
	_destroyFunction: (command) -> @_commands = []


#export
Namespace('jpp.command').register('CommandList', CommandList)

###
SerialList
###
class SerialList extends CommandList

	###
	Constructor
	###
	constructor: (commands...) ->
		super(commands...)
		@_currentCommand = null
		@_position = 0
		@_isPaused = false
		@_isCompleteOnPaused = false


	###
	Method
	###
	addCommand: (commands...) ->
		super(commands...)
		@

	insertCommand: (commands...) ->
		super(@_position + 1, commands...)
		@

	#pause: (withChildren = false) ->
	#	return if @_isPaused
	#	@_isPaused = true
	#	@_currentCommand.pause(true) if withChildren and @_currentCommand instanceof SerialList

	#resume: () ->
	#	return if not @_isPaused
	#	@_isPaused = false
	#	if @_isCompleteOnPaused
	#		@_isCompleteOnPaused = false
	#		@_updatePosition()

	_next: () ->
		@_currentCommand = @getCommandByIndex(@_position)
		@_currentCommand.addEventListener(Event.COMPLETE, @_completeHandler)
		@_currentCommand.execute()

	_completeHandler: (event) =>
		@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
		@_currentCommand = null
		#if @_isPaused
		#	@_isCompleteOnPaused = true
		#else
		#	@_updatePosition()
		if ++@_position >= @getLength() then @notifyComplete() else @_next() #pause実装したら消す

	#_updatePosition: () ->
	#	if ++@_position >= @getLength() then @notifyComplete() else @_next()

	notifyBreak: () ->
		if @_currentCommand?.getState() == CommandState.EXECUTING
			@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
			@_currentCommand.interrupt()
		@notifyComplete()

	notifyReturn: () ->
		if @_currentCommand?.getState() == CommandState.EXECUTING
			@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
			@_currentCommand.interrupt()
		@getParent()?.notifyReturn()
		@destroy()


	###
	Getter / Setter
	###
	getPosition: () -> return @_position
	#getIsPaused: () -> return @_isPaused


	###
	Protected
	###
	_executeFunction: (command) ->
		@_position = 0
		if @getLength() > 0 then @_next() else @notifyComplete()

	_interruptFunction: (command) ->
		if @_currentCommand?
			@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
			@_currentCommand.interrupt()
		@_currentCommand = null
		@_position = 0
		super(command)

	_destroyFunction: (command) ->
		if @_currentCommand?
			@_currentCommand.removeEventListener(Event.COMPLETE, @_completeHandler)
			@_currentCommand.destroy()
		@_currentCommand = null
		@_position = 0
		@_isPaused = false
		@_isCompleteOnPaused = false
		super(command)


#export
Namespace('jpp.command').register('SerialList', SerialList)
###
ParallelList
###
class ParallelList extends CommandList

	###
	Constructor
	###
	constructor: (commands...) ->
		super(commands...)
		@_completeCount = 0


	###
	Method
	###
	addCommand: (commands...) ->
		super(commands...)
		@

	insertCommand: (commands...) ->
		super(@getLength(), commands...)
		@

	_completeHandler: (event) =>
		@notifyComplete() if ++@_completeCount >= @getLength()

	notifyBreak: () ->
		for c in @getCommands()
			if c.getState() == CommandState.EXECUTING
				c.removeEventListener(Event.COMPLETE, @_completeHandler)
				c.interrupt()
		@notifyComplete()

	notifyReturn: () ->
		for c in @getCommands()
			if c.getState() == CommandState.EXECUTING
				c.removeEventListener(Event.COMPLETE, @_completeHandler)
				c.interrupt()
		@getParent()?.notifyReturn()
		@destroy()


	###
	Getter / Setter
	###
	getCompleteCount: () -> return @_completeCount


	###
	Protected
	###
	_executeFunction: (command) ->
		@_completeCount = 0
		for c in @getCommands()
			c.addEventListener(Event.COMPLETE, @_completeHandler)
			c.execute()


	_interruptFunction: (command) ->
		for c in @getCommands()
			c.removeEventListener(Event.COMPLETE, @_completeHandler)
			c.interrupt()
		super(command)

	_destroyFunction: (command) ->
		for c in @getCommands()
			c.removeEventListener(Event.COMPLETE, @_completeHandler)
			c.destroy()
		@_completeCount = 0
		super(command)


#export
Namespace('jpp.command').register('ParallelList', ParallelList)
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
###
Func Command
###
class Func extends Command

	###
	Constructor
	###
	constructor: (func = null, args = [], dispatcher = null, eventType = null) ->
		super()
		@_func = func
		@_args = args
		@_dispatcher = dispatcher
		@_eventType = eventType


	###
	Method
	###
	_completeHandler: (event) =>
		@notifyComplete()


	###
	Getter / Setter
	###
	getFunction: () -> return @_func
	setFunction: (func) -> @_func = func; @

	getArguments: () -> return @_args
	setArguments: (args) -> @_args = args; @


	###
	Protected
	###
	_executeFunction: (command) ->
		if @_dispatcher? && @_eventType?
			@_dispatcher.addEventListener(@_eventType, @_completeHandler)
			@_func?(@_args...)
		else
			@_func?(@_args...)
			@notifyComplete()

	_interruptFunction: (command) ->
		if @_dispatcher? && @_eventType?
			@_dispatcher.removeEventListener(@_eventType, @_completeHandler)

	_destroyFunction: (command) ->
		@_func = null
		@_args = null
		@_dispatcher = null
		@_eventType = null


#export
Namespace('jpp.command').register('Func', Func)
###
Trace Command
###
class Trace extends Command

	###
	Constructor
	###
	constructor: (message) ->
		super()
		@_message = message


	###
	Method
	###


	###
	Getter / Setter
	###
	getMessage: () -> return @_message
	setMessage: (message) -> @_message = message; @


	###
	Protected
	###
	_executeFunction: (command) ->
		console.log(@_message)
		@notifyComplete()

	_interruptFunction: (command) ->

	_destroyFunction: (command) ->
		@_message = null


#export
Namespace('jpp.command').register('Trace', Trace)

###
Wait Command
###
class Wait extends Command

	###
	Constructor
	###
	constructor: (time = 1) ->
		super()
		@_time = time
		@_timeoutId = -1


	###
	Method
	###
	_cancel: () ->
		clearTimeout(@_timeoutId) unless @_timeoutId == -1
		@_timeoutId = -1

	_completeHandler: (event) =>
		@notifyComplete()


	###
	Getter / Setter
	###
	getTime: () -> return @_time
	setTime: (time) -> @_time = time; @


	###
	Protected
	###
	_executeFunction: (command) ->
		@_timeoutId = setTimeout(@_completeHandler, @_time * 1000)

	_interruptFunction: (command) ->
		@_cancel()

	_destroyFunction: (command) ->
		@_cancel()


#export
Namespace('jpp.command').register('Wait', Wait)
###
Listen Command
###
class Listen extends Command

	###
	Constructor
	###
	constructor: (type = null, dispatcher = null) ->
		super()
		@_type = type
		@_dispatcher = dispatcher


	###
	Method
	###
	_handler: (event) =>
		@notifyComplete()


	###
	Getter / Setter
	###
	getType: () -> return @_type
	setType: (type) -> @_type = type; @

	getDispatcher: () -> return @_dispatcher
	setDispatcher: (dispatcher) -> @_dispatcher = dispatcher; @

	###
	Protected
	###
	_executeFunction: (command) ->
		@_dispatcher?.addEventListener(@_type, @_handler) if @_type?

	_interruptFunction: (command) ->
		@_dispatcher?.removeEventListener(@_type, @_handler) if @_type?

	_destroyFunction: (command) ->
		@_dispatcher?.removeEventListener(@_type, @_handler) if @_type?
		@_type = null
		@_dispatcher = null


#export
Namespace('jpp.command').register('Listen', Listen)
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
###
jQuery.ajax Command
###
class JqueryAjax extends Command

	###
	Constructor
	###
	constructor: (options = null) ->
		super()
		@_options = options ? {}
		@_status = ''
		@_isSucceed = false


	###
	Method
	###
	_completeHandler: (XMLHttpRequest, status) =>
		console.log(this);
		@_status = status
		@_isSucceed = status == 'success'
		@_options.complete?(XMLHttpRequest, status)
		@notifyComplete() if @getState() == CommandState.EXECUTING


	###
	Getter / Setter
	###
	getOptions: () -> return @_options
	setOptions: (options) -> @_options = options; @

	getUrl: () -> return @_options.url
	setUrl: (url) -> @_options.url = url; @

	getMethod: () -> return @_options.type
	setMethod: (method) -> @_options.type = method; @

	getData: () -> return @_options.data
	setData: (data) -> @_options.data = data; @

	getDataType: () -> return @_options.dataType
	setDataType: (dataType) -> @_options.dataType = dataType; @

	getOnSuccess: () -> return @_options.success
	setOnSuccess: (callback) -> @_options.success = callback; @

	getOnError: () -> return @_options.error
	setOnError: (callback) -> @_options.error = callback; @

	getOnComplete: () -> return @_options.complete
	setOnComplete: (callback) -> @_options.complete = callback; @

	#Result
	getStatus: () -> return @_status
	getIsSucceed: () -> return @_isSucceed


	###
	Protected
	###
	_executeFunction: (command) ->
		p = {}
		p[key] = value for key, value of @_options
		p.complete = @_completeHandler
		jQuery.ajax(p)

	_interruptFunction: (command) -> @

	_destroyFunction: (command) ->
		@_options = null
		@_status = ''
		@_isSucceed = false


#export
Namespace('jpp.command').register('JqueryAjax', JqueryAjax)
###
jQuery.get Command
###
class JqueryGet extends JqueryAjax

	###
	Constructor
	###
	constructor: (url = null, data = null, onSuccess = null, onError = null, dataType = null) ->
		super({
			type : 'get'
			url : url
			data : data
			success : onSuccess
			error : onError
			dataType : dataType
		})


	###
	Method
	###


	###
	Getter / Setter
	###


	###
	Protected
	###


#export
Namespace('jpp.command').register('JqueryGet', JqueryGet)
###
jQuery.post Command
###
class JqueryPost extends JqueryAjax

	###
	Constructor
	###
	constructor: (url = null, data = null, onSuccess = null, onError = null, dataType = null) ->
		super({
			type : 'post'
			url : url
			data : data
			success : onSuccess
			error : onError
			dataType : dataType
		})


	###
	Method
	###


	###
	Getter / Setter
	###


	###
	Protected
	###


#export
Namespace('jpp.command').register('JqueryPost', JqueryPost)
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

###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class Compass extends EventDispatcher

	#バージョン
	@VERSION: '0.1.0'

	#===============================================
	#
	# Constructor
	#
	#===============================================
	constructor: (option) ->
		super(@)

		@_isReleaseMode = option.isReleaseMode ? true
		@_log = CompassUtil.log

		@_queue = []
		@_queuePosition = -1
		@_direction = []
		@_targetFragment = null
		@_currentScene = null
		@_isInGeneratingSubFragment = false
		@_isRunning = false
		@_isFirstRequest = true
		@_scenes = {}

		@root = option.root ? @root
		@rootFile = option.rootFile ? @rootFile
		@routes = option.routes ? @routes

		#ルート
		kazitoriRoutes = {}
		getRouteHandler = (rule, sceneClass) =>
			return (params...) =>
				@_kazitoriRoutingHandler(rule, sceneClass, params)
		#シーンが関連づけられているパス
		for rule, sceneClass of @routes
			kazitoriRoutes[rule] = getRouteHandler(rule, sceneClass)
		#シーンが関連づけられていない中間パス
		for rule of @routes
			fragments = CompassUtil.decompseFragment(rule).route
			for subRule in fragments
				if kazitoriRoutes[subRule] is undefined
					kazitoriRoutes[subRule] = getRouteHandler(subRule, null)

		#kazitoriに渡す用
		kazitoriOption = {}
		kazitoriOption.root = @root
		kazitoriOption.rootFile = @rootFile
		kazitoriOption.routes = kazitoriRoutes
		kazitoriOption.isAutoStart = false
		kazitoriOption.notFound = (params...) => @_kazitoriRoutingNotFoundHandler(params)

		@_kazitori = new Kazitori(kazitoriOption)
		@_kazitori.addEventListener(KazitoriEvent.EXECUTED, @_kazitoriExecutedHandler)

		CompassUtil.LOGGING = true
		CompassUtil.printInit(@_kazitori, @routes)

		#ユーザによる初期化タイミング
		@onInit()

		#開始
		@_kazitori.start()


	#===============================================
	#
	# Method
	#
	#===============================================

	#指定のフラグメントに遷移する
	goto: (fragment) ->
		@_log("goto : '#{fragment}'")
		@_kazitori.change(fragment)

	#ヒストリーの次へ遷移する
	next: () ->
		@_log('next')
		@_kazitori.torikazi()

	#ヒストリーの前へ遷移する
	prev: () ->
		@_log('prev')
		@_kazitori.omokazi()

	#シーンオブジェクトを取得する
	getScene: (fragment) ->
		@_log("get scene : '#{fragment}'")
		scene = @_scenes[fragment]

		#シーンが登録されていない場合は作成
		if scene is undefined
			@_log("get scene temporary : '#{fragment}'")
			@_isInGeneratingSubFragment = true
			@_kazitori.fragment = fragment
			@_kazitori.executeHandlers() #TODO loadURLではエラーが出る謎を解く
			@_targetFragment = @_kazitori.fragment
			@_isInGeneratingSubFragment = false
			scene = @_scenes[fragment]

		#初期化されていない場合はエラー
		if scene.getIsInitialized() is false
			CompassUtil.error("初期化されていないシーン'#{fragment}'が呼び出されました")

		return scene

	#ユーザによる初期化のタイミングで呼び出される(for ovverride)
	onInit: () ->

	#シーンが未定義だったときに呼び出される(for ovverride)
	onSceneRequest: (fragment, params) ->
		return Scene

	#kazitoriのルーティングバインド関数
	_kazitoriRoutingHandler: (rule, sceneClass, params) =>
		fragment = @_kazitori.fragment
		scene = @_scenes[fragment]

		if scene is undefined
			@_log("create new Scene of '#{fragment}'")
			if sceneClass is null
				@_log("request Scene of '#{fragment}'")
				sceneClass = @onSceneRequest(fragment, params)
				if sceneClass is undefined or sceneClass is null
					@_log("default Scene of '#{fragment}'")
					sceneClass = Scene

			scene = new sceneClass(rule, fragment, params)
			scene.init()
			@_scenes[fragment] = scene

		@_log("kazitoriRoutingHandler : rule     = #{scene.getRule()}")
		@_log("kazitoriRoutingHandler : fragment = #{scene.getFragment()}")
		@_log("kazitoriRoutingHandler : params   = [#{scene.getParams().join(', ')}]")

	#kazitoriのルーティングバインド関数(not found)
	_kazitoriRoutingNotFoundHandler: (params) =>
		@_log('404 :' + params.join(', '))
		#TODO ユーザが定義した404Sceneに遷移する, なければTOPへ？

	#Kazitori.EXECUTEDイベントハンドラ(not foundの場合は実行されない)
	_kazitoriExecutedHandler: (event) =>
		#中間パス生成中は何もしない
		return if @_isInGeneratingSubFragment

		#1回目のEXECUTEイベントが不正に発行されるバグを回避
		return if @_isFirstRequest and event.next is @root
		@_isFirstRequest = false

		fragment = event.next
		if @_targetFragment is null
			#first request
			flow = CompassUtil.decompseFragment(fragment)
		else
			flow = CompassUtil.complementFragment(@_targetFragment, fragment)
		route = flow.route
		direction = flow.direction

		@_pushRoute(route, direction)

	#経路を追加する
	_pushRoute: (route, direction) ->
		return false if route is null
		return false if route.length == 0
		return false if route[route.length - 1] is @_targetFragment

		prevTargetFragment = @_targetFragment

		@_targetFragment = route[route.length - 1]
		@_queue = @_queue[0...@_queuePosition].concat(route)
		@_direction = @_direction[0...@_queuePosition].concat(direction)
		@_log("pushRoute : queue = '#{@_queue.join('\' -> \'')}'")
		@_log("pushRoute : direction = '#{@_direction.join('\' -> \'')}'")
		@_log("pushRoute : position = #{@_queuePosition}")

		#TODO タイトルの変更
		#location.title = @getScene(@_targetFragment).getTitle()

		#イベントの発行
		@_log("change : route = '#{route.join('\' -> \'')}'")
		@dispatchEvent(CompassEvent.CHANGE, { prev: prevTargetFragment , next: @_targetFragment })

		@_startAsync()
		return true

	#非同期処理を開始する
	_startAsync: () ->
		return false if @_isRunning

		if @_currentScene is null
			#初回
			@_log('start async process : first')
			@_nextAsync()
		else
			#2回目以降
			@_currentScene.addEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
			if @_currentScene.getStatus() is SceneStatus.STAY
				@_log('start async process : leave')
				@_currentScene.leave()
			else
				@_log('start async process : bye')
				@_currentScene.bye()

	#非同期処理
	_nextAsync: () ->
		@_currentScene?.removeEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)

		++@_queuePosition
		fragment = @_queue[@_queuePosition]

		@_currentScene = @getScene(fragment)
		@_currentScene.addEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
		@_currentScene.hello()

	#シーン変更ハンドラ
	_sceneChangeStatusHandler: (event) =>
		if event.extra.isComplete
			@_isRunning = false
			@_currentScene.removeEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
			switch event.extra.status

				when SceneStatus.HELLO
					if @_queuePosition == @_queue.length - 1
						@_currentScene.addEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
						@_currentScene.arrive()
					else
						@_nextAsync()

				when SceneStatus.ARRIVE
					@

				when SceneStatus.LEAVE
					@_currentScene.addEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
					@_currentScene.bye()

				when SceneStatus.BYE
					@_nextAsync()
		else
			@_isRunning = true


#export
Namespace('jpp.compass').register('Compass', Compass)

###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class CompassEvent extends Event

	#===============================================
	#
	# Event Type
	#
	#===============================================

	#最初のシーンが認識されたときに発行される
	@INIT: 'init'

	#シーンが切り替わったときに発行される
	@CHANGE: 'change'


#export
Namespace('jpp.compass').register('CompassEvent', CompassEvent)

###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class CompassUtil

	@LOGGING: true

	#===============================================
	#
	# Method
	#
	#===============================================

	#フラグメントを分解する '/a/b/c' -> ['/', '/a', '/a/b', '/a/b/c']
	@decompseFragment: (fragment) ->
		if fragment is null or fragment is '' or fragment is '/'
			return { route : ['/'], direction : true }
		else
			route = fragment.split('/')
			direction = []
			s = ''
			i = 0
			for sub in route
				s += if s == '/' then sub else '/' + sub
				route[i] = s
				direction[i] = true
				++i
			return { route : route, direction : direction }

	#2つのパス間の経路を算出する
	@complementFragment: (prev, next) ->
		route = []
		direction = []

		#normalize
		prev ?= ''
		next ?= ''
		prev = prev.substr(1) if prev.charAt(0) == '/'
		next = next.substr(1) if next.charAt(0) == '/'
		#console.log("prev : '#{prev}'")
		#console.log("next : '#{next}'")

		#split fragment
		prevs = CompassUtil.decompseFragment(prev).route
		nexts = CompassUtil.decompseFragment(next).route
		#console.log("prevs : '#{prevs}'")
		#console.log("nexts : '#{nexts}'")

		#get branch point
		n = Math.min(prevs.length, nexts.length)
		branch = 0
		while branch < n
			break if prevs[branch] isnt nexts[branch]
			++branch
		#console.log("branch : #{branch}")

		#backword
		n = branch
		i = prevs.length - 1
		while i >= n
			route.push(prevs[i])
			direction.push(false)
			--i
		#console.log("route backward : '#{route}'")

		#forward
		n = nexts.length - 1
		i = branch
		while i <= n
			route.push(nexts[i])
			direction.push(true)
			++i
		#console.log("route result : '#{route}'")

		return { route : route, direction : direction }

	#ログ出力
	@log: (m...) ->
		console.log('[Comppass] ' + m.join(' ')) if CompassUtil.LOGGING

	@error: (m...) ->
		console.log('[Comppass Error] ' + m.join(' '))

	#コピーライト出力
	@printInit: (kazitori, routes) ->
		return unless CompassUtil.LOGGING

		routeArray = []
		for fragment, handler of routes
			routeArray.push('           \'' + fragment + '\'')


		CompassUtil.log("----------------------------------------")
		CompassUtil.log("Compass #{Compass.VERSION}  © Copyright alumican.net All rights reserved.")
		CompassUtil.log("Kazitori #{kazitori.VERSION}  © Copyright hageee.net All rights reserved.")
		CompassUtil.log("root: #{kazitori.root}")
		CompassUtil.log("routes: \n" + routeArray.join('\n'))
		CompassUtil.log("----------------------------------------")


#export
Namespace('jpp.compass').register('CompassUtil', CompassUtil)

###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class Scene extends EventDispatcher

	@self = null


	#===============================================
	#
	# Constructor
	#
	#===============================================
	constructor: (rule, fragment, params) ->
		super(@)

		@self = @

		@_rule = rule
		@_fragment = fragment
		@_params = params

		@_title = null

		@_status = SceneStatus.GONE

		@_isInitialized = false

		@_command = null
		@_commandWrapper = null

		@__commandsHello = []
		@__commandsArrive = []
		@__commandsLeave = []
		@__commandsBye = []


	#===============================================
	#
	# Method
	#
	#===============================================

	#初期化
	init: () ->
		return if @_isInitialized
		@_isInitialized = true
		@_onInit()

	#Helloフェーズを開始する
	hello: () ->
		@_switchStatus(SceneStatus.HELLO, @_getHello)

	#Arriveフェーズを開始する
	arrive: () ->
		@_switchStatus(SceneStatus.ARRIVE, @_getArrive)

	#Leaveフェーズを開始する
	leave: () ->
		@_switchStatus(SceneStatus.LEAVE, @_getLeave)

	#Byeフェーズを開始する
	bye: () ->
		@_switchStatus(SceneStatus.BYE, @_getBye)

	#実行中のコマンドに新たなコマンドを追加する
	addCommand: (commands...) ->
		@_commandWrapper.addCommand(commands...) if @_commandWrapper isnt null

	#実行中のコマンドに新たなコマンドを挿入する
	insertCommand: (commands...) ->
		@_commandWrapper.insertCommand(commands...) if @_commandWrapper isnt null

	#フェーズを切り替える
	_switchStatus: (status, commandFunction) ->
		if @_command isnt null
			CompassUtil.log("Command is being executed (status = #{@_status})")
			return
		@_clearCommand()
		@_status = status
		@_dispatchStatusEvent(@_status, false)
		@_command = commandFunction() #非同期処理生成 / 同期処理実行
		@_command.addEventListener(Event.COMPLETE, @_commandCompleteHandler)
		@_command.execute()

	#フェーズを終了する
	_clearCommand: () ->
		if @_command isnt null
			@_command.removeEventListener(Event.COMPLETE, @_commandCompleteHandler)
			@_command.interrupt()
			@_command = null

	#コマンドの完了ハンドラ
	_commandCompleteHandler: (event) =>
		@_clearCommand()
		prevStatus = @_status
		switch @_status
			when SceneStatus.ARRIVE then @_status = SceneStatus.STAY
			when SceneStatus.BYE then @_status = SceneStatus.GONE
		@_dispatchStatusEvent(prevStatus, true)

	#イベントを発行する
	_dispatchStatusEvent: (status, isComplete) ->
		CompassUtil.log("Scene '#{@_fragment}' : #{status} #{if isComplete then 'End' else 'Begin'}")
		@dispatchEvent(SceneEvent.CHANGE_STATUS, { status: status, isComplete: isComplete })

	#登録されているコマンドを取得する
	_getCommandInternal: (protectedFunction, externalCommands) ->
		@_commandWrapper = new SerialList()
		if @__commandsHello.length == 0 then protectedFunction() else @_commandWrapper.addCommandArray(externalCommands)
		return @_commandWrapper


	#===============================================
	#
	# Getter / Setter
	#
	#===============================================

	#初期化されたかどうかを取得する
	getIsInitialized: () -> return @_isInitialized

	#ルールを取得する
	getRule: () -> return @_rule

	#フラグメントを取得する
	getFragment: () -> return @_fragment

	#パラメータを取得する
	getParams: () -> return @_params

	#現在のステータスを取得する
	getStatus: () -> return @_status

	#このシーンが目的地だった場合もしくはこのシーンを通過するときに実行するコマンドを設定する
	_getHello: () =>
		return @_getCommandInternal(@_onHello, @__commandsHello)

	setHello: (command...) ->
		@__commandsHello = command
		return @

	#このシーンが目的地だった場合に行するコマンドを設定する
	_getArrive: () =>
		return @_getCommandInternal(@_onArrive, @__commandsArrive)

	setArrive: (command...) ->
		@__commandsArrive = command
		return @

	#このシーンから離れる場合に行するコマンドを設定する
	_getLeave: () =>
		return @_getCommandInternal(@_onLeave, @__commandsLeave)

	setLeave: (command...) ->
		@__commandsLeave = command
		return @

	#このシーンより上の階層が目的地だった場合にこのシーンを通過するときに実行するコマンドを設定する
	_getBye: () =>
		return @_getCommandInternal(@_onBye, @__commandsBye)

	setBye: (command...) ->
		@__commandsBye = command
		return @

	#ページタイトルを設定する
	getTitle: () -> return @_title
	setTitle: (title) -> @_title = title


	#===============================================
	#
	# Protected
	#
	#===============================================

	_onInit: () =>

	_onHello: () =>

	_onArrive: () =>

	_onLeave: () =>

	_onBye: () =>


#export
Namespace('jpp.compass').register('Scene', Scene)

###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class SceneStatus extends Event

	#===============================================
	#
	# Event Type
	#
	#===============================================

	@HELLO : 'hello'
	@ARRIVE: 'arrive'
	@STAY  : 'stay'
	@LEAVE : 'leave'
	@BYE   : 'bye'
	@GONE  : 'gone'


#export
Namespace('jpp.compass').register('SceneStatus', SceneStatus)

###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class SceneEvent extends Event

	#===============================================
	#
	# Event Type
	#
	#===============================================

	@CHANGE_STATUS: 'chanegStatus'


#export
Namespace('jpp.compass').register('SceneEvent', SceneEvent)
