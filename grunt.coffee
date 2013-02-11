module.exports = (grunt) ->
	grunt.initConfig

		#========================================
		# SCRIPT
		#========================================
		concat:
			jppcorelib:
				src: [
					'src/util/Namespace.coffee'
					'src/util/Err.coffee'
					'src/util/Num.coffee'
					'src/util/Arr.coffee'
					'src/util/Obj.coffee'
					'src/util/Easing.coffee'
					'src/event/Event.coffee'
					'src/event/EventDispatcher.coffee'
					'src/command/CommandState.coffee'
					'src/command/Command.coffee'
					'src/command/CommandList.coffee'
					'src/command/Serial.coffee'
					'src/command/Parallel.coffee'
					'src/command/Break.coffee'
					'src/command/Return.coffee'
					'src/command/Func.coffee'
					'src/command/Trace.coffee'
					'src/command/Wait.coffee'
					'src/command/Listen.coffee'
					'src/command/Tween.coffee'
					'src/command/JqueryAjax.coffee'
					'src/command/JqueryGet.coffee'
					'src/command/JqueryPost.coffee'
					'src/command/JqueryAnimate.coffee'
					'src/command/DoTweenJS.coffee'
					'src/milkpack/Milkpack.coffee'
					'src/milkpack/MilkpackEvent.coffee'
					'src/milkpack/Scene.coffee'
					'src/milkpack/SceneEvent.coffee'
					'src/milkpack/SceneStatus.coffee'
					'src/milkpack/Util.coffee'
				]
				dest: 'tmp/jppcorelib-concat.coffee'

		coffee:
			jppcorelib:
				files:
					'lib/jppcorelib.js': 'tmp/jppcorelib-concat.coffee'
			example:
				files:
					'example/milkpack/script/main.js': 'example/milkpack/coffee/main.coffee'
			kazitori:
				files:
					'example/milkpack/script/kazitori.js': 'example/milkpack/coffee/kazitori.coffee'
				options:
					bare: true

		min:
			jppcorelib:
				src:
					'lib/jppcorelib.js'
				dest:
					'lib/jppcorelib.min.js'

		#========================================
		# WATCH
		#========================================
		less:
			example:
				src:
					'example/milkpack/less/main.less'
				dest:
					'example/milkpack/style/main.css'

		#========================================
		# WATCH
		#========================================
		watch:
			script:
				files: [
					'src/**/*.coffee'
					'example/milkpack/coffee/*.coffee'
				]
				tasks:
					#['default', 'r']
					'default'
			style:
				files:
					'example/milkpack/less/*.less'
				tasks:
					#['default', 'r']
					'default'
			#html:
			#	files: 'example/milkpack/index.html'
			#	tasks: 'r'

	#========================================
	# PLUGIN
	#========================================
	grunt.loadNpmTasks 'grunt-contrib'

	#========================================
	# TASK
	#========================================
	#url = 'http://jppcorelib.local/example/milkpack/'
	#script = '''
	#	tell application "Google Chrome"
	#		set theURL to URL of active tab of window 1
	#		if theURL = "''' + url + '''"
	#			tell the active tab of its first window
	#				reload
	#			end tell
	#		end if
	#	end tell
	#'''
	#grunt.registerTask 'r', 'reload Google Chrome (OS X)', () -> require('child_process').exec('osascript -e \'' + script + '\'')
	grunt.registerTask 'default', 'concat coffee min less'
	grunt.registerTask "r", "reload Google Chrome (OS X)", () -> require("child_process").exec 'osascript -e \'tell application \"Google Chrome\" to tell the active tab of its first window to reload\''
	grunt.registerTask 'w', 'watch'
