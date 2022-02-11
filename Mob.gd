extends RigidBody2D

const MOB_SPEEDS = {
	'green': 100,
	'red': 150,
	'blue': 200
}

# Declare member variables here. Examples:
export var min_speed = 150
export var max_speed = 250
export var shell_type = ''



# Called when the node enters the scene tree for the first time.
func _ready():
	# We get a list of the shell types; green, red, blue
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	
	# Then we randomly choose a shell type
	var chosen_mob_type = randi() % mob_types.size()
	
	# We set the animation according to the shell type
	$AnimatedSprite.animation = mob_types[chosen_mob_type]
	shell_type = mob_types[chosen_mob_type]
	
	# Then we set this shell speed to the speed mapped to the shell type
	min_speed = MOB_SPEEDS[mob_types[chosen_mob_type]]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# When the shell leaves the screen, it is marked for deletion to free up space.
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func stop():
	set_deferred("linear_velocity", Vector2(0,0))
