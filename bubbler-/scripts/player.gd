extends CharacterBody2D

const SPEED = 500.0

var bullet_scene = preload("res://scenes/bullet.tscn")
var bullets = []
enum dir {right, left, up, down}
var facing = dir.down

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO # stay in place
	
	if Input.is_action_pressed("RIGHT"):
		facing = dir.right
		direction.x = SPEED*delta
		$Gun.position = Vector2(32,-32)
	elif Input.is_action_pressed("LEFT"):
		facing = dir.left
		direction.x = -SPEED*delta
		$Gun.position = Vector2(-32,-32)
	elif Input.is_action_pressed("DOWN"):
		facing = dir.down
		direction.y = SPEED*delta
		$Gun.position = Vector2(0,0)
	elif Input.is_action_pressed("UP"):
		facing = dir.up
		direction.y = -SPEED*delta
		$Gun.position = Vector2(0, -64)
	
	if direction.length() > 0:
		direction = direction.normalized()
		
	velocity = direction * SPEED
	move_and_slide()

	# Fire bullet only once per click
	if Input.is_action_just_pressed("shoot"):
		var boba = bullet_scene.instantiate()
		boba.global_position = $Gun.global_position
		if facing == dir.right:
			boba.global_rotation = deg_to_rad(0)
		elif facing == dir.left:
			boba.rotation = deg_to_rad(180)
		elif facing == dir.up:
			boba.rotation = deg_to_rad(270)
		elif facing == dir.down:  
			boba.rotation = deg_to_rad(90)
		get_parent().add_child(boba)
		bullets.append(boba)

	# Prevent player from moving out of bounds
	var viewport = get_viewport_rect().size
	var player_width = $CollisionShape2D.shape.get_rect().size.x
	var player_height = $CollisionShape2D.shape.get_rect().size.y

	position.x = clamp(position.x, player_width, viewport.x)
	position.y = clamp(position.y, player_height, viewport.y)
