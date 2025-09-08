extends Node

## This is the parent node for the character. It controls absolute position in the game world
@export var main_node: NetworkCharacterV

## This controls the mesh instance. Mostly, it is concerned with the direction the player is facing
## This is a less important node, and can be synced less often.
@export var mesh_instance: Node3D

@export var REF_test_prop : NodePath

@export var test_prop : PropertySelectorNode

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

#TODO LEFT OFF TUESDAY: Nothing really works anymore. Spawning broke for some reason
# I think these rpc's will fire, i just need to tweak them a little.
# ~ Maybe it would be better to have a server authoritative model, and have two
#  instances of everything: A visible, approximate version of the object. A facade.
# And a backed version. NOTE: maybe start another FACADE based server project next
# to see if that is an easier thing to develop with.

# Called every frame. 'delta' is the elapsed time since the previous frame.
var round_robin_index = 0;
var update_cadence = 4
var update_index = 0

# for slerping rotation and position
var rot_speed = 5.0
func _process(delta):
  if(is_multiplayer_authority()):
    # update the server ever "update_cadence" frames
    update_index = ( update_index + 1 ) % update_cadence 
    if update_index == 0:
      send_loc_rot.rpc_id(1, main_node.position, mesh_instance.global_transform.basis.get_rotation_quaternion())
  elif(multiplayer.is_server()):
    var player_to_update = multiplayer.get_peers()[round_robin_index]
    if is_peer_the_server(player_to_update):
      inc_round_robin(); # the server can't actually call this function on itself, but let's save it the check
      player_to_update = multiplayer.get_peers()[round_robin_index]
    if player_to_update == get_multiplayer_authority():
      inc_round_robin(); # don't update the auth client
      player_to_update = multiplayer.get_peers()[round_robin_index]
    inc_round_robin()
    # Just update one player per turn
    broadcast_loc_rot.rpc_id(player_to_update ,main_node.global_transform.origin, mesh_instance.global_transform.basis.get_rotation_quaternion())
    # Update the rotation of the mesh instance
    #var current_rot = mesh_instance.basis.get_rotation_quaternion()
    #var new_rot = current_rot.slerp(target_rot, rot_speed * delta)
#
    #var new_basis = Basis(new_rot)
    #mesh_instance.global_transform.basis = new_basis
 


func is_peer_the_server(peerId):
  return peerId == 1
func inc_round_robin():
  round_robin_index = ( round_robin_index + 1 ) % multiplayer.get_peers().size();

@rpc("unreliable","authority","call_remote")
func send_loc_rot(position: Vector3,rotation: Quaternion):
  if position != main_node.global_position:
    main_node.global_transform.origin = position
  if mesh_instance.global_basis.get_rotation_quaternion() != rotation:
    mesh_instance.global_transform.basis = Basis(rotation)

#var target_rot

@rpc("unreliable","any_peer","call_remote")
func broadcast_loc_rot(location: Vector3 , rotation: Quaternion):
  main_node.network_update_location( location )
  #TODO update rotation, too, except on the mesh instance.
  #mesh_instance.global_transform.basis = Basis(rotation)
  
  
