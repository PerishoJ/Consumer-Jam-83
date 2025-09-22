extends Node3D

@export var speed = Vector3.FORWARD * .8

func _physics_process(delta: float) -> void:
  position = position + speed
  
