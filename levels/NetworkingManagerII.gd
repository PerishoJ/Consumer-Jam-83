extends Node

var playerInst = preload("res://characters/multiplayer_test.tscn")
@onready var playerSpawn = $"../Players"
# Called when the node enters the scene tree for the first time.
func _ready():
  var args = OS.get_cmdline_args()
  for arg in args:
    match arg:
      "--server":
        host()
        
      "--client":
        join()

func host():
  var peer = ENetMultiplayerPeer.new()
  peer.create_server(8080)
  multiplayer.multiplayer_peer = peer
  peer.peer_connected.connect(_add_player)
  peer.peer_disconnected.connect(_remove_player)
  $"../ServerLabel".show()
  
func _add_player(id: int):
  var plyr : NetworkedCharacterType = playerInst.instantiate()
  plyr.network_init(id)
  playerSpawn.add_child(plyr);
  print("Adding player "+str(id))
  
  
func _remove_player(id: int):
  var player_id = str(id)
  if playerSpawn.has_node(player_id):
    playerSpawn.get_node(player_id).queue_free()
  print("rem plyr " + str(id))
  
func join():
  var peer = ENetMultiplayerPeer.new()
  peer.create_client("127.0.0.1",8080)
  multiplayer.multiplayer_peer = peer
