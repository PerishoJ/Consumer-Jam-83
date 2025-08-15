extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


var sleep_time = 60
var cnt = 0
var target : Vector3 = Vector3.ZERO
var speed: float = 5
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  _move_randomly_every_so_often()
  
  
func _move_randomly_every_so_often():
  cnt = (cnt + 1) % sleep_time
  if cnt==0:
    target = Vector3( randf_range(-2,2),randf_range(-2,2),randf_range(-2,2))
  pass

func _physics_process(delta):
  position = position.lerp(target, speed * delta)
