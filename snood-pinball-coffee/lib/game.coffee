module.exports = start: ->
  game = new Phaser.Game(800, 600, Phaser.WEBGL, 'game', null, false, true)
  game.state.add 'PlayState', PlayState
  game.state.start 'PlayState'

