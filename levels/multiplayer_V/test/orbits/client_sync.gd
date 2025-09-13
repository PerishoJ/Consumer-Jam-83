extends Node

@export var player_id : int

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
  

func _pass_to_network_update_queue(networkUpdateData, origin_object):
  # TODO make sure this object has a wrapper with priority
  # TODO calculate priority and assign it based on which object is sending it, etc
  network_heap.insert(networkUpdateData)
  pass

@rpc("call_remote")
func spawn():
  # Make sure we have enough metadata to at least spawn one thing
  pass
  
  
@rpc("call_remote")
func despawn():
  # I don't know if we need this, or if the client can handle garbage collection themselves?
  pass

func _on_area_3d_area_entered(area):
  if multiplayer.is_server():
    if area is NetworkSync:
      # Subscribe to property updates when entering area
      (area as NetworkSync).network_update_coarse.connect(_pass_to_network_update_queue)
    pass
  pass # Replace with function body.
#
func _on_area_3d_area_exited(area):
  if multiplayer.is_server():
    if area is NetworkSync:
      # Stop listening to updates from objects that leave this area
      (area as NetworkSync).network_update_coarse.disconnect(_pass_to_network_update_queue)
  pass # Replace with function body.
