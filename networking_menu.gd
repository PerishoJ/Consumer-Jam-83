extends Control

@onready var menu_scene = $"."
signal host
signal join


var level_scene = preload("res://levels/test_networking.tscn")

func _on_host_btn_pressed():
  print("host pressed...")
  menu_scene.hide()
  emit_signal("host")


func _on_join_btn_pressed():
  menu_scene.hide()
  emit_signal("join")
