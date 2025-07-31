extends Node

var playerInst = preload("res://characters/multiplayer_character.tscn")
@onready var playerSpawn = $Players


@export var player_name : String
@export var peer_id : int

# Called when the node enters the scene tree for the first time.
func _ready():
  var args = OS.get_cmdline_args()
  for i in range(args.size()):
    match args[i]:
      "--server":
        host()
      "--client":
        player_name = GameGlobals.player_name
        join()
      "--player-name":
        var nm = args[i+1]
        if nm:
          player_name = nm
          GameGlobals.player_name = nm

func host():
  var peer = ENetMultiplayerPeer.new()
  peer.create_server(8080)
  multiplayer.multiplayer_peer = peer
  peer.peer_connected.connect(_add_player)
  peer.peer_disconnected.connect(_remove_player)
  $"../ServerLabel".show()
  
func _add_player(id: int):
  var plyr : NetCharacterCtrl = playerInst.instantiate()
  plyr.name = str(id)
  plyr.peer_id = id
  plyr.set_multiplayer_authority(id) # set auth on server side
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


func _on_multiplayer_spawner_spawned(node):
  if node is NetCharacterCtrl:
    var player = (node as NetCharacterCtrl)
    if (player.name) == str(multiplayer.get_unique_id()): # Does this correspond to the Peer ID, i wonder
      player.set_multiplayer_authority(multiplayer.get_unique_id())
      player.player_name = GameGlobals.player_name
      player.set_physics_process(true)
    else:
      player.set_multiplayer_authority(1) # set default auth to the server
      
    
  pass # Replace with function body.

func _get_player_obj_name(id : int):
  player_name + "_" + str(id)
