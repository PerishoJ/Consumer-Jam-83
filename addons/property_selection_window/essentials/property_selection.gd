@tool
extends Resource
class_name PropertySelection
## Holds a reference to an object and a list of some properties it contains

## The path to the Node that contains the properties
@export var target_path: NodePath
## A list of properties for the Node at target_path
@export var properties_list: Array[String]
