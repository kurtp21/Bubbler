extends CharacterBody2D

const SPEED = 500.0
const LIFE = 5

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar

var player_health = LIFE

func _ready() -> void:
	health_bar.value = player_health
	health_bar.max_value = LIFE
	health_bar.visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void: #SPECIFICALLY FOR TESTING
	#player_health -= 1
	#health_bar.value = player_health
	health_bar.value -=1
	$HealthBar.value -= 1
	
	if player_health <= 0:
		_die()

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO # stay in place
	
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
	print("Player Died!")
