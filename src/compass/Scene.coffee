###
 Copyright (c) 2013 Yukiya Okuda
 http://alumican.net/

 Compass is free software distributed under the terms of the MIT license:
 http://www.opensource.org/licenses/mit-license.php
###

class Scene

	###
	Constructor
	###
	constructor: (path) ->
		@_path = path
		@_paths = @_path.split('/')
		@_level = @_paths.length - 1
		@_isRoot = @_level == 0
		@_parent = if @_isRoot then null else @_paths[@_level - 1]


	###
	Method
	###


	###
	Getter / Setter
	###
	getPath: () -> return @_path
	getPaths: () -> return @_paths
	getLevel: () -> return @_level
	getIsRoot: () -> return @_isRoot
	getParent: () -> return @_parent


	###
	Protected
	###


#export
Namespace('jpp.compass').register('Scene', Scene)