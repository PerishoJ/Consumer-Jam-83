extends Node2D



func _on_host_btn_pressed():
  NetworkingManager.host_game()
  pass # Replace with function body.


func _on_join_btn_pressed():
  print("trying to join...")
  NetworkingManager.join_game()
  pass # Replace with function body.
