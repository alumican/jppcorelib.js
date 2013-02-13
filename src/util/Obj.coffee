###
Object Util
###
class Obj

	Obj.clone = (object) ->
		dst = {}
		for key, value of object
			dst[key] = value
		return dst


#export
Namespace('jpp.util').register('Obj', Obj).use()
