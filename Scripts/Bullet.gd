extends Area2D

var velocity = 12
var direction

# Indlæs TileMap scenen, hvor tiles bliver placeret på mappet
onready var tilemap = get_tree().root.get_node("gameScene/Map/TileMap")
# Lav et tomt array
var posInWall = []

func _ready():
	# hent alle children der findes i gruppen PositionInWalls, og indsæt i et array
	for n in get_child_count():
		if get_child(n).is_in_group("PositionInWalls"):
			posInWall.push_back(get_child(n))

func _physics_process(_delta):
	
	if direction == "left":
		position.x -= velocity
		scale.x = -1
	
	if direction == "right":
		position.x += velocity
		scale.x = 1

func _on_Bullet_body_entered(body):
	# Hvis spilleren rammer en fjender eller spiller, gør skade på denne
	if body.is_in_group("Enemies") or body.is_in_group("Players"):
		body.takeDamage()
	else:
		# Ellers kald destroyWall()
		destroyWall()
	
	queue_free()

func destroyWall():
	# Lav et nyt PoolVector2Array
	var pos = [PoolVector2Array()]
	# Kør for antal Position2D nodes
	for n in posInWall.size():
		# Tilføj positionen af PositionInWalls
		pos.append(tilemap.world_to_map(posInWall[n].global_position))
		
		# Skift værdien i pos fra en global position til tilemap position
		# Rund op til nærmeste position og gang med to grundet map har scale*2
		pos[n+1] = Vector2(floor(pos[n+1].x/2), floor(pos[n+1].y/2))
		
		# Fjern celle i tilemap på positionen
		tilemap.set_cellv(pos[n+1], -1)
	
