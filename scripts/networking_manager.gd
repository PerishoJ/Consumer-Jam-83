extends Node

var SERVER_PORT : int = 8080
var SERVER_IP = "127.0.0.1" # loopback. Localhost
#var WEBSOCKET_URL = "wss://127.0.0.1"

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

  
func _delete_player(id :int ):
  print("Player %s has left game" % id)
