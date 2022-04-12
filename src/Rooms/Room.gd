extends Node2D

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://src/Characters/SpawnExplosion.tscn")
const ENEMY_SCENES:Dictionary={
	"FLYING_CREATURE":preload("res://src/Characters/FlyingCreature.tscn")}

	
var num_enemies:int
onready var tilemap:TileMap = get_node("TileMap2")
onready var entrance: Node2D = get_node("Entrance")
onready var door_container:Node2D = get_node("Doors")
onready var enemy_positions_container:Node2D= get_node("EnemyPositions")
onready var player_detector:Node2D = get_node("PlayerDetector")
onready var center:Position2D = get_node("Center")
onready var connections = {"bot":null,
						"top":null,
						"right":null,
						"left":null}

###############################################################################################################################
"""func _init():
	var connections = {"bot":null,
						"top":null,
						"right":null,
						"left":null}
"""
var disabled = false
		
func add_connection(room,direction):
		if self.connections[direction] !=null: #Cannot override connections already made
			return
		self.connections[direction] = room

func get_connection(direction):
		return self.connections[direction]

func available_directions():
		var result:Array = []
		for key in connections:
			if self.connections[key] == null:
				result.append(key)
		return result
		
func num_connections():
		var num:int = 0
		for item in self.connections.values():
			if item != null:
				num+=1
		return num

#####################################################################################################################################	

var is_cleared = false

func _ready() -> void:
	num_enemies= enemy_positions_container.get_child_count()

func is_room_cleared() ->bool:
	return is_cleared

func _open_doors() ->void:
	if visible:
		for door in door_container.get_children():
			door.open()
		for entry_position in entrance.get_children():
			for point in entry_position.get_children():
			#tilemap.set_cellv(tilemap.world_to_map(entry_position.position),999)
			#tilemap.set_cellv(tilemap.world_to_map(entry_position.position)+ Vector2.DOWN,999)
				_get_entrance(point,false)
			
		
func _close_entrance() -> void:
	if visible:
		for entry_position in entrance.get_children():
			for point in entry_position.get_children():
			#tilemap.set_cellv(tilemap.world_to_map(entry_position.position),0)
			#tilemap.set_cellv(tilemap.world_to_map(entry_position.position)+ Vector2.DOWN,1)
				_get_entrance(point,true)
		
		
func _spawn_enemies()-> void:
	if visible:
		for enemy_position in enemy_positions_container.get_children():
			var enemy:KinematicBody2D = ENEMY_SCENES.FLYING_CREATURE.instance()
			var __	= enemy.connect("tree_exited",self,"_on_enemy_killed")	
			enemy.position = enemy_position.position
			call_deferred("add_child", enemy)
			
			var spawn_explosion:AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
			spawn_explosion.position = enemy_position.position
			call_deferred("add_child", spawn_explosion)
			
func _on_enemy_killed()->void:
	if visible:
		num_enemies-=1
		if num_enemies == 0:
			is_cleared =true
			_open_doors()


func _on_PlayerDetector_body_entered(body: KinematicBody2D) -> void:
	if visible:
		if body is KinematicBody2D and not disabled:
			player_detector.queue_free()
			_close_entrance()
			_spawn_enemies()

func _get_entrance(entry_position,close):
	if center.position.x < entry_position.position.x and abs(center.position.y - entry_position.position.y) <=20:
		if close:
			_close_right(entry_position)
		else:
			_open_right(entry_position)
	elif center.position.x > entry_position.position.x and abs(center.position.y - entry_position.position.y) <=20:
		if close:
			_close_left(entry_position)
		else:
			_open_left(entry_position)
	else:
		if close:
			_close_bottom(entry_position)
		else:
			_open_bottom(entry_position)



########################################################################################################################################
func _open_bottom(entry_position):
	tilemap.set_cellv(tilemap.world_to_map(entry_position.position),999)
	tilemap.set_cellv(tilemap.world_to_map(entry_position.position)+ Vector2.DOWN,999)
func _close_bottom(entry_position):
	tilemap.set_cellv(tilemap.world_to_map(entry_position.position),1)
	tilemap.set_cellv(tilemap.world_to_map(entry_position.position)+ Vector2.DOWN,0)
	
func _open_right(entry_position) -> void:
	tilemap.set_cellv(tilemap.world_to_map(entry_position.position),999)
func _close_right(entry_position) -> void:
	tilemap.set_cellv(tilemap.world_to_map(entry_position.position),2)

func _open_left(entry_position) -> void:
	tilemap.set_cellv(tilemap.world_to_map(entry_position.position),999)
func _close_left(entry_position) -> void:
	tilemap.set_cellv(tilemap.world_to_map(entry_position.position),3)



#######################################################################################################################################
	


func _on_LeaveDetctor_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
