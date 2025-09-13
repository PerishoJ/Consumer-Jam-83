extends RigidBody3D
var MAX_SPEED = 2.0
var MIN_SPEED = 0.1
var mv_sp = Networking.rng.randf_range(MIN_SPEED,MAX_SPEED)
@export var cube_materials : Array[Material] = []
var MAX_SIZE = 25.0
var MIN_SIZE = 1.0

func _ready():
  var rnd_material = Networking.rng.randi_range(0,len(cube_materials))
  set_cube_material(cube_materials.get(rnd_material)) # pick rnd material
  var rnd_scale = Networking.rng.randf_range(MIN_SIZE,MAX_SIZE)
  set_overall_scale (rnd_scale)
  
func _process(delta):
  if position.length() > 500:
    queue_free()

func get_props():
  return {
    "overall_scale" :  $CollisionShape3D.scale.x, # only need one dim. All the same. NOT magnitude tho
    "cube_material" : $MeshInstance3D.mesh.material.resource_path, # just need the path of rsc
    "mv_sp" : mv_sp
  }


func set_cube_material(mat):
  $MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate() # because otherwise a chng to one affects EVERYTHING
  if mat is Resource:
    var new_mat = mat.duplicate()
    $MeshInstance3D.mesh.material = new_mat
  elif mat is String :
    var new_mat = load(mat).duplicate()
    $MeshInstance3D.mesh.material_override = mat


func set_overall_scale (scl):
  $CollisionShape3D.scale = scl * Vector3.ONE
  $MeshInstance3D.scale = scl * Vector3.ONE
  
  
func _physics_process(delta):
  var move = Vector3.FORWARD * mv_sp
  move_and_collide(move)
