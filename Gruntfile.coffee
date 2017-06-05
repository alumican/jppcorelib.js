module.exports = (grunt) ->
	grunt.initConfig

		#========================================
		# SCRIPT
		#========================================
		concat:
			jppcorelib:
				src: [
					'src/util/Namespace.coffee'
					'src/util/Scope.coffee'
					'src/util/Err.coffee'
					'src/util/Num.coffee'
					'src/util/Arr.coffee'
					'src/util/Obj.coffee'
					'src/util/Easing.coffee'
					'src/util/require.coffee'
					'src/util/trace.coffee'

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
					'src/command/RequireScript.coffee'

					'src/import.coffee'
				]
				dest: 'tmp/jppcorelib-concat.coffee'

		coffee:
			jppcorelib:
				files:
					'lib/jppcorelib.js': 'tmp/jppcorelib-concat.coffee'

		uglify:
			jppcorelib:
				files: {
					'lib/jppcorelib.min.js': 'lib/jppcorelib.js'
				}

		#========================================
		# WATCH
		#========================================
		watch:
			script:
				files: [
					'src/**/*.coffee'
				]
				tasks:
					'default'

	#========================================
	# PLUGIN
	#========================================
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-uglify'

	#========================================
	# TASK
	#========================================
	grunt.registerTask 'default', ['concat', 'coffee', 'uglify']
	grunt.registerTask "r", "reload Google Chrome (OS X)", () -> require("child_process").exec 'osascript -e \'tell application \"Google Chrome\" to tell the active tab of its first window to reload\''
	grunt.registerTask 'w', 'watch'
