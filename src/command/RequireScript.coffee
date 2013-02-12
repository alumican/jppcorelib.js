###
RequireScript Command
###
class RequireScript extends Command

	###
	Constructor
	###
	constructor: (url) ->
		super()
		@_url = url
		@_script = null
		@_status = 0


	###
	Method
	###
	_completeHandler: (event) =>
		return if @_status != 1

		if @_script.readyState is 'loaded' or @_script.readyState is 'complete'
			@_status = 2
			@_script.onload = @_script.onreadystatechange = null;
			@_script.parentNode.removeChild(@_script);
			@notifyComplete()

	_cancel: () ->
		return if @_status != 1

		@_status = 0
		@_script.parentNode.removeChild(@_script) if @_script isnt null


	###
	Getter / Setter
	###
	getUrl: () -> return @_url
	setUrl: (url) -> @_url = url; @


	###
	Protected
	###
	_executeFunction: (command) ->
		@_status = 1

		@_script = document.createElement('script');
		@_script.src = @_url
		@_script.type = 'text/javascript'
		@_script.language = 'javascript'
		@_script.onload = @_completeHandler
		@_script.onreadystatechange = @_completeHandler
		document.body.appendChild(@_script);

	_interruptFunction: (command) ->
		@_cancel()

	_destroyFunction: (command) ->
		@_cancel()
		
		@_url = null
		@_script = null
		@_status = 0


#export
Namespace('jpp.command').register('RequireScript', RequireScript)
