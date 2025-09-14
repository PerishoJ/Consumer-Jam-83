@tool
extends EditorProperty

var select_button: Button
# Root is the Node that the PropertySelection object
var root : Node
var selector_property : PropertySelection
var target_path : NodePath

func _init():
  select_button = Button.new();
  select_button.text = "Property Menu"
  # Make the button blue, or you just don't notice it
  select_button.modulate = Color(0.63, 0.89, 1.00)
  select_button.pressed.connect(_open_prop_select_window)
  add_child(select_button)

func _ready():
  var inspector := get_parent_control()
  if inspector:
    for n in inspector.get_children():
      if n is EditorProperty and n.label == "Node":
        (n as EditorProperty).property_changed.connect(_on_property_edited)
 
func _on_property_edited(property: StringName, value: Variant, field: StringName, changing: bool):
  if target_path != value:
    target_path = value
    selector_property.props = []
    
func add_root_node( root ):
  self.root = root

## This is the property list held by the PropertySelection.
## This is the datastructure that the menu will put it's values into.
func set_selector_property( selector : PropertySelection):
  selector_property = selector
  target_path = selector.node
  
func _open_prop_select_window():
  # we should be currently editing the PropertyPath object, whose list SHOULD contain all the properties we just selected
  if(get_edited_object() != null):
    var current_prop_list = selector_property.props
    if(current_prop_list == null):
      current_prop_list = []
    var selection_window = PropertySelectionWindow.new()
    if selection_window == null:
      printerr("PropertySelection property is null.")
      return
    var target_node = root.get_node_or_null(selector_property.node)
    selection_window.create_window(target_node, # Target node
    current_prop_list, # initially selected properties
    false, # show hidden properties
    -1, # filter type
    propertry_selection_callback) # selection callback
  else:
    push_error("Could not find Property Selector Object being edited")
    
func propertry_selection_callback(selected_properties : Array[String]):
  selector_property.props = selected_properties
  emit_changed(get_edited_property(), selector_property)
  pass
  
