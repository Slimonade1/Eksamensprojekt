extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var startPosX = position.x
onready var startPosY = position.y
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	position.x += 1
	position.y -= sin(3.1) /10
	posCheck(position.x)


func posCheck(posX):
	if posX > OS.get_screen_size().x:
		position.y -= texture.get_size().y*2*(sin(3.1) /10)
		position.x -=  texture.get_size().x*2
		
