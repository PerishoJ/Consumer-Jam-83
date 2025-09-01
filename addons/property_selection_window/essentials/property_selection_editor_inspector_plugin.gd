@tool
extends EditorInspectorPlugin
class_name PropSelEditorInspectorPlugin

# Only handle the custom Property Path class that we've setup
func _can_handle(object):
  return (object is Node)
  
func _parse_begin(object):
  pass
  
# TODO Probably should assign
func _parse_end(object):
  pass

# Keeps track of what object to find properties for
var prop_ref_dict := Dictionary()

# Prefix to look for
const PREFIX := "ref_"

  # Add the Editor Selector for our new Type.
  # It should just be a button to pop-up the menu, and update the values.
func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
  # TODO just collect references to prefixes here
  if name.begins_with(PREFIX):
    var suffix = name.substr(PREFIX.length(), name.length() - PREFIX.length())
    print("found reference for " + suffix)
    # Store a reference: (object, property_name)
    # Because it is the base Node, not the value of the property inside.
    prop_ref_dict[suffix] = {"object": object, "property": name}
    
  if hint_string=="PropertyPath":
    print("Parsing property " + name)
    var property_selector = preload("res://addons/property_selection_window/essentials/property_selection_editor_property.gd").new()
    # Bind the property selector to the Property named with the PREFIX
    # TODO probably should bind at the very end, because otherwise ORDER MATTERS
    # and reference properties that are parsed after this won't be picked up.
    if prop_ref_dict.has(name):
      var ref_obj = prop_ref_dict.get(name)["object"]
      var ref_prop = prop_ref_dict.get(name)["property"]
      property_selector.set_reference_object( ref_obj , ref_prop )
      
    var is_added_to_end = true
    add_property_editor(name, property_selector , is_added_to_end)
    return true
  else:
    return false
  # add a control to select the node
  # add the new control to select the property from that node
  
func _parse_category(object, category):
  pass
  
  
