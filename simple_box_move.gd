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
  if Networking.is_host():
    # the dir chng logic lives in the server
    var dir_chng_timer :=  Timer.new()
    dir_chng_timer.timeout.connect(_change_directions)
    add_child(dir_chng_timer)
    dir_chng_timer.start(dir_chng_period)
  else:
    set_physics_process(false)

    
  
func _change_directions():
  if Networking.is_host():
    velocity = dirs[rand.randi_range(0, dirs.size()-1)] * speed

func _physics_process(_delta):
  move_and_slide()
  
