extends State

@export var idle_state: State
@export var shoot_state: State
@export var run_state: State

func enter() -> void:
	super()
	print("jump")
	

func _physics_process(delta):
		#animation handling section
	if parent.velocity:
		if parent.velocity.y != 0:
			if parent.velocity.y  * delta < -400:
				#print("rising")
				if parent.player_sprite:
					parent.player_sprite.frame = 11
			elif parent.velocity.y * delta > 400:
				if parent.player_sprite:
					parent.player_sprite.frame = 9
			else:
				#print("falling")
				if parent.player_sprite:
					parent.player_sprite.frame = 10


func physics_update(_delta: float) -> State:	
	if parent.is_on_floor():
		if parent.velocity.x != 0:
			return run_state
		else:
			return idle_state
	return null


func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('SPACE'):
		return shoot_state
	return null
