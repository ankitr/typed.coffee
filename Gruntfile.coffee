module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    watch:
      coffee:
        files: 'js/*.coffee'
        tasks: ['coffee:compile']

    coffee:
      compile:
        expand: true,
        flatten: true,
        src: ['js/*.coffee'],
        dest: 'js/',
        ext: '.js'


  # 4. Where we tell Grunt what to do when we type "grunt" into the terminal.
  grunt.registerTask('default', ['watch'])
