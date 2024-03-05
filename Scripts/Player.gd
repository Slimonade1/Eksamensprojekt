extends KinematicBody2D

# stats
var score = 0
var damage = 1
var attackSpeed = 2.0

# physics
var speed = 60
var jumpForce = 800
var gravity = 2000

var vel = Vector2()
var grounded = false

# graphics
var playerDirection = "right"
onready var sprite = $playerSprite
onready var spriteFriend = $playerSprite/spriteFriend

# gun cooldown
var cooldown = false
onready var bulletCooldown = $BulletCooldown

var Bullet = preload("res://Scenes/Bullet.tscn")

func _ready():
	sprite.playing = true
	
	spriteFriend.visible = false
	spriteFriend.playing = true

func _physics_process(delta):
	handleMovement(delta)
	
	if Input.is_action_pressed("ui_shoot") and !cooldown:
		handleShooting()

	

func handleMovement(delta):
	#slow stop
	vel.x *= 0.85
	if vel.x <= speed*5 / 6 and vel.x >= -speed*5 / 6:
		vel.x = 0
	
	if Input.is_action_pressed("ui_left"):
		vel.x -= speed
	if Input.is_action_pressed("ui_right"):
		vel.x += speed
	
	#apply gravity to player
	if is_on_wall():
		vel.y = 0
	else:
		vel.y += gravity * delta
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		vel.y -= jumpForce
	
	#sprite direction
	if vel.x < 0:
		sprite.scale.x = -1
		sprite.animation = "running"
		spriteFriend.animation = "running"
		playerDirection = "left"
	if vel.x > 0:
		sprite.scale.x = 1
		sprite.animation = "running"
		spriteFriend.animation = "running"
		playerDirection = "right"
	if vel.x == 0:
		sprite.animation = "idle"
		spriteFriend.animation = "idle"
	
	vel = move_and_slide(vel, Vector2.UP)

func showCompanion():
	spriteFriend.visible = true

func handleShooting():
	bulletCooldown.wait_time = 1 / attackSpeed
	bulletCooldown.start()
	cooldown = true
	
	var gameScene = get_parent()
	var newBullet = Bullet.instance()
	newBullet.direction = playerDirection
	newBullet.position = position
	gameScene.add_child(newBullet)


func _on_BulletCooldown_timeout():
	cooldown = false
