extends Area3D
class_name NetworkSync

# TODO need a network ID so that we have a place to send these variables back to
# once we've sent them across from server to the client.

## ID of object. Is Persistant across the network
var network_id : int

signal network_update_coarse
signal network_update_fine

@export var synced_vars : PropertySelection
# TODO make FINE and COARSE synced variables lists separately.

@export var course_period_millis : int = 700
var course_update_time : int = 0
@export var fine_period_millis : int = 100
var fine_update_time : int = 0


func _process(delta):
  
  if Time.get_ticks_msec() > course_update_time:
    _course_update()
    course_update_time = Time.get_ticks_msec() + course_period_millis
    
  if Time.get_ticks_msec() > fine_update_time:
    fine_update_time = Time.get_ticks_msec() + fine_period_millis
    _fine_update()
  
  pass
  
  
func _fine_update():
  var prop_updates = {}
  # Each PropertiesSelection object just represents the properties for a single
  # object...so synced_vars needs to be a list of PropertySelection objects.
  
  #TODO make synced_vars a list. Iterate over that list. Have the 'node' as the key, and dict of props as value. 
  #populate the dict w/ props from a single child node 
  for prop in synced_vars.props:
    var val = get_node(synced_vars.node).get(prop)
    prop_updates[prop]= val
  
  # broadcast a dict of props and net_id so listeners know which object it came from.  
  network_update_fine.emit(network_id , prop_updates)
  

func _course_update():
  pass
