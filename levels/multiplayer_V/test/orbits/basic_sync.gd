extends Node

@export var properties : PropertySelectorNode


func _ready():
  set_multiplayer_authority(1)
  if not is_multiplayer_authority():
    get_node(properties.target_path).set_process(false)
    print("Is client. Waiting for info from server")
