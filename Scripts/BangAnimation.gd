extends AnimatedSprite

func _ready():
	visible = false

func _on_BangAnimation_animation_finished():
	#visible = false
	playing = false
	
