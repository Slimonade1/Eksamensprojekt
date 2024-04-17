extends KinematicBody2D

# stats
var damage = 1
var attackSpeed = 2.0
var health = 5
var trauma = 0.0
var politiker = ""

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
onready var jumpEffect = $"../Jump effect"
onready var camera = $Camera2D
var spriteFriend

# gun cooldown
var cooldown = false
onready var bulletCooldown = $BulletCooldown

# gun physics
onready var tilemap = $"../Background/TileMap"
var Bullet = preload("res://Scenes/Bullet.tscn")
var counter = 0

func _ready():
	sprite.playing = true
	

func _physics_process(delta):
	handleMovement(delta)
	
	if Input.is_action_pressed("ui_shoot") and !cooldown:
		handleShooting()
	
	if !is_on_floor() && !is_on_wall():
		if trauma < 0.2:
			trauma += 0.03
			if trauma > 0:
				camera.trauma = trauma
	
	handlePowerUps()

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
	if is_on_wall() and Input.is_action_pressed("ui_up"):
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
		
	
	#sprite direction and animation
	if is_on_wall():
		handleAnimation("climbing")
		camera.trauma = 0.15
	
	elif !is_on_floor():
		handleAnimation("jumping")
		if vel.x < 0:
			sprite.scale.x = -1
			playerDirection = "left"
		if vel.x > 0:
			sprite.scale.x = 1
			playerDirection = "right"
	
	elif vel.x < 0:
		sprite.scale.x = -1
		handleAnimation("running")
		playerDirection = "left"
	elif vel.x > 0:
		sprite.scale.x = 1
		handleAnimation("running")
		playerDirection = "right"
	
	if vel.x == 0:
		handleAnimation("idle")
	
	vel = move_and_slide(vel, Vector2.UP)
	
	if position.y > 0:
		get_tree().change_scene("res://Scenes/gameScene.tscn")
		Singletons.gameTime = 0

func handleAnimation(action):
	if !spriteFriend == null:
		spriteFriend.animation = "idle"
	if(action == "idle"):
		if(health > 3):
			sprite.animation = "idle"
		elif(health > 1):
			sprite.animation = "idleDMG1"
		else:
			sprite.animation = "idleDMG2"
		
	if(action == "running"):
		if !spriteFriend == null:
			spriteFriend.animation = "running"
		if(health > 3):
			sprite.animation = "running"
		elif(health > 1):
			sprite.animation = "runningDMG1"
		else:
			sprite.animation = "runningDMG2"
		
	
	if(action == "climbing"):
		if !spriteFriend == null:
			spriteFriend.animation = "climbing"
		if(health > 3):
			sprite.animation = "climbing"
		elif(health > 1):
			sprite.animation = "climbingDMG1"
		else:
			sprite.animation = "climbingDMG2"
	
	if(action == "jumping"):
		if !spriteFriend == null:
			spriteFriend.animation = "jumping"
		if(health > 3):
			sprite.animation = "jumping"
		elif(health > 1):
			sprite.animation = "jumpingDMG1"
		else:
			sprite.animation = "jumpingDMG2"

func showCompanion():
	$playerSprite/Niels.hide()
	$playerSprite/Kira.hide()
	$playerSprite/Bergur.hide()
	
	if politiker == "niels":
		spriteFriend = $playerSprite/Niels
	if politiker == "kira":
		spriteFriend = $playerSprite/Kira
	if politiker == "bergur":
		spriteFriend = $playerSprite/Bergur
	
	spriteFriend.visible = true
	

func handleShooting():
	bulletCooldown.wait_time = 1 / attackSpeed
	bulletCooldown.start()
	cooldown = true
	
	#camerashake
	camera.trauma = 0.4
	
	var gameScene = get_parent()
	var spawnPosition
	counter += 1
	if counter%2 == 0:
		spawnPosition = $playerSprite/GunPositionL
	if counter%2 == 1:
		spawnPosition = $playerSprite/GunPositionR
	
	var newBullet = Bullet.instance()
	newBullet.direction = playerDirection
	newBullet.position = spawnPosition.global_position
	gameScene.add_child(newBullet)
	
	$playerSprite/BangAnimation.position = spawnPosition.position
	$playerSprite/BangAnimation.visible = true
	$playerSprite/BangAnimation.playing = true

func _on_BulletCooldown_timeout():
	cooldown = false

func takeDamage():
	health -= 1
	camera.trauma = 0.3
	if health == 0:
		get_tree().change_scene("res://Scenes/gameScene.tscn")
		Singletons.gameTime = 0
	
	sprite.modulate = Color.red
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate = Color.white


func _on_Jump_effect_animation_finished():
	jumpEffect.playing = false
	jumpEffect.visible = false

func handlePowerUps():
	if politiker == "bergur":
		speed = 100
	else:
		speed = 60
	
	if politiker == "niels":
		attackSpeed = 3.0
	else:
		attackSpeed = 2.0
