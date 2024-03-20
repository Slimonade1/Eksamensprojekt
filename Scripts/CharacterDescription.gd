extends Control

var is_paused = false setget set_is_paused
onready var description = $CanvasLayer
onready var showing = false

func _unhandled_input(event):
	if showing:
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	description.visible = is_paused

func _input(event):
	if event is InputEventKey and event.pressed:
		showing = false
		self.is_paused = false
