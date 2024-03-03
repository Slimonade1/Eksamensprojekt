extends KinematicBody2D

#stats
var score = 0

# physics
var speed = 60
var jumpForce = 800
var gravity = 2000

var vel = Vector2()
var grounded = false

onready var sprite = $playerSprite
onready var spriteFriend = $playerSprite/spriteFriend

func _ready():
	sprite.playing = true
	spriteFriend.playing = true

func _physics_process(delta):
	#slow stop
	vel.x *= 0.85
	if vel.x <= speed*5 / 6 and vel.x >= -speed*5 / 6:
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
		sprite.scale.x = -1
		sprite.animation = "running"
		spriteFriend.animation = "Running"
	if vel.x > 0:
		sprite.scale.x = 1
		sprite.animation = "running"
		spriteFriend.animation = "Running"
	if vel.x == 0:
		sprite.animation = "idle"
		spriteFriend.animation = "Idle"
	
	vel = move_and_slide(vel, Vector2.UP)
