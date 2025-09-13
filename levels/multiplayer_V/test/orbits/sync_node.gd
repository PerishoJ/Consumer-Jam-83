extends Area3D

@export var properties : PropertySelectorNode
@export var network_id : int

func _ready():
  set_multiplayer_authority(1)
  if not is_multiplayer_authority():
    call_deferred("_disable_node_process")  
    print("Is client. Waiting for info from server")
    # from here, we are basically hijacking the process()
    # method and updating properties here.
  else:
    # is this right? Or should we do some magic at the network to assign and associate this?
    network_id = Networking.get_network_id()
    pass
  
func _disable_node_process():
  get_node(properties.target_path).set_process(false)
