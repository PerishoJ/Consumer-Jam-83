extends Area3D
class_name NetworkSync

## handles network id of scene, listing properties persisted over the network
## and serializing, deserializing them

## Network ID Scene. Persistant across the network
var network_id : int

@export var synced_vars : Array[PropertySelection]
  
  
func get_update():
  var scene_updates = {}
  # go through each tracked node
  for selection in synced_vars:
    # Get the properties and values for each node
    var prop_updates = {}
    for prop in selection.props:
      var val = get_node(selection.node).get(prop)
      prop_updates[prop]= val
    scene_updates[selection.node] = prop_updates
  return scene_updates
  
# TODO test this...maybe make a mirror scene. One object is controlled, the other just mirrors
func apply_update(scene_updates : Dictionary):
  for update_node_path in scene_updates.keys():
    # Get the properties that belong to this node
    var update_properties = scene_updates[update_node_path] as Dictionary
    # Get the actual node from the node path
    var update_node = get_node(update_node_path)
    # Update each property with it's value
    for prop_name in update_properties.keys():
      var prop_value = update_properties[prop_name]
      update_node[prop_name] = prop_value
