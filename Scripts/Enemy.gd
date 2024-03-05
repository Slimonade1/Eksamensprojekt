extends KinematicBody2D

var speed = 60
var jumpForce = 800
var gravity = 2000

var vel = Vector2()

onready var sprite = $EnemySprite

func _ready():
	sprite.playing = true

func _physics_process(delta):
	#reset x velocity
	vel.x = 0
	
	#movement left and right
	vel.x -= speed
	
	#apply gravity to player
	vel.y += gravity * delta
	
	vel = move_and_slide(vel, Vector2.UP)
	
	#sprite direction
	if vel.x < 0:
		sprite.flip_h = true
	if vel.x > 0:
		sprite.flip_h = false
