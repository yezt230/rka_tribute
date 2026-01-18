extends Node

@export var starting_state: State

var current_state: State

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(parent: Player) -> void:
	for child in get_children():
		#if child is State:
		child.parent = parent
		
	if starting_state:
		change_state(starting_state)
	
	# Initialize to the default state
	change_state(starting_state)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
		

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)


func on_enemy_eaten():
	var new_state = current_state.on_enemy_eaten()
	if new_state:
		change_state(new_state)
		

func get_current_state() -> String:
	return str(current_state.name) if current_state else "None"
