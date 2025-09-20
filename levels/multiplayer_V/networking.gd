extends Node

var is_server = false
var rng = RandomNumberGenerator.new()

func _ready():
  rng.randomize()  # Seed from time
  print("loading networking code.")
  var args = OS.get_cmdline_args()
  for arg in args:
    if "--server"==arg:
      is_server = true
      print("Loading up as Server")
  var peer = ENetMultiplayerPeer.new()
  if is_server:
    peer.create_server(8080)
    peer.peer_connected.connect(load_player_server)
  else:
    peer.create_client("127.0.0.1",8080)
  multiplayer.multiplayer_peer = peer

func get_network_id():
  return rng.randi();
  
func load_player_server(id : int):
  # Spawning logic will eventually go here, but for now, with
  # just a single player, we can just assign this id to a statically
  # created Player object.
  _assign_player_id.call_deferred(_assign_player_id)
  pass
func _assign_player_id(id: int):
  $Player.player_id = id
  
