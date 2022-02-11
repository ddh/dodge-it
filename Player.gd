extends Area2D

# Preparing for collisions
signal hit
signal died


# Declare member variables here. Examples:
export var speed = 400 # (pixels/sec)
var screen_size # Size of game window
var i_am_big = true
var i_am_invincible = true
var controls_enabled = true


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	 # The player's movement vector
	var velocity = Vector2()
	
	# Keyboard controls and movement
	if controls_enabled:
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		
	# Play animation when char is moving:
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$PlayerSprite.animation = "walk" if i_am_big else "small_walk"
		$PlayerSprite.play()
	else:
		$PlayerSprite.stop() # `$` is shorthand for get_node(); get_node("PlayerSprite")
	
	# Clamping variables
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# If char is not moving, play idle animation
	if velocity.length() == 0:
		$PlayerSprite.animation = "idle" if i_am_big else "small_idle"

	# Flip sprite in left/right direction when moving
	# If velocity is 
	if velocity.x != 0:
		$PlayerSprite.flip_h = velocity.x < 0

func _on_Player_body_entered(body):
	print("Something entered the body: {body}".format({"body": body.name}))
	print(body.name)
	
	# When player hits an enemy
	if body.is_in_group("mobs"):
		print("I got hit by an enemy!")
		
		# Player is powered up.
		if i_am_invincible && !i_am_big:
			print("Player - I'm invincible!")
			return
		elif i_am_big:
			emit_signal("hit")
			i_am_big = false # No longer powered up.
			i_am_invincible = true # Temp invincibility timer
			$InvincibilityTimer.start()
			
			$PowerDownSfx.play()
			
			$BigCollision.set_deferred("disabled", true)
			$SmallCollision.set_deferred("disabled", false)
		# Player isn't powered up, so death occurs.
		else:
			emit_signal("died")
			controls_enabled = false
			$SmallCollision.set_deferred("disabled", true)
			$PlayerSprite.hide()
			$DeathSprite.show()

func start(pos):
	controls_enabled = true
	position = pos
	i_am_big = true # Player is powered up to start.
	show() # Show the Player on screen.
	$PlayerSprite.show()
	$DeathSprite.hide()
	$BigCollision.disabled = false # Player starts big, with matching collision box size.
	$SmallCollision.disabled = true # Disable the smaller collision box size.


# When invincibility is over, character has smaller hitbox
# and is no longer invincible.
func _on_InvincibilityTimer_timeout():
	i_am_invincible = false
	print("Player - No longer invincible, after the timeout.")
	$SmallCollision.set_deferred("disabled", false)

func _on_Player_hit():
	blink()


func _on_Player_area_shape_entered(area_id, area, area_shape, local_shape):
	print("on_player_area_shape_entered" + area.get_name())
	if area.is_in_group("powerups"):
		print("Mario ate a mushroom!")
		$PowerUpSfx.play()
		blink()
		i_am_big = true
		i_am_invincible = true
		$InvincibilityTimer.start()
		$BigCollision.set_deferred('disabled', false)
		$SmallCollision.set_deferred('disabled', true)

func blink():
	for i in 5:
		hide()
		yield(get_tree().create_timer(0.1), "timeout")
		show()
		yield(get_tree().create_timer(0.1), "timeout")
