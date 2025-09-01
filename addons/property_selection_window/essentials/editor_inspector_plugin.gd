@tool
extends EditorInspectorPlugin
# Only handle the custom Property Path class that we've setup

# Keeps track of what object to find properties for
var prop_ref_dict := Dictionary()

# Prefix to look for
const PREFIX := "ref_"

func _can_handle(object):
  return (object is Node)
  
func _parse_begin(object):
  # Each object will only reference itself. No cross-talk
  prop_ref_dict.clear()
  pass
  
# TODO Probably should assign
func _parse_end(object):
  
  #TODO collect all the property names here
  # ONLY arrays of PropertySelector objects need to
  # search for a reference node to piggyback off of.
  # Make those associations here, and update those GUIs
  pass



  # Add the Editor Selector for our new Type.
  # It should just be a button to pop-up the menu, and update the values.
func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):

  if hint_string=="PropertyPath":
    var property_selector = preload("res://addons/property_selection_window/essentials/property_selection_editor_property.gd").new()
    var is_added_to_end = true
    add_property_editor(name, property_selector , is_added_to_end)
  return false
  # add a control to select the node
  # add the new control to select the property from that node
  
