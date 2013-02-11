###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Milkpack is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class MilkpackEvent extends Event

	#===============================================
	#
	# Event Type
	#
	#===============================================

	#最初のシーンが認識されたときに発行される
	@INIT: 'init'

	#シーンが切り替わったときに発行される
	@CHANGE: 'change'


#export
Namespace('jpp.milkpack').register('MilkpackEvent', MilkpackEvent)
