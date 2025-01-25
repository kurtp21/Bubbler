extends CharacterBody2D


const SPEED = 500.0

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2.ZERO # stay in place
	
	
	if Input.is_action_pressed("RIGHT"):
		direction.x = SPEED
	elif Input.is_action_pressed("LEFT"):
		direction.x = -SPEED
	elif Input.is_action_pressed("DOWN"):
		direction.y = SPEED
	elif Input.is_action_pressed("UP"):
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
	
