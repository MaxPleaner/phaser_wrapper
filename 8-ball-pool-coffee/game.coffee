Pixi = require 'pixi.js'
window.p2 = require 'p2'
Phaser = require 'phaser'
PoolTable = require './lib/pool_table'

deps = {Pixi, p2, Phaser, PoolTable}

game = new Phaser.Game(800, 600, Phaser.WEBGL, 'game', null, false, true)
game.state.add 'PoolTable.Preloader', PoolTable.Preloader.define(deps)
game.state.add 'PoolTable.MainMenu', PoolTable.MainMenu.define(deps)
game.state.add 'PoolTable.Game', PoolTable.Game.define(deps)

game.state.start 'PoolTable.Preloader'

