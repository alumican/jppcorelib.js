module.exports = function(grunt) {
	
	grunt.initConfig({
		
		coffee: {
			compile: {
				files: {
					'lib/jppcorelib.js': [
						'src/util/*.coffee',
						'src/event/*.coffee',
						'src/command/*.coffee',
						'src/compass/*.coffee'
					],
					'example/compass/script/main.js': 'example/compass/coffee/main.coffee'
				}
			},
			kazitori: {
				options: {
					bare: true
				},
				files: {
					'example/compass/script/kazitori.js': 'example/compass/coffee/kazitori.coffee'
				}
			}
		}
		
		/*
		less: {
			development: {
				options: {
					paths: ["assets/css"]
				},
				files: {
					"path/to/result.css": "path/to/source.less"
				}
			},
			production: {
				options: {
					paths: ["assets/css"],
					yuicompress: true
				},
				files: {
					"path/to/result.css": "path/to/source.less"
				}
			}
		}
		*/
	});
	
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-contrib-less');
	
	grunt.registerTask('default', 'coffee');
};