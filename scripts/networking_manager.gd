extends Node

var SERVER_PORT : int = 8080
var SERVER_IP = "127.0.0.1" # loopback. Localhost
#var WEBSOCKET_URL = "wss://127.0.0.1"

var multiplayer_scene = preload("res://characters/network_character.tscn")
var _player_spawn_scene

var is_ = false;

func host_game():
  #TODO Set this up for Web Sockets
#  This simple stuff ACTUALLY should make a server
  #var server_peer = WebSocketMultiplayerPeer.new();
  var server_peer = ENetMultiplayerPeer.new();
  server_peer.create_server(SERVER_PORT)
  print("now hosting a game")
  multiplayer.multiplayer_peer = server_peer
  # handle game join callback
  multiplayer.peer_connected.connect(_add_player_to_server)
  multiplayer.peer_disconnected.connect(_delete_player)
  # get reference to the spawn node
  # Something about, this needs to happen EVERY game, so this might not even be the right place to put this code...whatever.
  _player_spawn_scene = get_tree().get_current_scene().get_node("Players")
  _add_player_to_server(1)
  
  
  
func join_game():
  var client_peer = ENetMultiplayerPeer.new();
  #var client_peer= WebSocketMultiplayerPeer.new();
  var err: Error = client_peer.create_client(SERVER_IP,SERVER_PORT)
  #var err: Error = client_peer.create_client(WEBSOCKET_URL)
  if err != null and err!=0:
    print(err)
  multiplayer.multiplayer_peer = client_peer


# passes the network id into
func _add_player_to_server(id : int): 
  print("Player %s joined " % id)
  var new_player = multiplayer_scene.instantiate()
  new_player.player_id = id
  new_player.set_name ( str(id) ) # 
  _player_spawn_scene.add_child(new_player)
  
func _delete_player(id :int ):
  print("Player %s has left game" % id)
  var player_name : String = str(id)
  if _player_spawn_scene.has_node(player_name):
    _player_spawn_scene.get_node(player_name).queue_free()
