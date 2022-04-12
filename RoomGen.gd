extends Node2D

var room = preload("res://src/Level/RoomShape.tscn")

var tile_size = 16
var num_rooms = 16
var min_size = 11
var max_size = 14
var positions:Array = []

func _ready():
	randomize()
	make_rooms()
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
	
	
func make_rooms():

	for i in range (num_rooms):
		var pos = Vector2(0,0)
		var r = room.instance()
		var w = min_size+randi()%(max_size - min_size)
		var h = min_size+randi()%(max_size - min_size)
		r.make_room(pos,Vector2(w,h)*tile_size)
		r.offset= Vector2(w,h)
		$Rooms.add_child(r)
	yield(get_tree().create_timer(0.3), "timeout")
	make_positions()
	

func get_positions() -> Array:
		return positions

func make_positions():
	for room in $Rooms.get_children():
		positions.append(room.position-room.offset)
	

	
		
