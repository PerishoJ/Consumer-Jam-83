@tool
extends EditorProperty
class_name PropSelEditorProperty

var node_btn: Button
var prop_list : ItemList

## detect change during a property update. This actually correlates to the
## literal object that contains the properties we are selecting 
var ref_obj_value;

## Has to do with the weird way that the Editor Inspector plugin references variables
## the ref object is the node that is holding this new PropertyPath object
var ref_object;
## This is the name of the property holding the node which our property path
## object will be finding properties for 
var ref_prop;

## I don't think I'm using this anymore. HMmm
## DEPRECATED
func set_object_and_property(object: Object, property: StringName):
  (object as EditorProperty).property_changed.connect(_update_property)
  pass

# Just added this to check validity often... in this case, whenever something changes
func _handle_prop_chng(property: StringName, value: Variant, field: StringName, changing: bool):
  #var isRefObjectChanged : bool = ( ref_prop !=null and ref_prop == property )
  #if isRefObjectChanged:
    # just error handling to warning users that they're missing the reference var
  print("asdfasfed detected")

# TODO 
# This is just supposed to notify user if the reference property
# wasn't an exported variable.
func _validate_reference_object():
  var missing_var_warning="Missing refence var"
  var missing_var_error="Please export a var of name REF_"+get_edited_property().get_basename() + " in base object for this property path to reference."
  if ref_object == null:
    # This would mean there's an error on initialization, and this wasn't assigned.
    # OR ... maybe this could mean that the initial parsing didn't find a suitable property
    # to bind this to.
    node_btn.text = missing_var_warning
    push_error(missing_var_error)
  if ref_prop == null:
    # not 100% sure how this would happen. Probably just the same way as above
    node_btn.text=missing_var_warning
    error_string(missing_var_error)
    
func _init():
  # Part 1: button that behaves like "pick node"
  node_btn = Button.new()
  node_btn.pressed.connect(_on_node_selected)
  reset_button()
  # add a list that shows all the properties you selected
  prop_list = ItemList.new()
  var vbox = VBoxContainer.new()
  prop_list.select_mode = ItemList.SELECT_MULTI
  prop_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
  prop_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  prop_list.custom_minimum_size = Vector2(0, 100) # give it some default height
  vbox.add_child(node_btn)
  vbox.add_child(prop_list)
  add_child(vbox)


  
# We set a reference, because we might not want to be adjusting
# properties directly on this object. It might be somewhere else
# in the scene.
func set_reference_object(reference_object , reference_property):
  if reference_object != null and reference_object is EditorProperty:
    self.ref_object = reference_object
    (reference_object as EditorProperty).property_changed.connect(_handle_prop_chng)
    # This next bit is just for testing.
  if reference_property !=null:
    self.ref_prop = reference_property
    
  

func _on_node_selected():
  if(ref_object == null || ref_prop ==null):
    # set the label text to red or something
    node_btn.text = "NO REFERENCE"
    pass
    
  # get this literal node we are getting properties for
  var prop_value = _extract_node_from_property(ref_object, ref_prop)
  ref_obj_value = prop_value # used to detect changes
  if prop_value == null:
    node_btn.text = "REF OBJECT UNASSIGNED"
    
  node_btn.text = "...choosing values"
  var property_selector = PropertySelectionWindow.new()
  # we should be currently editing the PropertyPath object, whose list SHOULD contain all the properties we just selected
  var current_prop_list = ( get_edited_object().get(get_edited_property()) as PropertyPath).selected_properties
  if(current_prop_list == null):
    current_prop_list = []
  
  property_selector.create_window(prop_value, # Target node
  current_prop_list, # initially selected properties
  false, # show hidden properties
  -1, # filter type
  propertry_selection_callback) # selection callback
  

  # This bit of code is actually what updates the object we're controlling

func propertry_selection_callback(selected_properties : Array[String]):
  var val = PropertyPath.new()
  val.selected_properties = selected_properties
  emit_changed(get_edited_property(), val)
  # add all the selected items to the list
  clear_list();
  for item in selected_properties:
    prop_list.add_item(item)
  reset_button()
  pass

func reset_button():
  node_btn.text = "Select Properties"

func clear_list():
  prop_list.clear()

### Because the editor inspector gives us an object and the 
### name of the field on that object, we have to figure out
### what that is a reference to.
func _extract_node_from_property( ref_obj, ref_prop ):
  #region
  # This just shows how to use the property that is bound to this thing
  # Had to use this method because using the NodePath selector UI is
  # basically impossible.
  
  # Read the value
  # var value = ref_object.get(target_property)
  
  # Write a value
  #ref_object.set(target_property, new_value)
  #endregion
  
  if ref_prop == null or ref_obj == null: # End early if there isn't a property to set.
    return 
  var prop_value = ref_object.get(ref_prop)
  if prop_value is NodePath:
    return ref_object.get_node(prop_value)
  elif prop_value is Node:
    return prop_value
  else:
    return null
  pass


func _update_property():
  # get the object from the property we are pointing at 
  print("detected change")
  _validate_reference_object()
  var updated = _extract_node_from_property( ref_object, ref_prop )
  if updated != ref_obj_value:
    # something changed
    clear_list()
  ref_obj_value = updated;
  var val = PropertyPath.new()
  emit_changed(get_edited_property(), val)
  pass
