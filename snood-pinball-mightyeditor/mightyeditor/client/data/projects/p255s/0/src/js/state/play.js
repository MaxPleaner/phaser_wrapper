"use strict";
window["11"].state.play = {
	preload: function(){
		this.game.load.physics("pickle_physics", "pickle.json");
	},
	
	create: function(){
		var game = this.game
		this.foo = mt.create('foo');
		this.foo.scale.setTo(0.125, 0.125)
		this.paddles = mt.create('paddles');		
		this.upKey = game.input.keyboard.addKey(Phaser.Keyboard.UP);
		this.downKey = game.input.keyboard.addKey(Phaser.Keyboard.DOWN);
		this.leftKey = game.input.keyboard.addKey(Phaser.Keyboard.LEFT);
		this.rightKey = game.input.keyboard.addKey(Phaser.Keyboard.RIGHT);
		this.keyboard = new Phaser.Keyboard(this.game)
		this.cursors = this.keyboard.createCursorKeys()
// 		this.angular_vel = 0
		
		window.foo = this.foo
		window.game = this.game
		window.x = this
		window.pickles = game.add.group()


		// non-rectangular sprites
		game.physics.startSystem(Phaser.Physics.P2JS);
		game.physics.p2.enable(this.foo, false)
		game.physics.p2.setImpactEvents(true);
		var worldMaterial = game.physics.p2.createMaterial('worldMaterial');
		game.physics.p2.setWorldMaterial(worldMaterial, true, true, true, true);
		window.worldMaterial = worldMaterial
		foo.body = new Phaser.Physics.P2.Body(game, foo, 300, 0)
		var foo_collision = game.physics.p2.createCollisionGroup();
	
		// Foo to wall interaction
		var foo_material = game.physics.p2.createMaterial(
			'foo_material',
			foo.body
		);	
		var contactMaterial = game.physics.p2.createContactMaterial(
			worldMaterial,
			foo_material
		);
		contactMaterial.friction = 0.3;     // Friction to use in the contact of these two materials.
		contactMaterial.restitution = 0;  // Restitution (i.e. how bouncy it is!) to use in the contact of these two materials.
		contactMaterial.stiffness = 1e7;    // Stiffness of the resulting ContactEquation that this ContactMaterial generate.
		contactMaterial.relaxation = 3;     // Relaxation of the resulting ContactEquation that this ContactMaterial generate.
		contactMaterial.frictionStiffness = 1e7;    // Stiffness of the resulting FrictionEquation that this ContactMaterial generate.
		contactMaterial.frictionRelaxation = 3;     // Relaxation of the resulting FrictionEquation that this ContactMaterial generate.
		contactMaterial.surfaceVelocity = 0;        // Will add surface velocity to this material. If bodyA rests on top if bodyB, and the surface velocity is positive, bodyA will slide to the right.
		
		
		this.pickle1 = game.add.sprite(910, 390, '/pickle.png');
		this.pickle2 = game.add.sprite(250, 390, '/pickle.png');
		var pickle1 = this.pickle1
		var pickle2 = this.pickle2
		window.pickle1 = pickle1		
		window.pickle2 = pickle2
		pickles.add(pickle1)
		pickles.add(pickle2)
		pickles.forEach(function(pickle){
			
			pickle.anchor.setTo(0.5,0.5)

			game.physics.p2.enable(pickle, false);
			pickle.body.clearShapes();
			pickle.body.loadPolygon('pickle_physics', 'pickle');
// 			pickle.scale.setTo(0.57, 0.67)
			
			// Foo to pickle interaction
			var pickle_material = game.physics.p2.createMaterial(
				'pickle_material',
				pickle.body
			);	
			var contactMaterial = game.physics.p2.createContactMaterial(
				pickle_material,
				foo_material
			);
			contactMaterial.friction = 0.3;     // Friction to use in the contact of these two materials.
			contactMaterial.restitution = 2.0;  // Restitution (i.e. how bouncy it is!) to use in the contact of these two materials.
			contactMaterial.stiffness = 1e7;    // Stiffness of the resulting ContactEquation that this ContactMaterial generate.
			contactMaterial.relaxation = 3;     // Relaxation of the resulting ContactEquation that this ContactMaterial generate.
			contactMaterial.frictionStiffness = 1e7;    // Stiffness of the resulting FrictionEquation that this ContactMaterial generate.
			contactMaterial.frictionRelaxation = 3;     // Relaxation of the resulting FrictionEquation that this ContactMaterial generate.
			contactMaterial.surfaceVelocity = 0;        // Will add surface velocity to this material. If bodyA rests on top if bodyB, and the surface velocity is positive, bodyA will slide to the right.

		})
		
		var pickle_collision = game.physics.p2.createCollisionGroup();

		// collision setup for non-rectanular sprites
		game.physics.p2.updateBoundsCollisionGroup();
		this.foo.body.setCollisionGroup(foo_collision);
		this.foo.body.collides([foo_collision, pickle_collision]);
		pickles.forEach(function(pickle){
			pickle.body.setCollisionGroup(pickle_collision);
			pickle.body.collides(foo_collision, () => {
			}, this)
		})

		// P2 environment config
		game.physics.p2.gravity.y = 3000;
		pickles.forEach(function(pickle){
			pickle.body.data.gravityScale = 0; // disable gravity for pickle
			pickle.body.static = true

		})
		
	},
	
	touching_floor: function(){
  	  return this.foo.position.y > (this.game.height * 0.85)
	},
	
	left_striking: function() {
		val = this.left_strike_frames
		
	},
	
	left_strike_reverting: function() {
	},
	
	right_striking: function() {
	},
	
	right_strike_reverting: function() {
	}
	
	update: function(){
		
		if (this.left_striking()) {
			this.pickle2.body.rotateLeft(300)
		} else if (this.left_strike_reverting()){
		} else {
			this.pickle2.body.rotation = -2 // flip it 180%
		}
		
		
		
		// Foo (ball object) movement stuff
		var vel = this.foo.body.velocity
		var vel_change_y = 500
		var vel_change_x = 50
		var vel_slowdown_x = 0
		var vel_slowdown_y = 0
		var max_vel_x = 1000
		var max_vel_y = 1000
// 		var max_angular_vel = 5
// 		var xy_vel_over_angular_vel_ratio = 1500
// 		var angular_vel_reversal_speedup = 1.0 // 1 is the minimum

		if (!this.upKey.isDown) {
			if (vel.y > vel_slowdown_y) { vel.y -= vel_slowdown_y}
		} else {
			vel.y -= vel_change_y
		}
		
		if (!this.downKey.isDown) {
			if (vel.y < -vel_slowdown_y) { vel.y += vel_slowdown_y}
		} else { 
			vel.y += vel_change_y
		}
		
		if (!this.rightKey.isDown) {
			if (this.touching_floor()){
				if (vel.x > vel_slowdown_x) { vel.x -= vel_slowdown_x }
			}
		} else { 
			vel.x += vel_change_x
		}
		
		if (!this.leftKey.isDown) {
			if (this.touching_floor()){
				if (vel.y < -vel_slowdown_x) { vel.x += vel_slowdown_x }
			}
		} else { 
			vel.x -= vel_change_x		
		}
		
		if (vel.x > max_vel_x) {
			vel.x = max_vel_x
		}
		if (vel.x < -max_vel_x) {
			vel.x = -max_vel_x 
		}
		if (vel.y > max_vel_x) {
			vel.y = max_vel_y
		}
		if (vel.y < -max_vel_y) {
			vel.y = -max_vel_y
		}

	// The followin stuff is not necessary with P2 physics, or has a different API
		
		// ANGULAR VELOCITY (rotation)
// 		if (this.touching_floor()) {
// 			if (vel.x > 0) {
// 				this.angular_vel += (vel.x / xy_vel_over_angular_vel_ratio)
// 				if (this.angular_vel < 0) {
// 					this.angular_vel = this.angular_vel / angular_vel_reversal_speedup
// 				}
// 			}
// 			else if (vel.x < 0) {
// 				this.angular_vel -= (-vel.x / xy_vel_over_angular_vel_ratio)
// 				if (this.angular_vel > 0) {
// 					this.angular_vel = this.angular_vel / angular_vel_reversal_speedup
// 				}
// 			}
// 		}
// 		if (this.angular_vel > max_angular_vel) {
// 			this.angular_vel = max_angular_vel
// 		} else if (this.angular_vel < -max_angular_vel) {
// 			this.angular_vel = -max_angular_vel
// 		}
// 		this.foo.angle += this.angular_vel

// 		Collision ( for Arcade physics)
// 		this.game.physics.arcade.collide(
// 			this.foo, this.pickle, function(foo, pickle) {
// 				debugger
// 			}, null, this
// 		)
		
 	}
};