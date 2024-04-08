extends AnimatedSprite

func _ready():
	pass
	#visible = false

func _on_BangAnimation_animation_finished():
	#visible = false
	playing = false
	
