extends Node3D

@export var MOUSE_SENSITIVITY = -0.002;
@onready var spring_arm = $SpringArm3D
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
  
func _input(event):
  if event is InputEventMouseMotion:
    rotate_y ( event.relative.x * MOUSE_SENSITIVITY) # rotate left/right
    spring_arm.rotate_x ( clampf( event.relative.y * MOUSE_SENSITIVITY , -0.7 , 0.7) ) # rotate up/down

func add_camera( cam : Camera3D ):
  spring_arm.add_child(cam)
