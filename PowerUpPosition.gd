extends Position2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_x = rand_range($Sprite.texture.get_width(), get_viewport().size.x - $Sprite.texture.get_width())
	var random_y = rand_range($Sprite.texture.get_height(), get_viewport().size.y - $Sprite.texture.get_height())
	position = Vector2(random_x, random_y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
