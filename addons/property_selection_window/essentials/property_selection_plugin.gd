@tool
extends EditorPlugin

var plugin

func _enter_tree() -> void:
  # this is just inlined below
  plugin = custom_property_selector_plugin.new()
  add_inspector_plugin(plugin)
  print("Adding Property Selector Plugin")
  pass

func _exit_tree() -> void:
  remove_inspector_plugin(plugin)
  pass

## Adds the custom Editor property for new property selector class 
class custom_property_selector_plugin extends EditorInspectorPlugin:
  const ADD_TO_END: bool = true
  func _can_handle(object):
    # Need to reference to the object containing 
    # the property, NOT the property itself, otherwise the NodePaths don't work
    return object is Node
  
  func _parse_property(object, type, path, hint, hint_text, usage, wide):
    if hint_text == "PropertySelectorNode":
      var property_editor = preload("res://addons/property_selection_window/essentials/property_selector_editor.gd").new()
      property_editor.add_root_node(object, path)
      add_property_editor(path, property_editor, ADD_TO_END, "Choose...")
      # TODO you should probably just use a Node. Resources are a PITA...
      return false
    else:
      return false
      
