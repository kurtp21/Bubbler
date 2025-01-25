extends CharacterBody2D

const SPEED = 500.0
const LIFE = 5

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar

var player_health = LIFE

func _ready() -> void:
	health_bar.value = 5
	health_bar.max_value = 5
	health_bar.visible = true
	set_process_input(true)
	mouse_entered.connect(_on_mouse_entered)
	
	input_pickable = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
		animated_sprite.play("right_facing")
	elif Input.is_action_pressed("LEFT"):
		facing = dir.left
		direction.x = -SPEED*delta
		$Gun.position = Vector2(-32,-32)
		animated_sprite.play("left_facing")
	elif Input.is_action_pressed("DOWN"):
		facing = dir.down
		direction.y = SPEED*delta
		$Gun.position = Vector2(0,0)
		animated_sprite.play("down_facing")
	elif Input.is_action_pressed("UP"):
		facing = dir.up
		direction.y = -SPEED*delta
		$Gun.position = Vector2(0, -64)
		animated_sprite.play("up_facing")
	
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
	position.y = clamp(viewport.y, player_height, position.y)
	
	#_on_mouse_entered()
	
func _die() -> void:
	print("Player Died!")


func _on_mouse_entered() -> void:
	#player_health -= 1sw
	#health_bar.value = player_healthwwwwwww

	print(1)
	health_bar.value -=1
	$HealthBar.value -= 1
	
	if player_health <= 0:
		_die()
