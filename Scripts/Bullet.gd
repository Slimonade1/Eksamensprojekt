extends Area2D

var velocity = 5
var direction

onready var tilemap = get_parent().get_node("Background/TileMap")
onready var positionInWalls1 = $PositionInWalls1
onready var positionInWalls2 = $PositionInWalls2

func _physics_process(delta):
	if direction == "left":
		position.x -= velocity
		scale.x = -1
	
	if direction == "right":
		position.x += velocity
		scale.x = 1

func _on_Bullet_body_entered(body):
	if body.is_in_group("Enemies") or body.is_in_group("Players"):
		body.takeDamage()
	else:
		destroyWall()
	
	queue_free()

func destroyWall():
	var pos1 : Vector2 = tilemap.world_to_map(positionInWalls1.global_position)
	var pos2 : Vector2 = tilemap.world_to_map(positionInWalls2.global_position)
	pos1 = Vector2(floor(pos1.x/6), floor(pos1.y/6))
	print(pos1)
	tilemap.set_cellv(pos1, -1)
	pos2 = Vector2(floor(pos2.x/6), floor(pos2.y/6))
	print(pos2)
	tilemap.set_cellv(pos2, -1)
	
