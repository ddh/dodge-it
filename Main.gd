extends Node

export (PackedScene) var Mob
var score

func _ready():
	randomize()


func _on_MobTimer_timeout():
	
	# Make the next timer a little shorter
	$MobTimer.wait_time = max($MobTimer.wait_time * 0.99, 0.25)
	
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Set the velocity (speed & direction).
	# This line is chooses a random speed
	# mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	# This line multiplies the speed depending on the score.
	# mob.linear_velocity = Vector2(min(mob.min_speed + score * 3.0, 250), 0)
	var speed = min(mob.min_speed + score * 5.0, 400)
	mob.linear_velocity = Vector2(speed, 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

	print("Launching a %s Shell @ speed: %s. Next shell in %ss" % [mob.shell_type, speed, $MobTimer.wait_time])
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func game_over():
	print("Main - Game Over")
	$HUD.show_game_over()
	$CharacterDeadMusic.play()
	$BackgroundMusic.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	get_tree().call_group("mobs", "queue_free")

func new_game():
	$BackgroundMusic.play()
	score = 0
	$MobTimer.wait_time = 1
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")


func _on_CharacterDeadMusic_finished():
	$GameOverMusic.play()
