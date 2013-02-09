###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class SceneEvent extends Event

	#===============================================
	#
	# Event Type
	#
	#===============================================

	@HELLO_BEGIN: 'helloStart'
	@HELLO_COMPLETE: 'helloComplete'
	@ARRIVE_BEGIN: 'helloStart'
	@ARRIVE_COMPLETE: 'helloComplete'
	@LEAVE_BEGIN: 'helloStart'
	@LEAVE_COMPLETE: 'helloComplete'
	@BYE_BEGIN: 'helloStart'
	@BYE_COMPLETE: 'helloComplete'


#export
Namespace('jpp.compass').register('SceneEvent', CompassEvent)