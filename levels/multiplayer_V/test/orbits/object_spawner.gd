extends Node

@export var object_repo : Dictionary [String, PackedScene] = {}
@export var base_container : Node
func _ready():
  if not base_container:
    base_container =  $".."
  if Networking.is_host():
    multiplayer.peer_connected.connect(spawn_player)
  else:
    pass

func spawn_player(id):
  $"../Player".player_id = id
  pass

@rpc("call_local","any_peer","reliable")
func spawn( obj_name:String, props: Dictionary):
  var scene = object_repo.get(obj_name)
  if scene:
    # print("found scene. Adding")
    var new_obj = scene.instantiate()
    base_container.add_child.call_deferred(new_obj)
    # update properties
    for key in props.keys():
      if new_obj.has_method("set_" + str(key)):
        ## Optional: if you have setter methods, use them
        new_obj.call("set_" + str(key), props[key])
      elif new_obj.has_meta(key) or new_obj.has_property(key):
        ## If it's a property, assign directly
        new_obj.set(key, props[key])
      else:
          print("Warning: Property '%s' does not exist on this node." % key)
