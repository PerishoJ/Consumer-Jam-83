extends Node
class_name NetworkedInputII

#DEPRECATED

@export var direction := Vector3.ZERO
@onready var camera_pivot = $"../CameraFocus"
# Called when the node enters the scene tree for the first time.
func _ready():
  if multiplayer.is_server():
    set_process(false)
