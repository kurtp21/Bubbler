extends Node2D

@export var mute: bool = false

func _ready():
	if not mute:
		play_music()

func play_music():
	if not mute:
		$BGM.play()
		
func play_death() -> void:
	if not mute:
		$Death.play()
		
func end_level() -> void:
	if not mute:
		$BGM.stop()	
