extends Control

onready var volumeControl = $controls/ColorRect2/ColorRect/Volume

func _ready():
	$controls.visible = false

func _process(delta):
	Singletons.volume = volumeControl.value

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/gameScene.tscn")

func _on_Quit_pressed():
		get_tree().quit()

func _on_Setting_pressed():
	$controls.visible = true

func _on_TextureButton_pressed():
	$controls.visible = false
