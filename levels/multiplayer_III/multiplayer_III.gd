extends MultiplayerSpawner

@export var playerScene = preload("res://multiplayer_III/multiplayer_character_III.tscn")
@onready var spawnerScene = $Players

func _ready():
  var args = OS.get_cmdline_args()
  for i in range(args.size()):
    var arg = args[i]
    match arg:
      "--server":
        host_game()
        pass
      "--client":
        join_game()
        pass
      "--player-name":
        var name = args[i+1]
        if name:
          GameGlobals.player_name = name
  pass # Replace with function body.

func host_game():
  print("starting server")
  var server = ENetMultiplayerPeer.new()
  server.create_server(8080,8)
  multiplayer.multiplayer_peer = server
  server.peer_connected.connect(_add_player)
  server.peer_disconnected.connect(_rm_player)
  
func join_game():
  var client = ENetMultiplayerPeer.new()
  client.create_client("127.0.0.1",8080)
  multiplayer.multiplayer_peer = client
  

func _add_player(id : int):
  print("adding player "+str(id))
  var new_player: NetCharacterCtrlIII = playerScene.instantiate()
  new_player.peer_id = id;
  print("Adding new player with peer id " + str(id))
  spawnerScene.add_child(new_player)
  # AFTER you add to the scene, or anything you add won't be pushed down.
  # I think the spawn function requires me to make a custom callback
  new_player.set_multiplayer_authority(id) # it's important to make this happen
  pass
 
func _rm_player(id : int):
  print("rm player "+str(id))
  pass 
  
func _process(delta):
  pass


func _on_spawned(node):
  # clients own any nodes named after your peer ID
  if node is NetCharacterCtrlIII:
    var new_player = node as NetCharacterCtrlIII
    print( "Checking new node " + str(new_player.peer_id) + " from " + str(multiplayer.get_unique_id()))
    if new_player.peer_id == multiplayer.get_unique_id():
      new_player.set_multiplayer_authority(multiplayer.get_unique_id())
      new_player.player_name = GameGlobals.player_name # set the players name
  pass # Replace with function body.
