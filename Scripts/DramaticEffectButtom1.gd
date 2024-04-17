extends Sprite

func _process(_delta):
	if $"../..".visible:
		position += Vector2(2665*3, -354).normalized()
