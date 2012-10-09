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


#jppexport('command', JqueryGet)
Namespace('jpp.command').register('JqueryGet', JqueryGet)