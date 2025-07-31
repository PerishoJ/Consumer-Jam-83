extends Node

## This Marks a Node with the ID of the Client that has control over it.
## If the client sees this node, and it is not it's own, then 
## the client should set the multiplayer auth of that node to the server.
## The Server sets each object's authority to the literall client that has auth.
## over it.

## The owner of this node, with respect to the server.
## For clients, if this does not match client's peer id, 
## then the authority belongs to the server.
@export var owner_id := 0

func _ready():
  ## don't waste time processing this node. Only for obvious data labeling
  set_process(false)
  set_physics_process(false)
  set_process_input(false)
  set_process_unhandled_input(false)
  set_process_unhandled_key_input(false)
