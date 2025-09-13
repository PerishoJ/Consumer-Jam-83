extends Area3D
class_name NetworkSync

signal network_update_coarse
signal network_update_fine

@export var synced_vars : PropertySelectorNode

func _process(delta):
  # TODO publish some network updates here!
  pass
