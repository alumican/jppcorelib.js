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