@tool
extends Resource
class_name PropertySelector
@export_node_path
var target_path: NodePath
var property_name: String


func _init(target_path: NodePath, property_name: String):
    self.target_path = target_path
    self.property_name = property_name

## If you are using this in a script, pass it the reference
## to the base object, usually 'this'
func get_value(root: Node) -> Variant:
    if not root or target_path.is_empty():
        return null
    var node := root.get_node_or_null(target_path)
    if node and node.has_method("get"):
        return node.get(property_name)
    return null
    
## If you are using this in a script, pass it the reference
## to the base object, usually 'this'
func set_value(root: Node, value: Variant) -> void:
    if not root or target_path.is_empty():
        return
    var node := root.get_node_or_null(target_path)
    if node and node.has_method("set"):
        node.set(property_name, value)
