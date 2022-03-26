extends Node2D

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://src/Characters/SpawnExplosion.tscn")
const ENEMY_SCENES:Dictionary={
	"FLYING_CREATURE":preload("res://src/Characters/FlyingCreature.tscn")}
	
var num_enemies:int
onready var tilemap:TileMap = get_node("Navigation2D/TileMap2")
onready var entrance: Node2D = get_node("Entrance")
onready var door_container:Node2D = get_node("Doors")
onready var enemy_positions_container:Node2D= get_node("EnemyPositions")
onready var player_detector:Node2D = get_node("PlayerDetector")
	

func _ready() -> void:
	num_enemies= enemy_positions_container.get_child_count()
	
func _open_doors() ->void:
	for door in door_container.get_children():
		door.open()
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position),999)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position)+ Vector2.DOWN,999)
		
func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position),0)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position)+ Vector2.DOWN,1)
		
		
func _spawn_enemies()-> void:
		for enemy_position in enemy_positions_container.get_children():
			var enemy:KinematicBody2D = ENEMY_SCENES.FLYING_CREATURE.instance()
			var __	= enemy.connect("tree_exited",self,"_on_enemy_killed")	
			enemy.position = enemy_position.position
			call_deferred("add_child", enemy)
			
			var spawn_explosion:AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
			spawn_explosion.position = enemy_position.position
			call_deferred("add_child", spawn_explosion)
			
func _on_enemy_killed()->void:
	num_enemies-=1
	if num_enemies == 0:
		_open_doors()


func _on_PlayerDetector_body_entered(body: KinematicBody2D) -> void:
	player_detector.queue_free()
	_close_entrance()
	_spawn_enemies()