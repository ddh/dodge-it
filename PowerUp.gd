extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("PowerUp#_ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn():
	print("Spawning a PowerUp!")
	var x_offset = $Sprite.texture.get_width() * $Sprite.scale.x
	var y_offset = $Sprite.texture.get_height() * $Sprite.scale.y
	var random_x = rand_range(x_offset, get_viewport().size.x - x_offset)
	var random_y = rand_range(y_offset, get_viewport().size.y - y_offset)
	position = Vector2(random_x, random_y)
	show()

func _on_Area2D_area_entered(area):
	print("Removing Powerup")
	queue_free()
