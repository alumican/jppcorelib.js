jpp.util.Namespace('jpp.compass').import('*');

###
Application
###
class App extends Compass

	#ルーティング定義
	routes:
		'/': 'index'
		'/about': 'about'
		'/gallery': 'gallery'
		'/gallery/<int:id>': 'item'
		'/contact': 'contact'
	
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
	window.app = new App({ root: '/example/compass/', isReleaseMode: false })
	window.app.bind($('.navi'))




###
var router = new Router(
	'/': 'index'
	'/about': 'about'
	'/gallery': 'gallery'
	'/gallery/:id': 'item'
	'/contact': 'contact'
)

router.handlers('index')
	.onLoad  ((event) -> console.log event.path + ' load')
	.onInit  ((event) -> console.log event.path + ' init')
	.onGoto  ((event) -> console.log event.path + ' goto')
	.onUnload((event) -> console.log event.path + ' unload')
###