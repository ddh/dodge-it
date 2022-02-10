extends Position2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PowerUpTimer_timeout():
	var random_x = rand_range(0, get_viewport().size.x)
	var random_y = rand_range(0, get_viewport().size.y)
	position = Vector2(random_x, random_y)
