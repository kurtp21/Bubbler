extends Area2D
class_name bullet

enum bullet_type {normal, white, strawberry, egg} # bullet types
@export var pos = global_position
@export var direction = global_position

# Called when the node enters the scene tree for the first time.

const SPEED = 500

func _ready() -> void:
	$Sprite2D.self_modulate.a = 1 # proof of opacity
	#position = pos#get_parent().players[0].position

@rpc("any_peer")
func sync_positions(new_pos: Vector2, new_rotation: float) -> void:
	position = new_pos
	rotation = new_rotation
	
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		pos = position
		direction = Vector2(cos(rotation), sin(rotation))
		position += direction * SPEED * delta
		sync_positions.rpc(position, rotation)

func _on_body_entered(body):
	if !is_multiplayer_authority():
		return
	if body is Player:
		body.take_damage.rpc_id(body.get_multiplayer_authority(), 1)
		remove_bullet.rpc()

@rpc("call_local")
func remove_bullet():
	queue_free()
	#
#func _process(delta: float) -> void:
	#pos = position
	## Calculate movement vector based on rotation
	#direction = Vector2(cos(rotation), sin(rotation))
	#position += direction * SPEED * delta
#
#func _on_body_entered(body): 
	#if !is_multiplayer_authority():
		#return
	#if body is Player:
		#body.take_damage.rpc_id(body.get_multiplayer_authority(), 1)
		#remove_bullet.rpc()
#
#@rpc("call_local")
#func remove_bullet():
	#queue_free()
