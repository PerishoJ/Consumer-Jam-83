extends MultiplayerSynchronizer
class_name  MultiplayerInput

var input_direction

@onready var camera_pivot = $"../CameraFocus"

# Called when the node enters the scene tree for the first time.
func _ready():
  _get_directions()
  if is_multiplayer_authority():
    set_process(false)
    set_physics_process(false)
    

func _physics_process(delta):
  _get_directions()
  
func _get_directions():
  var dir = Input.get_vector("left", "right", "forward", "backward")
  input_direction = (camera_pivot.basis * Vector3(dir.x, 0, dir.y)).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
  
