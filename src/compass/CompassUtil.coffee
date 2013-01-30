###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class CompassUtil

	@LOG_ENABLED: true

	#===============================================
	#
	# Method
	#
	#===============================================

	#2つのパス間の経路を算出する
	@calcPath: (prev, next) ->
		prev = '' if prev == null
		next = '' if next == null
		
		prev = prev.substr(1) if prev.charAt(0) == '/'
		next = next.substr(1) if next.charAt(0) == '/'
		
		#console.log("prev : '#{prev}'")
		#console.log("next : '#{next}'")
		
		prevs = prev.split('/')
		nexts = next.split('/')
		
		s = ''
		i = 0
		for sub in prevs
			s += '/' + sub
			prevs[i] = s
			++i
		
		s = ''
		i = 0
		for sub in nexts
			s += '/' + sub
			nexts[i] = s
			++i
		
		#console.log("prevs : '#{prevs}'")
		#console.log("nexts : '#{nexts}'")
		
		n = Math.min(prevs.length, nexts.length)
		branch = 0
		while branch < n
			break if prevs[branch] isnt nexts[branch] 
			++branch
		
		#console.log("branch : #{branch}")
		
		flow = []
		
		n = branch
		i = prevs.length - 1
		while i >= n
			flow.push(prevs[i])
			--i
		
		#console.log("flow prevs : '#{flow}'")
		
		n = nexts.length - 1
		i = branch
		while i <= n
			flow.push(nexts[i])
			++i
		
		#console.log("flow : '#{flow}'")
		return flow

	#ログ出力
	@log: (m...) ->
		console.log(m.join(' ')) if CompassUtil.LOG_ENABLED

	#コピーライト出力
	@printInit: (kazitori) ->
		CompassUtil.log("----------------------------------------")
		CompassUtil.log("Compass #{Compass.VERSION}  © Copyright alumican.net All rights reserved.")
		CompassUtil.log("Kazitori #{kazitori.VERSION}  © Copyright hageee.net All rights reserved.")
		CompassUtil.log("root  : " + kazitori.root)
		CompassUtil.log("routes: " + kazitori.routes)
		CompassUtil.log("----------------------------------------")