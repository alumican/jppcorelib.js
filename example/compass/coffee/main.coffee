jpp.util.Namespace('jpp.compass').import('*');
jpp.util.Namespace('jpp.command').import('*');


#===============================================
class IndexScene extends Scene

	_onInit: () =>
		console.log('init index scene')
		console.log("  rule     = '#{@getRule()}'")
		console.log("  fragment = '#{@getFragment()}'")
		console.log("  param    = [#{@getParams().join(', ')}]")

	_onHello: () =>
		@addCommand(
			new Wait(1),
			new Trace('index hello complete')
		)

	_onArrive: () =>
		@addCommand(
			new Wait(1),
			new Trace('index arrive complete')
		)

	_onLeave: () =>
		@addCommand(
			new Wait(1),
			new Trace('index leave complete')
		)

	_onBye: () =>
		@addCommand(
			new Wait(1),
			new Trace('index bye complete')
		)


class AboutScene extends Scene

	_onInit: () =>
		console.log('init about scene')
		console.log("  rule     = '#{@getRule()}'")
		console.log("  fragment = '#{@getFragment()}'")
		console.log("  param    = [#{@getParams().join(', ')}]")

	_onHello: () =>
	_onArrive: () =>
	_onLeave: () =>
	_onBye: () =>


class GalleryScene extends Scene

	_onInit: () =>
		console.log('init gallery scene')
		console.log("  rule     = '#{@getRule()}'")
		console.log("  fragment = '#{@getFragment()}'")
		console.log("  param    = [#{@getParams().join(', ')}]")

	_onHello: () =>
	_onArrive: () =>
	_onLeave: () =>
	_onBye: () =>


class GalleryItemScene extends Scene

	_onInit: (id) =>
		console.log('init gallery item scene')
		console.log("  rule     = '#{@getRule()}'")
		console.log("  fragment = '#{@getFragment()}'")
		console.log("  param    = [#{@getParams().join(', ')}]")

	_onHello: () =>
	_onArrive: () =>
	_onLeave: () =>
	_onBye: () =>


class ContactScene extends Scene

	_onInit: () =>
		console.log('init contact scene')
		console.log("  rule     = '#{@getRule()}'")
		console.log("  fragment = '#{@getFragment()}'")
		console.log("  param    = [#{@getParams().join(', ')}]")

	_onHello: () =>
	_onArrive: () =>
	_onLeave: () =>
	_onBye: () =>
#===============================================


###
Application
###
class App extends Compass

	#アプリケーションのルート
	root: '/example/compass/'

	#インデックスファイル名
	rootFile: 'index.html'

	#ルーティング定義
	routes:
		'/': IndexScene
		'/about/<int:n>/<string:s>': AboutScene
		'/gallery': GalleryScene
		'/gallery/<int:id>': GalleryItemScene
		'/contact': ContactScene

	#アプリケーション初期化時に呼び出される
	onInit: () ->
		###
		@getScene('/')
			.setHello(
				new Wait(1),
				new Trace('index hello complete')
			)
			.setArrive(
				new Wait(1),
				new Trace('index arrive complete')
			)
			.setLeave(
				new Wait(1),
				new Trace('index leave complete')
			)
			.setBye(
				new Wait(1),
				new Trace('index bye complete')
			)
		###

	#シーン定義が見つからないときに呼び出される
	#returnしたシーンクラスがインスタンス化されて使用される
	onSceneRequest: (fragment, params...) ->
		console.log("onSceneRequest : fragment = '#{fragment}', params = [#{params.join(', ')}]")
		return null

	#ユーティリティ
	_clickHandler: (event) =>
		event.preventDefault()
		@goto(event.currentTarget.pathname)

	bind: ($target) ->
		$target.on("click", @_clickHandler)

	unbind: ($target) ->
		$target.off("click", @_clickHandler)

#entry point
$(document).ready ()->
	window.app = new App({ isReleaseMode: false })
	window.app.bind($('.navi'))
