module.exports = ->
  Object.assign this, require('./config').load(this)
  @physics.startSystem Phaser.Physics.P2JS
  @game.physics.p2.setImpactEvents(true);
  Object.assign @game.physics.p2.gravity, @gravity
  window.app = this
