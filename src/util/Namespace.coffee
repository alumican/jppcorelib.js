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


#register myself
Namespace('jpp.util').register('Namespace', Namespace).use()