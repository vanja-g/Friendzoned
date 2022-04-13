extends Area2D
class_name Hitbox

export(int) var damage: int = 20
export(int) var knockback_force: int = 200


onready var knockback_direction: = Vector2.ZERO
onready var bullet: = get_node("../../")
#onready var bullet: = preload("res://src/Bullet.tscn")

onready var collision_shape: CollisionShape2D = get_child(0)

func _init() -> void:
	connect("body_entered", self, "_on_body_entered")
	

func _ready() -> void:
	assert(collision_shape != null)

func _on_body_entered(body:PhysicsBody2D)-> void:
	if is_instance_valid(bullet) and bullet.has_method("get_overlapping_areas") :
		knockback_direction = bullet.get_direction()
	
	
	_collide(body)
	if is_instance_valid(bullet) and bullet.has_method("get_overlapping_areas") :
		bullet.destroy()
	#print("body entered")	
	
func _collide(body:KinematicBody2D)->void:
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		body.take_damage(damage,knockback_direction, knockback_force)
	

