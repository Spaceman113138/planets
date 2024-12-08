@tool
extends Node2D
class_name body

const GRAVCONST: float = 6.6743

var force: Vector2 = Vector2.ZERO
@export var velocity: Vector2 = Vector2.ZERO
var clicked: bool = false

@export var bodyRadius: float:
	set(val):
		bodyRadius = val
		get_node("mesh").scale = Vector2(bodyRadius, bodyRadius)
		get_node("planetCollider/planetColliderShape").scale = Vector2(bodyRadius, bodyRadius)
		#print("ran")
		#if Engine.is_editor_hint():
			#bodyTool.updateVars(self)
		
@export var mass: float
@export var color: Color = Color.LIGHT_BLUE:
	set(val):
		color = val
		#if Engine.is_editor_hint():
			#bodyTool.updateVars(self)

@export var collisionSize: float:
	set(val):
		collisionSize = val
		get_node("detectCollider/detectColliderShape").scale = Vector2(collisionSize, collisionSize)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("mesh").scale = Vector2(bodyRadius, bodyRadius)
	get_node("planetCollider/planetColliderShape").scale = Vector2(bodyRadius, bodyRadius)
	modulate = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		force = Vector2.ZERO
		
		if clicked:
				bodyRadius += 1
				mass += 1/5
		else:
			for area: Area2D in get_node("planetCollider").get_overlapping_areas():
				
				var body_: body = area.get_parent()
				if body_ != self:
					if dispVector(body_).length() < (bodyRadius + body_.bodyRadius):
						if abs(bodyRadius - body_.bodyRadius) < 10:
							body_.queue_free()
							queue_free()
						elif bodyRadius < body_.bodyRadius:
							body_.bodyRadius += bodyRadius/mass
							body_.mass += mass
							self.queue_free()
							return
						else:
							bodyRadius += body_.bodyRadius/body_.mass
							mass += body_.mass
							body_.queue_free()
					if body_ is body:
						force += forceToBody(body_)

		#print(force)
		velocity += getAccel()
		velocity.clamp(Vector2(-9999, -9999),Vector2(9999, 9999))
		global_position += velocity
		#queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if !Engine.is_editor_hint():
		if event is InputEventMouseButton:
			if event.button_index == 1 and event.is_released():
				clicked = false
		if event is InputEventMouseMotion:
			if event.button_mask == 1 and clicked:
				velocity += event.velocity/1000
				print(velocity)


func _draw() -> void:
	draw_line(to_local(global_position), to_local(global_position + force), Color.RED, 10)


func forceToBody(target: body) -> Vector2:
	#print(-GRAVCONST * (mass * target.mass) / (dispVector(target).length() ** 3)) 
	return (-GRAVCONST * (mass * target.mass) / (dispVector(target).length() ** 3)) * dispVector(target)


func dispVector(target: body) -> Vector2:
	#print(target.global_position - global_position)
	return global_position - target.global_position

#F = MA
#A = F/M
func getAccel() -> Vector2:
	return force/mass
