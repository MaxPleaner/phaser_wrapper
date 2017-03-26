module.exports = define: ({Phaser, PoolTable}) ->

  Game = (game) ->
    @score = 0
    @scoreText = null
    @speed = 0
    @allowShotSpeed = 20.0
    @balls = null
    @shadows = null
    @cue = null
    @fill = null
    @fillRect = null
    @aimLine = null
    @cueball = null
    @resetting = false
    @placeball = null
    @placeballShadow = null
    @placeRect = null
    @pauseKey = null
    @debugKey = null
    this

  Game.prototype = 
    
    init: ->
      @score = 0
      @speed = 0
      @resetting = false

    create: ->
      @stage.backgroundColor = 0x001b07
      # table
      @table = this.add.sprite 400, 300, 'table'
      @physics.p2.enable @table, PoolTable.showDebug
      @table.body.static = true
      @table.body.clearShapes()
      @table.body.loadPolygon 'table', 'pool-table-physics-shape'
      @tableMaterial = @physics.p2.createMaterial 'tableMaterial', @table.body
      # pockets
      @pockets = this.add.sprite()
      @physics.p2.enable @pockets, PoolTable.showDebug
      @pockets.body.static = true
      @pockets.body.clearShapes()
      @pockets.body.addCircle 32, 64, 80
      @pockets.body.addCircle 16, 400, 80
      @pockets.body.addCircle 32, 736, 80
      @pockets.body.addCircle 32, 64, 528
      @pockets.body.addCircle 16, 400, 528
      @pockets.body.addCircle 32, 736, 528
      # ball shadows
      @shadows = this.add.group()
      # cushions
      @add.sprite 0,0, 'cushions'
      # balls
      @balls = @add.physicsGroup Phaser.Physics.P2JS
      @balls.enableBodyDebug = PoolTable.showDebug
      @ballMaterial = @physics.p2.createMaterial 'ballMaterial'
      # row 1 (5 balls)
      y = 241
      @makeBall 200, y, PoolTable.RED
      @makeBall 200, y + 32, PoolTable.YELLOW
      @makeBall 200, y + 64, PoolTable.YELLOW
      @makeBall 200, y + 96, PoolTable.RED
      @makeBall 200, y + 128, PoolTable.YELLOW
      # row 2 (4 balls)
      y = 257
      @makeBall 232, y, PoolTable.YELLOW
      @makeBall 232, y + 32, PoolTable.RED
      @makeBall 232, y + 64, PoolTable.YELLOW
      @makeBall 232, y + 96, PoolTable.RED
      # row 3 (3 balls including black)
      y = 273
      @makeBall 264, y, PoolTable.RED
      @makeBall 264, y + 32, PoolTable.BLACK
      @makeBall 264, y + 64, PoolTable.YELLOW
      #  Row 4 (2 balls)
      y = 289;
      @makeBall 296, y, PoolTable.YELLOW
      @makeBall 296, y + 32, PoolTable.RED
      # row 5 (single red ball)
      @makeBall 328, 305, PoolTable.RED
      # cue ball
      @cueball = @makeBall 576, 305, PoolTable.WHITE
      # place cue ball and shadow
      @placeball = @add.sprite 0,0, 'balls', PoolTable.WHITE
      @placeball.anchor.set 0.5
      @placeball.visible = false
      @placeballShadow = @shadows.create 0,0, 'balls', 4
      @placeballShadow.anchor.set 0.5
      @placeballShadow.visible = false
      @placeRect = new Phaser.Rectangle 112, 128, 576, 352
      # P2 impact events
      @physics.p2.setImpactEvents true
      # ball vs table
      ballVsTableMaterial = @physics.p2.createContactMaterial @ballMaterial, @tableMaterial
      ballVsTableMaterial.restitution = 0.5
      # ball vs ball
      ballVsBallMaterial = @physics.p2.createContactMaterial @ballMaterial, @ballMaterial
      ballVsBallMaterial.restitution = 0.9
      # cue
      @cue = @add.sprite 0,0, 'cue'
      @cue.anchor.y = 0.5
      @fill = @add.sprite 0,0, 'fill'
      @fill.anchor.y = 0.5
      @fillRect = new Phaser.Rectangle 0, 0, 332, 6
      @fill.crop @fillRect
      @aimLine = new Phaser.Line @cueball.x, @cueball.y, @cueball.x, @cueball.y
      # score
      @scoreText = @add.bitmapText 16, 0, 'fat-and-tiny', 'SCORE: 0', 32
      @scoreText.smoothed = false
      # p to pause/resume
      @pauseKey = @input.keyboard.addKey Phaser.Keyboard.P
      @pauseKey.onDown.add @togglePause, this
      # d to toggle debug display
      @debugKey = @input.keyboard.addKey Phaser.Keyboard.D
      @debugKey.onDown.add @takeShot, this

    togglePause: ->
      @game.paused = !@game.paused

    toggleDebug: ->
      PoolTable.showDebug = !PoolTable.showDebug
      @state.restart()

    makeBall: (x, y, color) ->
      ball = @balls.create x, y, 'balls', color
      ball.body.setCircle 13
      ball.body.fixedRotation = true
      ball.body.setMaterial @ballMaterial
      ball.body.damping = 0.4
      ball.body.angularDampin = 0.45
      ball.body.createBodyCallback @pockets, @hitPocket, this
      # link 2 sprites together
      shadow = @shadows.create x+4, y+4, 'balls', 4
      shadow.anchor.set 0.5
      ball.shadow = shadow
      ball

    takeShot: ->
      if @speed > @allowShotSpeed
        return
      speed = @aimLine.length / 2
      if speed > 112
        speed = 112
      @updateCue()
      px = Math.cos(@aimLine.angle) * speed
      py = Math.sin(@aimLine.angle) * speed
      @cueball.body.applyImpulse [px, py], @cueball.x, @cueball.y
      @cue.visible = false
      @fill.visible = false

    hitPocket: (ball, pocket) ->
      # cue ball reset
      if ball.sprite == @cueball
        @resetCueBall()
      else
        ball.sprite.shadow.destroy()
        ball.sprite.destroy()
        @score += 100
        @scoreText.text = "SCORE: #{@score}"
        if @balls.total == 1
          @time.events.add 3000, @gameOver, this

    resetCueBall: ->
      @cueball.body.setZeroVelocity()
      # move it to safe area
      @cueball.body.x = 16
      @cueball.body.y = 16
      @resetting = true
      # disable physics body and stick ball to pointer
      @cueball.visible = false
      @cueball.shadow.visible = false
      @placeball.x = @input.activePointer.x
      @placeball.y = @input.activePointer.y
      @placeball.visible = true
      @placeballShadow.x = @placeball.x + 10
      @placeballShadow.y = @placeball.y + 10
      @placeballShadow.visible = true
      @input.onDown.remove @takeShot, this
      @input.onDown.add @placeCueBall, this

    placeCueBall: ->
      # make sure there's no collision
      a = new Phaser.Circle @placeball.x, @placeball.y, 26
      b = new Phaser.Circle 0, 0, 26
      for i in [0..@balls.length]
        ball = @balls.children[i]
        if (ball.frame != 2) && ball.exists
          b.x = ball.x
          b.y = ball.y
          return if Phaser.Circle.intersects a, b
      @cueball.reset @placeball.x, @placeball, y
      @cueball.body.reset @placeball.x, @placeball.y
      @cueball.visible = true
      @cueball.shadow.visible = true
      @placeball.visible = false
      @placeballShadow.visible = false
      @resetting = false
      @input.onDown.remove @placeCueBall, this
      @input.onDown.add @takeShot, this

    updateCue: ->
      @aimLine.start.set @cueball.x, @cueball.y
      @aimLine.end.set @input.activePointer.x, @input.activePointer.y
      @cue.position.copyFrom @aimLine.start
      @cue.rotation = @aimLine.angle
      @fill.position.copyFrom @aimLine.start
      @fill.rotation = @aimLine.angle
      @fillRect.width = @aimLine.length
      @fill.updateCrop()


    update: ->
      if @resetting
        @placeball.x = @math.clamp @input.x, @placeRect.left, @placeRect, right
        @placeball.y = @math.clamp @input.y, @placeRect.top, @placeRect.bottom
        @placeballShadow.x = @placeball.x + 10
        @placeballShadow.y = @placeball.y + 10
      else
        @updateSpeed()
        @updateCue()

    updateSpeed: ->
      @speed = Math.sqrt(
        (@cueball.body.velocity.x * @cueball.body.velocity.x) + (@cueball.body.velocity.y * @cueball.body.velocity.y)
      )
      if @speed > @allowShotSpeed
        if !@cue.visible
          @cue.visible = true
          @fill.visible = true
      else if @speed < 3.0
        @cueball.body.setZeroVelocity()

    preRender: ->
      @balls.forEach @positionShadow, this

    positionShadow: (ball) ->
      ball.shadow.x = ball.x + 4
      ball.shadow.y = ball.y + 3

    gameOver: ->
      @state.start "PoolTable.MainMenu"

    render: ->
      if PoolTable.showDebug
        if @speed < 6
          @game.debug.geom @aimLine
        @game.debug.text "speed: #{@speed}", 540, 24
        @game.debug.text "power: #{@aimLine.length / 3}", 540, 48

  Game
