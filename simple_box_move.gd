extends CharacterBody3D

@export var speed = .8
@export var dir_chng_period :float = 1.0
var rand = RandomNumberGenerator.new() 
var dirs = [
  Vector3.FORWARD,
  Vector3.BACK,
  Vector3.UP,
  Vector3.DOWN
]

func _ready():
  if multiplayer.is_server():
    print("")
    # the dir chng logic lives in the server
    var dir_chng_timer :=  Timer.new()
    dir_chng_timer.timeout.connect(_change_directions)
    add_child(dir_chng_timer)
    dir_chng_timer.start(dir_chng_period)

  
func _change_directions():
  if multiplayer.is_server():
    print("changing direction on " + str(get_instance_id()))
    velocity = dirs[rand.randi_range(0, dirs.size()-1)] * speed

func _physics_process(delta: float) -> void:
  move_and_slide()
  
