extends Node

@export var node_path: NodePath
@export var property: String

# Handle selections
func _on_properties_selected(selected_properties: Array[String]):
    print("Selected:", selected_properties)

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
