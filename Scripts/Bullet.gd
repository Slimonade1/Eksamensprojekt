extends Area2D

var velocity = 12
var direction

onready var tilemap = get_parent().get_node("Background/TileMap")
var posInWall = []

func _ready():
	for n in get_child_count():
		if get_child(n).is_in_group("PositionInWalls"):
			posInWall.push_back(get_child(n))

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
	var pos = [PoolVector2Array()]
	for n in posInWall.size():
		pos.append(tilemap.world_to_map(posInWall[n].global_position))
		pos[n+1] = tilemap.world_to_map(posInWall[n].global_position)
		pos[n+1] = Vector2(floor(pos[n+1].x/6), floor(pos[n+1].y/6))
		tilemap.set_cellv(pos[n+1], -1)
	
