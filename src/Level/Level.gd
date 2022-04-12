extends Node2D

const ROOMS:Dictionary={
	0:preload("res://src/Rooms/Room0.tscn"),
	1:preload("res://src/Rooms/Room1.1.tscn"),
	2:preload("res://src/Rooms/Room1.2.tscn"),
	3:preload("res://src/Rooms/Room1.3.tscn")
	}
export (int) var num_rooms =  15
var level:Array = []
const REVERSE_DIRECTION = {"bot":"top","top":"bot","right":"left","left":"right"}
var current_room = null

var positions = preload("res://src/Level/RoomGen.tscn")


func room_positions():
	pass

func make_level(room_positions) ->void:
	var positions = room_positions
	var curr_position = 0
	
	var rng = RandomNumberGenerator.new()
	var remaining_rooms = num_rooms
	var start_room = ROOMS[0].instance()
	
	level.append(start_room)
	
	var to_connect:Array= [start_room]
	add_child(start_room,true)
	
	#start_room.position = positions[curr_position]
	#curr_position+=1
	
	current_room = start_room
	
	while remaining_rooms >0:
		
		var tmp_level = []
		for item in level:
			tmp_level.append(item)
		for room in tmp_level:
			if room in to_connect and remaining_rooms >0:
				var directions = shuffleList(room.available_directions())
				randomize()
				for i in range (rng.randi_range(1,len(directions))):
					if remaining_rooms<=0:
						break
					randomize()
					var pick_room = rng.randi_range(0,len(ROOMS)-1)
					var next_room = ROOMS[pick_room].instance()
					level.append(next_room)
					add_child(next_room,true)
					
					#next_room.position= positions[curr_position]
					#curr_position+=1
					
					#next_room.visible = false
					connect_rooms(room,next_room,directions[i-1])
					to_connect.append(next_room)
					remaining_rooms -=1
					
				to_connect.erase(room)
	for r in level:
		r.position = positions[curr_position]
		curr_position+=1

func connect_rooms(room1,room2,direction):

		assert (room1 in level)
		assert (room2 in level)
		
		room1.add_connection(room2,direction)
		room2.add_connection(room1, REVERSE_DIRECTION[direction])

func shuffleList(list):
	var shuffledList = []
	var indexList = range(list.size())
	for i in range(list.size()):
		randomize()
		var x = randi()%indexList.size()
		shuffledList.append(list[x])
		indexList.remove(x)
		list.remove(x)
	return shuffledList




func next_room(direction):
	fade_screen()
	current_room.visibility = false
	var next_room = current_room.connections[direction]
	current_room = next_room
	move_player()
	current_room.connections[direction].visibility = true
	fade_screen()
	
func move_player():
	pass
func fade_screen():
	pass

func _ready() -> void:
	var p = positions.instance()
	add_child(p,true)
	yield(get_tree().create_timer(0.3), "timeout")
	var room_positions = p.get_positions()
	
	
	
	make_level(room_positions)
	

