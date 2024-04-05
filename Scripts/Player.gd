extends KinematicBody2D

# stats
var score = 0
var damage = 1
var attackSpeed = 2.0
var health = 5
var trauma = 0.0

# physics
var speed = 60
var jumpForce = 800
var climbSpeed = 200
var gravity = 2000

var vel = Vector2()
var grounded = false

# graphics
var playerDirection = "right"
onready var sprite = $playerSprite
onready var spriteFriend = $playerSprite/spriteFriend
onready var jumpEffect = $"../Jump effect"
onready var camera = $Camera2D

# gun cooldown
var cooldown = false
onready var bulletCooldown = $BulletCooldown

# gun physics
onready var tilemap = $"../Background/TileMap"
var Bullet = preload("res://Scenes/Bullet.tscn")
var bulletSpacing = -5


func _ready():
	sprite.playing = true
	
	spriteFriend.visible = false
	spriteFriend.playing = true
	

func _physics_process(delta):
	
	handleMovement(delta)
	
	if Input.is_action_pressed("ui_shoot") and !cooldown:
		handleShooting()
	
	if !is_on_floor() && !is_on_wall():
		if trauma < 0.2:
			trauma += 0.03
			camera.trauma = trauma

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
	
	# wall climb
	if is_on_wall() and Input.is_action_pressed("ui_up"):
		vel.y -= climbSpeed
	
	# jump
	if Input.is_action_pressed("ui_up") and is_on_floor():
		vel.y -= jumpForce
		jumpEffect.position.x = position.x - 8
		jumpEffect.position.y = position.y+ 30
		jumpEffect.playing = true
		jumpEffect.visible = true
		trauma = -1.3
		
	
	#sprite direction
	if vel.x < 0:
		sprite.scale.x = -1
		handleAnimation("running")
		spriteFriend.animation = "running"
		playerDirection = "left"
	if vel.x > 0:
		sprite.scale.x = 1
		handleAnimation("running")
		spriteFriend.animation = "running"
		playerDirection = "right"
	if vel.x == 0:
		handleAnimation("idle")
		spriteFriend.animation = "idle"
	
	vel = move_and_slide(vel, Vector2.UP)

func handleAnimation(action):
	if(action == "idle"):
		if(health > 3):
			sprite.animation = "idle"
		elif(health > 1):
			sprite.animation = "idleDMG1"
		else:
			sprite.animation = "idleDMG2"
		
	if(action == "running"):
		if(health > 3):
			sprite.animation = "running"
		elif(health > 1):
			sprite.animation = "runningDMG1"
		else:
			sprite.animation = "runningDMG2"

func showCompanion():
	spriteFriend.visible = true

func handleShooting():
	bulletCooldown.wait_time = 1 / attackSpeed
	bulletCooldown.start()
	cooldown = true
	
	var gameScene = get_parent()
	var newBullet = Bullet.instance()
	newBullet.direction = playerDirection
	bulletSpacing *= -1
	newBullet.position = Vector2(position.x + 10, position.y + bulletSpacing + 20)
	gameScene.add_child(newBullet)

func _on_BulletCooldown_timeout():
	cooldown = false

func takeDamage():
	health -= 1
	camera.trauma = 0.3
	if health == 0:
		queue_free()
	
	sprite.modulate = Color.red
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate = Color.white


func _on_Jump_effect_animation_finished():
	jumpEffect.playing = false
	jumpEffect.visible = false
