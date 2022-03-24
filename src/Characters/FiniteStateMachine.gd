extends FiniteStateMachine

func _init() -> void:
	_add_state("Idle")
	_add_state("Move")



func _ready() -> void:
	set_state(states.Idle)

func _state_logic(_delta: float) -> void:
	parent.get_input()
	parent.move()
	
func _get_transition() -> int:
	match state:
		states.Idle:
			if parent.velocity.length() > 10:
				return states.Move
		states.Move:
			if parent.velocity.length() < 10:
				return states.Idle
				
	return -1 
			
func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.Idle:
			animation_player.play("Idle")
		states.Move:
			animation_player.play("Move")

