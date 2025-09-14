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
    # Need to reference to the object containing 
    # the property, NOT the property itself, otherwise the NodePaths don't work
    return object is Node || object is PropertySelectorNode
    
  func _parse_property(object, type, path, hint, hint_text, usage, wide):
    # print ("Parsing " + path + " of object " + str(object))
    if object is Node and path != null and ( hint_text == "PropertySelectorNode" || hint_text.contains("PropertySelectorNode")):
      property_editor_path = path
      print (" Setting path to " + str(path))
    if path == "properties_list" and object is PropertySelectorNode:
      print ("Adding button to " + str(object) + " of path " + str(path))
      var property_editor = preload("res://addons/property_selection_window/essentials/property_selector_editor.gd").new()
      # The target object is not the PropertySelectorNode, that's just a property
      # The target object is the Node that contains the PropertySelectorNode property
      property_editor.set_selector_property(object)
      property_editor.add_root_node(property_editor_root, property_editor_path)
      # But we need to add the editorProperty to each element, so it shows up in Arrays
      add_property_editor(path, property_editor, ADD_TO_END, "Choose...")
      # TODO you should probably just use a Node. Resources are a PITA...
      return false
    else:
      return false
      

  func _parse_begin(object: Object) -> void:
      # Get the list of all properties for this object
      var property_list := object.get_property_list()
      for prop in property_list:
        var name: String = prop.name
        var type: int = prop.type
        var hint: int = prop.hint
        var hint_string: String = prop.hint_string

        # Debug all props if you want
        # print("Property: %s, Type: %d, Hint: %d, HintString: %s" % [name, type, hint, hint_string])
        if hint_string.find("PropertySelectorNode") != -1:
          print("Found PropertySelectorNode property:", name, " (hint:", hint_string, ")")
          property_editor_root = object
  
  func _parse_end(object):
    print(str(object) + " end ")
    pass
