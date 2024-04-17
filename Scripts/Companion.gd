extends Area2D

onready var sprite = $companionSprite
onready var infoScreen = $"../../CanvasLayer2/CharacterDescription"
export var politiker = ""

func _ready():
	sprite.playing = true

func _on_Companion_body_entered(body):
	if body.name == "Player":
		body.politiker = politiker
		body.showCompanion()
		infoScreen.politiker = politiker
		infoScreen.showing = true
		
		queue_free()
