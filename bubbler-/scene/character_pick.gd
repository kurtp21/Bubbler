extends Control

var icon = null:
	set (value):
		icon = value
		$purp.texture_normal = value

signal pressed


func _ready():
	$Sel.hide()
	
	
func _on_purp_pressed() -> void:
	for slot in get_parent().get_children():
		slot.deselect()
	$Sel.show()
	pressed.emit()

func deselect():
	$Sel.hide()
