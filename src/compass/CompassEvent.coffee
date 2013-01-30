###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class CompassEvent extends Event

	#===============================================
	#
	# Event Type
	#
	#===============================================

	#シーンが切り替わったときに発行される
	@CHANGE: 'change'


#export
Namespace('jpp.compass').register('CompassEvent', CompassEvent)