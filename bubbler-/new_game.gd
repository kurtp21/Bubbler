extends Control





func _on_host_pressed() -> void:
	print("New Host")
	
	
func _on_join_pressed() -> void:
	print("Joining game")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/Duplicatemenu.tscn")
