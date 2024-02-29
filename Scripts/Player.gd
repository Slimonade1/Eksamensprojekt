extends KinematicBody2D

#stats
var score = 0

# physics
var speed = 200
var jumpForce = 600
var gravity = 800

var vel = Vector2()
var grounded = false

onready var sprite = $AnimatedSprite

func _ready():
	sprite.playing = true

func _physics_process(delta):
	#reset horizontal velocity
	vel.x = 0
	
	if Input.is_action_pressed("ui_left"):
		vel.x -= speed
	if Input.is_action_pressed("ui_right"):
		vel.x += speed
	
	#apply gravity to player
	vel.y += gravity * delta
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		vel.y -= jumpForce
	
	#sprite direction
	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false
	
	vel = move_and_slide(vel, Vector2.UP)
