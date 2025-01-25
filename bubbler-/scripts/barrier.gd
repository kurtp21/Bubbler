extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthBar.value = 2
	$HealthBar.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void: #SPECIFICALLY FOR TESTING
	$HealthBar.value -= 1 # Replace with function body.

func _on_area_entered(area: Area2D) -> void:
	if area is bullet:
		hit(area)

func hit(dam: bullet):
	$HealthBar.value -= 1 #CHange this ti a var when other hullet types are added
