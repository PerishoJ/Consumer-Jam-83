extends Node

var is_server = false
var rng = RandomNumberGenerator.new()

func _ready():
  # wait for one frame to be fully processed.
  # otherwise, the scene won't be loaded when networking kicks in
  await get_tree().process_frame
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
  else:
    peer.create_client("127.0.0.1",8080)
  multiplayer.multiplayer_peer = peer

func get_network_id():
  return rng.randi();
  
  
