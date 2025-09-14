@tool
extends Resource
class_name PropertySelection
## Holds a reference to an object and a list of some properties it contains

## Path to the Node whose properties are being sampled
@export var node: NodePath
## A list of properties for the Node
@export var props: Array[String]
