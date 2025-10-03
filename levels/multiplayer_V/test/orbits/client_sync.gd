extends Node3D

@export var player_id : int

const MAX_PAYLOAD_BYTES = 1200 # Normal HTTP is 1500, but headers eat up some. This is good enough approx.
# How...do we get this?
@export var serializer : RegistrySerializer
## Keeps track of all the properties to send down the line,
## in order of priority, so that clients get what they are 
## most interested in...mostly
var network_heap : MinHeap = MinHeap.new()
## Server side only
var server_tracked_synchronizers : Array[NetworkSync] = []
## Client side only
var client_tracked_objects : Dictionary[int , Node] = {}

@export var max_refresh_ticks = 8
var next_update_time: = 0

func _process(_delta):
  if _should_send_update():      
    _reset_update_timer()
    var update_chunk = _chunk_updates()
    if not update_chunk.is_empty():
      send_updates.rpc_id(player_id, update_chunk)

## how do i pass enough information to find it again?
func _chunk_updates() -> Array:
  # Update the priority of each tracked object based on distance, direction, etc.
  for sync in server_tracked_synchronizers:
    sync.update_priority(global_position, _get_camera_direction())
  # sort on update priority
  server_tracked_synchronizers.sort_custom(func(a,b): return a.get_update_priority() < b.get_update_priority())
  # Create a chunk
  var update_packet = []
  # just meant to check for packet size checking
  var update_total_bytes = 0 
  for sync in server_tracked_synchronizers:
    # NetworkUpdateChunk -> simple custom data holder at bottom of this class... should we just use a dict?
    var chunk = {}
    chunk["id"] = sync.network_id
    chunk["payload"] = sync.create_update()
    # Check the size the payload WOULD be if we added this chunk
    update_total_bytes += var_to_bytes(chunk).size()
    if(update_total_bytes < MAX_PAYLOAD_BYTES):
      update_packet.append(chunk)
      sync.refresh() # signal that this sync property was recently updated
    else:
      break # It's too big. We're done. Stop packing
  return update_packet
  
func _get_camera_direction():
  # In Godot, a camera’s forward vector is the negative Z axis of its basis
  var camera_forward = -($Camera).global_transform.basis.z.normalized()
  return camera_forward
  
  
@rpc("call_remote","unreliable_ordered")
func send_updates(update : Array):
  for chunk in update:
    if client_tracked_objects.has(chunk["id"]):
      var tracked_obj = client_tracked_objects[chunk["id"]] as NetworkSync
      tracked_obj.apply_update(chunk["payload"])
  pass

func _should_send_update():
  return Networking.is_host() and Time.get_ticks_msec() > next_update_time 

func _reset_update_timer():
  next_update_time = Time.get_ticks_msec() + max_refresh_ticks
  

@rpc("call_remote","reliable")
func spawn(serialized_scene_id : int, network_id : int, location : Vector3):
  # deserialize which object to spawn, and spawn it
  var scene = serializer.deserialize(serialized_scene_id)
  var new_object = scene.instantiate()
  # add it to the scene
  (new_object as Node3D).position = location
  _get_scene_root().add_child(new_object)
  # start tracking it by its network id
  var net_sync = new_object.find_child("NetworkSync") as NetworkSync # TODO type check this better
  client_tracked_objects[network_id] = net_sync
  net_sync.network_id = network_id
  pass
  
## Need a more reliable way to get the place to add scenes into
func _get_scene_root()->Node:
  return get_parent()
  
@rpc("call_remote","reliable")
func despawn(network_id : int ):
  # the object has moved out of interest
  # remove it
  var rm_obj = client_tracked_objects[network_id].get_parent()
  rm_obj.queue_free()
  # and stop tracking updates from it
  client_tracked_objects.erase(network_id)
  pass

func _on_area_entered(sync_node):
  if multiplayer.is_server():
    if sync_node is NetworkSync:
      # Subscribe to property updates when entering area
      # Get what type of object this is, and spawn it on the client
      var obj = sync_node.get_parent_node_3d()
      var ser_id = serializer.serialize(obj)
      # The network id is what allows us to trace this object
      # It's needed to tie sync commands to objects on the receiving side 
      var network_id = sync_node.network_id;
      spawn.rpc_id(player_id , ser_id, network_id , obj.position)
      # Start tracking this network objects properties    
      server_tracked_synchronizers.push_back(sync_node)
      pass   
    pass
  pass # Replace with function body.

func _on_area_exited(sync_node: Area3D) -> void:
  if multiplayer.is_server():
    if sync_node is NetworkSync:
      _untrack_network_sync(sync_node)
      despawn.rpc_id(player_id ,sync_node.network_id)
  else: # CLIENT
    pass
  pass
  
## Pop and drop from array.
func _untrack_network_sync( sync ):
  var i = server_tracked_synchronizers.find(sync)
  if i > -1 : # did it find ?
    # to delete, find the object, replace it with the back, and pop the back, 
    # that way the entire array doesn't have to be rewritten everytime something gets erased.
    var back = server_tracked_synchronizers.back()
    server_tracked_synchronizers[i] = back
    server_tracked_synchronizers.pop_back()
    pass
  pass
