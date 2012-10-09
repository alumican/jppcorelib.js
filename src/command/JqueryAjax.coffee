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