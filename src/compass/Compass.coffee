###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class Compass extends EventDispatcher

	#バージョン
	@VERSION: '0.1.0'

	#===============================================
	#
	# Constructor
	#
	#===============================================
	constructor: (option) ->
		super(@)

		@_isReleaseMode = option.isReleaseMode ? true
		@_log = CompassUtil.log

		@_queue = []
		@_queuePosition = -1
		@_direction = []
		@_targetFragment = null
		@_currentScene = null
		@_isInGeneratingSubFragment = false
		@_isRunning = false
		@_isFirstRequest = true
		@_scenes = {}

		@root = option.root ? @root
		@rootFile = option.rootFile ? @rootFile
		@routes = option.routes ? @routes

		#ルート
		kazitoriRoutes = {}
		getRouteHandler = (rule, sceneClass) =>
			return (params...) =>
				@_kazitoriRoutingHandler(rule, sceneClass, params)
		#シーンが関連づけられているパス
		for rule, sceneClass of @routes
			kazitoriRoutes[rule] = getRouteHandler(rule, sceneClass)
		#シーンが関連づけられていない中間パス
		for rule of @routes
			fragments = CompassUtil.decompseFragment(rule).route
			for subRule in fragments
				if kazitoriRoutes[subRule] is undefined
					kazitoriRoutes[subRule] = getRouteHandler(subRule, null)

		#kazitoriに渡す用
		kazitoriOption = {}
		kazitoriOption.root = @root
		kazitoriOption.rootFile = @rootFile
		kazitoriOption.routes = kazitoriRoutes
		kazitoriOption.isAutoStart = false
		kazitoriOption.notFound = (params...) => @_kazitoriRoutingNotFoundHandler(params)

		@_kazitori = new Kazitori(kazitoriOption)
		@_kazitori.addEventListener(KazitoriEvent.EXECUTED, @_kazitoriExecutedHandler)

		CompassUtil.LOGGING = true
		CompassUtil.printInit(@_kazitori, @routes)

		#ユーザによる初期化タイミング
		@onInit()

		#開始
		@_kazitori.start()


	#===============================================
	#
	# Method
	#
	#===============================================

	#指定のフラグメントに遷移する
	goto: (fragment) ->
		@_log("goto : '#{fragment}'")
		@_kazitori.change(fragment)

	#ヒストリーの次へ遷移する
	next: () ->
		@_log('next')
		@_kazitori.torikazi()

	#ヒストリーの前へ遷移する
	prev: () ->
		@_log('prev')
		@_kazitori.omokazi()

	#シーンオブジェクトを取得する
	getScene: (fragment) ->
		@_log("get scene : '#{fragment}'")
		scene = @_scenes[fragment]

		#シーンが登録されていない場合は作成
		if scene is undefined
			@_log("get scene temporary : '#{fragment}'")
			@_isInGeneratingSubFragment = true
			@_kazitori.fragment = fragment
			@_kazitori.executeHandlers() #TODO loadURLではエラーが出る謎を解く
			@_targetFragment = @_kazitori.fragment
			@_isInGeneratingSubFragment = false
			scene = @_scenes[fragment]

		#初期化されていない場合はエラー
		if scene.getIsInitialized() is false
			CompassUtil.error("初期化されていないシーン'#{fragment}'が呼び出されました")

		return scene

	#ユーザによる初期化のタイミングで呼び出される(for ovverride)
	onInit: () ->

	#シーンが未定義だったときに呼び出される(for ovverride)
	onSceneRequest: (fragment, params) ->
		return Scene

	#kazitoriのルーティングバインド関数
	_kazitoriRoutingHandler: (rule, sceneClass, params) =>
		fragment = @_kazitori.fragment
		scene = @_scenes[fragment]

		if scene is undefined
			@_log("create new Scene of '#{fragment}'")
			if sceneClass is null
				@_log("request Scene of '#{fragment}'")
				sceneClass = @onSceneRequest(fragment, params)
				if sceneClass is undefined or sceneClass is null
					@_log("default Scene of '#{fragment}'")
					sceneClass = Scene

			scene = new sceneClass(rule, fragment, params)
			scene.init()
			@_scenes[fragment] = scene

		@_log("kazitoriRoutingHandler : rule     = #{scene.getRule()}")
		@_log("kazitoriRoutingHandler : fragment = #{scene.getFragment()}")
		@_log("kazitoriRoutingHandler : params   = [#{scene.getParams().join(', ')}]")

	#kazitoriのルーティングバインド関数(not found)
	_kazitoriRoutingNotFoundHandler: (params) =>
		@_log('404 :' + params.join(', '))
		#TODO ユーザが定義した404Sceneに遷移する, なければTOPへ？

	#Kazitori.EXECUTEDイベントハンドラ(not foundの場合は実行されない)
	_kazitoriExecutedHandler: (event) =>
		#中間パス生成中は何もしない
		return if @_isInGeneratingSubFragment

		#1回目のEXECUTEイベントが不正に発行されるバグを回避
		return if @_isFirstRequest and event.next is @root
		@_isFirstRequest = false

		fragment = event.next
		if @_targetFragment is null
			#first request
			flow = CompassUtil.decompseFragment(fragment)
		else
			flow = CompassUtil.complementFragment(@_targetFragment, fragment)
		route = flow.route
		direction = flow.direction

		@_pushRoute(route, direction)

	#経路を追加する
	_pushRoute: (route, direction) ->
		return false if route is null
		return false if route.length == 0
		return false if route[route.length - 1] is @_targetFragment

		prevTargetFragment = @_targetFragment

		@_targetFragment = route[route.length - 1]
		@_queue = @_queue[0...@_queuePosition].concat(route)
		@_direction = @_direction[0...@_queuePosition].concat(direction)
		@_log("pushRoute : queue = '#{@_queue.join('\' -> \'')}'")
		@_log("pushRoute : direction = '#{@_direction.join('\' -> \'')}'")
		@_log("pushRoute : position = #{@_queuePosition}")

		#TODO タイトルの変更
		#location.title = @getScene(@_targetFragment).getTitle()

		#イベントの発行
		@_log("change : route = '#{route.join('\' -> \'')}'")
		@dispatchEvent(CompassEvent.CHANGE, { prev: prevTargetFragment , next: @_targetFragment })

		@_startAsync()
		return true

	#非同期処理を開始する
	_startAsync: () ->
		return false if @_isRunning

		if @_currentScene is null
			#初回
			@_log('start async process : first')
			@_nextAsync()
		else
			#2回目以降
			@_currentScene.addEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
			if @_currentScene.getStatus() is SceneStatus.STAY
				@_log('start async process : leave')
				@_currentScene.leave()
			else
				@_log('start async process : bye')
				@_currentScene.bye()

	#非同期処理
	_nextAsync: () ->
		@_currentScene?.removeEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)

		++@_queuePosition
		fragment = @_queue[@_queuePosition]

		@_currentScene = @getScene(fragment)
		@_currentScene.addEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
		@_currentScene.hello()

	#シーン変更ハンドラ
	_sceneChangeStatusHandler: (event) =>
		if event.extra.isComplete
			@_isRunning = false
			@_currentScene.removeEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
			switch event.extra.status

				when SceneStatus.HELLO
					if @_queuePosition == @_queue.length - 1
						@_currentScene.addEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
						@_currentScene.arrive()
					else
						@_nextAsync()

				when SceneStatus.ARRIVE
					@

				when SceneStatus.LEAVE
					@_currentScene.addEventListener(SceneEvent.CHANGE_STATUS, @_sceneChangeStatusHandler)
					@_currentScene.bye()

				when SceneStatus.BYE
					@_nextAsync()
		else
			@_isRunning = true


#export
Namespace('jpp.compass').register('Compass', Compass)
