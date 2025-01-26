extends CharacterBody2D

func _enter_tree():
	set_multiplayer_authority(name.to_int())

const SPEED = 500.0

@onready var animated_sprite = $AnimatedSprite2D

var last_loc = Vector2.ZERO

func _ready() -> void:
	$HealthBar.value = 5
	$HealthBar.visible = true
	input_pickable = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void: #SPECIFICALLY FOR TESTING
	$HealthBar.value -= 1
	
	if $HealthBar.value <= 0:
		#_die(position)
		_die()

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		var direction = Vector2.ZERO
		
		
	#var direction = Vector2.ZERO # stay in place
	
	# Apply movement
		if Input.is_action_pressed("RIGHT"):
			animated_sprite.play("right_facing")
			direction.x = SPEED
		elif Input.is_action_pressed("LEFT"):
			animated_sprite.play("left_facing")
			direction.x = -SPEED
		elif Input.is_action_pressed("DOWN"):
			animated_sprite.play("down_facing")
			direction.y = SPEED
		elif Input.is_action_pressed("UP"):
			animated_sprite.play("up_facing")
			direction.y = -SPEED
	
		if direction.length() > 0:
			direction = direction.normalized()
			velocity = direction * SPEED
	move_and_slide()
	
	# Prevent from moing out of bounds
	var viewport = get_viewport_rect().size
	
	var player_width = $CollisionShape2D.shape.get_rect().size.x
	var player_height = $CollisionShape2D.shape.get_rect().size.y
	
	position.x = clamp(position.x, player_width, viewport.x)
	position.y = clamp(viewport.y, player_height, position.y)
	
func _die() -> void:
	print("In die function")
	#last_loc = position
	visible = false
	await get_tree().create_timer(3.0).timeout
	_respawn()

func _respawn() -> void:
	print("Player respawned")
	position = $"../Node2D/Player1_Spawner".global_position
	$HealthBar.value = 5
	visible = true
	
	
