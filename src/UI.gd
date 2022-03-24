extends CanvasLayer

const MIN_HEALTH:int = 23

var max_hp: int =4

onready var player:KinematicBody2D = get_parent().get_node("Player")
onready var health_bar:TextureProgress = get_node("HP bar")
onready var hp_tween:Tween = get_node("HP bar/Tween")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_hp = player.hp
	_update_health_bar(100)
	
func _update_health_bar(new_value:int)->void:
	var __ = hp_tween.interpolate_property(health_bar,"value",
	health_bar.value,new_value,0.5,Tween.TRANS_QUINT,Tween.EASE_OUT)
	__ = hp_tween.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Player_hp_changed(new_hp:int) -> void:
	var new_health:int = int((100 - MIN_HEALTH)
	*float(new_hp)/max_hp)+MIN_HEALTH
	
	_update_health_bar(new_health)
	
	
