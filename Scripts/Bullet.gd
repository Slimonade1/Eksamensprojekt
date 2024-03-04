extends Area2D

var velocity = 5

func _ready():
	pass

func _physics_process(delta):
	position.x += velocity

