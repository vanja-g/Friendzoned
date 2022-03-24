extends Area2D

export (int) var speed = 2
var direction := Vector2.ZERO

onready var kill_timer = $KillTimer



func _ready() -> void:
	kill_timer.start()

func set_direction(direction):
	self.direction = direction
	
func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		
		global_position += velocity

func get_direction()-> Vector2:
	return direction

func destroy()-> void:
	queue_free()

func _on_KillTimer_timeout() -> void:
	destroy()
