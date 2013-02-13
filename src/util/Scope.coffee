class Scope
	@_spaces: {}

	#名称nameのthisスコープを生成し、その中で関数を実行する
	#this.hogeで定義した変数はスコープ内に保存される
	@bind: (name, f) ->
		@_spaces[name] ?= {}
		f.call(@_spaces[name])

	#名称nameのthisスコープを削除する
	@clear: (name) ->
		delete @_spaces[name]

	#一時thisスコープで関数を実行する
	@temp: (f) ->
		f.call({})


#export
Namespace('jpp.util').register('Scope', Scope).use()
