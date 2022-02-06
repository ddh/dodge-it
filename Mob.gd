extends RigidBody2D

const MOB_SPEEDS = {
	'green': 100,
	'red': 150,
	'blue': 200
}

# Declare member variables here. Examples:
export var min_speed = 150
export var max_speed = 250
export var speed_multiplier = 1
export var shell_type = ''



# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	var chosen_mob_type = randi() % mob_types.size()
	$AnimatedSprite.animation = mob_types[chosen_mob_type]
	shell_type = mob_types[chosen_mob_type]
	min_speed = MOB_SPEEDS[mob_types[chosen_mob_type]]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
