extends Area2D

onready var sprite = $companionSprite
onready var infoScreen = $"../../CanvasLayer/CharacterDescription"


func _ready():
	sprite.playing = true

func _on_Companion_body_entered(body):
	if body.name == "Player":
		body.showCompanion()
		infoScreen.showing = true
		queue_free()
