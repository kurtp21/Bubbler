extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var multiplayer_scene = preload("res://scene/multiplayer_player.tscn")

var _players_spawn_node

func _become_host():
	print("You are now the host!")
	
	_players_spawn_node = get_tree().get_current_scene().get_node("Players")
	# Set this up to be a server host
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT) # Start up server at SERVER_POST
	
	# Establish that this instance is a server
	multiplayer.multiplayer_peer = server_peer
	
	# Manage connection of players
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	_remove_single_player()
	_add_player_to_game(1)

func _join_as_player_2():
	print("Join as Player 2")
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	#if result != OK:
		#print("Failed to connect! Error code:", result)
		#return
	
	multiplayer.multiplayer_peer = client_peer
	
	_remove_single_player()
	
	
func _add_player_to_game(id: int):
	print("Player %s joined the game!" % id)
	
	var player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	_players_spawn_node.add_child(player_to_add, true)

func _del_player(id: int):
	print("Player %s left the game!" % id)
	
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()
	
func _remove_single_player():
	print("Remove single player")
	
	var player_to_remove = get_tree().get_current_scene().get_node("Player")
	player_to_remove.queue_free()
