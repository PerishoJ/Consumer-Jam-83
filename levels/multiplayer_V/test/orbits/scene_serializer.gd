extends Node
class_name RegistrySerializer
## Every networked scene must be registered here,
## otherwise, it can't be serialized correctly.


@export var registry :Array[PackedScene] = []
var deser_regisitery : Dictionary[int , PackedScene]

func _ready():
  # Assign each 
  for scene:PackedScene in registry :
    var scene_hash = deterministic_hash ( scene.resource_path )
    deser_regisitery[scene_hash] = scene
    
func serialize(scene : Node):
  return deterministic_hash(scene.scene_file_path)
  
func deserialize( scene_hash : int) -> PackedScene:
  return deser_regisitery[scene_hash]
  
## the Godot hash() algo is only deterministic within the
## same machine. Across a network, on multiple machines, it
## losses that guarentee.
## Need a deterministic algorithm to generate consistent hashes
## across all machines
func deterministic_hash(input: String) -> int:
    var ctx = HashingContext.new()
    ctx.start(HashingContext.HASH_MD5)  # MD5, fast and good enough for this
    ctx.update(input.to_utf8_buffer())
    var hash_bytes = ctx.finish()
    # Take first 8 bytes as 64-bit int
    var result: int = 0
    for i in range(8):
        result = (result << 8) | int(hash_bytes[i])
    return result
