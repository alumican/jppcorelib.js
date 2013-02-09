###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class Scene

	#===============================================
	#
	# Constructor
	#
	#===============================================
	constructor: (path) ->
		@_path = path
		
		@__helloCommand = null
		@__arriveCommand = null
		@__leaveCommand = null
		@__byeCommand = null
		
		@_command = null


	#===============================================
	#
	# Method
	#
	#===============================================

	hello: () ->
		command = @_getHello()
		command.execute()
		@

	arrive: () ->
		command = @_getArrive()
		command.execute()
		@

	leave: () ->
		command = @_getLeave()
		command.execute()
		@

	bye: () ->
		command = @_getBye()
		command.execute()
		@


	#===============================================
	#
	# Getter / Setter
	#
	#===============================================

	#パスを取得する
	getPath: () -> return @_path

	#このシーンが目的地だった場合もしくはこのシーンを通過するときに実行するコマンドを設定する
	_getHello: () -> return @__helloCommand or @_onHello
	setHello: (command) ->
		@__helloCommand = command
		return @

	#このシーンが目的地だった場合に行するコマンドを設定する
	_getArrive: () -> return @__arriveCommand or @_onArrive
	setArrive: (command) ->
		@__arriveCommand = command
		return @

	#このシーンから離れる場合に行するコマンドを設定する
	_getLeave: () -> return @__leaveCommand or @_onLeave
	setLeave: (command) ->
		@__leaveCommand = command
		return @

	#このシーンより上の階層が目的地だった場合にこのシーンを通過するときに実行するコマンドを設定する
	_getBye: () -> return @__byeCommand or @_onBye
	setBye: (command) ->
		@__byeCommand = command
		return @


	#===============================================
	#
	# Protected
	#
	#===============================================

	_onHello: () ->
		return new Command()

	_onArrive: () ->
		return new Command()

	_onLeave: () ->
		return new Command()

	_onBye: () ->
		return new Command()


#export
Namespace('jpp.compass').register('Scene', Scene)