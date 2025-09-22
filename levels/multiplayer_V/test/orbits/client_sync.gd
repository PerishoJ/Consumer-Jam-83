extends Node

@export var player_id : int
# How...do we get this?
@export var serializer : RegistrySerializer
## Keeps track of all the properties to send down the line,
## in order of priority, so that clients get what they are 
## most interested in...mostly
var network_heap : MinHeap = MinHeap.new()

## how do i pass enough information to find it again?
func update(node, network_id ,property, value , priority):
  pass


@rpc("call_remote")
func send_updates(properties : Array):
  # TODO keep popping off the heap until package is full, or (will be),
  # then finally send it out.
  pass
  

func _pass_to_network_update_queue(origin_obj_network_id, networkUpdateData):
  # TODO make sure this object has a wrapper with priority
  # TODO calculate priority and assign it based on which object is sending it, etc
  # TODO make sure origin object is indexed
  network_heap.insert(networkUpdateData)
  pass

@rpc("call_remote")
func spawn(serialized_scene_id : int, location : Vector3):
  print("Spawning node")
  var scene = serializer.deserialize(serialized_scene_id)
  var new_object = scene.instantiate()
  (new_object as Node3D).position = location
  _get_scene_root().add_child(new_object)
  pass
  
## Need a more reliable way to get the place to add scenes into
func _get_scene_root()->Node:
  return get_parent()
  
@rpc("call_remote")
func despawn():
  # I don't know if we need this, or if the client can handle garbage collection themselves?
  pass

func _on_area_entered(area):
  print("area entered")
  if multiplayer.is_server():
    if area is NetworkSync:
      # Subscribe to property updates when entering area
      # TODO add the NetworkSync to a heap of objects to update
      # Get what type of object this is, and spawn it on the client
      var obj = area.get_parent_node_3d()
      var ser_id = serializer.serialize(obj)
      print('sending sync command to client ')
      spawn.rpc_id(player_id , ser_id, obj.position)
      pass   
    pass
  pass # Replace with function body.

func _on_area_exited(area: Area3D) -> void:
  if multiplayer.is_server():
    if area is NetworkSync:
      ## TODO remove this from the network update heap
      pass
  pass # Replace with function body.
