extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
  if event.is_action_pressed("toggle_mouse"):
    print("Pressed action")
    _toggle_mouse_mode()
  
func _toggle_mouse_mode():
  if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
  else:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
