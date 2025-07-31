extends CharacterBody3D
class_name NetworkedCharacterType

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = -0.002;
var sprint
var direction := Vector3.ZERO
@onready var camera_pivot = $"CameraFocus"
# Called when the node enters the scene tree for the first time.
@export var auth_peer_id = 1;

# This function should be called by the server
# on instantiation
func network_init(id : int):
  position.x = randf_range(0,7)
  position.z = randf_range(0,7)
  name = str(id)
  print( "Spawning player with id " + str(id))

func _ready():
  print("Character with name "  + name + "spawned in")
  if multiplayer.is_server():
    set_process(false) # Servers don't take in input
  else:
    set_physics_process(false) # Clients don't process movement
  if name == str(multiplayer.get_unique_id()):
    var camera = $CameraFocus/SpringArm3D/Camera3D
    camera.current = true
    
func _physics_process(delta):
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta

  # Handle jump.
  if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)
  move_and_slide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  # because really, authority is kind of broken in godot ATM
  if int(name) == multiplayer.get_unique_id():
    var dir = Input.get_vector("left", "right", "forward", "backward")
    var new_direction = (camera_pivot.basis * Vector3(dir.x, 0, dir.y)).normalized()
    if not is_equal_approx(direction.length(),new_direction.length()):
      send_input.rpc(new_direction)
      #print("direction changed to" + str(direction))
      
  
@rpc("any_peer","unreliable_ordered")
func send_input(input_direction: Vector3):
    direction = input_direction
    print("received direction " + str(input_direction))
