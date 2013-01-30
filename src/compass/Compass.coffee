###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class Compass extends EventDispatcher

	#バージョン
	@VERSION: '0.0.1'

	#===============================================
	#
	# Constructor
	#
	#===============================================
	constructor: (option) ->
		super(@)
		
		option ?= {}
		option.routes = option.route ? @routes
		option.root = option.root ? @root
		
		@_kazitori = new Kazitori(option)
		@_kazitori.addEventListener(KazitoriEvent.CHANGE, @_kazitoriChangeHandler)
		
		@_log = CompassUtil.log
		@_isReleaseMode = option.isReleaseMode ? true
		CompassUtil.LOG_ENABLED = true
		CompassUtil.printInit(@_kazitori)
		
		


	#===============================================
	#
	# Method
	#
	#===============================================

	#Kazitori.CHANGEイベントハンドラ
	_kazitoriChangeHandler: (event) =>
		prev = event.prev
		next = event.next
		@_log("[Compass] change : prev = '#{prev}' next = '#{next}'")
		
		@dispatchEvent(CompassEvent.CHANGE, { prev: prev, next: next })
		
		flow = CompassUtil.calcPath(prev, next)
		@_log("[Compass] change :  '#{flow.join('\' -> \'')}'")
	
	#非同期処理を開始する
	_startAsync: () ->
		


	#===============================================
	#
	# Getter / Setter
	#
	#===============================================

	#指定のパスに遷移する
	goto: (path) ->
		@_log("[Compass] goto : '#{path}'")
		@_kazitori.change(path)

	#ヒストリーの次へ遷移する
	next: () ->
		@_log('[Compass] next')
		@_kazitori.torikazi()

	#ヒストリーの前へ遷移する
	prev: () ->
		@_log('[Compass] prev')
		@_kazitori.omokazi()


#export
Namespace('jpp.compass').register('Compass', Compass)