extends Control

var is_paused = false setget set_is_paused
onready var description = $CanvasLayer
onready var showing = false
var showDescription = false
var politiker
var startPositions = []
var dramaticEffects = []

func _ready():
	for i in get_children():
		for j in i.get_children():
			for k in j.get_children():
				if k.is_in_group("DramaticEffect"):
					dramaticEffects.push_back(k)
					startPositions.push_back(k.position)

func _process(delta):
	if showing:
		self.is_paused = true
		set_is_paused(self.is_paused)
	
	$CanvasLayer/ColorRect/Kira.visible = false
	$CanvasLayer/ColorRect/Bergur.visible = false
	$CanvasLayer/ColorRect/Niels.visible = false
	if politiker == "kira":
		$CanvasLayer/ColorRect/Kira.visible = true
	if politiker == "bergur":
		$CanvasLayer/ColorRect/Bergur.visible = true
	if politiker == "niels":
		$CanvasLayer/ColorRect/Niels.visible = true

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	description.visible = is_paused

func _input(event):
	if event is InputEventKey and event.pressed and showDescription:
		showing = false
		self.is_paused = false

func _on_CanvasLayer_visibility_changed():
	for n in dramaticEffects.size():
		dramaticEffects[n].position = startPositions[n]
	
	showDescription = false
	
	$InputCooldown.start()
	$InputCooldown.wait_time = 3
	
	$MaxTime.start()
	$MaxTime.wait_time = 15
	

func _on_InputCooldown_timeout():
	showDescription = true

func _on_MaxTime_timeout():
	showing = false
	self.is_paused = false
