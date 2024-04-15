extends KinematicBody2D

#stats
export var speed = 200
var jumpForce = 800
var gravity = 2000
var health = 3

var vel = Vector2()
var turn = false

var enemyDirection = "right"
onready var sprite = $EnemySprite
onready var player = $"../../Player"
onready var edgeDetection = $EdgeDetection
onready var playerDetection = $PlayerDetection

var cooldown = false
onready var bulletCooldown = $BulletCooldown
var attackSpeed = 1.0
var Bullet = preload("res://Scenes/Bullet.tscn")

func _ready():
	sprite.playing = true

func _physics_process(delta):
	# Dynamic edge detection
	if !edgeDetection.is_colliding() or is_on_wall():
		turnAround()
	
	# If enemy sees player, and is not blocked by a wall
	if(playerDetection.is_colliding() and !playerDetection.get_collider().is_in_group("Map") and !cooldown):
		handleShooting()
	
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
		enemyDirection = "left"
		playerDetection.scale.x = -1
		
	if vel.x > 0:
		sprite.flip_h = false
		enemyDirection = "right"
		playerDetection.scale.x = 1

func turnAround():
	turn = true
	if turn:
		speed *= -1
		turn = false

func takeDamage():
	health -= player.damage
	if health == 0:
		queue_free()
	
	if player.currentPowerUp == "kira":
		if player.health < 5:
			player.health += 1
	
	sprite.modulate = Color.red
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate = Color.white
	

func handleShooting():
	bulletCooldown.wait_time = 1 / attackSpeed
	bulletCooldown.start()
	cooldown = true
	
	var gameScene = get_parent()
	var newBullet = Bullet.instance()
	newBullet.collision_mask = 1
	newBullet.direction = enemyDirection
	newBullet.position = position
	gameScene.add_child(newBullet)

func _on_BulletCooldown_timeout():
	cooldown = false
