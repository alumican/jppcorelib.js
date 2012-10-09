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
buildInfos = []

setTask = (namespace, srcfiles, outputfile) ->
	buildInfos.push({
		namespace : namespace
		srcfiles : srcfiles
		outputfile : outputfile
	})
	task namespace, "build package -> jpp.#{namespace}", (options) ->
		#srcfiles.unshift('export.coffee')
		build(srcfiles, outputfile)

build = (srcfiles, outputfile) ->

	util.log('gathering source files...')
	fileList = []
	for filename, index in srcfiles
		file = SOURCE_DIR + '/' + filename
		fileList.push(file)
		util.log("#{index + 1}) #{file}")
	fileList = fileList.join(' ')

	option = "-l -cj #{TARGET_DIR}/#{outputfile}.js #{fileList}"

	outputerror = (error, stdout, stderr) ->
		util.log(error) if error
		util.log(stdout) if stdout
		util.log(stderr) if stderr
		if error then util.log('build failed!') else util.log("build succeeded! -> #{outputfile}")

	util.log('compiling...')

	#compile
	exec "coffee #{option}", outputerror

	#minify
	muffin.run
	muffin.minifyScript("#{TARGET_DIR}/#{outputfile}.js")


task 'all', "build all packages", (options) ->
	for info in buildInfos
		#srcfiles = info.srcfiles.concat()
		#srcfiles.unshift('export.coffee')
		#build(srcfiles, info.outputfile)
		build(info.srcfiles, info.outputfile)

###
Define task
###
setTask('build', [
	'util/Namespace'
	'util/Err.coffee'
	'event/Event.coffee'
	'event/EventDispatcher.coffee'
	'command/CommandState.coffee'
	'command/Command.coffee'
	'command/CommandList.coffee'
	'command/SerialList.coffee'
	'command/ParallelList.coffee'
	'command/Func.coffee'
	'command/Wait.coffee'
	'command/Listen.coffee'
	'command/JqueryAjax.coffee'
	'command/JqueryGet.coffee'
	'command/JqueryPost.coffee'
], 'jppcorelib')