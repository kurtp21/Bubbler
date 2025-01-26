extends Control




func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/new_game.tscn")
	
	
func _on_how_to_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/how_to.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
