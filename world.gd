extends Node2D


var bodyScene: PackedScene = preload("res://body.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			var scene: body = bodyScene.instantiate()
			scene.bodyRadius = 5
			scene.mass = 20;
			scene.collisionSize = 1100
			scene.color = randomColor()
			scene.global_position = event.global_position
			scene.clicked = true
			add_child(scene)


func randomColor() -> Color:
	return Color8(randi_range(150,255), randi_range(150,255), randi_range(150,255))
