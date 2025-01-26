extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _become_host():
	print("You are now the host!")
	%Multiplayer_HUB.hide()
	MutiplayerManager._become_host()

func _join_as_player_2():
	print("Join as Player 2")
	%Multiplayer_HUB.hide()
	MutiplayerManager._join_as_player_2()
