util = require('util')
exec = require('child_process').exec
muffin = require('muffin')

###
Setting
###
SOURCE_DIR = './src'
TARGET_DIR = './lib'

###
Method
###
setTask = (outputfile, srcfiles) ->
	task 'build' , "build  #{outputfile}", (options) -> build(outputfile, srcfiles)
	task 'minify', "minify #{outputfile}", (options) -> minify(outputfile)

build = (outputfile, srcfiles) ->
	#join source
	util.log('gathering source files...')
	files = srcfiles.concat()
	for filename, index in srcfiles
		files[index] = "#{SOURCE_DIR}/#{filename}"
		util.log("#{index + 1}) #{filename}")

	#compile option
	option = "-l -cj #{TARGET_DIR}/#{outputfile}.js #{files.join(' ')}"

	#compile
	util.log('compiling...')
	exec "coffee #{option}", (error, stdout, stderr) ->
		util.log(error) if error
		util.log(stdout) if stdout
		util.log(stderr) if stderr
		if error
			util.log('build failed!')
		else
			util.log("build succeeded! -> #{outputfile}")

minify = (outputfile) ->
	muffin.run
	muffin.minifyScript("#{TARGET_DIR}/#{outputfile}.js")

###
Define task
###
setTask('jppcorelib', [
	'util/Namespace'
	'util/Err'
	'util/Num'
	'util/Arr'
	'util/Easing'
	'event/Event'
	'event/EventDispatcher'
	'command/CommandState'
	'command/Command'
	'command/CommandList'
	'command/SerialList'
	'command/ParallelList'
	'command/Func'
	'command/Wait'
	'command/Listen'
	'command/Tween'
	'command/JqueryAjax'
	'command/JqueryGet'
	'command/JqueryPost'
])