###
Error Util
###
class Err
	@build: (at, text = '') ->
		return new Error("Error at #{at}" + (" : #{text}" unless text == ''))

	@throw: (at, text = '') ->
		throw @build(at, text)


#jppexport('util', Err)
Namespace('jpp.util').register('Err', Err)