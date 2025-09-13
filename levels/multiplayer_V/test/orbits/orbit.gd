extends Node3D

@export var rotation_speed: float = 1.0  

## So, synched nodes should just look normal...
## The sync code belongs in the Synchronizer.
func _process(delta: float) -> void:
    # Rotate around the Y axis
    rotate_y(rotation_speed * delta)

func set_planet_distance( distance ):
  $PlanetMesh.position.z = distance
  
func set_planet_scale (scale: float):
  ( $PlanetMesh as MeshInstance3D).scale = Vector3.ONE * scale
