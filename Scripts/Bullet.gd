extends Area2D

var velocity = 5
var direction

func _ready():
	pass

func _physics_process(delta):
	if direction == "left":
		position.x -= velocity
	
	if direction == "right":
		position.x += velocity



func _on_Bullet_body_entered(body):
	print("HIT")
