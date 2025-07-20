extends Node

@onready var player = $"../../"
@export var enabled := true
# Called when the node enters the scene tree for the first time.
func _ready():
  if(enabled):
    if player.player_id == multiplayer.get_unique_id():
      Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    else:
      set_process_input(false)
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
  if(enabled):
    if event.is_action_pressed("toggle_mouse"):
      print("Pressed action")
      _toggle_mouse_mode()
  
func _toggle_mouse_mode():
  if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
  else:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
