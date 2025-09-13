extends Node

@onready var sun = $"../sun"
@onready var spawn = $"../ObjectSpawner"

@export var MAX_DELAY_IN_SEC = 0.2 * 1000
@export var boxScene : PackedScene

@export var spawn_location : Node3D

var delay

func _ready():
  _reset_delay()
  pass
  
  
func _process(delta):
  if multiplayer.is_server():
    _spawn_periodically()
  
func _spawn_periodically( ):
  if(Time.get_ticks_msec() > delay): # probably could use one shot timer...alwell
    _reset_delay()
    var new_box : RigidBody3D = boxScene.instantiate()
    if spawn_location:
      new_box.position = spawn_location.position
    else:
      new_box.position = Vector3.ZERO
    
    new_box.position.y = new_box.position.y + randi_range(-4,4)
    $"..".add_child(new_box)
    
    
    
func _reset_delay():
  delay = Networking.rng.randf()*MAX_DELAY_IN_SEC + Time.get_ticks_msec()
