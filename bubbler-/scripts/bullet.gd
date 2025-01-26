extends Area2D
class_name bullet

enum bullet_type {normal, white, strawberry, egg} # bullet types

# Called when the node enters the scene tree for the first time.

const SPEED = 500

func _ready() -> void:
	$Sprite2D.self_modulate.a = 1 # proof of opacity

func _process(delta: float) -> void:
	# Calculate movement vector based on rotation
	var direction = Vector2(cos(rotation), sin(rotation))
	position += direction * SPEED * delta




func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
