module.exports = ->

# ------------------------------------------------
# Flipper actions
# # ------------------------------------------------

  # Right cursor
  if @cursors.right.isDown
    if @flipper_right.rotation <= @flipper_max_rotation
      @flipper_right.body.rotateRight @flipper_rotation_speed
    else
      @flipper_right.body.rotateRight(0)
  else if @flipper_right.rotation > 0
    @flipper_right.body.rotateLeft @flipper_revert_speed
  else
    @flipper_right.body.rotateRight(0)
    @flipper_right.rotation = 0

  # Left cursor
  if @cursors.left.isDown
    if @flipper_left.rotation >= -@flipper_max_rotation
      @flipper_left.body.rotateLeft @flipper_rotation_speed
    else
      @flipper_left.body.rotateLeft(0)
  else if @flipper_left.rotation < 0
    @flipper_left.body.rotateRight @flipper_revert_speed
  else
    @flipper_left.body.rotateLeft(0)
    @flipper_left.rotation = 0

