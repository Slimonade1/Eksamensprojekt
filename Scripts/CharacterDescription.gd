extends Control

var is_paused = false setget set_is_paused
onready var description = $CanvasLayer
onready var showing = false
var inputCooldown = 3
var cooldown = false
var showDescription = false

func _process(delta):
	if showing:
		self.is_paused = true
		set_is_paused(self.is_paused)
		cooldown = true
	
	if cooldown:
		inputCooldown -= delta
	
	if inputCooldown <= 0:
		cooldown = false
		inputCooldown = 3
		showDescription = true
	

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	description.visible = is_paused

func _input(event):
	if event is InputEventKey and event.pressed and showDescription:
		showing = false
		self.is_paused = false
