module.exports = ->

  add_p2_sprite = (x, y, key) =>
    sprite = @add.sprite x, y, key
    @physics.p2.enable sprite
    sprite

  make_static = (sprite) =>
    sprite.static = true
    sprite.body.data.gravityScale = 0

  add_collision_group = (sprite) =>
    collision_group = @game.physics.p2.createCollisionGroup()
    @game.physics.p2.updateBoundsCollisionGroup()
    sprite.body.setCollisionGroup(collision_group);
    collision_group

  add_group = =>
    group = @game.add.group();
    group.enableBody = true;
    group.physicsBodyType = Phaser.Physics.P2JS;
    group

  add_sprite_material = (sprite=null, key) =>
    @game.physics.p2.createMaterial key, (if sprite then sprite.body else null)

  add_world_material = (key) =>
    material = add_sprite_material key
    @game.physics.p2.setWorldMaterial material, true, true, true, true
    material

  add_contact_material = (material1, material2, opts) =>
    contact_material = @game.physics.p2.createContactMaterial material1, material2
    Object.assign contact_material, opts
    contact_material.friction           ||= 0
    contact_material.restitution        ||= 1.0
    contact_material.stuffness          ||= 1e7
    contact_material.relaxation         ||= 3
    contact_material.frictionStiffness  ||= 1e7
    contact_material.frictionRelaxation ||= 3
    contact_material.surfaceVelocity    ||= 0
    contact_material

  add_collision_function = (sprite, collision_group, fn) =>
    sprite.collides(collision_group, fn)

  # ------------------------------------------------
  # custom stuff goes here
  # ------------------------------------------------

  # assets - the order is important here
  # 1. background
  @background = add_p2_sprite 300, 385, 'background'
  @background.scale.setTo 2.5, 1.5
  make_static(@background)
  # 2. playfield
  @ball = add_p2_sprite @ball_start_x, @ball_start_y, 'ball'

  
  # collision groups
  @collision_groups.ball = add_collision_group(@ball)

  # materials
  @materials.world = add_world_material 'world_material'
  @materials.ball = add_sprite_material @ball, 'ball_material'

  # contact materials
  @contact_materials.ball_and_world = add_contact_material(
    @materials.world,
    @materials.ball,
    restitution: 1
  )



