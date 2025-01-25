extends Area2D
class_name bullet
enum bullet_type {normal, white, strawberry, egg} # bullet types

const SPEED = 500

func _process(delta: float) -> void:
	# Calculate movement vector based on rotation
	var direction = Vector2(cos(rotation), sin(rotation))
	position += direction * SPEED * delta
