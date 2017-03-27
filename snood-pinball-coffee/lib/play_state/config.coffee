module.exports = load: (caller) ->
  ball_start_x: caller.world.centerX / 2
  ball_start_y: 0
  collision_groups: {}
  materials: {}
  contact_materials: {}
  cursors: caller.game.input.keyboard.createCursorKeys();
  gravity:
    x: 0
    y: 100
