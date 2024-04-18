extends Node2D

onready var music = $AudioStreamPlayer

func _ready():
	music.volume_db = Singletons.volume

func _process(delta):
	Singletons.gameTime += delta
	
