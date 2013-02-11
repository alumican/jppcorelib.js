###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Milkpack is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class Util

	@LOGGING: true

	#===============================================
	#
	# Method
	#
	#===============================================

	#フラグメントを分解する '/a/b/c' -> ['/', '/a', '/a/b', '/a/b/c']
	@decompseFragment: (fragment) ->
		if fragment is null or fragment is '' or fragment is '/'
			return { route : ['/'], direction : true }
		else
			route = fragment.split('/')
			direction = []
			s = ''
			i = 0
			for sub in route
				s += if s == '/' then sub else '/' + sub
				route[i] = s
				direction[i] = true
				++i
			return { route : route, direction : direction }

	#2つのパス間の経路を算出する
	@complementFragment: (prev, next) ->
		route = []
		direction = []

		#normalize
		prev ?= ''
		next ?= ''
		prev = prev.substr(1) if prev.charAt(0) == '/'
		next = next.substr(1) if next.charAt(0) == '/'
		#console.log("prev : '#{prev}'")
		#console.log("next : '#{next}'")

		#split fragment
		prevs = Util.decompseFragment(prev).route
		nexts = Util.decompseFragment(next).route
		#console.log("prevs : '#{prevs}'")
		#console.log("nexts : '#{nexts}'")

		#get branch point
		n = Math.min(prevs.length, nexts.length)
		branch = 0
		while branch < n
			break if prevs[branch] isnt nexts[branch]
			++branch
		#console.log("branch : #{branch}")

		#backword
		n = branch
		i = prevs.length - 1
		while i >= n
			route.push(prevs[i])
			direction.push(false)
			--i
		#console.log("route backward : '#{route}'")

		#forward
		n = nexts.length - 1
		i = branch
		while i <= n
			route.push(nexts[i])
			direction.push(true)
			++i
		#console.log("route result : '#{route}'")

		return { route : route, direction : direction }

	#fragmentAからfragmentBに移動するときの最初の方向を取得する(-1:上方向, +1:下方向, 0:同階層)
	@getDirection: (fragmentA, fragmentB) ->
		#AとBが同じシーン
		return 0 if fragmentA is fragmentB

		#シーンが不一致になるまでループ
		a = if fragmentA is '/' then [''] else fragmentA.split('/')
		b = if fragmentB is '/' then [''] else fragmentB.split('/')
		aLen = a.length
		bLen = b.length
		n = Math.min(aLen, bLen)
		i = 1
		while i < n
			break if (a[i] != b[i])
			++i

		###
		console.log a
		console.log b
		console.log aLen
		console.log bLen
		console.log i
		###

		#AとBが同階層
		return 0 if aLen == bLen && i == aLen - 1

		#AがBの親
		return 1 if i == aLen && i < bLen

		#AがBに向かうために親階層へ戻る
		return -1

	#ログ出力
	@log: (m...) ->
		console.log('[Comppass] ' + m.join(' ')) if Util.LOGGING

	@error: (m...) ->
		console.log('[Comppass Error] ' + m.join(' '))

	#コピーライト出力
	@printInit: (kazitori, routes) ->
		return unless Util.LOGGING

		routeArray = []
		for fragment, handler of routes
			routeArray.push('           \'' + fragment + '\'')


		Util.log("----------------------------------------")
		Util.log("Milkpack #{Milkpack.VERSION}  © Copyright alumican.net All rights reserved.")
		Util.log("Kazitori #{kazitori.VERSION}  © Copyright hageee.net All rights reserved.")
		Util.log("root: #{kazitori.root}")
		Util.log("routes: \n" + routeArray.join('\n'))
		Util.log("----------------------------------------")


#export
Namespace('jpp.milkpack').register('Util', Util)
