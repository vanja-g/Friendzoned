extends Area2D
class_name Hitbox

export(int) var damage: int = 20
export(int) var knockback_force: int = 100


onready var knockback_direction: = Vector2.ZERO
onready var bullet:Area2D = get_node("../../")

onready var collision_shape: CollisionShape2D = get_child(0)

func _init() -> void:
	connect("body_entered", self, "_on_body_entered")
	print(get_owner())

func _ready() -> void:
	assert(collision_shape != null)

func _on_body_entered(body:PhysicsBody2D)-> void:
	if is_instance_valid(bullet):
		knockback_direction = bullet.get_direction()
	
	body.take_damage(damage, knockback_direction, knockback_force)
	bullet.destroy()
	#print("body entered")	
