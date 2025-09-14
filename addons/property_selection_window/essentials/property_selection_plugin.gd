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
  var property_editor_root
  var property_editor_path
  
  func _can_handle(object):
    return object is Node || object is PropertySelection
    
  func _parse_property(object, type, path, hint, hint_text, usage, wide):
    if _is_property_a_PropertySelection(object, path, hint_text):
      property_editor_path = path
    if path == "properties_list" and object is PropertySelection:
      _add_custom_property_editor(object, path)
      return false
    else:
      return false
      
  func _is_property_a_PropertySelection(object, path, hint_text):
    return object is Node and \
     path != null and \
     ( hint_text == "PropertySelection" || hint_text.contains("PropertySelection"))
      
  ## This is the property editor that has the custom button that fires the selection menu 
  func _add_custom_property_editor(object, path):
    var property_editor = preload("res://addons/property_selection_window/essentials/property_selector_editor.gd").new()
    property_editor.set_selector_property(object)
    property_editor.add_root_node(property_editor_root, property_editor_path)
    add_property_editor(path, property_editor, ADD_TO_END, "Choose...")

  func _parse_begin(object: Object) -> void:
    if(_does_object_contain_a_PropertySelection_property(object)):
      property_editor_root = object
  
  func _does_object_contain_a_PropertySelection_property(object : Object):
    # Get the list of all properties for this object
    var property_list := object.get_property_list()
    for prop in property_list:
      var name: String = prop.name
      var type: int = prop.type
      var hint: int = prop.hint
      var hint_string: String = prop.hint_string
      if hint_string.find("PropertySelection") != -1:
        return true
    return false
    
  func _parse_end(object):
    pass
