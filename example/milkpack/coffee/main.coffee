jpp.util.Namespace('jpp.milkpack').import('*');
jpp.util.Namespace('jpp.command').import('*');


#===============================================
#
# Scenes
#
#===============================================
class IndexScene extends Scene

	_onInit: () =>
		@$header = $('#header')
		@$footer = $('#footer')

	_onHello: () =>
		@addCommand(
			new Parallel(
				new JqueryAnimate(@$header, { opacity : '1' }, { duration : 500, easing : 'linear' })
				new JqueryAnimate(@$footer, { opacity : '1' }, { duration : 500, easing : 'linear' })
			)
		)

	_onArrive: () =>
		@addCommand(
		)

	_onLeave: () =>
		@addCommand(
		)

	_onBye: () =>
		@addCommand(
			new Parallel(
				new JqueryAnimate(@$header, { opacity : '0' }, { duration : 500, easing : 'linear' })
				new JqueryAnimate(@$footer, { opacity : '0' }, { duration : 500, easing : 'linear' })
			)
		)


class PageScene extends Scene

	_onInit: ($page) =>
		@$page = $page

	_onHello: () =>
		@addCommand(
			new JqueryAnimate(@$page, { opacity : '1' }, { duration : 500, easing : 'linear' })
		)

	_onArrive: () =>
		@addCommand(
		)

	_onLeave: () =>
		@addCommand(
		)

	_onBye: () =>
		@addCommand(
			new JqueryAnimate(@$page, { opacity : '0' }, { duration : 500, easing : 'linear' })
		)


class AboutScene extends PageScene

	_onInit: () =>
		super($('#page_what'))

	_onHello: () =>
		super()

	_onArrive: () =>

	_onLeave: () =>
		
	_onBye: () =>
		super()
		


class UsageScene extends PageScene

	_onInit: () =>
		super($('#page_how'))

	_onHello: () =>
		super()

	_onArrive: () =>

	_onLeave: () =>
		
	_onBye: () =>
		super()


class DownloadScene extends PageScene

	_onInit: (id) =>
		super($('#page_where'))

	_onHello: () =>
		super()

	_onArrive: () =>

	_onLeave: () =>
		
	_onBye: () =>
		super()


class ContactScene extends PageScene

	_onInit: () =>
		super($('#page_who'))

	_onHello: () =>
		super()

	_onArrive: () =>

	_onLeave: () =>
		
	_onBye: () =>
		super()


#===============================================
#
# Application
#
#===============================================
class App extends Milkpack

	#アプリケーションのルート
	root: '/example/milkpack/'

	#インデックスファイル名
	rootFile: 'index.html'

	#ルーティング定義
	routes:
		'/': IndexScene
		'/what': AboutScene
		'/how': UsageScene
		'/where': DownloadScene
		'/who': ContactScene

	#アプリケーション初期化時に呼び出される
	onInit: () ->
		$('.fragment').on("click", (event) =>
			event.preventDefault()
			@goto(event.currentTarget.pathname)
		)


#===============================================
#
# Entry point
# 
#===============================================
$(document).ready ()->
	window.app = new App({ isReleaseMode: false })
