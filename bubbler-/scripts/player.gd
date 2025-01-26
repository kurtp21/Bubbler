class_name Player
extends CharacterBody2D

const SPEED = 500.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var game: Game = get_parent()

var last_loc = Vector2.ZERO

func _enter_tree():
	set_multiplayer_authority(int(str(name)))

func _ready() -> void:
	$HealthBar.value = 5
	$HealthBar.visible = true
	input_pickable = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var bullet_scene = preload("res://scenes/bullet.tscn")
var bullets = []
enum dir {right, left, up, down}
var facing = dir.down

func _on_mouse_entered() -> void: #SPECIFICALLY FOR TESTING
	$HealthBar.value -= 1
	
	if $HealthBar.value <= 0:
		#_die(position)
		_die()


func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	var direction = Vector2.ZERO # stay in place
	
	
	if Input.is_action_pressed("RIGHT"):
		facing = dir.right
		direction.x = SPEED*delta
		$Gun.position = Vector2(35,-32)
		animated_sprite.play("right_facing")
	elif Input.is_action_pressed("LEFT"):
		facing = dir.left
		direction.x = -SPEED*delta
		$Gun.position = Vector2(-35,-32)
		animated_sprite.play("left_facing")
	elif Input.is_action_pressed("DOWN"):
		facing = dir.down
		direction.y = SPEED*delta
		$Gun.position = Vector2(0,10)
		animated_sprite.play("down_facing")
	elif Input.is_action_pressed("UP"):
		facing = dir.up
		direction.y = -SPEED*delta
		$Gun.position = Vector2(0, -69)
		animated_sprite.play("up_facing")
	
	if direction.length() > 0:
		direction = direction.normalized()
		
	velocity = direction * SPEED
	move_and_slide()

	# Fire bullet only once per click
	if Input.is_action_just_pressed("shoot"):
		shoot.rpc(multiplayer.get_unique_id())

	# Prevent player from moving out of bounds
	var viewport = get_viewport_rect().size
	var player_width = $CollisionShape2D.shape.get_rect().size.x
	var player_height = $CollisionShape2D.shape.get_rect().size.y

	position.x = clamp(position.x, player_width, viewport.x)
	position.y = clamp(position.y, player_height, viewport.y)
	position.y = clamp(viewport.y, player_height, position.y)
	
	#_on_mouse_entered()
	
func _die() -> void:
	print("In die function")
	#last_loc = position
	visible = false
	$Respawn.start()

func _respawn() -> void:
	print("Player respawned")
	position = last_loc # $"../Node2D/Player1_Spawner".global_position
	$HealthBar.value = 5
	visible = true
	
@rpc("any_peer")
func take_damage(amount):
	$HealthBar.value -= amount
	if $HealthBar.value <= 0:
		#_die(position)
		_die()

func _on_respawn_timeout() -> void:
	_respawn()
	$Respawn.stop()
	$Respawn.wait_time = 3

@rpc("call_local")
func shoot(shooter_pid):
	var boba = bullet_scene.instantiate()
	boba.set_multiplayer_authority(shooter_pid)
	get_parent().add_child(boba)
	#boba.transform = $Gun.global_transform
	boba.global_position = $Gun.global_position
	if facing == dir.right:
		boba.global_rotation = deg_to_rad(0)
	elif facing == dir.left:
		boba.rotation = deg_to_rad(180)
	elif facing == dir.up:
		boba.rotation = deg_to_rad(270)
	elif facing == dir.down:  
		boba.rotation = deg_to_rad(90)
	
	bullets.append(boba)
