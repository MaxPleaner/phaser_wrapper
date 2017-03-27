module.exports = define: ({Phaser}) ->

  Preloader = ->

  Preloader.prototype = 
    init: ->
        @input.maxPointers = 1
        @scale.paleAlignHorizontally = true
        @game.renderer.renderSession.roundPixels = true
        @physics.startSystem Phaser.Physics.P2JS
    preload: ->
        @load.path = 'assets/'
        @load.bitmapFont 'fat-and-tiny'
        @load.images ['logo', 'table', 'cushions', 'cue', 'fill']
        @load.spritesheet 'balls', 'balls.png', 26, 26
        @load.physics 'table'
    create: ->
        @state.start 'PoolTable.MainMenu'

  Preloader
