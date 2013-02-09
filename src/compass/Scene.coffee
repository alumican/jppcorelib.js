###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class Scene extends EventDispatcher

	@self = null


	#===============================================
	#
	# Constructor
	#
	#===============================================
	constructor: (rule, fragment, params) ->
		super(@)

		@self = @

		@_rule = rule
		@_fragment = fragment
		@_params = params

		@_title = null

		@_status = SceneStatus.GONE

		@_isInitialized = false

		@_command = null
		@_commandWrapper = null

		@__commandsHello = []
		@__commandsArrive = []
		@__commandsLeave = []
		@__commandsBye = []


	#===============================================
	#
	# Method
	#
	#===============================================

	#初期化
	init: () ->
		return if @_isInitialized
		@_isInitialized = true
		@_onInit()

	#Helloフェーズを開始する
	hello: () ->
		@_switchStatus(SceneStatus.HELLO, @_getHello)

	#Arriveフェーズを開始する
	arrive: () ->
		@_switchStatus(SceneStatus.ARRIVE, @_getArrive)

	#Leaveフェーズを開始する
	leave: () ->
		@_switchStatus(SceneStatus.LEAVE, @_getLeave)

	#Byeフェーズを開始する
	bye: () ->
		@_switchStatus(SceneStatus.BYE, @_getBye)

	#実行中のコマンドに新たなコマンドを追加する
	addCommand: (commands...) ->
		@_commandWrapper.addCommand(commands...) if @_commandWrapper isnt null

	#実行中のコマンドに新たなコマンドを挿入する
	insertCommand: (commands...) ->
		@_commandWrapper.insertCommand(commands...) if @_commandWrapper isnt null

	#フェーズを切り替える
	_switchStatus: (status, commandFunction) ->
		if @_command isnt null
			CompassUtil.log("Command is being executed (status = #{@_status})")
			return
		@_clearCommand()
		@_status = status
		@_dispatchStatusEvent(@_status, false)
		@_command = commandFunction() #非同期処理生成 / 同期処理実行
		@_command.addEventListener(Event.COMPLETE, @_commandCompleteHandler)
		@_command.execute()

	#フェーズを終了する
	_clearCommand: () ->
		if @_command isnt null
			@_command.removeEventListener(Event.COMPLETE, @_commandCompleteHandler)
			@_command.interrupt()
			@_command = null

	#コマンドの完了ハンドラ
	_commandCompleteHandler: (event) =>
		@_clearCommand()
		prevStatus = @_status
		switch @_status
			when SceneStatus.ARRIVE then @_status = SceneStatus.STAY
			when SceneStatus.BYE then @_status = SceneStatus.GONE
		@_dispatchStatusEvent(prevStatus, true)

	#イベントを発行する
	_dispatchStatusEvent: (status, isComplete) ->
		CompassUtil.log("Scene '#{@_fragment}' : #{status} #{if isComplete then 'End' else 'Begin'}")
		@dispatchEvent(SceneEvent.CHANGE_STATUS, { status: status, isComplete: isComplete })

	#登録されているコマンドを取得する
	_getCommandInternal: (protectedFunction, externalCommands) ->
		@_commandWrapper = new SerialList()
		if @__commandsHello.length == 0 then protectedFunction() else @_commandWrapper.addCommandArray(externalCommands)
		return @_commandWrapper


	#===============================================
	#
	# Getter / Setter
	#
	#===============================================

	#初期化されたかどうかを取得する
	getIsInitialized: () -> return @_isInitialized

	#ルールを取得する
	getRule: () -> return @_rule

	#フラグメントを取得する
	getFragment: () -> return @_fragment

	#パラメータを取得する
	getParams: () -> return @_params

	#現在のステータスを取得する
	getStatus: () -> return @_status

	#このシーンが目的地だった場合もしくはこのシーンを通過するときに実行するコマンドを設定する
	_getHello: () =>
		return @_getCommandInternal(@_onHello, @__commandsHello)

	setHello: (command...) ->
		@__commandsHello = command
		return @

	#このシーンが目的地だった場合に行するコマンドを設定する
	_getArrive: () =>
		return @_getCommandInternal(@_onArrive, @__commandsArrive)

	setArrive: (command...) ->
		@__commandsArrive = command
		return @

	#このシーンから離れる場合に行するコマンドを設定する
	_getLeave: () =>
		return @_getCommandInternal(@_onLeave, @__commandsLeave)

	setLeave: (command...) ->
		@__commandsLeave = command
		return @

	#このシーンより上の階層が目的地だった場合にこのシーンを通過するときに実行するコマンドを設定する
	_getBye: () =>
		return @_getCommandInternal(@_onBye, @__commandsBye)

	setBye: (command...) ->
		@__commandsBye = command
		return @

	#ページタイトルを設定する
	getTitle: () -> return @_title
	setTitle: (title) -> @_title = title


	#===============================================
	#
	# Protected
	#
	#===============================================

	_onInit: () =>

	_onHello: () =>

	_onArrive: () =>

	_onLeave: () =>

	_onBye: () =>


#export
Namespace('jpp.compass').register('Scene', Scene)
