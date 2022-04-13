extends Character


signal player_fired_bullet(bullet, position, direction)

onready var attack: Node2D = get_node("Attack")

#onready var animated_sprite:AnimatedSprite = get_node("AnimatedSprite")

onready var bullet_hitbox: Area2D = get_node("Attack/Bullet/Sprite/Hitbox")

onready var attack_timer:Timer = $AttackTimer

export (PackedScene) var Bullet
var can_attack:bool = true

func _process(delta: float) -> void:
	var mouse_direction :Vector2 = (get_global_mouse_position()- global_position).normalized()
	
	if mouse_direction.x>0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	
	attack.rotation= mouse_direction.angle()	
	
func get_input() -> void:
	mov_direction = Vector2.ZERO	
	if Input.is_action_pressed("ui_down"):
		mov_direction +=Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		mov_direction +=Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		mov_direction +=Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		mov_direction +=Vector2.UP
	if Input.is_action_just_released("ui_attack"):
		shoot()
		
func shoot():
	if can_attack:
		var bullet_instance = Bullet.instance()
		bullet_instance.global_position = attack.global_position
		var target = get_global_mouse_position()
		var dir_to_mouse = attack.global_position.direction_to(target).normalized()
		emit_signal("player_fired_bullet", bullet_instance, attack.global_position, dir_to_mouse)
		can_attack = false
		attack_timer.start()
		
	
	


#func _ready() -> void:
	#animated_sprite.show()




func _on_AttackTimer_timeout() -> void:
	can_attack = true
