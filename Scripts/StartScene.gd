extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$controls.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Settings_pressed():
	$controls.visible = true
	pass


func _on_TextureButton_pressed():
	$controls.visible = false
	pass # Replace with function body.


func _on_start_pressed():
	get_tree().change_scene("res://Scenes/gameScene.tscn")
	pass # Replace with function body.
