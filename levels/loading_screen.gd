extends Node2D

@onready var playerNameField = $CanvasLayer/HBoxContainer/VBoxContainer/LineEdit

var game_scene = preload ("res://levels/archive/TemporaryPassed.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func _load_game():
  var player_name = playerNameField.text
  print("loading game for " + player_name)
  GameGlobals.player_name = player_name
  get_tree().change_scene_to_packed(game_scene)
