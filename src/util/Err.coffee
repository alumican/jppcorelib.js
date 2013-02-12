###
Error Util
###
class Err
	Err.build = (at, text = '') -> return new Error("Error at #{at}" + (" : #{text}" unless text == ''))
	Err.throw = (at, text = '') -> throw Err.build(at, text)


#export
Namespace('jpp.util').register('Err', Err).use()
