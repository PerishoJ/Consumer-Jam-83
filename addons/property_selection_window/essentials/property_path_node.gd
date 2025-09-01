@icon("res://addons/property_selection_window/essentials/icon.png")
extends Resource
class_name PropertyPath

@export var selected_properties: Array[String]

# Handle selections
func _on_properties_selected(selected_properties: Array[String]):
    # What was I doing?
    print("Selected:", selected_properties)
