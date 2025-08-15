extends Node

@export var tracked_scenes : Dictionary [String, PackedScene]
@export var spawn_location : Array [Node3D] 
var _is_server = false
# Called when the node enters the scene tree for the first time.
func _ready():
  _parse_game_args()
  _create_multiplayer_peer()
  _connect_callbacks()
  _debugging()

func _parse_game_args():
  var args = OS.get_cmdline_args()
  for i in range(args.size()):
    match(args[i]):
      "--server":
        _is_server = true

func _create_multiplayer_peer():  
  var peer = ENetMultiplayerPeer.new()
  if _is_server:
    var result = peer.create_server(8080)
    if result == OK:
      print("Setting up Server")
    else:
      print("FAILED SETTING UP SERVER")
  else:
    _sim_delay()
    print("Setting up Client")
    var result = peer.create_client(_get_server_address(),8080)
    if result == OK:
      print("Setting up Client")
    else:
      print("FAILED SETTING UP CLIENT")
  multiplayer.multiplayer_peer=peer
  set_multiplayer_authority(1) # server owns the Multiplayer node

func _get_server_address():
  return "127.0.0.1"

## Simulates the delay that clients will always join
## later than the server...usually much later.
func _sim_delay():
  await get_tree().create_timer(randf_range(0.5, 6.0)).timeout
  print("Timer done!")

func _connect_callbacks():
  if _is_server:
    # Setup logic to add new players to the game
    multiplayer.peer_connected.connect(_connect_new_player)
    multiplayer.peer_disconnected.connect(_rm_player)
  else:
    # Setup logic to get caught up with the game state
    multiplayer.peer_connected.connect(_update_game_state)

## The request sent by clients, exec by server
## Returns each player and their position
## id - the id of the client to return the data to
@rpc("any_peer","call_remote","reliable")
func _request_other_player_data(client_id : int):
  # I probably ought to return them all in one call...alwell. Later improvement.
  for player in get_children():
     _player_data_response.rpc_id(client_id , player.name , player.position )

## The response sent by server, exec by clients
@rpc("any_peer","call_remote","reliable")
func _player_data_response(other_player: String , player_position:Vector3):  
  var child = get_node_or_null(other_player)
  if child:
    print("yay, no need to re-add this player")
  else:
    _create_player_by_name(other_player, player_position)
  pass
  
func _update_game_state(current_client_id : int):
  rpc_id(1 ,"_request_other_player_data",current_client_id)
  #_request_other_player_data.rpc_id(1, id)
  pass

func _connect_new_player(id: int):
  print("connecting new player " + _player_name(id))
  # ALL PEERS -> create new player
  # Classic rpc way of calling
  #rpc("create_player",id,_get_player_location(id))
  create_player.rpc(id,_get_player_location(id))
  pass
  
func _dc_player(id : int):
  # TODO need to broadcast DC's to clients...or they' 
  print("disconnecing new player " + _player_name(id))
  _rm_player(id).rpc()

@rpc("call_local","reliable")
func create_player(id: int , spawn_position:Vector3 ):
  _create_player_by_name(_player_name(id), spawn_position)
  pass
  
func _create_player_by_name(player_name : String , spawn_position: Vector3):
  print("instantiating new player " + player_name + " at " + str(spawn_position))
  if tracked_scenes.has("player"):
    var player = tracked_scenes.get("player").instantiate()
    player.position = spawn_position
    player.name = player_name # TODO extract ID from name
    add_child(player)
    _set_player_network_auth(player)
    
func _set_player_network_auth(player):
    var player_peer_id = _get_id_from_player_name(player.name)
    if multiplayer.is_server():
      # This is a client authoritative model
      # clients control their character
      player.set_multiplayer_authority(player_peer_id)
    else:
      # However, according to the clients, the server
      # controls everything EXCEPT their own player.
      # In reality, the server is just relaying the 
      # info from each peer to each other.
      if player_peer_id == multiplayer.get_unique_id():
        player.set_multiplayer_authority(multiplayer.get_unique_id())
      else:
        player.set_multiplayer_authority(1)
    
func _get_player_location(id : int):
  # pick a rnd loc from spawn location list
  return spawn_location[id % spawn_location.size()].position

@rpc("call_local","reliable")
func _rm_player(id : int):
  find_child(_player_name(id)).queue_free()
  pass

func _player_name(id : int):
  return str(id)

func _get_id_from_player_name(player_name:String):
  return int(player_name)

#host

#client

#add player - rem logic for late joiners

#rm player

# RPC - instantiate scenes

# RPC - get scenes list from server

# RPC - pass scenes list to client

# RPC - update data of a scene so it doesn't spawn in the wrong state/place

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
  #pass
func _debugging():
  if _is_server:
    $"../ServerLabel".show()
