module.exports = define: ({Phaser}) ->
  MainMenu = ->

  MainMenu.prototype =
    create: ->
      @stage.backgroundColor = 0x001b07
      @logo = @add.image @world.centerX, 140, 'logo'
      @logo.anchor.x = 0.5
      @start_text = @add.bitmapText @world.centerX, 460, 'fat-and-tiny', "CLICK TO PLAY", 64
      @start_text.anchor.x = 0.5
      @start_text.smoothed = false
      @start_text.tint = 0xff0000
      @input.onDown.addOnce @start, this

    start: ->
      @state.start 'PoolTable.Game'

  MainMenu
