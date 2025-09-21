extends Area3D
class_name NetworkSync

## handles network id of scene, listing properties persisted over the network
## and serializing, deserializing them

## Network ID Scene. Persistant across the network
var network_id : int

@export var synced_vars : Array[PropertySelection]
  
# TODO test this...maybe make a mirror scene. One object is controlled, the other just mirrors  

## An update is composed of a 2 level Dictionary
## { NodePath : { PropertyName : PropertyValue } }
## So, a list of all the affected nodes, and each contains a 
## map of their properties to values (Basically a simplified scene tree)
func create_update() -> Dictionary[NodePath , Dictionary]:
  var scene_updates = {}
  # go through each tracked node
  for selection in synced_vars:
    # Get the properties and values for each node
    var prop_updates = {}
    for prop in selection.props:
      # Store all the values of all the properties
      var val = get_node(selection.node).get(prop)
      prop_updates[prop]= val
    # Associate those properties back to the nodepath it belongs to
    scene_updates[selection.node] = prop_updates
  return scene_updates
  
## Apply updates created with create_update() method
func apply_update(scene_updates : Dictionary[NodePath,Dictionary]):
  for update_node_path in scene_updates.keys():
    # Get the properties that belong to this node
    var update_properties = scene_updates[update_node_path] as Dictionary
    # Get the actual node from the node path
    var update_node = get_node(update_node_path)
    # Update each property with it's value
    for prop_name in update_properties.keys():
      var prop_value = update_properties[prop_name]
      update_node[prop_name] = prop_value
