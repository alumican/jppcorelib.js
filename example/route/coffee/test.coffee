class App extends Kazitori

	#ルーティング定義
	routes:
		'/': 'index'
		'about': 'about'
		'gallery': 'gallery'
		'gallery/:id': 'item'
		'contact': 'contact'

	#遷移時に実行されるメソッド
	#index: () ->
	#	console.log("This is index page.")

	about: () ->
		console.log("This is about page.")

	#gallery: () ->
	#	console.log("This is gallery page.")

	item: (id) ->
		console.log("This is gallery item #{id} page.")

	contact: () ->
		console.log("This is contact page.")
	
	#ユーティリティ
	_clickHandler: (event) =>
		event.preventDefault()
		path = event.currentTarget.pathname
		@change(path)
		
	bind: ($target) ->
		$target.on("click", @_clickHandler)

	unbind: ($target) ->
		$target.off("click", @_clickHandler)

#entry point
$(document).ready ()->
	window.app = new App({ root: '/example/route/' })
	window.app.bind($('.navi'))