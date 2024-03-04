extends Area2D

onready var sprite = $companionSprite

func _ready():
	sprite.playing = true

func _on_Companion_body_entered(body):
	if body.name == "Player":
		body.showCompanion()
		queue_free()
