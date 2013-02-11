###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Milkpack is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class SceneStatus extends Event

	#===============================================
	#
	# Event Type
	#
	#===============================================

	@HELLO : 'hello'
	@ARRIVE: 'arrive'
	@STAY  : 'stay'
	@LEAVE : 'leave'
	@BYE   : 'bye'
	@GONE  : 'gone'


#export
Namespace('jpp.milkpack').register('SceneStatus', SceneStatus)
