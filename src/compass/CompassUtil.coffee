###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class CompassUtil

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
		prevs = CompassUtil.decompseFragment(prev).route
		nexts = CompassUtil.decompseFragment(next).route
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

	#ログ出力
	@log: (m...) ->
		console.log('[Comppass] ' + m.join(' ')) if CompassUtil.LOGGING

	@error: (m...) ->
		console.log('[Comppass Error] ' + m.join(' '))

	#コピーライト出力
	@printInit: (kazitori, routes) ->
		return unless CompassUtil.LOGGING

		routeArray = []
		for fragment, handler of routes
			routeArray.push('           \'' + fragment + '\'')


		CompassUtil.log("----------------------------------------")
		CompassUtil.log("Compass #{Compass.VERSION}  © Copyright alumican.net All rights reserved.")
		CompassUtil.log("Kazitori #{kazitori.VERSION}  © Copyright hageee.net All rights reserved.")
		CompassUtil.log("root: #{kazitori.root}")
		CompassUtil.log("routes: \n" + routeArray.join('\n'))
		CompassUtil.log("----------------------------------------")


#export
Namespace('jpp.compass').register('CompassUtil', CompassUtil)
