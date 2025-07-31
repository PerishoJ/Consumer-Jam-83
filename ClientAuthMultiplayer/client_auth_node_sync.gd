extends MultiplayerSpawner


func _ready():
  if multiplayer.is_server():
    multiplayer.peer_connected.connect(_sync_on_connect)
    multiplayer.peer_disconnected.connect(_deactivate_client_nodes)
  
func _deactivate_client_nodes(id: int):
  pass
  
# When a peer connects, send spawn calls for all
# tracked objects
# TODO
func _sync_on_connect(id : int):
  for child in get_node(spawn_path).get_children():
    pass
  pass

# The multiplayer spawner SHOULD track removals and additions 
