extends Node

@export var player_name : String

# Called when the node enters the scene tree for the first time.
func _ready():
  player_name = "Player_"+str(randi_range(10,99));
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
  #pass
