extends KinematicBody2D

#stats
export var speed = 200
var jumpForce = 800
var gravity = 2000
var health = 3

var vel = Vector2()
var turn = false

onready var sprite = $EnemySprite
onready var player = $"../../Player"

func _ready():
	sprite.playing = true

func _physics_process(delta):
	#reset x velocity
	vel.x = 0
	
	#movement left and right
	vel.x += speed
	
	#apply gravity to player
	vel.y += gravity * delta
	
	vel = move_and_slide(vel, Vector2.UP)
	
	#sprite direction
	if vel.x < 0:
		sprite.flip_h = true
	if vel.x > 0:
		sprite.flip_h = false


func turnAround():
	turn = true
	if turn:
		speed *= -1
		turn = false

func takeDamage():
	if health == 0:
		queue_free()
	health -= player.damage
