extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera_pivot = $CameraFocus
@onready var character_mesh = $CharacterMesh

@export var player : AnimationPlayer 
enum animation_state {IDLE, RUN, JUMP}
var anim : animation_state = animation_state.IDLE

func _physics_process(delta):
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta

  # Handle jump.
  if Input.is_action_just_pressed("jump") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var input_dir = Input.get_vector("left", "right", "forward", "backward")
  var direction = (camera_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
    character_mesh.basis = lerp( character_mesh.basis, Basis.looking_at(direction), 10.0 * delta )
    anim = animation_state.RUN
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)
    anim = animation_state.IDLE
  
  if not is_on_floor():
    anim = animation_state.JUMP
    
  move_and_slide()

func _process(delta):
  match anim:
    animation_state.RUN:
      player.play("sprint")
    animation_state.IDLE:
      player.play("idle")
    animation_state.JUMP:
      player.play("jump")
