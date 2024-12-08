@tool
extends Object
class_name bodyTool


static func updateVars(object) -> void:
	#print(object)
	object.get_node("mesh").scale = Vector2(object.bodyRadius, object.bodyRadius)
	object.get_node("planetCollider").scale = Vector2(object.bodyRadius, object.bodyRadius)
	object.modulate = object.color
