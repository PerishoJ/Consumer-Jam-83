@tool
extends EditorProperty

var select_button: Button
# Root is the Node that HAS the PropertySelector object
var root : Node
# The name of the property in the root object that IS a property selector object
var prop_name : String
func _init():
  select_button = Button.new();
  select_button.text = "Property Menu"
  # Make the button blue, or you just don't notice it
  select_button.modulate = Color(0.63, 0.89, 1.00)
  select_button.pressed.connect(_open_prop_select_window)
  add_child(select_button)
  pass
  
func add_root_node( root , prop_name):
  self.root = root
  print("Setting root to " + str(root))
  self.prop_name = prop_name

func _open_prop_select_window():
  # we should be currently editing the PropertyPath object, whose list SHOULD contain all the properties we just selected
  if(get_edited_object() != null):
    var selector_node :PropertySelectorNode = root.get(prop_name) 
    if not selector_node:
      root.set(prop_name, PropertySelectorNode.new())
      return
    var current_prop_list = selector_node.properties_list
    if(current_prop_list == null):
      current_prop_list = []
    var property_selector = PropertySelectionWindow.new()
    property_selector.create_window(root.get_node_or_null(selector_node.target_path), # Target node
    current_prop_list, # initially selected properties
    false, # show hidden properties
    -1, # filter type
    propertry_selection_callback) # selection callback
  else:
    push_error("Could not find Property Selector Object being edited")
    
func propertry_selection_callback(selected_properties : Array[String]):
  var selector = ( root.get(prop_name)  as PropertySelectorNode)
  selector.properties_list = selected_properties
  emit_changed(get_edited_property(), selector)
  pass
  
func _update_property():
  print("Property Change Detected")
