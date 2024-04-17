extends Control

func _ready():
	$controls.visible = false

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/gameScene.tscn")

func _on_Quit_pressed():
		get_tree().quit()

func _on_Setting_pressed():
	$controls.visible = true

func _on_TextureButton_pressed():
	$controls.visible = false
